public class AmostraOportunidades {

    @AuraEnabled
    public static Map<String, String> getRecsTypesIds() {
        Map<String, String> mapRetorno = new Map<String, String>();
        
        mapRetorno.put('Sample_Order_University', Schema.SObjectType.Opportunity.getRecordTypeInfosByDeveloperName().get('Sample_Order_University').getRecordTypeId());
        mapRetorno.put('Sample_Order_Languages', Schema.SObjectType.Opportunity.getRecordTypeInfosByDeveloperName().get('Sample_Order_Languages').getRecordTypeId());
        mapRetorno.put('Sample_Order_Solutions', Schema.SObjectType.Opportunity.getRecordTypeInfosByDeveloperName().get('Sample_Order_Solutions').getRecordTypeId());
        mapRetorno.put('Sample_Order_COC', Schema.SObjectType.Opportunity.getRecordTypeInfosByDeveloperName().get('Sample_Order_COC').getRecordTypeId());
        mapRetorno.put('Sample_Order_Pueri_Domus', Schema.SObjectType.Opportunity.getRecordTypeInfosByDeveloperName().get('Sample_Order_Pueri_Domus').getRecordTypeId());
        mapRetorno.put('Sample_Order_Dom_Bosco', Schema.SObjectType.Opportunity.getRecordTypeInfosByDeveloperName().get('Sample_Order_Dom_Bosco').getRecordTypeId());
        mapRetorno.put('Sample_Order_NAME', Schema.SObjectType.Opportunity.getRecordTypeInfosByDeveloperName().get('Sample_Order_NAME').getRecordTypeId());
        
        return mapRetorno;
    }
    
    @AuraEnabled 
    public static Opportunity getOpportunity(String idOportunidade) {
        List<Opportunity> opps = [SELECT Id, AccountId FROM Opportunity WHERE Id =: idOportunidade];
        return opps.isEmpty() ? null : opps[0];
    } 
}