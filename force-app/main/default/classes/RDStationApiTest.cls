@isTest
public class RDStationApiTest {

    public class RequestMock implements HttpCalloutMock {
        private String body;
        private Integer status;

        public RequestMock(String body, Integer status){
            this.body = body;
            this.status = status;
        }

        public HTTPResponse respond(HTTPRequest req) {
            HttpResponse res = new HttpResponse();
            res.setHeader('Content-Type', 'application/json');
            res.setBody(this.body);
            res.setStatusCode(this.status);
            return res;
        }
    }
    
    @isTest
    static void shouldMarkOpportunityAsWon(){

        Test.setMock(HttpCalloutMock.class, new RDStationApiTest.RequestMock('{"uuid": "123456789"}', 200));
        
        RDStationApi api = new RDStationApi('Mentes');
        HttpResponse response = api.setOpportunityAsWon('test@test.com', 100);

        System.assertEquals(response.getStatusCode(), 200);

    }

    @isTest
    static void shouldMarkOpportunityAsLost(){

        Test.setMock(HttpCalloutMock.class, new RDStationApiTest.RequestMock('{"uuid": "123456789"}', 200));
        
        RDStationApi api = new RDStationApi('Mentes');
        HttpResponse response = api.setOpportunityAsLost('test@test.com', 'Lost reason');

        System.assertEquals(response.getStatusCode(), 200);

    }

    @isTest
    static void shouldMarkContactAsOpportunity(){

        Test.setMock(HttpCalloutMock.class, new RDStationApiTest.RequestMock('{"uuid": "123456789"}', 200));
        
        RDStationApi api = new RDStationApi('Mentes');
        HttpResponse response = api.setContactAsOpportunity('test@test.com');

        System.assertEquals(response.getStatusCode(), 200);

    }

    @isTest
    static void shouldThrowErrorOnContactUpdate(){

        try{
            RDStationApi api = new RDStationApi('Mentes');

            RDStationModel.Contato contact = new RDStationModel.Contato();
            System.assertEquals(false, contact.isValid());
            
            HttpResponse response = api.updateContact(contact);
        }
        catch(Exception e){
            System.assert(e != null);
        }
        

    }

    @isTest
    static void shouldUpdateContact(){

        Test.setMock(HttpCalloutMock.class, new RDStationApiTest.RequestMock('{"uuid": "123456789"}', 200));

        RDStationApi api = new RDStationApi('Mentes');

        RDStationModel.Contato contact = new RDStationModel.Contato();
        contact.email = 'test@test.com';
        
        HttpResponse response = api.updateContact(contact);

        System.assertEquals(response.getStatusCode(), 200);

    }


    @isTest
    static void shouldRetrieveContact(){

        Test.setMock(HttpCalloutMock.class, new RDStationApiTest.RequestMock('{"email": "test@test.com"}', 200));

        RDStationApi api = new RDStationApi('Mentes');

        HttpResponse response = api.retrieveContact('test@test.com');
        
        RDStationModel.Contato contact = (RDStationModel.Contato)JSON.deserialize(response.getBody(), RDStationModel.Contato.class);
        
        System.assertEquals(true, contact.isValid());

    }

}