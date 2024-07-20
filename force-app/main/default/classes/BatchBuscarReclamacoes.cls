global without sharing class BatchBuscarReclamacoes implements Database.Batchable<sObject>, Database.AllowsCallouts, Database.Stateful {
    
    String query = 'SELECT Id, Token__c FROM IntegracaoRA__c';
    
    global Database.QueryLocator start(Database.BatchableContext BC) {
        return Database.getQueryLocator(query);
    }
    
    global void execute(Database.BatchableContext BC, List<sObject> integracao) {
        Map<String, ReclameAquiBO.CaseVO> casos = ReclameAquiBO.buscarReclamacoes();
        
        Map<String, Case> mapCasosUpsert = new Map<String, Case>();
        List<Attachment> anexosInsert = new List<Attachment>();
        
        if(!casos.isEmpty()) {
            for(String idRA : casos.keySet())  mapCasosUpsert.put(idRA, casos.get(idRA).caso);
            
            TriggerHandler.bypass('CaseTriggerHandler'); Database.UpsertResult[] srList = Database.upsert(mapCasosUpsert.values(), false); TriggerHandler.clearBypass('CaseTriggerHandler');
            
            for (Database.UpsertResult sr : srList) { if (!sr.isSuccess()) { for(Database.Error err : sr.getErrors()) {
                System.debug('----------------');
                System.debug('The following error has occurred.');                    
                System.debug(err.getStatusCode() + ': ' + err.getMessage());
                System.debug('Case fields that affected this error: ' + err.getFields());
                System.debug('----------------');
            }
                                                                           }
                                                    }
        }
    }
    
    global void finish(Database.BatchableContext BC) {
        IntegracaoRA__c settingsRA = IntegracaoRA__c.getOrgDefaults();
        
        if(settingsRA.Token__c == null || settingsRA.Token__c == 'Usuário ou senha inválido.')
            settingsRA.Token__c = ReclameAquiWS.getToken();
        
        
        try {
            settingsRA.Token__c = settingsRA.Token__c.split(':').get(0) != 'Erro'? settingsRA.Token__c : 'Usuário ou senha inválido.';
            update settingsRA;            
        }catch(Exception ex){
            System.debug('Integracao ERRO '+ex.getStackTraceString()+' '+ex.getMessage());
        }
    }
}