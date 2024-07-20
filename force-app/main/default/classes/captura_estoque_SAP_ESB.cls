public class captura_estoque_SAP_ESB{
    // String valor;
    public String ISBN;
    public Integer Qtd;
    public String Local_Estoque;
    public String Mensagem;

 
    public class Exports
    {
        public string V_COUNT { get; set; }
    }
    
    public class Structure
    {
        public string MATNR { get; set; }
        public string BUKRS { get; set; }
        public string LBKUM { get; set; }
        public string LABST { get; set; }
    }
    
    public class Table
    {
        public string Name { get; set; }
        public List<Structure> Structures { get; set; }
    }
    
    public class Data
    {
        public Exports Exports { get; set; }
        public List<Table> Tables { get; set; }
    }
    
    public class RootObject
    {
        public string Status { get; set; }
        public Data Data { get; set; }
    }
            

    
    public RootObject parseJSONResponse() {     
		
        //------- Acesso a base estoques  ------------
        String retorno;
        String endpoint;
        String body ;
        String str_datarequest; 
        
        if (String.IsBlank(Local_Estoque)) {
        	Local_Estoque = 'PE01';
        }
 	
 	    /*
        endpoint = 'http://159.182.80.91/rfc';
        body = 'Key=42963.83939217776&User=umiosro&ConnectionName=SAP_QAS&Application=SAP&EndPoint=ZSD_RETORNA_ESTOQUE_DISPONIVEL&DataRequest={"MATNR":"' + '00000' + ISBN  + '","BUKRS":"PEBR","BWKEY":"' + Local_Estoque + '"}';
        system.debug(body);
        */
     	
        if(!test.isrunningtest()){
            HTTPExterno portal = new HTTPExterno();
            //str_datarequest = '{"MATNR":"' + '00000' + ISBN  + '","BUKRS":"PEBR","BWKEY":"' + Local_Estoque + '"}';
            str_datarequest = '{"I_MATNR":"' + '00000' + ISBN  + '"}';
            body = 'key=' + Constants.ESTOQUE_ESB_KEY + '&User=' + Constants.ESTOQUE_ESB_USER + '&ConnectionName=' + Constants.ESTOQUE_ESB_CONNECTIONNAME + '&Application=' +  Constants.ESTOQUE_ESB_APPLICATION + '&EndPoint=' + Constants.ESTOQUE_ESB_RFC + '&DataRequest=' + str_datarequest; 
            
            system.debug('aquii ' + str_datarequest);
            system.debug('aquii ' + body);
            retorno = portal.getContent(Constants.ESTOQUE_ESB_URL,'POST', 'application/x-www-form-urlencoded',body);                           
            System.debug('aquii ' + retorno);
        } else
            retorno = '{"Status":"OK","Data":{"Exports":{},"Tables":[{"Name":"ZBRSDS026","Structures":[{"MATNR":"000009780131106420","LABST":"0,000"}]}]}}';
        /*
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
        */
        
        // retorno = '{"Exports":[{"V_COUNT":"1"}],"Tables":[{"Name":"ZSDS013","Structures":[{"MATNR":"000009788534614597","BUKRS":"PEBR","LBKUM":"89,000"}]}]}';
		// retorno = '{"Status":"OK","Data":{"Exports":{"V_COUNT":"1"},"Tables":[{"Name":"ZSDS013","Structures":[{"MATNR":"000009780074504093","BUKRS":"PEBR","LBKUM":"2116,000"}]}]}}';
       
        JSONParser parser = JSON.createParser(retorno);
		sYSTEM.DEBUG('aquii ' + parser);
		sYSTEM.DEBUG('aquii ' + retorno);
        RootObject inv = new RootObject();
        
        while (parser.nextToken() != null) {
            if (parser.getCurrentToken() == JSONToken.START_OBJECT) {
                inv = (RootObject)parser.readValueAs(RootObject.class);
            }
        }
        
        if (inv.Data.Exports.V_COUNT == '0') {
        	System.debug('Name = '  +inv.Data.Tables[0].Name);
        	
        	//inv.Data.Tables[0].Structure[0].MATNR = '0';
        	//inv.Data.Tables[0].Structure[0].BUKRS = '0';
        	//inv.Data.Tables[0].Structure[0].LBKUM = '0';
        	
        }
        
        return inv;
        
   
    }    
    
}

/*
captura_estoque_SAP_ESB A = new captura_estoque_SAP_ESB();
 A.ISBN = '9788534614597'; // 9780130652034
 A.Local_Estoque = 'PE01';
captura_estoque_SAP_ESB.RootObject B = A.parseJSONResponse();
System.debug('B.Status: ' +B.Status);
System.debug('B.Data.Exports.V_COUNT): ' +B.Data.Exports.V_COUNT);
System.debug('B.Data.Tables[0].Name: ' + B.Data.Tables[0].Name);

system.debug('B.Data.Tables[0].Structures[0].MATNR:' + B.Data.Tables[0].Structures[0].MATNR);
System.debug('B.Data.Tables[0].Structures[0].BUKRS:' + B.Data.Tables[0].Structures[0].BUKRS);
System.debug('B.Data.Tables[0].Structures[0].LBKUM:' + B.Data.Tables[0].Structures[0].LBKUM);
 */