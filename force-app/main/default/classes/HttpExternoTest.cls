@isTest
public class HttpExternoTest {

    @isTest
    static void testOne() {
        Test.setMock(HttpCalloutMock.class, new MockHTTPResponseEstoqueSAP());
        
        insert new IntegracaoEstoqueSAP__c(ConnectionName__c = 'test', EndpointApplication__c='tes', EndpointKey__c='test',EndpointURL__c='test',EndpointUser__c='test',RFC__c='test');
        IntegracaoEstoqueSAP__c ENDPOINT_INFO = IntegracaoEstoqueSAP__c.getOrgDefaults();
        Test.startTest();
        HttpExterno request = new HttpExterno();
        
        Map<String, String> mapParams = new Map<String, String>();
        mapParams.put('key', ENDPOINT_INFO.EndpointKey__c);
        mapParams.put('User', ENDPOINT_INFO.EndpointUser__c);
        mapParams.put('ConnectionName', ENDPOINT_INFO.ConnectionName__c);
        mapParams.put('Application', ENDPOINT_INFO.EndpointApplication__c);
        mapParams.put('EndPoint', ENDPOINT_INFO.RFC__c);
        mapParams.put('DataRequest', '[]');
        
        List<String> listParams = new List<String>();
        for (String mp : mapParams.keySet()) {
            listParams.add(mp + '=' + mapParams.get(mp));
        }
        
        String urlParams =  string.join(listParams, '&');
        HttpResponse response = request.makeRequest(ENDPOINT_INFO.EndpointURL__c, 'POST', 'application/x-www-form-urlencoded', urlParams);
        request.getContent(ENDPOINT_INFO.EndpointURL__c, 'POST', 'application/x-www-form-urlencoded', urlParams);
        
        Test.stopTest();
    }
}