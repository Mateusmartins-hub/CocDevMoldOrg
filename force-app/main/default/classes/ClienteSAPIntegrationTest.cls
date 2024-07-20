@isTest
public class ClienteSAPIntegrationTest {

    @TestSetup static void testSetup() {
        insert new IntegracaoClienteSAP__c(ConnectionName__c = 'test', EndpointApplication__c='tes', EndpointKey__c='test',EndpointURL__c='test',EndpointUser__c='test',RFC__c='test');
        
        ParametrizacaoCasos__c param = new ParametrizacaoCasos__c();
        param.Tipo__c = 'Cadastro';
        param.Subtipo__c = 'Novo Cadastro';
        param.Detalhamento__c = 'Novo Cliente';
        param.Detalhamento2__c = '';
        param.AreaDonaProcesso__c = 'Financeiro';
        insert param;
        
        GrupoSolucionador__c grupo = new GrupoSolucionador__c();
        grupo.CamposObrigatorios__c = '';
        grupo.Ordem__c = 1;
        grupo.ParametrizacaoCasos__c = param.Id;
        grupo.GrupoSolucionador__c = 'Customer Care';
        grupo.MinutosSLA__c = 720;
        insert grupo;  
	}


	@IsTest
	static void buscarClienteOpportunityTest() {

        User userToRun = [
    		SELECT Id FROM User WHERE Profile.Name LIKE '%admin%' AND ManagerId != null AND isActive = true LIMIT 1
		];

		System.runAs(userToRun){
                
            Opportunity opp = TestHelper.createOpportunity();
            insert opp;
            
            Account acc = [select Id, BR_CNPJ_CPF__c from Account where Id = :opp.AccountId];
            acc.BR_cnpj__c = '01.853.863/0001-74';
            update acc;

            Test.startTest();
            Test.setMock(HttpCalloutMock.class, new ClientSAPCalloutMock());
            ClienteSAPIntegration.getClientSAPAndUpdate(acc);
            Test.stopTest();
        }
	}
}