@isTest
public class TesteSetupTest {

    @isTest 
    static void testar() {
        Test.startTest();        
        TesteSetup i 							= TesteSetup.instance;
        Account conta 							= i.criarConta();
        Contact contato							= i.criarContato(conta);
        ParametrizacaoCasos__c parametrizacao	= i.criarParametrizacao();
        CamposObrigatorios__c camposObrigator	= i.criarCamposObrigatorios(parametrizacao);
        Case caso								= i.criarCaso(conta, contato); 
        Opportunity ObterOportunidadeTest		= i.ObterOportunidadeTest();
        BR_DistribuicaoGratuita__c obterDistr	= i.obterDistribuicaoGratuita();
        Test.stopTest();
    }
    
}