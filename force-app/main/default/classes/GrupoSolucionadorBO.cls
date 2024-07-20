public class GrupoSolucionadorBO {

    public static void preencherCampos(List<GrupoSolucionador__c> grupos) {
        Set<Id> paramsIds = new Set<Id>();
        for(GrupoSolucionador__c g : grupos)
            paramsIds.add(g.ParametrizacaoCasos__c);
        
        List<GrupoSolucionador__c> listGruposExistentes = GrupoSolucionadorDAO.getAllGruposSolucionadoresByParametrizacaoIds(paramsIds);
        Map<Id, List<GrupoSolucionador__c>> mapGruposExistentes = new Map<Id, List<GrupoSolucionador__c>>();
        
        for(GrupoSolucionador__c grupo : listGruposExistentes) {
            if(!mapGruposExistentes.containsKey(grupo.ParametrizacaoCasos__c))
                mapGruposExistentes.put(grupo.ParametrizacaoCasos__c, new List<GrupoSolucionador__c>());
            
            mapGruposExistentes.get(grupo.ParametrizacaoCasos__c).add(grupo);
        }
        
        for(GrupoSolucionador__c g : grupos) {
            Integer maiorOrdem = 0;
            if(mapGruposExistentes.containsKey(g.ParametrizacaoCasos__c)) {
                for(GrupoSolucionador__c gExistente : mapGruposExistentes.get(g.ParametrizacaoCasos__c)) { 
                      if(gExistente.Ordem__c > maiorOrdem)
                          maiorOrdem = Integer.ValueOf(gExistente.Ordem__c);
                }
            }
            if(g.Ordem__c == null)
                g.Ordem__c = maiorOrdem + 1;
            g.Name = g.Ordem__c + 'º Grupo Solucionador - ' + g.GrupoSolucionador__c; 
        }
    }
}