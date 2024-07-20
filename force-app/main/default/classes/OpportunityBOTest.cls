@IsTest
public class OpportunityBOTest {
    @isTest
    public static void Executar()
    {
        User userToRun = [
    		SELECT Id FROM User WHERE Profile.Name LIKE '%admin%' AND ManagerId != null AND isActive = true LIMIT 1
		];

		System.runAs(userToRun){

            Test.setMock(HttpCalloutMock.class, new MockCapturaSAP());
            OpportunityLineItem opItem = TestHelper.createOpportunityLineItem();
            insert opItem;
            
            Opportunity op = TestHelper.createOpportunity();
            insert op;
            
            InstanciaIntegracao__c config = new InstanciaIntegracao__c();
            config.NomeClasse__c = 'IntegracaoDistribOrdemVendaTest';
            config.EndPoint__c = 'teste.com';
            config.ESBKey__c = 'teste';
            config.ESBRFC__c = 'teste';
            config.ESBUser__c = 'teste';
            config.Metodo__c = 'tese';
            config.TimeOut__c = 1000;
            config.Name = 'IntegracaoDistribuicaoOrdemVenda';                   
            insert config;
        
        
            BR_DistribuicaoGratuita__c dg = new BR_DistribuicaoGratuita__c();
            dg.BR_Oportunidade__c = opItem.OpportunityId;
            insert dg;
            
            Id idRecTypeDistribuidor     = RecordTypeMemory.getRecType( 'Product2', 'Product_University' );
            Product2 prd = new Product2(
                Name = 'Livro Universitário',
                BR_Author_name__c = 'Autor Universitário',
                BR_ISBN__c = '9111111111111',
                BR_Linha_Negocio__c = '20',
                // Business_Line__c = 'Universitário',
                RecordTypeID = idRecTypeDistribuidor,
                BR_Edicao__c = '1');
            insert prd;
            
            BR_ProdutoDistribuicaoGratuita__c produtoDistGrat = new BR_ProdutoDistribuicaoGratuita__c();
            produtoDistGrat.BR_DistribuicaoGratuita__c = dg.Id;
            produtoDistGrat.BR_ProdutoDistribuicaoGratuita__c = prd.Id;
            produtoDistGrat.BR_Enviado__c = true;        
            Insert produtoDistGrat;
            
            List<BR_DistribuicaoGratuita__c> lstDG = [SELECT
                                                      		Id,
                                                      		BR_TipoOrdemVenda__c,
                                                      		BR_CodigoOrganizacaoVenda__c,
                                                      		BR_CodigoCanalDistribuicao__c,
                                                      		BR_CodigoSetorAtividade__c,
                                                      		Name,
                                                      		BR_Aos_Cuidados_de_Account_Contact__r.Account__r.BR_Account_Id_SAP__c,
                                                      		BR_CentroCusto__c,
                                                      		BR_Centro__c,
                                                      		(SELECT Id,BR_ISBN__c,BR_Quantidade__c,BR_PrecoCusto__c FROM ProdutosDistribuicaoGratuita__r)
                                                      FROM BR_DistribuicaoGratuita__c];
            
            
            OpportunityBO bo = OpportunityBO.getInstance();
            
            bo.validateDeleteOpp(new List<Opportunity> {op});
            bo.getOpportunityById(opItem.OpportunityId);
            bo.setDadosEmailToOpportunity(new List<string> {opItem.OpportunityId});
            bo.integrarDistribuicaoOrdemVenda(lstDG);            
            bo.integrarDistribuicao(new List<BR_DistribuicaoGratuita__c> {dg});
            
            Map<Id, Opportunity> mapOld = new Map<Id, Opportunity>();
            mapOld.put(op.Id, op);
            bo.integrarDistribuicaoOrdemVendaSAP(new List<Opportunity> {op}, mapOld);
            bo.integrarDistribuicaoOrdemVenda(new List<Opportunity> {op});
        }
    }
}