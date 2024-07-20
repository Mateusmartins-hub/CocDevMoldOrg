@IsTest
public class OpportunityStagesCheckTest {    
    @IsTest
    static void setorPrivadoStagesCheckTest() {

        User userToRun = [
            SELECT Id FROM User WHERE Profile.Name LIKE '%admin%' AND ManagerId != null AND isActive = true LIMIT 1
        ];

        System.runAs(userToRun){
            List<String> stageNames = new List<String>{'Visita Inicial', 'Aprofundamento Pedagógico', 'Negociação', 'Elaborando Contrato', 'Coletando assinatura', 'Contrato Finalizado', 'Pedido Gerado'};
            List<Opportunity> opps = new List<Opportunity>();
            
            PricebookEntry pbe = TestHelper.createPricebookEntry();
            insert pbe;
            
            OpportunityLineItem oppItem = new OpportunityLineItem();
            oppItem.Quantity = 1;
            oppItem.TotalPrice = 1;
            oppItem.Product2Id = pbe.Product2Id;
            
            Id PESQUISA_MERCADO_RECORD_TYPE =  Schema.SObjectType.BR_Pesquisa__c.getRecordTypeInfosByDeveloperName().get('PesquisaMercadoEscola').getRecordTypeId();
            for (String stage : stageNames) {
                Opportunity oppClone = new Opportunity();
                
                oppClone.RecordTypeId = OpportunityStagesCheck.RECORD_TYPE_OPORTUNIDADE_SETOR_PRIVADO;
                oppClone.StageName = stage;
                oppClone.Name = stage;
                oppClone.CloseDate = System.today();
                oppClone.BR_Modalidade_licitacao__c = 'Carta Convite';
                oppClone.VisitaDeExpansaoRealizada__c = true;
                oppClone.AprovadoCompliance__c = true;
                oppClone.AprovacaoGerencial__c = true;
                oppClone.AmostraFisicaEnviada__c = true;     
                oppClone.CotacaoGerada__c = true;
                oppClone.CasoFechado__c = true;
                oppClone.ContratoAnexado__c = true;             
                
                opps.add(oppClone);
            }
            
            insert opps;     
            
            Account acc = TestHelper.createAccount();
            insert acc;
            
            BR_Pesquisa__c pesquisa = new BR_Pesquisa__c();
            pesquisa.RecordTypeId = PESQUISA_MERCADO_RECORD_TYPE;
            pesquisa.BR_Conta__c = acc.Id;
            for(Integer i = 0; i < stageNames.size(); i++) {
                opps[i].StageName = stageNames[i];
                if (stageNames[i] == 'Pedido Gerado') {
                    opps[i].StageName = 'Contrato Finalizado';
                    pesquisa.Opportunity__c = opps[i].Id;                
                    oppItem.OpportunityId = opps[i].Id;
                    opps[i].AccountId = acc.Id;
                    opps[i].Pricebook2Id = pbe.Pricebook2Id;
                    update opps[i];
                    opps[i].StageName = 'Pedido Gerado';
                }
            }
            insert pesquisa;
            insert oppItem;
            update opps;   
        }
    }

    @IsTest
    static void setorPublicoStagesCheckTest() {

        User userToRun = [
            SELECT Id FROM User WHERE Profile.Name LIKE '%admin%' AND ManagerId != null AND isActive = true LIMIT 1
        ];

        System.runAs(userToRun){

            List<String> stageNames = new List<String>{'Aprovação Compliance', 'Visita Inicial', 'Degustação Pedagógica', 'Aguardando Edital', 'Contrato Finalizado', 'Contrato Anexado'};
            List<Opportunity> opps = new List<Opportunity>();
            
            for (String stage : stageNames) {
                Opportunity oppClone = new Opportunity();
                
                oppClone.RecordTypeId = OpportunityStagesCheck.RECORD_TYPE_OPORTUNIDADE_SETOR_PUBLICO;
                oppClone.StageName = stage;            
                oppClone.Name = stage;
                oppClone.CloseDate = System.today();            
                oppClone.BR_Modalidade_licitacao__c = 'Carta Convite';
                oppClone.VisitaDeExpansaoRealizada__c = true;
                oppClone.AprovadoCompliance__c = true;
                oppClone.AprovacaoGerencial__c = true;
                oppClone.AmostraFisicaEnviada__c = true;
                oppClone.CotacaoGerada__c = true;
                oppClone.CasoFechado__c = true;
                oppClone.ContratoAnexado__c = true; 
                
                opps.add(oppClone);
            }
            
            insert opps;   
            
            for(Integer i = 0; i < stageNames.size(); i++) {
                opps[i].StageName = stageNames[i];
            }
            
            update opps;     
        }
    }

