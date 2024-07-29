@isTest
public class TestHelper {
    
    @isTest
    public static List<PerguntaFormulario__c> createPerguntasFormulario()
    {
        Formulario__c form = createFormularioPergunta();
        insert form;
        
        List<PerguntaFormulario__c> perguntas = new List<PerguntaFormulario__c>();
        
        PerguntaFormulario__c picklist = new PerguntaFormulario__c();
        picklist.Formulario__c = form.Id;
        picklist.OpcoesResposta__c = 'valor1;valor2;valor3';
        picklist.Pergunta__c = 'teste';
        picklist.TipoResposta__c = 'Lista de opções única';
        picklist.Obrigatorio__c = true;

        
        perguntas.add(picklist);

        PerguntaFormulario__c multiPicklist = new PerguntaFormulario__c();
        multiPicklist.Formulario__c = form.Id;
        multiPicklist.OpcoesResposta__c = 'valor1;valor2;valor3';
        multiPicklist.Pergunta__c = 'teste';
        multiPicklist.TipoResposta__c = 'Lista de opções múltipla';
        multiPicklist.Obrigatorio__c = true;

        perguntas.add(multiPicklist);

        PerguntaFormulario__c text = new PerguntaFormulario__c();
        text.Formulario__c = form.Id;
        text.Pergunta__c = 'teste';
        text.TipoResposta__c = 'Texto livre';
        text.Obrigatorio__c = true;

        perguntas.add(text);

        PerguntaFormulario__c numerico = new PerguntaFormulario__c();
        numerico.Formulario__c = form.Id;
        numerico.Pergunta__c = 'teste';
        numerico.TipoResposta__c = 'Numérico';
        numerico.Obrigatorio__c = true;

        perguntas.add(numerico); 
        
        return perguntas;
    }
    
    @isTest
    public static Formulario__c createFormularioPergunta()
    {
        Id recordTypeId = Schema.SObjectType.Formulario__c.getRecordTypeInfosByDeveloperName().get('Pergunta').getRecordTypeId();

        Formulario__c form = new Formulario__c();
        form.RecordTypeId = recordTypeId;
        form.Tipo__c = 'Visita de expansão';
        form.Destinatario__c = 'Consultor';
		
        return form;
    }
    
    @isTest
    public static Opportunity createOpportunity() {
        Account ac = createAccount();
        insert ac;

        Opportunity op = new Opportunity();
        op.Name = 'Opportunity Test';
        op.StageName = 'Orçamento';
        op.CloseDate = Date.today();
		op.RecordTypeId = Schema.SObjectType.Opportunity.getRecordTypeInfosByDeveloperName().get('Sample_Order_University').getRecordTypeId();
        op.AccountId = ac.Id;
        op.Description = 'Test';

        return op;
    }

    @isTest
    public static Opportunity createOpportunityEnglishEdu() {
        Account ac = createAccount();
        insert ac;

        Opportunity op = new Opportunity();
        op.Name = 'Opportunity Test English EDU';
        op.StageName = 'Negociação';
        op.CloseDate = Date.today();
    	op.RecordTypeId = Schema.SObjectType.Opportunity.getRecordTypeInfosByDeveloperName().get('Oportunidade_de_Negocio_Pearson_English_EDU').getRecordTypeId();
        op.AccountId = ac.Id;
        op.Description = 'Test';

        return op;
    }

    @isTest
    public static Opportunity createOpportunityExpansaoEscolas() {
        Account ac = createAccount();
        insert ac;

        Opportunity op = new Opportunity();
        op.Name = 'Opportunity Test';
        op.StageName = 'Análise Financeira - Escolas';
        op.CloseDate = Date.today();
		op.RecordTypeId = Schema.SObjectType.Opportunity.getRecordTypeInfosByDeveloperName().get('Expansao_Escolas').getRecordTypeId();
        op.AccountId = ac.Id;
        op.Description = 'Test';

        return op;
    }
    
