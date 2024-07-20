global class VendaEspecial_Mock  implements HttpCalloutMock {
   global HTTPResponse respond(HTTPRequest req) {
        // System.assertEquals('http://159.182.80.91/rfc', req.getEndpoint());
        System.assertEquals('POST', req.getMethod());

        HttpResponse res = new HttpResponse();
        res.setHeader('Content-Type', 'application/x-www-form-urlencoded');
 
        res.SetBody('<string xmlns="http://tempuri.org/">{"Status":"OK","Data":[{"Cod_Campanha":"75", "CPF":"60142010332","CODIGO":null,"VARIAVEL":null,"VALIDO":null,"MENSAGEM":""}]}</string>');
        res.setStatusCode(200);
        return res;
        
    }
}