    @IsTest
    static void institutoLinguasStagesCheckTest() {

        User userToRun = [
            SELECT Id FROM User WHERE Profile.Name LIKE '%admin%' AND ManagerId != null AND isActive = true LIMIT 1
        ];

        System.runAs(userToRun){
        
            List<String> stageNames = new List<String>{'Visita Inicial', 'Amostras Físicas', 'Aprofundamento Pedagógico', 'Registro de Adoção', 'Confirmação de Adoção', 'Adoção'};
            List<Opportunity> opps = new List<Opportunity>();
            
            for (String stage : stageNames) {
                Opportunity oppClone = new Opportunity();
                
                oppClone.RecordTypeId = OpportunityStagesCheck.RECORD_TYPE_OPORTUNIDADE_INSTITUTO_LINGUAS;
                oppClone.StageName = stage;            
                oppClone.Name = stage;
                oppClone.CloseDate = System.today();            
                oppClone.BR_Modalidade_licitacao__c = 'Carta Convite';
                oppClone.VisitaDeExpansaoRealizada__c = true;
                oppClone.AprovadoCompliance__c = true;
                oppClone.AprovacaoGerencial__c = true;
                oppClone.AmostraFisicaEnviada__c = true;    
                oppClone.CotacaoGerada__c = true;
                oppClone.CasoFechado__c = true;
                oppClone.ContratoAnexado__c = true; 

                opps.add(oppClone);
            }
            
            insert opps; 
            
            for(Integer i = 0; i < stageNames.size(); i++) {
                opps[i].StageName = stageNames[i];
            }
            
            update opps;
        }
    }
    
    @IsTest
    static void vendasCOCStagesCheckTest() {

        User userToRun = [
            SELECT Id FROM User WHERE Profile.Name LIKE '%admin%' AND ManagerId != null AND isActive = true LIMIT 1
        ];

        System.runAs(userToRun){

            List<String> stageNames = new List<String>{'Contrato Finalizado'};
            List<Opportunity> opps = new List<Opportunity>();
            
            for (String stage : stageNames) {
                Opportunity oppClone = new Opportunity();
                
                oppClone.RecordTypeId = OpportunityStagesCheck.RECORD_TYPE_OPORTUNIDADE_VENDAS_COC;
                oppClone.StageName = stage;            
                oppClone.Name = stage;
                oppClone.CloseDate = System.today();            
                oppClone.BR_Modalidade_licitacao__c = 'Carta Convite';
                oppClone.VisitaDeExpansaoRealizada__c = true;
                oppClone.AprovadoCompliance__c = true;
                oppClone.AprovacaoGerencial__c = true;
                oppClone.AmostraFisicaEnviada__c = true;    
                oppClone.CotacaoGerada__c = true;
                oppClone.CasoFechado__c = true;
                oppClone.ContratoAnexado__c = true; 

                opps.add(oppClone);
            }
            
            insert opps; 
            
            for(Integer i = 0; i < stageNames.size(); i++) {
                opps[i].StageName = stageNames[i];
            }
            
            update opps;
        }
    }
    
