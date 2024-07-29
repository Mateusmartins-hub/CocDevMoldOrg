@isTest
public class RestHybrisTest {
    
    @isTest
    static void testOne() {
        RestHybris.ParamInsertCaso param = new RestHybris.ParamInsertCaso();
        param.conta = new RestHybris.ContaHybris();
        
        RestHybris.OVHybris ov = new RestHybris.OVHybris();
        
        RestHybris.ProductHybris prod = new RestHybris.ProductHybris();

        ov.prods.add(prod);
        param.ovs.add(ov);
        
        RestRequest req = new RestRequest(); 
        RestResponse res = new RestResponse();
        req.params.put('t', '1');
        RestContext.request = req;
        RestContext.response = res;
        
        RestHybris.insertCaso(param);
    }
    
    @isTest
    static void testTwo() {
        Account acc = TestHelper.createAccount();
        acc.BR_CNPJ__c = '15.974.486/0001-36';
        insert acc;
        
        RestHybris.ParamInsertCaso param = new RestHybris.ParamInsertCaso();
        param.conta = new RestHybris.ContaHybris();
        param.conta.cpfCnpj = '15.974.486/0001-36';
        
        RestHybris.OVHybris ov = new RestHybris.OVHybris();
        
        RestHybris.ProductHybris prod = new RestHybris.ProductHybris();

        ov.prods.add(prod);
        param.ovs.add(ov);
        
        RestRequest req = new RestRequest(); 
        RestResponse res = new RestResponse();
        req.params.put('t', '1');
        RestContext.request = req;
        RestContext.response = res;
        
        RestHybris.insertCaso(param);
    }
    
    @isTest
    static void testThree() {
        Case caso = new Case();
        caso.Origin = 'Hybris';
        caso.OrdemGrupoSolucionador__c = 1;
        caso.Subject = 'Novo Cadastro & Devolução de Pedido';
        caso.Description = 'Novo Cadastro & Devolução de Pedido do Hybris';
        caso.Tipo__c = 'Serviço COC';
        caso.Subtipo__c = 'Atendimento';
        caso.Detalhamento__c = 'Atendimento';
        insert caso;
        
        caso = [SELECT Id, CaseNumber FROM Case WHERE Id =: caso.Id];
                 
        RestRequest req = new RestRequest(); 
        RestResponse res = new RestResponse();
        
        req.requestURI = '/' + caso.CaseNumber;
        RestContext.request = req;
        RestContext.response = res;
        
        RestHybris.getCasoDevolucaoStatus();
        RestHybris.getInfoProds(caso);
        RestHybris.isEmpty('123');
    }
    
    @isTest
    static void testFour() {
        Case caso = new Case();
        caso.Origin = 'Hybris';
        caso.OrdemGrupoSolucionador__c = 1;
        caso.Subject = 'Novo Cadastro & Devolução de Pedido';
        caso.Description = 'Novo Cadastro & Devolução de Pedido do Hybris';
        caso.Tipo__c = 'Serviço COC';
        caso.Subtipo__c = 'Atendimento';
        caso.Detalhamento__c = 'Atendimento';
        insert caso;
        
        caso = [SELECT Id, CaseNumber FROM Case WHERE Id =: caso.Id];
        
        RestRequest req = new RestRequest(); 
        RestResponse res = new RestResponse();
        
        req.requestURI = '/' + caso.CaseNumber;
        RestContext.request = req;
        RestContext.response = res;
        
        RestHybris.ParamUpdateStatusCaso p = new RestHybris.ParamUpdateStatusCaso();
        p.status = 'Em análise';
        
        RestHybris.updateStatusCase(p);
        RestHybris.isEmpty('123');
    }
    
    @isTest
    static void testFive() {
        Account acc = TestHelper.createAccount();
        acc.BR_CNPJ__c = '15.974.486/0001-36';
        insert acc;
        
        RestHybris.ParamInsertCaso param = new RestHybris.ParamInsertCaso();
        param.conta = new RestHybris.ContaHybris();
        param.conta.cpfCnpj = '15.974.486/0001-36';
        
        RestHybris.OVHybris ov = new RestHybris.OVHybris();
        
        RestHybris.ProductHybris prod = new RestHybris.ProductHybris();

        ov.prods.add(prod);
        param.ovs.add(ov);
        
        RestRequest req = new RestRequest(); 
        RestResponse res = new RestResponse();
        req.params.put('t', '2');
        RestContext.request = req;
        RestContext.response = res;
        
        RestHybris.insertCaso(param);
    }
    
    @isTest
    static void testSix() {
        Account acc = TestHelper.createAccount();
        acc.BR_CNPJ__c = '15.974.486/0001-36';
        insert acc;
        
        RestHybris.ParamInsertCaso param = new RestHybris.ParamInsertCaso();
        param.conta = new RestHybris.ContaHybris();
        param.conta.cpfCnpj = '15.974.486/0001-36';
        
        RestHybris.OVHybris ov = new RestHybris.OVHybris();
        
        RestHybris.ProductHybris prod = new RestHybris.ProductHybris();

        ov.prods.add(prod);
        param.ovs.add(ov);
        
        RestRequest req = new RestRequest(); 
        RestResponse res = new RestResponse();
        req.params.put('t', '3');
        RestContext.request = req;
        RestContext.response = res;
        
        RestHybris.insertCaso(param);
    }
    
    @isTest
    static void testSeven() {
        RestRequest req = new RestRequest(); 
        RestResponse res = new RestResponse();
        
        req.requestURI = '/';
        RestContext.request = req;
        RestContext.response = res;
        
        RestHybris.ParamUpdateStatusCaso p = new RestHybris.ParamUpdateStatusCaso();
        p.status = 'Em análise';
        
        RestHybris.updateStatusCase(p);
        RestHybris.isEmpty('123');
    }
    
    @isTest
    static void testEight() {
        RestRequest req = new RestRequest(); 
        RestResponse res = new RestResponse();
        
        req.requestURI = '/';
        RestContext.request = req;
        RestContext.response = res;
        
        RestHybris.getCasoDevolucaoStatus();
        RestHybris.isEmpty('123');
    }
}