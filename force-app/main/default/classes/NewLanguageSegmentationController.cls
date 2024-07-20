public with sharing class NewLanguageSegmentationController {

    @AuraEnabled
    public static Account getRecord(String recordId) {
        List<Account> rs = [SELECT Id FROM Account WHERE Id =: recordId];
        return rs.isEmpty() ? null : rs[0];
    } 
}