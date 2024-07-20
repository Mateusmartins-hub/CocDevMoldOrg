@isTest
public class AreaVendaDAOTest {
    
    @isTest
    static void testObterAtravesDeAreaVenda(){
        
        Account iAccount = new Account();
        iAccount.Name = 'Conta Teste';
        insert iAccount;
        
        BR_AreaVenda__c iAreaVenda = new BR_AreaVenda__c();
        iAreaVenda.BR_Conta__c = iAccount.Id;
        insert iAreaVenda;
        
        AreaVendaDAO.getInstance().obterListaAreaVendaPorId(String.valueOf(iAreaVenda.Id));
    }
    
    @isTest
    static void testObterAtravesDeConta(){
        
        Account iAccount = new Account();
        iAccount.Name = 'Conta Teste';
        insert iAccount;
        
        AreaVendaDAO.getInstance().obterListaAreaVendaPorConta(String.valueOf(iAccount.Id));
    }

}