@isTest
public class UpdateEstoqueBatchTest {

    @isTest
    static void testOne() {        
        Test.setMock(HttpCalloutMock.class, new MockHTTPResponseEstoqueSAP());
        
        insert new IntegracaoEstoqueSAP__c(ConnectionName__c = 'test', EndpointApplication__c='tes', EndpointKey__c='test',EndpointURL__c='test',EndpointUser__c='test',RFC__c='test');
        
        Product2 prdt = TestHelper.createProduct();
        prdt.BR_ISBN__c = '9788580408027';
        insert prdt;
        
        Test.StartTest();
        Database.executeBatch(new UpdateEstoqueBatch(), 150);
        Test.stopTest();
    }
}