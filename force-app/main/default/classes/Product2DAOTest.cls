@isTest
public class Product2DAOTest {

    @isTest
    static void testOne() {
        Product2 prdt = TestHelper.createProduct();
        prdt.BR_ISBN__c = '123';
        insert prdt;
        
        Product2DAO.getProduct2ById(prdt.Id);
        Product2DAO.listaProduto(new List<String> {prdt.Id});
        Product2DAO.getProductsByISBN(new Set<String> {prdt.BR_ISBN__c});
    }
}