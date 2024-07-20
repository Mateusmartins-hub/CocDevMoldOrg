@isTest
global class VendaEspecial_Find_Mock implements HttpCalloutMock {
    global HTTPResponse respond(HTTPRequest req) {
        // System.assertEquals('https://ecollege.pearson.com.br/ws/vendaEspecial.asmx/Find', req.getEndpoint());
        // System.assertEquals('https://ecollege.pearson.com.br/ws/vendaEspecial_producao.asmx/Find', req.getEndpoint());
        System.assertEquals('POST', req.getMethod());

        HttpResponse res = new HttpResponse();
        res.setHeader('Content-Type', 'application/x-www-form-urlencoded');
        //OK 
        //res.setBody('<string xmlns="http://tempuri.org/">{"Status":"OK","Data":[{"CODIGO":"1","VARIAVEL":"LivroParteDoCatalogo","VALIDO":"1","MENSAGEM":""},{"CODIGO":"2","VARIAVEL":"LivroVendaInternet","VALIDO":"1","MENSAGEM":""},{"CODIGO":"3","VARIAVEL":"LivroInternetEstoque","VALIDO":"1","MENSAGEM":""},{"CODIGO":"4","VARIAVEL":"LivroCampanha","VALIDO":"1","MENSAGEM":""},{"CODIGO":"5","VARIAVEL":"LivroAmostra","VALIDO":"1","MENSAGEM":""},{"CODIGO":"6","VARIAVEL":"LivroVendaEspecial","VALIDO":"1","MENSAGEM":""},{"CODIGO":"7","VARIAVEL":"Professor","VALIDO":"1","MENSAGEM":""},{"CODIGO":"8","VARIAVEL":"LivroContido75","VALIDO":"1","MENSAGEM":""}]}</string>');
        //INVALIDO
        res.SetBody('<string xmlns="http://tempuri.org/">{"Status":"INVALIDO","Data":[{"CODIGO":"1","VARIAVEL":"LivroParteDoCatalogo","VALIDO":"0","MENSAGEM":"Livro não disponível no catálogo"},{"CODIGO":"2","VARIAVEL":"LivroVendaInternet","VALIDO":"0","MENSAGEM":"Livro não disponível para venda no Ecommerce"},{"CODIGO":"3","VARIAVEL":"LivroInternetEstoque","VALIDO":"0","MENSAGEM":"Livro não tem estoque para internet"},{"CODIGO":"4","VARIAVEL":"LivroCampanha","VALIDO":"0","MENSAGEM":"Livro não está contido na campanha -364 - VENDA ESPECIAL 75%"},{"CODIGO":"5","VARIAVEL":"LivroAmostra","VALIDO":"1","MENSAGEM":""},{"CODIGO":"6","VARIAVEL":"LivroVendaEspecial","VALIDO":"1","MENSAGEM":""},{"CODIGO":"7","VARIAVEL":"Professor","VALIDO":"1","MENSAGEM":""},{"CODIGO":"8","VARIAVEL":"LivroContido75","VALIDO":"1","MENSAGEM":""}]}</string>');
        res.setStatusCode(200);
        return res;
    }
}