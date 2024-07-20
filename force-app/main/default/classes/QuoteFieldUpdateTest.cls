@IsTest
public class QuoteFieldUpdateTest {
    @TestSetup
    static void setup(){
        Profile p = [SELECT Id FROM Profile WHERE (Name = 'System Administrator') or  (Name = 'Administrador do Sistema' ) limit 1];
        
        // Aprovador 
        User u1 = new User(
            Alias = 'standt1', 
            Email='standarduser1@pearson.br', 
            EmailEncodingKey='UTF-8', 
            LastName='Testing', 
            LanguageLocaleKey='pt_BR', 
            LocaleSidKey='pt_BR', 
            ProfileId = p.Id, 
            TimeZoneSidKey='America/Sao_Paulo', 
            UserName='standarduser1@pearson.br'
            
        );
        insert u1;  
        
        // Solicitante
        User u2 = new User(
            Alias = 'standt2', 
            Email='standarduser2@pearson.br', 
            EmailEncodingKey='UTF-8', 
            LastName='Testing', 
            LanguageLocaleKey='pt_BR', 
            LocaleSidKey='pt_BR', 
            ProfileId = p.Id, 
            TimeZoneSidKey='America/Sao_Paulo', 
            UserName='standarduser2@pearson.br',
            ManagerId = u1.id 
        );
        insert u2;
        
        
    }
    
    @IsTest
    static void updateManagerFieldTest() {
        User u = [select id, email, ManagerId from User where UserName = 'standarduser2@pearson.br' limit 1];
        
        insert new VencimentoCotacao__c(Dias__c = 10);
        
        System.runAs(u){
            Test.startTest();
            Quote qt = TestHelper.createQuote();      
            qt.RecordTypeId = Schema.SObjectType.Quote.getRecordTypeInfosByDeveloperName().get('Padrao').getRecordTypeId();
            insert qt;
            Test.stopTest();
        }
        
        Quote qtResult = [SELECT Id, Approver_1__c FROM Quote LIMIT 1];
        
        //System.assertEquals(u.ManagerId, qtResult.Approver_1__c);
    }
    
    @IsTest
    static void testExpansaoEd() {
        insert new VencimentoCotacao__c(Dias__c = 10);
        
        Pricebook2 pb = TestHelper.createPricebook();
        pb.Name = 'Expansão Skill.Ed.';
        pb.CurrencyIsoCode = 'BRL';
        insert pb;
        
        PricebookEntry pbEDef = TestHelper.createPricebookEntry();
        pbEDef.CurrencyIsoCode = 'BRL';
        insert pbEDef;
        
        PricebookEntry pbE = new PricebookEntry();
        pbE.IsActive = true;
        pbE.Product2Id = pbEDef.Product2Id;
        pbE.UnitPrice = 10;
        pbE.Pricebook2Id = pb.Id;
        pbE.CurrencyIsoCode = 'BRL';        
        insert pbE;
        
        User u = [select id, email from User where UserName = 'standarduser2@pearson.br' limit 1];
        System.runAs(u){    
            
            Account ac = new Account();
            ac.Name = 'test account';
            ac.BR_Account_email__c = 'email@email.com';
            insert ac;
                
            Opportunity op = new Opportunity();
            op.Name = 'Opportunity Test';
            op.StageName = 'Orçamento';
            op.CloseDate = Date.today();
            op.RecordTypeId = Schema.SObjectType.Opportunity.getRecordTypeInfosByDeveloperName().get('Sample_Order_University').getRecordTypeId();
            op.AccountId = ac.Id;
            op.Description = 'Test';
            op.CurrencyIsoCode = 'BRL';
            insert op;
            
            Quote qt = TestHelper.createQuote();
            qt.OpportunityId =  op.Id;
            qt.Name = 'test Quote';
            qt.RecordTypeId = QuoteFieldUpdate.RECORD_TYPE_COTACAO_EXPANSAO_SKILL_ED;
            qt.Pricebook2Id = pb.Id;
            qt.CurrencyIsoCode = 'BRL';
            insert qt;    
        }
        
    }
    
