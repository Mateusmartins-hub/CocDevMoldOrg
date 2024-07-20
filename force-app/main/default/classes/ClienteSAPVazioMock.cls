public with sharing class ClienteSAPVazioMock  implements HttpCalloutMock {
	// Implement this interface method
	public HTTPResponse respond(HTTPRequest request) {
		// Create a fake response
		HttpResponse response = new HttpResponse();
		response.setHeader('Content-Type', 'application/json');
		response.setBody('{"Status":"OK","Data":{"Exports":{},"Tables":[{"Name":"E_DADOS","Structures":[]}]}}');
		response.setStatusCode(200);
		return response;
	}

}