    @IsTest
    static void vendasDomBoscoStagesCheckTest() {

        User userToRun = [
            SELECT Id FROM User WHERE Profile.Name LIKE '%admin%' AND ManagerId != null AND isActive = true LIMIT 1
        ];

        System.runAs(userToRun){
                
            List<String> stageNames = new List<String>{'Contrato Finalizado'};
            List<Opportunity> opps = new List<Opportunity>();
            
            for (String stage : stageNames) {
                Opportunity oppClone = new Opportunity();
                
                oppClone.RecordTypeId = OpportunityStagesCheck.RECORD_TYPE_OPORTUNIDADE_VENDAS_DOM_BOSCO;
                oppClone.StageName = stage;            
                oppClone.Name = stage;
                oppClone.CloseDate = System.today();            
                oppClone.BR_Modalidade_licitacao__c = 'Carta Convite';
                oppClone.VisitaDeExpansaoRealizada__c = true;
                oppClone.AprovadoCompliance__c = true;
                oppClone.AprovacaoGerencial__c = true;
                oppClone.AmostraFisicaEnviada__c = true;    
                oppClone.CotacaoGerada__c = true;
                oppClone.CasoFechado__c = true;
                oppClone.ContratoAnexado__c = true; 

                opps.add(oppClone);
            }
            
            insert opps; 
            
            for(Integer i = 0; i < stageNames.size(); i++) {
                opps[i].StageName = stageNames[i];
            }
            
            update opps;
        }
    }
    
    @IsTest
    static void vendasAtitudeStagesCheckTest() {

        User userToRun = [
            SELECT Id FROM User WHERE Profile.Name LIKE '%admin%' AND ManagerId != null AND isActive = true LIMIT 1
        ];

        System.runAs(userToRun){
                
            List<String> stageNames = new List<String>{'Contrato Finalizado'};
            List<Opportunity> opps = new List<Opportunity>();
            
            for (String stage : stageNames) {
                Opportunity oppClone = new Opportunity();
                
                oppClone.RecordTypeId = OpportunityStagesCheck.RECORD_TYPE_OPORTUNIDADE_VENDAS_ATITUDE;
                oppClone.StageName = stage;            
                oppClone.Name = stage;
                oppClone.CloseDate = System.today();            
                oppClone.BR_Modalidade_licitacao__c = 'Carta Convite';
                oppClone.VisitaDeExpansaoRealizada__c = true;
                oppClone.AprovadoCompliance__c = true;
                oppClone.AprovacaoGerencial__c = true;
                oppClone.AmostraFisicaEnviada__c = true;    
                oppClone.CotacaoGerada__c = true;
                oppClone.CasoFechado__c = true;
                oppClone.ContratoAnexado__c = true; 

                opps.add(oppClone);
            }
            
            insert opps; 
            
            for(Integer i = 0; i < stageNames.size(); i++) {
                opps[i].StageName = stageNames[i];
            }
            
            update opps;

        }
    }
    
    @IsTest
    static void ELTStagesCheckPesquisaTest() {
        User userToRun = [
            SELECT Id FROM User WHERE Profile.Name LIKE '%admin%' AND ManagerId != null AND isActive = true LIMIT 1
        ];

        System.runAs(userToRun){
            Id RecTypeAcc = Schema.SObjectType.Account.getRecordTypeInfosByDeveloperName().get('PessoaJuridica').getRecordTypeId();
            Account acc = new Account();
            acc.RecordTypeId = RecTypeAcc;
            acc.Name = Util.generateRandomStringChar(10);
            acc.BR_cnpj__c = Util.generateCNPJ(TRUE);
            acc.BR_Account_email__c = Util.generateRandomStringChar(10)+'@a.com';
            insert acc;
            
	        Opportunity opp = new Opportunity();
            opp.RecordTypeId = OpportunityStagesCheck.RECORD_TYPE_OPORTUNIDADE_ELT;
            opp.StageName = 'Preparação';
            opp.Name = Util.generateRandomStringChar(10);
            opp.BR_Modalidade_licitacao__c = 'Carta Convite';
            opp.Analise_de_historico__c = TRUE;
            opp.Compromisso_agendado__c = TRUE;
            opp.Material_de_apresentacao_preparado__c = TRUE;
            opp.AmostraDigitalEnviada__c = TRUE;
            opp.Envio_de_amostra_fisica__c = 'Foi necessário';
            opp.CloseDate = System.today();
            opp.Beneficio_confirmado__c = 'Não foi necessário';
            opp.AccountId = acc.Id;
            opp.Material_analisado__c = TRUE;
            opp.Visita_pedagogica__c = 'Agendada';
            opp.Faturamento_do_pedido__c = 'Não se aplica';
        	insert opp;
          
            Id RecTypePesquisa = Schema.SObjectType.BR_Pesquisa__c.getRecordTypeInfosByDeveloperName().get('ELT_Distribuidor').getRecordTypeId();
            
            Test.startTest();
            BR_Pesquisa__c p = new BR_Pesquisa__c();
            p.RecordTypeId = RecTypePesquisa;
            p.Opportunity__c = opp.Id;
            p.BR_Conta__c = acc.Id;
            p.NumeroDeAlunosPorSegmento__c = 'PV';
            p.QuantidadeAlunosPreVestibular__c = 10;
            insert p;
            
            opp.StageName = 'Análise do material';
            opp.Tipo_de_contrato__c = 'Upsell';
            
            update opp;
            
            System.assertNotEquals(opp.Id, NULL);
    
            Test.stopTest();
        }
    }
    