    @isTest
    public static Formulario__c createFormularioVisitaExpansaoCliente() {
        Formulario__c form = new Formulario__c();
        form.RecordTypeId = Schema.SObjectType.Formulario__c.getRecordTypeInfosByDeveloperName().get('Pergunta').getRecordTypeId();
        form.Tipo__c = 'Visita de expansão';
        form.Destinatario__c = 'Cliente';
             
        return form;
    }
    
    @isTest
    public static Formulario__c createFormularioVisitaExpansaoConsultor() {
        Formulario__c form = new Formulario__c();
        form.RecordTypeId = Schema.SObjectType.Formulario__c.getRecordTypeInfosByDeveloperName().get('Pergunta').getRecordTypeId();
        form.Tipo__c = 'Visita de expansão';
        form.Destinatario__c = 'Consultor';
             
        return form;
    }

    @isTest
    public static OpportunityLineItem createOpportunityLineItem() {

        User userToRun = [
            SELECT Id FROM User WHERE Profile.Name LIKE '%admin%' AND ManagerId != null AND isActive = true LIMIT 1
        ];

        System.runAs(userToRun){
            Opportunity op = CreateOpportunity();
            insert op;
            
            PricebookEntry ent = createPricebookEntry();
            insert ent;
            
            OpportunityLineItem opL = new OpportunityLineItem();
            opL.PricebookEntryId = ent.Id;
            opL.OpportunityId = op.Id;
            opL.Quantity = 10;
            opL.TotalPrice = 100;
            
            return opL;
        }

        return null;
    }
    	
    @isTest 
    public static PricebookEntry createPricebookEntry() {
        PricebookEntry ent = new PricebookEntry();
        
        Product2 prd = createProduct();
        insert prd;
        
        ent.Pricebook2Id = Test.getStandardPricebookId();
        ent.Product2Id = prd.Id;
        ent.UnitPrice = 10;
        ent.IsActive = true;
        
        return ent;
    }
    
    @isTest
    public static Product2 createProduct() {
        Product2 prd = new Product2();
        prd.Name = 'Test';
        
        return prd;
    }

    @isTest
    public static Lead createLead() {
        Lead lead = new Lead();
        lead.LastName = 'Test';
        lead.Company = 'Test';
        
        return lead;
    }
    
    public static Product2 createAmostraVirtual() {
        Product2 prd = new Product2();
        prd.Name = 'Test';
        //prd.LinkAmostra__c = 'www.google.com';
        prd.RecordTypeId = Schema.SObjectType.Product2.getRecordTypeInfosByDeveloperName().get('AmostraVirtual').getRecordTypeId();
        
        return prd;
    }

    @isTest
    public static Account createAccount() {
        Account ac = new Account();
        ac.Name = 'test account';
        ac.BR_Account_email__c = 'email@email.com';

        return ac;
    }

    @isTest
    public static FR_Procedimento_Franquias__c createConsulting() {
        Account ac = CreateAccount();
        insert ac;

        FR_Procedimento_Franquias__c consulting = new FR_Procedimento_Franquias__c();
        consulting.BR_StatusConsultoria__c = 'Aberta';
        consulting.BR_TipoConsultoria__c = 'Auditoria FR';

        consulting.BR_Conta__c = ac.Id;

        return consulting;
    }

    @isTest
    public static Contract createContract() {

        User userToRun = [
            SELECT Id FROM User WHERE Profile.Name LIKE '%admin%' AND ManagerId != null AND isActive = true LIMIT 1
        ];

        System.runAs(userToRun){
            Account ac = CreateAccount();
            insert ac;

            Opportunity opp = TestHelper.createOpportunity();
            opp.accountId = ac.Id;
            insert opp;

            Contract ct = new Contract();
            ct.BR_Oportunidade_do_contrato__c = opp.Id;
            ct.AccountId = ac.Id;
            
            return ct;
        }

        return null;
    }

