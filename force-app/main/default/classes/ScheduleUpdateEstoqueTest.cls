@isTest
public class ScheduleUpdateEstoqueTest {
    
    @isTest
    static void testOne() {
        Test.setMock(HttpCalloutMock.class, new MockHTTPResponseEstoqueSAP());

        insert new IntegracaoEstoqueSAP__c(ConnectionName__c = 'test', EndpointApplication__c='tes', EndpointKey__c='test',EndpointURL__c='test',EndpointUser__c='test',RFC__c='test');

        Product2 prdt = TestHelper.createProduct();
        prdt.BR_ISBN__c = '123';
        insert prdt;
        
        Test.StartTest();
        ScheduleUpdateEstoque sh1 = new ScheduleUpdateEstoque();
        
        String sch = '0 0 23 * * ?'; 
        system.schedule('Test Schedule - ' + System.now(), sch, sh1); 
        Test.stopTest();
    }
}