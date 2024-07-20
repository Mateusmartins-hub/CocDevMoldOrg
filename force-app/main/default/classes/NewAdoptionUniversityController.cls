public with sharing class NewAdoptionUniversityController {

    @AuraEnabled
    public static University_courses__c getRecord(String recordId) {
        List<University_courses__c> rs = [SELECT Id, Account__c FROM University_courses__c WHERE Id =: recordId];
        return rs.isEmpty() ? null : rs[0];
    } 
}