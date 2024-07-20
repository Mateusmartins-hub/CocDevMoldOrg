@isTest
public class ProdutosComDescontoDAOTest {
    
    @isTest
    static void testGetProdutos(){
        
        List<String> idContactSet = new List<String>();
        
        Account iAccount = new Account();
        iAccount.Name = 'Conta Teste';
        insert iAccount;
        
        Contact iContact = new Contact();
        iContact.AccountId = iAccount.Id;
        iContact.LastName = 'Test';
        iContact.Email = 'test@test.com';
        idContactSet.add(String.valueOf(iContact.Id));
        
        ProdutosComDescontoDAO.getInstance().getProdutos(idContactSet);
    }

}