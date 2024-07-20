@isTest
public class RestHybrisAttachmentTest {

    @isTest
    static void testOne() {
        Case caso = new Case();
        caso.Origin = 'Hybris';
        caso.OrdemGrupoSolucionador__c = 1;
        caso.Subject = 'Novo Cadastro & Devolução de Pedido';
        caso.Description = 'Novo Cadastro & Devolução de Pedido do Hybris';
        caso.Tipo__c = 'Cadastro';
        caso.Subtipo__c = 'Novo Cadastro';
        caso.Detalhamento__c = 'Devoluções';
        insert caso;
        
        caso = [SELECT Id, CaseNumber FROM Case WHERE Id =: caso.Id];
        
        RestHybrisAttachment.ParamAttachment param = new RestHybrisAttachment.ParamAttachment();
        param.name = 'test';
        param.b64 = 'dGVzdA==';
        
        RestRequest req = new RestRequest(); 
        RestResponse res = new RestResponse();
        req.requestURI = '/' + caso.CaseNumber;
        RestContext.request = req;
        RestContext.response = res;
        
        RestHybrisAttachment.insertAttachment(new List<RestHybrisAttachment.ParamAttachment> {param});
    }

    @isTest
    static void testTwo() {        
        RestHybrisAttachment.ParamAttachment param = new RestHybrisAttachment.ParamAttachment();
        param.name = 'test';
        param.b64 = 'dGVzdA==';
        
        RestRequest req = new RestRequest(); 
        RestResponse res = new RestResponse();
        req.requestURI = '/';
        RestContext.request = req;
        RestContext.response = res;
        
        RestHybrisAttachment.insertAttachment(new List<RestHybrisAttachment.ParamAttachment> {param});
    }
}