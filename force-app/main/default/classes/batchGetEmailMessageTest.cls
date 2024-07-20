@isTest
public class batchGetEmailMessageTest {

    private static final String FAKE_RESPONSE_JSON = '{"IdSegregacao__c": ""}';

    private class Mock implements HttpCalloutMock {
        public HTTPResponse respond(HTTPRequest req) {
            HTTPResponse res = new HTTPResponse();
            res.setBody(FAKE_RESPONSE_JSON);
            res.setStatusCode(200);
            return res;
        }
    }

    @TestSetup
    static void testSetup(){
        
        GetAttachmentsEndPoint__c endPoint	= new GetAttachmentsEndPoint__c();
        endPoint.URLPrefix__c 				= 'http://endpointtest';
        endPoint.Auth_Token__c				= 'Bearer XXXX';
        endPoint.Parent_Type__c				= 'Account';
        insert endPOint;
        
        GetEmail__c email 		= new GetEmail__c();
        email.IDSegregacao__c 	= 'IdTeste';
        email.Processado__c 	= false;
        insert email;
    }
    
    @isTest 
    static void testCreateList() {
                
        Test.setMock(HttpCalloutMock.class, new Mock());

        Test.startTest();
        Id idbatch = Database.executeBatch(new batchGetEmailMessage(), 100);
        Test.stopTest();

    }    
}