    @IsTest
    static void ELTStagesCheckPesquisaErrorTest() {
        User userToRun = [
            SELECT Id FROM User WHERE Profile.Name LIKE '%admin%' AND ManagerId != null AND isActive = true LIMIT 1
        ];

        System.runAs(userToRun){
            Id RecTypeAcc = Schema.SObjectType.Account.getRecordTypeInfosByDeveloperName().get('PessoaJuridica').getRecordTypeId();
            Account acc = new Account();
            acc.RecordTypeId = RecTypeAcc;
            acc.Name = Util.generateRandomStringChar(10);
            acc.BR_cnpj__c = Util.generateCNPJ(TRUE);
            acc.BR_Account_email__c = Util.generateRandomStringChar(10)+'@a.com';
            insert acc;
            
	        Opportunity opp = new Opportunity();
            opp.RecordTypeId = OpportunityStagesCheck.RECORD_TYPE_OPORTUNIDADE_ELT;
            opp.StageName = 'Preparação';
            opp.Name = Util.generateRandomStringChar(10);
            opp.BR_Modalidade_licitacao__c = 'Carta Convite';
            opp.Analise_de_historico__c = TRUE;
            opp.Compromisso_agendado__c = TRUE;
            opp.Material_de_apresentacao_preparado__c = TRUE;
            opp.AmostraDigitalEnviada__c = TRUE;
            opp.Envio_de_amostra_fisica__c = 'Foi necessário';
            opp.CloseDate = System.today();
            opp.Beneficio_confirmado__c = 'Não foi necessário';
            opp.AccountId = acc.Id;
            opp.Material_analisado__c = TRUE;
            opp.Visita_pedagogica__c = 'Agendada';
            opp.Faturamento_do_pedido__c = 'Não se aplica';
        	insert opp;
            
            Test.startTest();
            opp.StageName = 'Análise do material';
            opp.Tipo_de_contrato__c = 'Upsell';
            try{
                update opp;
            }
            catch(Exception e){
                System.assertEquals(e.getMessage().contains('É necessária a criação de um registro de Pesquisa do tipo ELT'), TRUE);
            }
            Test.stopTest();
        }
    }
    
