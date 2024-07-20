@isTest
private class PricebookDAOTest {
	
    static testMethod void myUnitTest() {    	
        Test.startTest();
        String priceBookId = PricebookDAO.getInstance().findByName('Ensino Superior').Id;
        Pricebook2 pb = PricebookDAO.getInstance().getPricebookById(Test.getStandardPricebookId());
        List<Pricebook2> lstPb = PricebookDAO.getInstance().getActivePricebookList();
    	Test.stopTest();
    }
    
}