    @isTest
    public static Event createEvent() {
        Event evt = new Event();        
        evt.Subject = 'teste';
        evt.DurationInMinutes = 123;
        evt.ActivityDateTime = DateTime.newInstance(2012, 7, 09, 3, 3, 3);
        evt.Description = 'teste';

        return evt;
    }        
    
    @isTest
    public static Event createVisitaExpansao()
    {
        Id idRecord = Schema.SObjectType.Event.getRecordTypeInfosByDeveloperName().get('VisitaExpansao').getRecordTypeId();
        
        Event e = createEvent();
        e.RecordTypeId = idRecord;
        
        return e;
    }

    @isTest
    public static Contact createContact() {
        Account ac = CreateAccount();
        insert ac;

        Contact ct = new Contact();
        ct.AccountId = ac.Id;
        ct.email = 'abc@abc.com';
        ct.LastName = 'Test';
        
        return ct;
    }
    
    @IsTest
    public static IntegracaoRA__c createCustomSettingsRA() {
        IntegracaoRA__c settingsRA = new IntegracaoRA__c();
        settingsRA.EndpointAllTickets__c = 'https://app.hugme.com.br/api/ticket/v1/tickets';
        settingsRA.EndpointAuth__c = 'https://app.hugme.com.br/api/auth/oauth/token?grant_type=client_credentials&';
        settingsRA.EndpointCountTickets__c = 'https://app.hugme.com.br/api/ticket/v1/tickets/count';
        settingsRA.EndpointModeration__c = 'https://app.hugme.com.br/api/ticket/v1/tickets/moderation';
        settingsRA.EndpointPublicMessage__c = 'https://app.hugme.com.br/api/ticket/v1/tickets/message/public';
        settingsRA.tempoBuscarReclamacoes__c = 30;
        settingsRA.tempoEnviarRespostas__c = 30;
        settingsRA.StatusBuscar__c = '5,7,18,19';
        settingsRA.Token__c = null;
        settingsRA.Timeout__c = 65000;
        settingsRA.UltimaPagina__c = 0;
        settingsRA.DataCorte__c = '2020-08-07';
        settingsRA.UserPassword__c = '1112:bb08d7f18a7f40ae99645c31db91fe29';
        
        insert settingsRA;
        return settingsRA;
    }
    
    @IsTest
    public static void createCaseRA() {
        Case novo = new Case();
        Contact ctc = TestHelper.createContact();
        insert ctc;
        novo.RecordTypeId = Schema.SObjectType.Case.getRecordTypeInfosByDeveloperName().get('ReclameAqui').getRecordTypeId();
        novo.IdRA__c = '123';
        novo.ContactId = ctc.id;
        novo.Status = 'Novo';
        novo.Origin = 'Reclame Aqui';
        novo.MarcaAtendimento__c = 'B2C';
        novo.Description = 'Descrição';
        novo.Subject = 'Assunto';
        novo.ConteudoReclamacaoRA__c = 'Conteúdo';
        novo.TituloReclamacaoRA__c = 'Título';
        novo.StatusIntegracao__c = 'Aguardando integração';
        novo.ProblemaResolvidoRA__c = false; 
        novo.Tipo__c = 'Serviço COC';
        novo.Subtipo__c = 'Atendimento';
        novo.Detalhamento__c = 'Atendimento';
        novo.respostaPublica__c = 'Resposta';
        
        insert novo;
    }

    @IsTest
    public static Quote createQuote() {

        User userToRun = [
            SELECT Id FROM User WHERE Profile.Name LIKE '%admin%' AND ManagerId != null AND isActive = true LIMIT 1
        ];

        System.runAs(userToRun){
            Opportunity opp = createOpportunity();
            insert opp;

            Quote qt = new Quote();
            qt.OpportunityId =  opp.Id;
            qt.Name = 'test Quote';
            return qt;
        }

        return null;
    }

    @IsTest
    public static Account_Contact__c createAccountContact() {
        Contact ctc = TestHelper.createContact();
        insert ctc;

        Account_Contact__c ct = new Account_Contact__c();
        ct.Account__c = ctc.AccountId;
        ct.Contact__c = ctc.Id;
        
        return ct;
    }
    
