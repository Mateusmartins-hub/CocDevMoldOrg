@IsTest
public class ContactDAOTest {

    @IsTest
    static void getContactFromAccountId() {
        Contact ctc = TestHelper.createContact();
        insert ctc;

        Contact aContact = ContactDAO.getContactFromAccountId(ctc.AccountId);

        System.assertNotEquals(null, aContact);
    }

    @IsTest
    static void getAccountContactTest() {
        Account_Contact__c ctc = TestHelper.createAccountContact();
        insert ctc;

        Account_Contact__c aContact = ContactDAO.getAccountContact(ctc.Account__c);

        System.assertNotEquals(null, aContact);
    }

    @IsTest
    static void getAccountContactsTest() {
        Account_Contact__c ctc = TestHelper.createAccountContact();
        insert ctc;

        Set<Id> accountIds = new Set<Id>();
        accountIds.add(ctc.Account__c);

        List<Account_Contact__c> aContact = ContactDAO.getAccountContacts(accountIds);
        System.assertEquals(1, aContact.size());
    }
}