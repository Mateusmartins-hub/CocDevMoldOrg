public with sharing  class HttpExterno { 
	public String getContent(String url, String metodo, String head, String body) { 
		try {
			Http h = new Http();	 
			HttpRequest req = new HttpRequest();
			req.setTimeout(60000); 
			req.setEndpoint(url); 
			req.setMethod(metodo); 
			req.setHeader('Content-Type', head);  
			req.setbody(body);
			
			HttpResponse res = h.send(req); 
			
			if (res.getStatusCode() != 200) {
				return 'Erro de conexão ' + res.getStatusCode();
			} else {
				return res.getBody();
			}
	     } catch(System.CalloutException e) {
             throw e;
			//return 'Erro de conexão com SAP';
	     }    	
    }

	public HttpResponse makeRequest(String url, String metodo, String head, String body) { 
		try {
			Http h = new Http();	 
			HttpRequest req = new HttpRequest();
			req.setTimeout(60000); 
			req.setEndpoint(url); 
			req.setMethod(metodo); 
			req.setHeader('Content-Type', head);  
			req.setbody(body);
			
			HttpResponse res = h.send(req);
			return res;
						
	     } catch(System.CalloutException e) {
             throw e;			
	     }    	
    }	
}