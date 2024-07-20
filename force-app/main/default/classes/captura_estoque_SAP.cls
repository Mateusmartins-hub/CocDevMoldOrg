public with sharing class captura_estoque_SAP {

    // String valor;
    public String ISBN;
    public Integer Qtd;
    public String Local_Estoque;
    public String Mensagem;
    
        
    @future(callout = true)
    public static void parseJSONResponseFuture(List<Id> ids) {
        List<OpportunityLineItem> itens = OpportunityLineItemDAO.BuscaProdutoOportunidade(ids);
        
        for (OpportunityLineItem item : itens) {
            captura_estoque_SAP capturaEstoque = new captura_estoque_SAP();
            capturaEstoque.ISBN = item.ProductCode;
            capturaEstoque.Local_Estoque = (item.Opportunity.Cod_Local_do_Estoque__c == null ? 'PE01' :  item.Opportunity.Cod_Local_do_Estoque__c);
            capturaEstoque.parseJSONResponse();
            
            item.QtdDisp__c = capturaEstoque.Qtd;
        }
        
        update itens;
    }
    
    public void parseJSONResponse() {
    	captura_estoque_SAP_ESB A = new captura_estoque_SAP_ESB();
    	A.ISBN = ISBN;
	    A.Local_Estoque = Local_Estoque;
	    captura_estoque_SAP_ESB.RootObject B = A.parseJSONResponse();
	    if (B.Data.Tables[0].Structures.size() > 0 ) {
		    ISBN = B.Data.Tables[0].Structures[0].MATNR;
		    Local_Estoque =  B.Data.Tables[0].Structures[0].BUKRS;
		    //Qtd = Integer.valueof(  B.Data.Tables[0].Structures[0].LBKUM.Replace(',','.'));
		    Qtd = Integer.valueof(  B.Data.Tables[0].Structures[0].LABST.Replace(',','.'));
		    System.debug(B.Data.Tables[0].Structures[0].LBKUM);
		    System.debug(B.Data.Tables[0].Structures[0].LABST);
		    Mensagem = B.Status;
	    } else {
	    	ISBN = '';
            Local_Estoque =  '';
            Qtd = 0;
            Mensagem = 'Produto não encontrado';
	    }
    } 
}

    /*
    public  void parseJSONResponse() {        
        //------- Acesso a base estoques  ------------
        String retorno;
        String endpoint;
        String body ;
        
        endpoint = 'https://ecollege.pearson.com.br/ws/sap.asmx/Estoque';
        //body = 'key=af7a158cb1b057f55938060f23177adf&ISBN=000009780131993136';
        body = 'key=af7a158cb1b057f55938060f23177adf&ISBN='+ ISBN ;
        HttpRequest req = new HttpRequest();
        req.setEndpoint(endpoint);
        req.setMethod('POST');
        req.setHeader('Content-Type', 'application/x-www-form-urlencoded');  
        req.setbody(body);
        //system.debug('body = ' + body);
        Http http = new Http();
        HTTPResponse response = http.send(req);
        retorno = response.getBody(); 
        system.debug(retorno);
        retorno = retorno.replace('<?xml version="1.0" encoding="utf-8"?>', '');  
        retorno = retorno.replace('<string xmlns="http://tempuri.org/">', '');    
        retorno = retorno.replace('</string>', '');    
        //system.debug('retorno = ' + retorno);

        JSONParser parser = JSON.createParser(retorno);
        while (parser.nextToken() != null) {
            // System.debug(parser.getText());
            if ((parser.getCurrentToken() == JSONToken.FIELD_NAME)) {
        	    String fieldName = parser.getText();
				parser.nextToken();
				if(fieldName == 'Status') {
					//System.debug('Status = ' + parser.getText());
                    Mensagem = parser.getText();
		   		}
                if(fieldName == 'matnr') {
					//System.debug('ISBN = ' + parser.getText());
		   		}
                if((fieldName == 'lbkum') && (parser.getText() != NULL) && (parser.getText() != 'null') && (parser.getText() != '')) {
					// System.debug('Qtd = #' + parser.getText() + '#');
                    Qtd =integer.valueof(parser.getText());
		   		}
                if(fieldName == 'bukrs') {
					//System.debug('Local Estoque = ' + parser.getText());
		   		}
                
            }
        }
    }    
    */

/*
captura_estoque_SAP A = new captura_estoque_SAP();
A.ISBN = '000009780131993136';
A.parseJSONResponse();
System.debug(A.Qtd);
System.debug(A.Mensagem);

captura_estoque_SAP A = new captura_estoque_SAP();
A.ISBN = '9780131993136';
A.Local_Estoque = 'PE14';
A.parseJSONResponse();
System.debug(A.Qtd);
System.debug(A.Mensagem);
 */