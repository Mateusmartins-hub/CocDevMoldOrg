@isTest
public class FormularioParaExemplaresControllerTest {

    @TestSetup
    public static void Setup()
    {

        User userToRun = [
    		SELECT Id FROM User WHERE Profile.Name LIKE '%admin%' AND ManagerId != null AND isActive = true LIMIT 1
		];

		System.runAs(userToRun){
                
            Opportunity op = TestHelper.createOpportunity();
            insert op;

            Lead ld = TestHelper.createLead();
            insert ld;

            MetodoEnsino__c me = new MetodoEnsino__c();
            me.Name = 'Teste';
            me.MetodoEnsino__c = 'COC';

            insert me;

            Product2 prod = TestHelper.createAmostraVirtual();
            insert prod;

            List<PerguntaFormulario__c> perguntas = TestHelper.createPerguntasFormulario();

            insert perguntas;
        }
    }

    @isTest
    public static void TestaFluxoConta()
    {
        Account ac = [SELECT Id FROM Account];
        Product2 prod = [SELECT Id FROM Product2];
        Formulario__c form = [SELECT Id FROM Formulario__c];

        Apexpages.currentPage().getParameters().put('ac', ac.Id);
        Apexpages.currentPage().getParameters().put('av', prod.Id);
        ApexPages.currentPage().getParameters().put('id', form.Id);
        FormularioParaExemplaresController controller = new FormularioParaExemplaresController();

        controller.Salvar();
    
        system.assert(string.isNotBlank(controller.Erro));
        
        for (PerguntaResposta pr : controller.PerguntaRespostas)
        {
            if (pr.TipoResposta == 'Numérico')
            {
                pr.Resposta = 'a';
            }
        }

        controller.Salvar();

        system.assert(string.isNotBlank(controller.Erro));

        for (PerguntaResposta pr : controller.PerguntaRespostas)
        {
            if (pr.TipoResposta == 'Numérico')
            {
                pr.Resposta = '1';
            }
            else if (pr.TipoResposta == 'Lista de opções múltipla')
            {
                pr.Respostas = new string[] {'valor1', 'valor2'};
            }
            else 
            {
                pr.Resposta = 'teste';
            }
        }

        controller.Salvar();
        
        system.assert(string.isBlank(controller.Erro));
    }

    @isTest
    public static void TestaFluxoOportunidade()
    {
        Opportunity op = [SELECT Id FROM Opportunity];
        Product2 prod = [SELECT Id FROM Product2];
        Formulario__c form = [SELECT Id FROM Formulario__c];

        Apexpages.currentPage().getParameters().put('op', op.Id);
        Apexpages.currentPage().getParameters().put('av', prod.Id);
        ApexPages.currentPage().getParameters().put('id', form.Id);
        FormularioParaExemplaresController controller = new FormularioParaExemplaresController();

        controller.Salvar();
    
        system.assert(string.isNotBlank(controller.Erro));
        
        for (PerguntaResposta pr : controller.PerguntaRespostas)
        {
            if (pr.TipoResposta == 'Numérico')
            {
                pr.Resposta = 'a';
            }
        }

        controller.Salvar();

        system.assert(string.isNotBlank(controller.Erro));

        for (PerguntaResposta pr : controller.PerguntaRespostas)
        {
            if (pr.TipoResposta == 'Numérico')
            {
                pr.Resposta = '1';
            }
            else if (pr.TipoResposta == 'Lista de opções múltipla')
            {
                pr.Respostas = new string[] {'valor1', 'valor2'};
            }
            else 
            {
                pr.Resposta = 'teste';
            }
        }

        controller.Salvar();

        system.assert(string.isBlank(controller.Erro));
    }

    @isTest
    public static void TestaFluxoLead()
    {
        Lead ld = [SELECT Id FROM Lead];
        Product2 prod = [SELECT Id FROM Product2];
        Formulario__c form = [SELECT Id FROM Formulario__c];

        Apexpages.currentPage().getParameters().put('ld', ld.Id);
        Apexpages.currentPage().getParameters().put('av', prod.Id);
        ApexPages.currentPage().getParameters().put('id', form.Id);
        FormularioParaExemplaresController controller = new FormularioParaExemplaresController();

        controller.Salvar();
    
        system.assert(string.isNotBlank(controller.Erro));
        
        for (PerguntaResposta pr : controller.PerguntaRespostas)
        {
            if (pr.TipoResposta == 'Numérico')
            {
                pr.Resposta = 'a';
            }
        }

        controller.Salvar();

        system.assert(string.isNotBlank(controller.Erro));

        for (PerguntaResposta pr : controller.PerguntaRespostas)
        {
            if (pr.TipoResposta == 'Numérico')
            {
                pr.Resposta = '1';
            }
            else if (pr.TipoResposta == 'Lista de opções múltipla')
            {
                pr.Respostas = new string[] {'valor1', 'valor2'};
            }
            else 
            {
                pr.Resposta = 'teste';
            }
        }

        controller.Salvar();
		
        system.assert(string.isBlank(controller.Erro));
    }

}