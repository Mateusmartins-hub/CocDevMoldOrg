public with sharing class NovoContatoInstituicaoController {

    @AuraEnabled
    public static string getRecordType() {
        return Schema.SobjectType.Account_Contact__c.getRecordTypeInfosByDeveloperName().get('Contatodaconta').getRecordTypeId();
    } 
}