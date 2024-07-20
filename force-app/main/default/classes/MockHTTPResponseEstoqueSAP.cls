@isTest
global class MockHTTPResponseEstoqueSAP implements HttpCalloutMock {
    global HTTPResponse respond(HTTPRequest req) {
        // Create a fake response
        HttpResponse res = new HttpResponse();
        res.setHeader('Content-Type', 'application/json');
        res.setBody('{"Status":"OK","Data":{"Exports":{},"Tables":[{"Name":"ZBRSDS026","Structures":[{"MATNR":"000009788580408027","LABST":"10,000"}]}]}}');
        res.setStatusCode(200);
        return res;
    }
}