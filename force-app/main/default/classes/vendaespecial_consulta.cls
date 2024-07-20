/**
 *
 * Class vendaespecial_consulta  - 03/09/2014 - Robinson Mioshi
 * 
 */
public with sharing class vendaespecial_consulta {

    public String ISBN { get; set; }
    public String CPF { get; set; }
    public String Pedido_Site { get; set; }
    public String Campanha {get;set; }
    
    public class Status_Pedido {
        public String status {get;set;}
        public List<Datum> Data {get;set;}
        public Status_Pedido () {
        }
    }
    
    public class Datum {
    	public String codigo;
        public String variavel;
        public String valido;
        public String mensagem;
    }
    
    // -------------- Consulta se o produto pode ser oferecido na cortesia
    /*
    vendaespecial_consulta A = new vendaespecial_consulta();
    A.ISBN = '97885814360361';
    A.CPF= '65251598653';
	A.Campanha = '75';
    vendaespecial_consulta.Status_Pedido B = A.parseJSONResponse();
    System.debug(B.status);
    System.debug(B.Data.Size());
    System.debug(B.Data[0].Mensagem);
     */
    public Status_Pedido parseJSONResponse() {        
        //------- Acesso a base estoques  ------------
        String retorno;
        String endpoint;
        String body ;
 
        endpoint = Constants.VENDAESPECIAL_ESB_URL + '/Find';
        //body = 'key=af7a158cb1b057f55938060f23177adf&ISBN=000009780131993136';
        body = 'ISBN='+ ISBN + '&CPF=' + CPF_apenas_numero(CPF) ;
        HttpRequest req = new HttpRequest();
        req.setEndpoint(endpoint);
        req.setMethod('POST');
        req.setHeader('Content-Type', 'application/x-www-form-urlencoded');  
        req.setbody(body);
        system.debug('body = ' + body);
        Http http = new Http();
        try{
                    HTTPResponse response = http.send(req);
                    retorno = response.getBody(); 
                    system.debug(retorno);
                    retorno = retorno.replace('<?xml version="1.0" encoding="utf-8"?>', '');  
                    retorno = retorno.replace('<string xmlns="http://tempuri.org/">', '');    
                    retorno = retorno.replace('</string>', '');    
                    system.debug('VendaEspecia_Consulta retorno = ' + retorno);
            
                    JSONParser parser = JSON.createParser(retorno);
                    
                    Status_Pedido inv = new Status_Pedido();
                    
                    while (parser.nextToken() != null) {
                        if (parser.getCurrentToken() == JSONToken.START_OBJECT) {
                            inv = (Status_Pedido)parser.readValueAs(Status_Pedido.class);
                        }
                    }
                    return inv;
        }catch(Exception e){
            	
            		retorno = '{"Status":"INVALIDO","Data":[{"CODIGO":"1","VARIAVEL":"LivroParteDoCatalogo","VALIDO":"1","MENSAGEM":""},{"CODIGO":"2","VARIAVEL":"LivroVendaInternet","VALIDO":"1","MENSAGEM":""},{"CODIGO":"3","VARIAVEL":"LivroInternetEstoque","VALIDO":"1","MENSAGEM":""},{"CODIGO":"4","VARIAVEL":"LivroCampanha","VALIDO":"1","MENSAGEM":""},{"CODIGO":"5","VARIAVEL":"LivroAmostra","VALIDO":"1","MENSAGEM":""},{"CODIGO":"6","VARIAVEL":"LivroVendaEspecial","VALIDO":"1","MENSAGEM":""},{"CODIGO":"7","VARIAVEL":"Professor","VALIDO":"1","MENSAGEM":""},{"CODIGO":"8","VARIAVEL":"LivroContido75","VALIDO":"1","MENSAGEM":""},{"CODIGO":"9","VARIAVEL":"Conexao","VALIDO":"0","MENSAGEM":"Sem conexão com Ecommerce - Tente mais tarde"}]}';
        			 JSONParser parser = JSON.createParser(retorno);
                    
                    Status_Pedido inv = new Status_Pedido();
                    
                    while (parser.nextToken() != null) {
                        if (parser.getCurrentToken() == JSONToken.START_OBJECT) {
                            inv = (Status_Pedido)parser.readValueAs(Status_Pedido.class);
                        }
                    }
            		return inv;
        }
    	
 
    } 
    
	/*    
    vendaespecial_consulta A = new vendaespecial_consulta();
    A.ISBN = '97885814360361';
    A.CPF= '17817062803';
	A.Campanha = '75';
    vendaespecial_consulta.Status_Pedido B = A.Altera_Produto_Adquirido();
    System.debug(B.status);
    System.debug(B.Data.Size());
    System.debug(B.Data[0].Mensagem);
     */
	public Status_Pedido Altera_Produto_Adquirido() { 
       
        String retorno;
        String endpoint;
        String body ;

        endpoint = Constants.VENDAESPECIAL_ESB_URL + '/Alteracao';
        body = 'ISBN='+ ISBN + '&CPF=' + CPF_apenas_numero(CPF) + '&cod_campanha=' + Campanha;
        HttpRequest req = new HttpRequest();
        req.setEndpoint(endpoint);
        req.setMethod('POST');
        req.setHeader('Content-Type', 'application/x-www-form-urlencoded');  
        req.setbody(body);
        //system.debug('body = ' + body);
        Http http = new Http();
        try{
            HTTPResponse response = http.send(req);
            retorno = response.getBody(); 
            system.debug(retorno);
            retorno = retorno.replace('<?xml version="1.0" encoding="utf-8"?>', '');  
            retorno = retorno.replace('<string xmlns="http://tempuri.org/">', '');    
            retorno = retorno.replace('</string>', '');    
            //system.debug('retorno = ' + retorno);
    
            JSONParser parser = JSON.createParser(retorno);
            
            Status_Pedido inv = new Status_Pedido();
            
            while (parser.nextToken() != null) {
                if (parser.getCurrentToken() == JSONToken.START_OBJECT) {
                    inv = (Status_Pedido)parser.readValueAs(Status_Pedido.class);
                }
            }
            // Voltar ao status de Adquirido Não e remover o PedidoSite
            
            return inv;
        }catch(Exception e){    
            retorno = '{"Status":"INVALIDO","Data":[{"CODIGO":"1","VARIAVEL":"LivroParteDoCatalogo","VALIDO":"1","MENSAGEM":""},{"CODIGO":"2","VARIAVEL":"LivroVendaInternet","VALIDO":"1","MENSAGEM":""},{"CODIGO":"3","VARIAVEL":"LivroInternetEstoque","VALIDO":"1","MENSAGEM":""},{"CODIGO":"4","VARIAVEL":"LivroCampanha","VALIDO":"1","MENSAGEM":""},{"CODIGO":"5","VARIAVEL":"LivroAmostra","VALIDO":"1","MENSAGEM":""},{"CODIGO":"6","VARIAVEL":"LivroVendaEspecial","VALIDO":"1","MENSAGEM":""},{"CODIGO":"7","VARIAVEL":"Professor","VALIDO":"1","MENSAGEM":""},{"CODIGO":"8","VARIAVEL":"LivroContido75","VALIDO":"1","MENSAGEM":""},{"CODIGO":"9","VARIAVEL":"Conexao","VALIDO":"0","MENSAGEM":"Sem conexão com Ecommerce - Tente mais tarde"}]}';
            JSONParser parser = JSON.createParser(retorno);
            
            Status_Pedido inv = new Status_Pedido();
            
            while (parser.nextToken() != null) {
                if (parser.getCurrentToken() == JSONToken.START_OBJECT) {
                    inv = (Status_Pedido)parser.readValueAs(Status_Pedido.class);
                }
            }
            return inv;
            
        } 
	}
    
    /*    
    vendaespecial_consulta A = new vendaespecial_consulta();
    A.ISBN = '97885814360361';
    A.CPF= '17817062803';
	A.Campanha = '75';
    vendaespecial_consulta.Status_Pedido B = A.Alterar_Ativo();
    System.debug(B.status);
    System.debug(B.Data.Size());
    System.debug(B.Data[0].Mensagem);
     */
    public Status_Pedido Alterar_Ativo() { 
        
        String retorno;
        String endpoint;
        String body ;

        endpoint = Constants.VENDAESPECIAL_ESB_URL + '/Desativar';
        body = 'ISBN='+ ISBN + '&CPF=' + CPF_apenas_numero(CPF) + '&cod_campanha=' + Campanha;
        HttpRequest req = new HttpRequest();
        req.setEndpoint(endpoint);
        req.setMethod('POST');
        req.setHeader('Content-Type', 'application/x-www-form-urlencoded');  
        req.setbody(body);
        //system.debug('body = ' + body);
        Http http = new Http();
        try{
            HTTPResponse response = http.send(req);
            retorno = response.getBody(); 
            system.debug(retorno);
            retorno = retorno.replace('<?xml version="1.0" encoding="utf-8"?>', '');  
            retorno = retorno.replace('<string xmlns="http://tempuri.org/">', '');    
            retorno = retorno.replace('</string>', '');    
    
            JSONParser parser = JSON.createParser(retorno);
            
            Status_Pedido inv = new Status_Pedido();
            
            while (parser.nextToken() != null) {
                if (parser.getCurrentToken() == JSONToken.START_OBJECT) {
                    inv = (Status_Pedido)parser.readValueAs(Status_Pedido.class);
                }
            }
            // Voltar ao status de Adquirido Não e remover o PedidoSite
            return inv;
        }catch(Exception e){ 
        	retorno = '{"Status":"INVALIDO","Data":[{"CODIGO":"1","VARIAVEL":"LivroParteDoCatalogo","VALIDO":"1","MENSAGEM":""},{"CODIGO":"2","VARIAVEL":"LivroVendaInternet","VALIDO":"1","MENSAGEM":""},{"CODIGO":"3","VARIAVEL":"LivroInternetEstoque","VALIDO":"1","MENSAGEM":""},{"CODIGO":"4","VARIAVEL":"LivroCampanha","VALIDO":"1","MENSAGEM":""},{"CODIGO":"5","VARIAVEL":"LivroAmostra","VALIDO":"1","MENSAGEM":""},{"CODIGO":"6","VARIAVEL":"LivroVendaEspecial","VALIDO":"1","MENSAGEM":""},{"CODIGO":"7","VARIAVEL":"Professor","VALIDO":"1","MENSAGEM":""},{"CODIGO":"8","VARIAVEL":"LivroContido75","VALIDO":"1","MENSAGEM":""},{"CODIGO":"9","VARIAVEL":"Conexao","VALIDO":"0","MENSAGEM":"Sem conexão com Ecommerce - Tente mais tarde"}]}';
            JSONParser parser = JSON.createParser(retorno);
            
            Status_Pedido inv = new Status_Pedido();
            
            while (parser.nextToken() != null) {
                if (parser.getCurrentToken() == JSONToken.START_OBJECT) {
                    inv = (Status_Pedido)parser.readValueAs(Status_Pedido.class);
                }
            }
            return inv;
        }   
    }
    
    public string CPF_apenas_numero(String CPF) { 
            if (CPF <> Null && CPF <> '') {
        	CPF = CPF.replace('-','');
        	CPF = CPF.replace('.','');	
            CPF = CPF.replace(' ','');	    
            } else {
                CPF = CPF;
            }
                
            return CPF;
    }
}