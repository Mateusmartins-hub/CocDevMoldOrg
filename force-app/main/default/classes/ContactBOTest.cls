@isTest
public class ContactBOTest {

    @isTest
    static void testOne() {
        Account conta = new Account();
        conta.Name = 'Conta Teste';
        insert conta;
        
        Contact con = new Contact();
        con.AccountId = conta.Id;
        con.LastName = 'Test';
        con.Email = 'test@test.com';
        insert con;
        
        con.UltimoInvitationId__c = 'Test';
        con.UltimaNotaPesquisa__c = 7.00;
        update con;
    }

    @isTest
    static void shouldAssignContactHierarchy(){

        Account account = new Account();
        account.Name = 'Account Test';
        Account.RecordTypeId = RecordTypeMemory.getRecType( 'Account', 'Academic_Account' );
        insert account;
        
        Contact contact1 = new Contact();
        contact1.AccountId = account.Id;
        contact1.LastName = 'Franqueado';
        contact1.Email = 'franqueado@test.com';
        contact1.Fun_o__c = 'Franqueado';
        insert contact1;

        Contact contact2 = new Contact();
        contact2.AccountId = account.Id;
        contact2.LastName = 'Diretor';
        contact2.Email = 'diretor@test.com';
        contact2.Fun_o__c = 'Diretor';
        insert contact2;
        
        Contact contact3 = new Contact();
        contact3.AccountId = account.Id;
        contact3.LastName = 'Professor';
        contact3.Email = 'professor@test.com';
        contact3.Fun_o__c = 'Professor';
        insert contact3;

        Contact contact4 = new Contact();
        contact4.AccountId = account.Id;
        contact4.LastName = 'Coordenador';
        contact4.Email = 'coordenador@test.com';
        contact4.Fun_o__c = 'Coordenador';
        insert contact4;

        Map<Id, Contact> contacts = new Map<Id, Contact>([
            SELECT Id, Fun_o__c, ReportsToId FROM Contact
        ]);
        
        Set<Id> accountIds = new Set<Id>();
        accountIds.add(account.Id);
        
        Map<Id, Contact> relatedContacts = new Map<Id, Contact>([
            SELECT Id, Fun_o__c, AccountId FROM Contact WHERE AccountId IN :accountIds
        ]);
        
        List<Contact> lstContacts = new List<Contact>();
        lstContacts.add(contact1);
        lstContacts.add(contact2);
        lstContacts.add(contact3);
        lstContacts.add(contact4);
        ContactBO.updateAccountData(lstContacts);

        //System.assert(contacts.get(contact1.Id).ReportsToId == null);
        /*System.assert(contacts.get(contact2.Id).ReportsToId == contact1.Id);
        System.assert(contacts.get(contact3.Id).ReportsToId == contact2.Id);
        System.assert(contacts.get(contact4.Id).ReportsToId == null);*/
    }
}