    @IsTest
    static void ELTStagesCheckBeneficioTest() {
        User userToRun = [
            SELECT Id FROM User WHERE Profile.Name LIKE '%admin%' AND ManagerId != null AND isActive = true LIMIT 1
        ];

        System.runAs(userToRun){
            Id RecTypeAcc = Schema.SObjectType.Account.getRecordTypeInfosByDeveloperName().get('PessoaJuridica').getRecordTypeId();
            Account acc = new Account();
            acc.RecordTypeId = RecTypeAcc;
            acc.Name = Util.generateRandomStringChar(10);
            acc.BR_cnpj__c = Util.generateCNPJ(TRUE);
            acc.BR_Account_email__c = Util.generateRandomStringChar(10)+'@a.com';
            insert acc;
            
	        Opportunity opp = new Opportunity();
            opp.RecordTypeId = OpportunityStagesCheck.RECORD_TYPE_OPORTUNIDADE_ELT;
            opp.StageName = 'Preparação';
            opp.Name = Util.generateRandomStringChar(10);
            opp.BR_Modalidade_licitacao__c = 'Carta Convite';
            opp.Analise_de_historico__c = TRUE;
            opp.Compromisso_agendado__c = TRUE;
            opp.Material_de_apresentacao_preparado__c = TRUE;
            opp.AmostraDigitalEnviada__c = TRUE;
            opp.Envio_de_amostra_fisica__c = 'Foi necessário';
            opp.CloseDate = System.today();
            opp.Beneficio_confirmado__c = 'Não foi necessário';
            opp.AccountId = acc.Id;
            opp.Material_analisado__c = TRUE;
            opp.Visita_pedagogica__c = 'Agendada';
            opp.Faturamento_do_pedido__c = 'Não se aplica';
        	insert opp;
            
            Id RecTypeBeneficio = Schema.SObjectType.Beneficio__c.getRecordTypeInfosByDeveloperName().get('ELT_Distribuidor').getRecordTypeId();
            
            Test.startTest();
            Beneficio__c b = new Beneficio__c();
            b.RecordTypeId = RecTypeBeneficio;
            b.Nome_da_Oportunidade__c = opp.Id;
            insert b;
            
            opp.StageName = 'Adotado';
            opp.Beneficio_confirmado__c = 'Foi necessário';
            
            update opp;
            
            System.assertNotEquals(opp.Id, NULL);
    
            Test.stopTest();
        }
    }
    
    @IsTest
    static void ELTStagesCheckBeneficioErrorTest() {
        User userToRun = [
            SELECT Id FROM User WHERE Profile.Name LIKE '%admin%' AND ManagerId != null AND isActive = true LIMIT 1
        ];

        System.runAs(userToRun){
            Id RecTypeAcc = Schema.SObjectType.Account.getRecordTypeInfosByDeveloperName().get('PessoaJuridica').getRecordTypeId();
            Account acc = new Account();
            acc.RecordTypeId = RecTypeAcc;
            acc.Name = Util.generateRandomStringChar(10);
            acc.BR_cnpj__c = Util.generateCNPJ(TRUE);
            acc.BR_Account_email__c = Util.generateRandomStringChar(10)+'@a.com';
            insert acc;
            
	        Opportunity opp = new Opportunity();
            opp.RecordTypeId = OpportunityStagesCheck.RECORD_TYPE_OPORTUNIDADE_ELT;
            opp.StageName = 'Preparação';
            opp.Name = Util.generateRandomStringChar(10);
            opp.BR_Modalidade_licitacao__c = 'Carta Convite';
            opp.Analise_de_historico__c = TRUE;
            opp.Compromisso_agendado__c = TRUE;
            opp.Material_de_apresentacao_preparado__c = TRUE;
            opp.AmostraDigitalEnviada__c = TRUE;
            opp.Envio_de_amostra_fisica__c = 'Foi necessário';
            opp.CloseDate = System.today();
            opp.Beneficio_confirmado__c = 'Não foi necessário';
            opp.AccountId = acc.Id;
            opp.Material_analisado__c = TRUE;
            opp.Visita_pedagogica__c = 'Agendada';
            opp.Faturamento_do_pedido__c = 'Não se aplica';
        	insert opp;
            
            Test.startTest();
            opp.StageName = 'Adotado';
            opp.Beneficio_confirmado__c = 'Foi necessário';
            try{
                update opp;
            }
            catch(Exception e){
                System.assertEquals(e.getMessage().contains('É necessária a criação de um registro de Benefício do tipo ELT'), TRUE);
            }
            Test.stopTest();
        }
    }
}