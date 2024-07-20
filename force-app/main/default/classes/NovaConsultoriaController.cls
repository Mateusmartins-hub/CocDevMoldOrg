public without sharing class NovaConsultoriaController {
    @AuraEnabled 
    public static user fetchUser(){
        User u = [select Id, Profile.Name from User where id =: userInfo.getUserId()];
        return u;
    }
    
    @AuraEnabled 
    public static Map<String, String> getRecordTypes(List<String> names){
        Map<String, String> retorno = new Map<String, String>();
        
        for(String n : names) {
            retorno.put(n, Schema.SObjectType.Event.getRecordTypeInfosByName().get(n).getRecordTypeId());
        }
        
        return retorno;
    }
    
    @AuraEnabled
    public static String criarConsultoria(String contaId) {
        try{
            FR_Procedimento_Franquias__c consultoria = new FR_Procedimento_Franquias__c();
            consultoria.RecordTypeId = Schema.SObjectType.FR_Procedimento_Franquias__c.getRecordTypeInfosByName().get('Pedagógico').getRecordTypeId();
            consultoria.BR_Conta__c = contaId;
            insert consultoria;
            
            return consultoria.Id;
        }catch(Exception e){
            throw new AuraHandledException(e.getMessage());
        }
    }
}