    @IsTest
    public static void createCustomSettings() {
        IntegracaoAmostraFisicaSAP__c integrAmostraSap = new IntegracaoAmostraFisicaSAP__c();
        integrAmostraSap.Application__c = 'SAP';
        integrAmostraSap.ConnectionName__c = 'SAP_QAS';
        integrAmostraSap.Endpoint__c = 'http://integracao.teste.com';
        integrAmostraSap.Key__c = '123';
        integrAmostraSap.RFC__c = 'ZSD_ORDEM_VENDA_BR';
        integrAmostraSap.User__c = 'userTest';
        
        insert integrAmostraSap;
    }

    @IsTest     
    public static ParametrizacaoCasos__c createParametrizacaoCaso() {
        ParametrizacaoCasos__c param = new ParametrizacaoCasos__c();
        param.Tipo__c = 'Cadastro';
        param.Subtipo__c = 'Alteração de Cadastro';
        param.Detalhamento__c = 'Dados Cadastrais';
        param.Detalhamento2__c = '';
        param.AreaDonaProcesso__c = 'Financeiro';
       
        return param;
    }

    @IsTest
    public static GrupoSolucionador__c createGrupoSolucionador() {
        ParametrizacaoCasos__c param = createParametrizacaoCaso();       
        insert param;
       
        GrupoSolucionador__c grupo0 = new GrupoSolucionador__c();
        grupo0.Ordem__c = 0;
        grupo0.ParametrizacaoCasos__c = param.Id;
        grupo0.MinutosSLA__c = 720;
       
        return grupo0;
    }

    @IsTest
    public static ItemAmostraFisica__c createItemAmostraFisica() {

        User userToRun = [
            SELECT Id FROM User WHERE Profile.Name LIKE '%admin%' AND ManagerId != null AND isActive = true LIMIT 1
        ];

        System.runAs(userToRun){
            Opportunity opp = createOpportunity();
            insert opp;

            AmostraFisica__c amostra = new AmostraFisica__c();
            amostra.Oportunidade__c = opp.Id;
            insert amostra;

            ItemAmostraFisica__c itemAmostra = new ItemAmostraFisica__c();
            itemAmostra.AmostraFisica__c = amostra.Id;
            itemAmostra.Quantidade__c = 1;

            return itemAmostra;
        }

        return null;
    } 

    @IsTest
    public static Pricebook2 createPricebook() {
        Pricebook2 pb = new Pricebook2();
        pb.Name = 'Test';
        pb.AmostraFisica__c = true;
        pb.isActive = true;        
        return pb;
    }
    
    //createProductQuote()
		//@isTest
    public static Product2 createProductQuote(String recordTypeDeveloperName, String segmento) {
        
        Product2 prd = new Product2();
        prd.Tipo__c = 'Principal';
        prd.RecordTypeId = Schema.SObjectType.Product2.getRecordTypeInfosByDeveloperName().get(recordTypeDeveloperName).getRecordTypeId();
        prd.BR_segmento__c = segmento;
        prd.Name = 'Test';
        
        return prd;
    }


	//createPricebookEntryQuote()
		// @isTest 
    public static PricebookEntry createPricebookEntryQuote(String recordTypeDeveloperName, String segmento ) {
        PricebookEntry ent = new PricebookEntry();
        
        Product2 prd = createProductQuote(recordTypeDeveloperName, segmento);
        insert prd;
        
        ent.Pricebook2Id = Test.getStandardPricebookId();
        ent.Product2Id = prd.Id;
        ent.UnitPrice = 10;
        ent.IsActive = true;
        
        return ent;
    }
    
    //create AlçadaAprovador
	 @isTest 
    public static AlcadasAprovador__c createAlcadaAProvador() {
        AlcadasAprovador__c alcadaAprovador = new AlcadasAprovador__c();
        alcadaAprovador.CurrencyIsoCode = 'BRA';
        return alcadaAprovador;
    }
}