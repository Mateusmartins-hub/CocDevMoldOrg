global without sharing class CaseReturnClass {
    webservice static string returnToQueue(List<Id> casosIds) {
        try{
            String result = 'sucesso';
            List<Case> casos = [SELECT Id, AceitoPor__c, CaseNumber, OwnerId FROM Case WHERE Id IN: casosIds];
            
            
            for(Case caso : casos) {
                if(caso.AceitoPor__c == UserInfo.getUserId()) {
                    caso.AceitoPor__c = null;
                    caso.Status = 'Novo';
                }
            }
            
            update casos;
            return result;
        }catch(Exception e){
            throw e;
        }
    }
}