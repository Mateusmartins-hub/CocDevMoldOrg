public without sharing class GrupoSolucionadorDAO {

    public static Map<String, GrupoSolucionador__c> buscarGruposAtuais(List<Case> casos) {
        Map<String, GrupoSolucionador__c> mapRetorno = new Map<String, GrupoSolucionador__c>();
            
        Set<String> identificadores = new Set<String>();
        
        for(Case caso : casos) {
            String tipo = caso.Tipo__c != null ? caso.Tipo__c : '';
            String subtipo = caso.Subtipo__c != null ? caso.Subtipo__c : '';
            String detalhamento = caso.Detalhamento__c != null ? caso.Detalhamento__c : '';
            String detalhamento2 = caso.Detalhamento2__c != null ? caso.Detalhamento2__c : ''; 
            
            for(Integer i = 0; i < 15; i++) {
                String key = tipo.trim() + '_' + subtipo.trim() + '_' + detalhamento.trim() + '_' + detalhamento2.trim() + '_' + String.ValueOf(i);
                identificadores.add(key);
            }
        }
        
        List<GrupoSolucionador__c> listGrupos = [SELECT Id, CamposObrigatorios__c, GrupoSolucionador__c, MinutosSLA__c, ParametrizacaoCasos__c, Ordem__c,
                                                 ParametrizacaoCasos__r.Tipo__c, ParametrizacaoCasos__r.Subtipo__c, ParametrizacaoCasos__r.Detalhamento__c, ParametrizacaoCasos__r.Detalhamento2__c
                                                 FROM GrupoSolucionador__c 
                                                 WHERE IdentificadorOrdem__c IN: identificadores];
        
        for(GrupoSolucionador__c grupo : listGrupos) {
            String tipo = grupo.ParametrizacaoCasos__r.Tipo__c != null ? grupo.ParametrizacaoCasos__r.Tipo__c : '';
            String subtipo = grupo.ParametrizacaoCasos__r.Subtipo__c != null ? grupo.ParametrizacaoCasos__r.Subtipo__c : '';
            String detalhamento = grupo.ParametrizacaoCasos__r.Detalhamento__c != null ? grupo.ParametrizacaoCasos__r.Detalhamento__c : '';
            String detalhamento2 = grupo.ParametrizacaoCasos__r.Detalhamento2__c != null ? grupo.ParametrizacaoCasos__r.Detalhamento2__c : '';
            String ordem = String.valueOf(grupo.Ordem__c);
            
            String key = tipo.trim() + '_' + subtipo.trim() + '_' + detalhamento.trim() + '_' + detalhamento2.trim() + '_' + ordem;
            
            if(!mapRetorno.containsKey(key))
                mapRetorno.put(key, grupo);
        }    

        return mapRetorno;
    }
    
    public static GrupoSolucionador__c getGrupoSolucionadorById(Id idGrupo) {
        return [SELECT Id, Ordem__c, GrupoSolucionador__c, ParametrizacaoCasos__r.AreaDonaProcesso__c, IdentificadorOrdem__c, IdentificadorGrupo__c, CamposObrigatorios__c, MinutosSLA__c, ParametrizacaoCasos__c
                FROM GrupoSolucionador__c 
                WHERE Id =: idGrupo];
    }
    
    public static GrupoSolucionador__c getGrupoSolucionadorByCampos(String tipo, String subtipo, String detalhamento, String detalhamento2, Integer ordemAtual) {
        List<GrupoSolucionador__c> listGrupo = [SELECT Id, Ordem__c, GrupoSolucionador__c, ParametrizacaoCasos__r.AreaDonaProcesso__c, CamposObrigatorios__c
                                                FROM GrupoSolucionador__c 
                                                WHERE ParametrizacaoCasos__r.Tipo__c =: tipo
                                                AND ParametrizacaoCasos__r.Subtipo__c =: subtipo
                                                AND ParametrizacaoCasos__r.Detalhamento__c =: detalhamento
                                                AND ParametrizacaoCasos__r.Detalhamento2__c =: detalhamento2
                                                AND Ordem__c =: ordemAtual
                                                ORDER BY Ordem__c ASC
                                                LIMIT 1];
        
        return listGrupo.isEmpty() ? null : listGrupo[0];
    }
    
    public static List<GrupoSolucionador__c> getPreviousGrupoSolucionadorByCampos(String tipo, String subtipo, String detalhamento, String detalhamento2, Integer ordemAtual) {
        return [SELECT Id, Ordem__c, GrupoSolucionador__c, ParametrizacaoCasos__r.AreaDonaProcesso__c, CamposObrigatorios__c
                FROM GrupoSolucionador__c 
                WHERE ParametrizacaoCasos__r.Tipo__c =: tipo
                AND ParametrizacaoCasos__r.Subtipo__c =: subtipo
                AND ParametrizacaoCasos__r.Detalhamento__c =: detalhamento
                AND ParametrizacaoCasos__r.Detalhamento2__c =: detalhamento2
                AND Ordem__c <: ordemAtual
                ORDER BY Ordem__c ASC];
    }
    
    public static List<GrupoSolucionador__c> getNextGruposSolucionadoresByCampos(String tipo, String subtipo, String detalhamento, String detalhamento2, Integer ordemAtual) {
        ordemAtual = ordemAtual == null ? 0 : ordemAtual;
        Integer ordem = ordemAtual + 1;
        List<GrupoSolucionador__c> listGrupo = [SELECT Id, Ordem__c, GrupoSolucionador__c, ParametrizacaoCasos__r.AreaDonaProcesso__c, CamposObrigatorios__c
                                                FROM GrupoSolucionador__c 
                                                WHERE ParametrizacaoCasos__r.Tipo__c =: tipo
                                                AND ParametrizacaoCasos__r.Subtipo__c =: subtipo
                                                AND ParametrizacaoCasos__r.Detalhamento__c =: detalhamento
                                                AND ParametrizacaoCasos__r.Detalhamento2__c =: detalhamento2
                                                AND Ordem__c =: ordem
                                                ORDER BY Ordem__c ASC, GrupoSolucionador__c ASC];
         
        return listGrupo.isEmpty() ? null : listGrupo;
    }
    
    public static List<GrupoSolucionador__c> getAllGruposSolucionadoresByParametrizacaoIds(Set<Id> idsParams) {
        return [SELECT Id, Ordem__c, GrupoSolucionador__c, ParametrizacaoCasos__c, ParametrizacaoCasos__r.AreaDonaProcesso__c, CamposObrigatorios__c
                FROM GrupoSolucionador__c 
                WHERE ParametrizacaoCasos__c IN: idsParams
                ORDER BY Ordem__c ASC];
    }
}