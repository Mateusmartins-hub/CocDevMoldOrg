global without sharing class CaseAcceptClass {
    webservice static string accept(List<Id> casosIds) {
        try{
            String result = 'sucesso';
            List<Case> casos = [SELECT Id, Novo__c, AceitoPor__c, CaseNumber, OwnerId FROM Case WHERE Id IN: casosIds];
            Set<Id> OwnerIds = new Set<Id>();         
            
            for(Case caso : casos) {
                OwnerIds.add(caso.OwnerId);
            }
            
            AllUsersFromQueue users = new AllUsersFromQueue();
            Map<Id, Set<Id>> usuariosDoGrupo = users.getUsers(null, OwnerIds);
            for(Case caso : casos) {
                if(!caso.Novo__c || (usuariosDoGrupo.containsKey(caso.OwnerId) && usuariosDoGrupo.get(caso.OwnerId).contains(UserInfo.getUserId()))) {
                    caso.AceitoPor__c = UserInfo.getUserId();
                    caso.Status = 'Em Execução';
                }else{
                    result = 'Você não pertence ao grupo solucionador do caso ' + caso.CaseNumber;
                }
            }
            
            TriggerHandler.bypass('CaseTriggerHandler');
            update casos; 
            TriggerHandler.clearBypass('CaseTriggerHandler');
            return result; 
        }catch(Exception e){
            return e.getMessage();
        }
    }
    
    public static Boolean validateOneCase(Case caso) {
        try{
            Boolean result = true;
            Set<Id> OwnerIds = new Set<Id>(); 
            OwnerIds.add(caso.OwnerId);
            
            system.debug('Owner Id ' + caso.OwnerId);
            
            AllUsersFromQueue users = new AllUsersFromQueue();
            Map<Id, Set<Id>> usuariosDoGrupo = users.getUsers(null, OwnerIds);
            if(usuariosDoGrupo.containsKey(caso.OwnerId) && !usuariosDoGrupo.get(caso.OwnerId).contains(UserInfo.getUserId())) {
                result = false;
            }
            return result; 
        }catch(Exception e){
            throw e;
        }
    }
}