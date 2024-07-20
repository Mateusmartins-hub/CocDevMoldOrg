public with sharing class ContactDAO {
    public static Contact getContactFromAccountId(Id accId) {
        List<Contact> contato = [SELECT Id, Email, Name FROM Contact WHERE AccountId = :accId LIMIT 1];

        if (!contato.isEmpty())
            return contato[0];
        
        return null;
    }    

    // public static List<Contact> getContactsFromAccountsIds(Set<Id> accIds) {
    //     return [SELECT Id, Email, Name, AccountId FROM Contact WHERE AccountId in :accIds];
    // }    


    public static Account_Contact__c getAccountContact(Id  accId) {
        return [SELECT Id, Email__c, Account__c FROM Account_Contact__c WHERE Account__c = :accId LIMIT 1];
    }    

    public static List<Account_Contact__c> getAccountContacts(Set<Id> accIds) {
        return [SELECT Id, Email__c, Account__c, Name,Contact__r.Email FROM Account_Contact__c WHERE Account__c in :accIds];
    }    
}