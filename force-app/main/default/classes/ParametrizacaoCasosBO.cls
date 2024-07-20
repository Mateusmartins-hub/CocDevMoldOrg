public class ParametrizacaoCasosBO {

    public static void validar(List<ParametrizacaoCasos__c> params) {
        validarParametrizacaoExistente(params);
    }
    
    private static void validarParametrizacaoExistente(List<ParametrizacaoCasos__c> params) {
        List<String> tipos = new List<String>();
        List<String> subtipos = new List<String>();
        List<String> detalhamentos = new List<String>();
        List<String> detalhamentos2 = new List<String>();
        
        for(ParametrizacaoCasos__c p : params) {
            tipos.add(p.Tipo__c);
            subtipos.add(p.Subtipo__c);
            detalhamentos.add(p.Detalhamento__c);
            detalhamentos2.add(p.Detalhamento2__c);
        }
        
        Map<string, Map<string, Map<string, Map<string, ParametrizacaoCasos__c>>>> mapParametrizacao = ParametrizacaoCasosDAO.mapearParametrizacoesByCampos(tipos, subtipos, detalhamentos, detalhamentos2);
        
        for(ParametrizacaoCasos__c p : params) {
            
            if(
            	!((p.RecordTypeId == Schema.SObjectType.ParametrizacaoCasos__c.getRecordTypeInfosByDeveloperName().get('Padrao').getRecordTypeId()) ||
            	(!mapParametrizacao.containsKey(p.Tipo__c)) ||
                (!mapParametrizacao.get(p.Tipo__c).containsKey(p.Subtipo__c)) ||
                (!mapParametrizacao.get(p.Tipo__c).get(p.Subtipo__c).containsKey(p.Detalhamento__c)) ||
                (!mapParametrizacao.get(p.Tipo__c).get(p.Subtipo__c).get(p.Detalhamento__c).containsKey(p.Detalhamento2__c)) ||
                (mapParametrizacao.get(p.Tipo__c).get(p.Subtipo__c).get(p.Detalhamento__c).get(p.Detalhamento2__c).Id == p.Id))
            ){
                p.AddError('Já existe uma parametrização com essa árvore de assunto.');
            }
            
            /*
            if (p.RecordTypeId == Schema.SObjectType.ParametrizacaoCasos__c.getRecordTypeInfosByDeveloperName().get('Padrao').getRecordTypeId())
                continue;
            
             if (!mapParametrizacao.containsKey(p.Tipo__c)) 
                 continue;
            
            if (!mapParametrizacao.get(p.Tipo__c).containsKey(p.Subtipo__c)) 
                continue;
            
            if (!mapParametrizacao.get(p.Tipo__c).get(p.Subtipo__c).containsKey(p.Detalhamento__c)) 
                continue;
            
            if (!mapParametrizacao.get(p.Tipo__c).get(p.Subtipo__c).get(p.Detalhamento__c).containsKey(p.Detalhamento2__c)) 
                continue;
            
            if (mapParametrizacao.get(p.Tipo__c).get(p.Subtipo__c).get(p.Detalhamento__c).get(p.Detalhamento2__c).Id == p.Id) 
                continue;
            
            p.AddError('Já existe uma parametrização com essa árvore de assunto.');
            */
        }
    }
    
    public static void inserirGrupoZero(List<ParametrizacaoCasos__c> params) {
        List<GrupoSolucionador__c> grupos = new List<GrupoSolucionador__c>();
        
        for(ParametrizacaoCasos__c param : params) {
            GrupoSolucionador__c grupo = new GrupoSolucionador__c();
            
            grupo.Name = '0º Grupo Solucionador - Abertura';
            grupo.ParametrizacaoCasos__c = param.Id;
            grupo.Ordem__c = 0;
            grupo.MinutosSLA__c = 720;
            grupos.add(grupo);
        }
        
        TriggerHandler.bypass('GrupoSolucionadorTriggerHandler');
        insert grupos;        
        TriggerHandler.clearbypass('GrupoSolucionadorTriggerHandler');
    }
}