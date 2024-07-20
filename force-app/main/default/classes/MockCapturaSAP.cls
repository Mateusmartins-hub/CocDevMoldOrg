@isTest
    global class MockCapturaSAP implements HttpCalloutMock {
    global HTTPResponse respond(HTTPRequest req) {        
        HttpResponse res = new HttpResponse();
        res.setHeader('Content-Type', 'application/json');
        res.setBody('{"Status":"OK","Data":{"Exports":{"V_COUNT":"1"},"Tables":[{"Name":"ZSDS013","Structures":[{"MATNR":"000009780074504093","BUKRS":"PEBR","LABST":"2116,000"}]}]}}');
        res.setStatusCode(200);
        return res;
    }
}