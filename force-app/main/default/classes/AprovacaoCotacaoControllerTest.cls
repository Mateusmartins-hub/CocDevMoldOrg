@IsTest
public class AprovacaoCotacaoControllerTest {           

    @IsTest
    static void aceitarCotacaoTest(){

        User userToRun = [
            SELECT Id FROM User WHERE Profile.Name LIKE '%admin%' AND ManagerId != null AND isActive = true LIMIT 1
        ];

        System.runAs(userToRun){
            
            insert new VencimentoCotacao__c(Dias__c = 10);
            Quote qt = TestHelper.createQuote();        
            insert qt;

            PageReference pageRef = Page.AprovacaoCotacao;
            Test.setCurrentPage(pageRef);        
            ParametrizacaoCasos__c param1 = TestHelper.createParametrizacaoCaso();
            param1.Tipo__c = 'Contrato';
            param1.Subtipo__c = 'Novo';
            param1.Detalhamento__c = '';
            param1.Detalhamento2__c = '';
            insert param1;
        
            GrupoSolucionador__c grupo0 = new GrupoSolucionador__c();
            grupo0.Ordem__c = 0;
            grupo0.ParametrizacaoCasos__c = param1.Id;
            grupo0.MinutosSLA__c = 720;
            insert grupo0;
            
            ApexPages.currentPage().getParameters().put('ObjectId', qt.Id);
            ApexPages.currentPage().getParameters().put('AprovacaoResposta', 'aceitar');
            
            AprovacaoCotacaoController cotacaoController = new AprovacaoCotacaoController();
            cotacaoController.InitPage();
            
            qt = [SELECT Id, Status FROM Quote LIMIT 1];
            System.assertEquals('Aprovado cliente', qt.Status);

        }
    }

    @IsTest
    static void recusarCotacaoTest(){

        User userToRun = [
            SELECT Id FROM User WHERE Profile.Name LIKE '%admin%' AND ManagerId != null AND isActive = true LIMIT 1
        ];

        System.runAs(userToRun){
                
            insert new VencimentoCotacao__c(Dias__c = 10);
            Quote qt = TestHelper.createQuote();
            insert qt;

            PageReference pageRef = Page.AprovacaoCotacao;
            Test.setCurrentPage(pageRef);
            ApexPages.currentPage().getParameters().put('ObjectId', qt.Id);
            ApexPages.currentPage().getParameters().put('AprovacaoResposta', 'recusar');

            AprovacaoCotacaoController cotacaoController = new AprovacaoCotacaoController();
            cotacaoController.InitPage();

            qt = [SELECT Id, Status FROM Quote LIMIT 1];
            System.assertEquals('Rejeitada', qt.Status);
        }
    }
}