    @IsTest
    static void testSetorPrivado() {
        insert new VencimentoCotacao__c(Dias__c = 10);
        
        Pricebook2 pb = TestHelper.createPricebook();
        pb.Name = 'Expansão Skill.Ed.';
        insert pb;
        
        PricebookEntry pbEDef = TestHelper.createPricebookEntry();
        insert pbEDef;
        
        PricebookEntry pbE = new PricebookEntry();
        pbE.IsActive = true;
        pbE.Product2Id = pbEDef.Product2Id;
        pbE.UnitPrice = 10;
        pbE.Pricebook2Id = pb.Id;
        insert pbE;
        
        User u = [select id, email from User where UserName = 'standarduser2@pearson.br' limit 1];
        System.runAs(u){            
            Quote qt = TestHelper.createQuote();
            qt.RecordTypeId = Schema.SObjectType.Quote.getRecordTypeInfosByDeveloperName().get('Padrao').getRecordTypeId();
            qt.Pricebook2Id = pb.Id;
            insert qt;
            
            qt.Aprovacao_interna_aceita__c = true;
            update qt;
        }
    }
    
    
      @IsTest
    static void testupdateCommercialConditionsAndCluster() {
        insert new VencimentoCotacao__c(Dias__c = 10);
        
        Profile pfr = [SELECT Id, Name  FROM Profile where Name = 'Brazil Global'];

        User manager = new User();
        manager.Username = 'test1234@pearson.com.Test2';
        manager.Lastname = 'test';
        manager.Email = 'test@email.com';
        manager.Alias = 'test1';
        manager.TimeZoneSidKey = 'America/Los_Angeles';
        manager.LocaleSidKey = 'en_US';
        manager.LanguageLocaleKey = 'en_US';
        manager.EmailEncodingKey = 'UTF-8';
        manager.ProfileId = pfr.Id;
        insert manager;

        User usr = new User();
        usr.Username = 'test123@pearson.com.Test';
        usr.Lastname = 'test';
        usr.Email = 'test@email1.com';
        usr.Alias = 'test123';
        usr.TimeZoneSidKey = 'America/Los_Angeles';
        usr.LocaleSidKey = 'en_US';
        usr.LanguageLocaleKey = 'en_US';
        usr.EmailEncodingKey = 'UTF-8';
        usr.ProfileId = pfr.Id;
        usr.ManagerId = manager.Id;
        insert usr;
		
        Test.startTest();
        System.runAs(usr){
            
            PricebookEntry ent = TestHelper.createPricebookEntryQuote('Product_COC', '');
        	insert ent;
            
            PricebookEntry ent2Mentes = 	TestHelper.createPricebookEntryQuote('Mentes', '');
        	insert ent2Mentes;
            
            PricebookEntry ent3Idiomas = 	TestHelper.createPricebookEntryQuote('Product_Languages', '');
        	insert ent3Idiomas;
            
            PricebookEntry ent3IdiomasEI = 	TestHelper.createPricebookEntryQuote('Product_Languages', 'EI');
        	insert ent3IdiomasEI;
            
            PricebookEntry ent3IdiomasEF1 = TestHelper.createPricebookEntryQuote('Product_Languages', 'EF1');
        	insert ent3IdiomasEF1;
            
            Opportunity opp = TestHelper.createOpportunity();
            opp.Pricebook2Id = Test.getStandardPricebookId();
            insert opp;

            //Quote rules Tabela
            Quote_Rules__mdt quoteRules = new Quote_Rules__mdt();
            quoteRules.label = 'COC 4';
            quoteRules.DeveloperName = 'COC_19';
            quoteRules.Marca__c = 'Dom BoscoN/NE EW';
            quoteRules.Cluster__c = 'BRONZE';
            quoteRules.Faturamento__c = 0;
            quoteRules.X1_Ano__c = 20;
            quoteRules.X2_Ano__c = 23;
            quoteRules.X3_Ano__c = 25;
            quoteRules.X4_Ano__c = 28;
            quoteRules.X5_Ano__c = 30;
			system.debug('passando pelo test - BRAND/SISTEM DE ENSINO = '+quoteRules.Marca__c);
            //Quote principal
            Quote qt = new Quote();
            qt.OpportunityId =  opp.Id;
            qt.Name = 'test Quote';            
            qt.RecordTypeId = Schema.SObjectType.Quote.getRecordTypeInfosByDeveloperName().get('Guarda_Chuva').getRecordTypeId();
            qt.Sistema_de_ensino__c = 'Dom Bosco N/NE';
            qt.Regiao_do_pais__c = 'N/NE';
            qt.Sistemas_Desconto_Ano_1__c = 10;
            qt.pricebook2id = Test.getStandardPricebookId();
            insert qt;
            
            
            
            QuoteLineItem qtL = new QuoteLineItem();
            qtL.UnitPrice = 10;
            qtL.Product2Id = ent.Product2Id;
            qtL.PricebookEntryId = ent.Id;
            qtL.QuoteId = qt.Id;
            qtL.Quantity = 10;
            insert qtl;
            
            QuoteLineItem qtlMentes = qtl.clone(false, true, false, false);
            qtlMentes.PricebookEntryId = ent2Mentes.id;
            qtlMentes.Product2Id = ent2Mentes.Product2Id;
			insert qtlMentes;
            
            QuoteLineItem qtlIdiomas = qtl.clone(false, true, false, false);
            qtlIdiomas.PricebookEntryId = ent3Idiomas.id;
            qtlIdiomas.Product2Id = ent3Idiomas.Product2Id;
			insert qtlIdiomas;
            
        }
        Test.stopTest();

        //Quote qtResult = [SELECT Id, Approver_1__c FROM Quote LIMIT 1];
        
        //System.assertEquals('Ok', qt.Sistemas_Condicao_comercial__c);
    }
   
}