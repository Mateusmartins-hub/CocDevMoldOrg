@isTest
public class EstoqueValidationTest {

    @isTest
    static void testOne() {
        Product2 prd = TestHelper.createProduct();
        insert prd;
        
        EstoqueProdutos__c est = new EstoqueProdutos__c();
        est.Produto__c = prd.Id;
        est.Quantidade__c = 10000;
        insert est;
    }
}