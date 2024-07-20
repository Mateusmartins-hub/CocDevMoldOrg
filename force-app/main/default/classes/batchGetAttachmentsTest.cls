@isTest
public class batchGetAttachmentsTest {

    private static final String FAKE_RESPONSE_JSON = '{""}';

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
        
        Anexo__c anexo 			= new Anexo__c();
        anexo.Name__c 			= 'TesteAnexo';
        anexo.IDSegregacao__c 	= 'IdTeste';
        anexo.ParentIdReal__c	= '';
        anexo.Processado__c 	= false;
        anexo.ParentType__c 	= 'Account';
        insert anexo;
        
        anexo.ParentIdReal__c 	= anexo.Id;
        update anexo;
    }
    
    @isTest 
    static void testCreateList() {
                
        Test.setMock(HttpCalloutMock.class, new Mock());

        Test.startTest();
        Id idbatch = Database.executeBatch(new batchGetAttachments(), 100);
        Test.stopTest();

    }    
}