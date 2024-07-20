global class BatchEnviarRespostas implements Database.Batchable<Case>, Database.AllowsCallouts, Database.Stateful {

    global Iterable<Case> start(Database.BatchableContext BC) {
        
        List<Case> casos = new List<Case>();

        casos = [SELECT Id, IdRA__c, MotivoModeracaoRA__c, DescricaoModeracaoRA__c, TreplicaPublica__c,
                RespostaPublica__c, StatusIntegracao__c, status, ErroIntegracaoRA__c
                FROM Case WHERE StatusIntegracao__c = 'Aguardando integração' LIMIT 20];
        
        return casos;
    }

    global void execute(Database.BatchableContext BC, List<sObject> casos) {
        if(!casos.isEmpty())
        {
            casos = ReclameAquiBO.enviarRespostas(casos);

            TriggerHandler.bypass('CaseTriggerHandler'); Database.UpsertResult[] srList = Database.upsert(casos, false); TriggerHandler.clearBypass('CaseTriggerHandler');
            
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
    // finish code
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