@isTest
private class AccountContactDAOTest {

    static testMethod void myUnitTest() {
        Account acc = TestHelper.createAccount();
        insert acc;
        
        Contact c = TestHelper.createContact();
        c.AccountId = acc.Id;
        insert c;
        
        Account_Contact__c accCon = new Account_Contact__c();
        accCon.Account__c = acc.Id;
        accCon.Contact__c = c.Id;
        insert accCon;
        
        AccountContactDAO.getListAccountContact( new List< String >{} );
        AccountContactDAO.getAccountContactByAccountId( acc.Id, new List< String >{} );
        AccountContactDAO.getAccountContactByAccountId( acc.Id, c.Id );
        AccountContactDAO.getAccountContactByContactIds( new Set< String >{c.Id} );
        
        AccountContactDAO.getInstance().getListAccountContactByAccountId(acc.Id);
        AccountContactDAO.getInstance().getListAccountContactByAccountIdAndContactName('', '');
        AccountContactDAO.getInstance().getListAccountContactByAccountIdRemoveContact(null, new List< String >{} );
        AccountContactDAO.getInstance().getListAccountContactByAccountIdAndContactNameRemoveContact(null, null, new List< String >{} );
        AccountContactDAO.getInstance().getContatosIstituicao(null);
        AccountContactDAO.getInstance().buscaContatos(accCon.Id);
        AccountContactDAO.getInstance().buscaContatosIstituicao(accCon.Id);
    }
}