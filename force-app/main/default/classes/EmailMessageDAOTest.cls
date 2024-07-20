@isTest
public class EmailMessageDAOTest {
    
    @isTest
    static void testGetEmailMessageByParentId(){
        
        Account iAccount = new Account();
        iAccount.Name = 'Conta Teste';
        insert iAccount;
        
        
        EmailMessageDAO.getInstance().getEmailMessageByParentId(iAccount.Id);
    }
    
    @isTest
    static void testGetEmailMessageByParentIdAndStatus(){
        
        Account iAccount = new Account();
        iAccount.Name = 'Conta Teste';
        insert iAccount;
        
        
        EmailMessageDAO.getInstance().getEmailMessageByParentIdAndStatus(iAccount.Id, 'Teste');
    }
    
}