@isTest
public class RestHybrisDevolucaoTest {
    
    @testSetup
    static void testSetup() {
        ParametrizacaoCasos__c p = new ParametrizacaoCasos__c();
        p.Tipo__c = 'Cadastro';
        p.Subtipo__c = 'Novo Cadastro';
        p.Detalhamento__c = 'Devoluções';
        p.GrupoSolucionador1__c = 'Customer Care';
        insert p;
        
        GrupoSolucionador__c grupo0 = new GrupoSolucionador__c();
        grupo0.Ordem__c = 1;
        grupo0.ParametrizacaoCasos__c = p.Id;
        grupo0.MinutosSLA__c = 720;
        insert grupo0;
        
        ParametrizacaoCasos__c p2 = new ParametrizacaoCasos__c();
        p2.Tipo__c = 'Pedidos';
        p2.Subtipo__c = 'Devolução';
        p2.GrupoSolucionador1__c = 'Customer Care';
        insert p2;
        
        GrupoSolucionador__c grupo1 = new GrupoSolucionador__c();
        grupo1.Ordem__c = 1;
        grupo1.ParametrizacaoCasos__c = p2.Id;
        grupo1.MinutosSLA__c = 720;
        insert grupo1;
    }
    
    @isTest
    static void testOne() {
        RestHybrisDevolucao.ParamInsertCasoDevolucao param = new RestHybrisDevolucao.ParamInsertCasoDevolucao();
        param.conta = new RestHybrisDevolucao.ContaHybris();
        
        RestHybrisDevolucao.OVHybris ov = new RestHybrisDevolucao.OVHybris();
        
        RestHybrisDevolucao.ProductHybris prod = new RestHybrisDevolucao.ProductHybris();

        ov.prods.add(prod);
        param.ovs.add(ov);
        
        RestHybrisDevolucao.insertCasoDevolucao(param);
    }
    
    @isTest
    static void testTwo() {
        Account acc = TestHelper.createAccount();
        acc.BR_CNPJ__c = '15.974.486/0001-36';
        insert acc;
        
        RestHybrisDevolucao.ParamInsertCasoDevolucao param = new RestHybrisDevolucao.ParamInsertCasoDevolucao();
        param.conta = new RestHybrisDevolucao.ContaHybris();
        param.conta.cpfCnpj = '15.974.486/0001-36';
        
        RestHybrisDevolucao.OVHybris ov = new RestHybrisDevolucao.OVHybris();
        
        RestHybrisDevolucao.ProductHybris prod = new RestHybrisDevolucao.ProductHybris();

        ov.prods.add(prod);
        param.ovs.add(ov);
        
        RestHybrisDevolucao.insertCasoDevolucao(param);
    }
    
    @isTest
    static void testThree() {
        Case caso = new Case();
        caso.Origin = 'Hybris';
        caso.OrdemGrupoSolucionador__c = 1;
        caso.Subject = 'Novo Cadastro & Devolução de Pedido';
        caso.Description = 'Novo Cadastro & Devolução de Pedido do Hybris';
        caso.Tipo__c = 'Cadastro';
        caso.Subtipo__c = 'Novo Cadastro';
        caso.Detalhamento__c = 'Devoluções';
        insert caso;
        
        RestRequest req = new RestRequest(); 
        RestResponse res = new RestResponse();
        
        req.requestURI = '/' + caso.CaseNumber;  
        RestContext.request = req;
        RestContext.response = res;
        
        RestHybrisDevolucao.getCasoDevolucaoStatus();
        RestHybrisDevolucao.getInfoProds(caso);
        RestHybrisDevolucao.isEmpty('123');
    }
    
    @isTest
    static void testFour() {
        Case caso = new Case();
        caso.Origin = 'Hybris';
        caso.OrdemGrupoSolucionador__c = 1;
        caso.Subject = 'Novo Cadastro & Devolução de Pedido';
        caso.Description = 'Novo Cadastro & Devolução de Pedido do Hybris';
        caso.Tipo__c = 'Cadastro';
        caso.Subtipo__c = 'Novo Cadastro';
        caso.Detalhamento__c = 'Devoluções';
        insert caso;
        
        RestRequest req = new RestRequest(); 
        RestResponse res = new RestResponse();
        
        req.requestURI = '/' + caso.CaseNumber;  
        RestContext.request = req;
        RestContext.response = res;
        
        RestHybrisDevolucao.ParamUpdateStatusCasoDevolucao p = new RestHybrisDevolucao.ParamUpdateStatusCasoDevolucao();
        p.status = 'Em análise';
        
        RestHybrisDevolucao.updateStatusCase(p);
        RestHybrisDevolucao.isEmpty('123');
    }
}