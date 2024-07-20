@isTest
public class EstoqueProdutosDAOTest {

    @isTest
    static void testOne() {
        Product2 prdt = TestHelper.createProduct();
        prdt.BR_ISBN__c = '123';
        insert prdt;
        
        EstoqueProdutos__c ep = new EstoqueProdutos__c();
        ep.Produto__c = prdt.Id;
        insert ep;
        
        EstoqueProdutosDAO.getEstoqueFromProductsId(new Set<Id> {prdt.Id});        
    }
}