@IsTest
public class MakeEstoqueSAPRequestTest {
    @IsTest
    static void estoqueRequestTest() {
        Test.setMock(HttpCalloutMock.class, new MockHTTPResponseEstoqueSAP());

        insert new IntegracaoEstoqueSAP__c(ConnectionName__c = 'test', EndpointApplication__c='tes', EndpointKey__c='test',EndpointURL__c='test',EndpointUser__c='test',RFC__c='test');

        Product2 prdt = TestHelper.createProduct();
        prdt.BR_ISBN__c = '123';
        insert prdt;

        Test.startTest();
        Map<String,String> resultQuantity = MakeEstoqueSAPRequest.getAllStocks();
        Test.stopTest();
    }
}