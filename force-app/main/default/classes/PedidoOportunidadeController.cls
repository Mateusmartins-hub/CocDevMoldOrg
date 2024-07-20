public with sharing class PedidoOportunidadeController {

    @AuraEnabled
    public static Map<String, String> getRecsTypesIds() {
        Map<String, String> mapRetorno = new Map<String, String>();
        
        mapRetorno.put('Sales_Opportunities_Solutions', Schema.SObjectType.Opportunity.getRecordTypeInfosByDeveloperName().get('Sales_Opportunities_Solutions').getRecordTypeId());
        mapRetorno.put('TESTE_TESE', Schema.SObjectType.Opportunity.getRecordTypeInfosByDeveloperName().get('TESTE_TESE').getRecordTypeId());
        mapRetorno.put('Sales_Opportunities_NAME', Schema.SObjectType.Opportunity.getRecordTypeInfosByDeveloperName().get('Sales_Opportunities_NAME').getRecordTypeId());
        mapRetorno.put('Sales_Opportunities_Languages', Schema.SObjectType.Opportunity.getRecordTypeInfosByDeveloperName().get('Sales_Opportunities_Languages').getRecordTypeId());
        
        return mapRetorno;
    }
    
    @AuraEnabled 
    public static Opportunity getOpportunity(String idOportunidade) {
        List<Opportunity> opps = [SELECT Id, AccountId FROM Opportunity WHERE Id =: idOportunidade];
        return opps.isEmpty() ? null : opps[0];
    } 
}