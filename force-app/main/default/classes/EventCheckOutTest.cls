@isTest
public class EventCheckOutTest {

    @testSetup
    public static void Setup() {

        User userToRun = [
    		SELECT Id FROM User WHERE Profile.Name LIKE '%admin%' AND ManagerId != null AND isActive = true LIMIT 1
		];

		System.runAs(userToRun){

            Opportunity op = TestHelper.createOpportunity();
            insert op;

            Lead ld = TestHelper.createLead();
            insert ld;

            Event e1 = TestHelper.createVisitaExpansao();
            e1.WhatId = op.Id;
            insert e1;

            Event e2 = TestHelper.createVisitaExpansao();
            e2.WhatId = op.AccountId;
            insert e2;

            Event e3 = TestHelper.createVisitaExpansao();
            e3.WhoId = ld.Id;
            insert e3;

            Event e4 = TestHelper.createEvent();
            e4.WhoId = ld.Id;
            insert e4;

            Event e5 = TestHelper.createEvent();
            e5.WhatId = op.AccountId;
            insert e5;
        }
    }

    @isTest
    public static void ExecutarConta()
    {
        Id visitExpansao = Schema.SObjectType.Event.getRecordTypeInfosByDeveloperName().get('VisitaExpansao').getRecordTypeId();
        Account ac = [SELECT Id FROM Account LIMIT 1];
        Event event = [SELECT Id FROM Event WHERE WhatId = :ac.Id AND recordTypeId = :visitExpansao];

        Formulario formulario = new Formulario();
        formulario.Perguntas = new List<PerguntaResposta>();

        List<PerguntaFormulario__c> perguntas = TestHelper.createPerguntasFormulario();
        insert perguntas;

        for (PerguntaFormulario__c p : perguntas)
        {
            PerguntaResposta pr = new PerguntaResposta(p);
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
            formulario.Perguntas.add(pr);
        }

        formulario.IdFormulario = perguntas[0].Formulario__c;

        EventCheckOutController.BuscarFormulario(event.Id);
        EventCheckOutController.SalvarRespostas(event.Id, formulario);
    }

	@isTest
    public static void ExecutarOportunidade()
    {
        Opportunity op = [SELECT Id FROM Opportunity LIMIT 1];
        Event event = [SELECT Id FROM Event WHERE WhatId = :op.Id];

        Formulario formulario = new Formulario();
        formulario.Perguntas = new List<PerguntaResposta>();

        List<PerguntaFormulario__c> perguntas = TestHelper.createPerguntasFormulario();
        insert perguntas;

        for (PerguntaFormulario__c p : perguntas)
        {
            PerguntaResposta pr = new PerguntaResposta(p);
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
            formulario.Perguntas.add(pr);
        }

        formulario.IdFormulario = perguntas[0].Formulario__c;

        EventCheckOutController.BuscarFormulario(event.Id);
        EventCheckOutController.SalvarRespostas(event.Id, formulario);
    }

    @isTest
    public static void ExecutarLead()
    {
        Id visitExpansao = Schema.SObjectType.Event.getRecordTypeInfosByDeveloperName().get('VisitaExpansao').getRecordTypeId();

        Lead ld = [SELECT Id FROM Lead LIMIT 1];
        Event event = [SELECT Id FROM Event WHERE WhoId = :ld.Id AND RecordtypeId = :visitExpansao];

        Formulario formulario = new Formulario();
        formulario.Perguntas = new List<PerguntaResposta>();

        List<PerguntaFormulario__c> perguntas = TestHelper.createPerguntasFormulario();
        insert perguntas;

        for (PerguntaFormulario__c p : perguntas)
        {
            PerguntaResposta pr = new PerguntaResposta(p);
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
            formulario.Perguntas.add(pr);
        }

        formulario.IdFormulario = perguntas[0].Formulario__c;

        EventCheckOutController.BuscarFormulario(event.Id);
        EventCheckOutController.SalvarRespostas(event.Id, formulario);
    }

    @isTest
    public static void Executar()
    {
        Id visitExpansao = Schema.SObjectType.Event.getRecordTypeInfosByDeveloperName().get('VisitaExpansao').getRecordTypeId();
    	Id visitaPedagogica = Schema.SObjectType.Event.getRecordTypeInfosByDeveloperName().get('Visita_Pedagogica').getRecordTypeId();

        Event event = [SELECT Id FROM Event WHERE RecordtypeId != :visitExpansao AND RecordTypeId != :visitaPedagogica LIMIT 1];

        EventCheckOutController.BuscarFormulario(event.Id);
    }

     @isTest
    public static void EnviarChecklistCliente()
    {
        Id visitExpansao = Schema.SObjectType.Event.getRecordTypeInfosByDeveloperName().get('VisitaExpansao').getRecordTypeId();
    	Id visitaPedagogica = Schema.SObjectType.Event.getRecordTypeInfosByDeveloperName().get('Visita_Pedagogica').getRecordTypeId();

        List<Event> events = [SELECT Id FROM Event WHERE RecordtypeId != :visitExpansao AND RecordTypeId != :visitaPedagogica];

        EventCheckOutController.EnviarChecklistCliente(events[0].Id);
        EventCheckOutController.EnviarChecklistCliente(events[1].Id);
    }
}