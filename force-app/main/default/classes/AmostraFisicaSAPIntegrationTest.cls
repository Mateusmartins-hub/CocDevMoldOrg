@istest
public class AmostraFisicaSAPIntegrationTest {

    @testSetup
    public static void Setup() {
        TestHelper.createCustomSettings();
        
        User u = new User(
            ProfileId = [SELECT Id FROM Profile WHERE (UserType = 'Standard' AND PermissionsPrivacyDataAccess = true) ORDER BY CreatedDate ASC LIMIT 1].Id,
            LastName = 'TestU1',
            Email = 'test@test.com',
            Username = 'test@testtest.com' + System.currentTimeMillis(),
            CompanyName = 'TEST',
            Title = 'title',
            Alias = 'alias',
            TimeZoneSidKey = 'America/Los_Angeles',
            EmailEncodingKey = 'UTF-8',
            LanguageLocaleKey = 'pt_BR',
            LocaleSidKey = 'pt_BR',
            IsActive = true
        );
        insert u;
        User u2 = new User(ProfileId = [SELECT Id FROM Profile WHERE Name = 'Brazil Global'].Id, 
            LastName = 'TestU2',
            Email = 'test@test.com',
            Username = 'test@testtest.com' + System.currentTimeMillis(),
            CompanyName = 'TEST',
            Title = 'title',
            Alias = 'alias',
            TimeZoneSidKey = 'America/Los_Angeles',
            EmailEncodingKey = 'UTF-8',
            LanguageLocaleKey = 'pt_BR',
            LocaleSidKey = 'pt_BR',
            ManagerId = u.Id
        );
        insert u2;
        
        System.runAs(u) {
            SaldoParaAmostras__c saldo = new SaldoParaAmostras__c();
            saldo.Funcionario__c = u.Id;
            saldo.Saldo__c = 100;
            insert saldo;
            
            SaldoParaAmostras__c saldo2 = new SaldoParaAmostras__c();
            saldo2.Funcionario__c = u2.Id;
            saldo2.Saldo__c = 100;
            insert saldo2;
        }
        
        Opportunity opp = TestHelper.createOpportunity();
        opp.BR_Shipping_Address__c = 'Instituição';
        opp.OwnerId = u2.Id;
        insert opp;
        
        PricebookEntry pbEntry = TestHelper.createPricebookEntry();
        insert pbEntry;
        
        Pricebook2 pb = new Pricebook2();
        pb.Id = pbEntry.Pricebook2Id;
        pb.AmostraFisica__c = true;
        update pb;
        
        AmostraFisica__c amostra = new AmostraFisica__c();
        amostra.Oportunidade__c = opp.Id;
        amostra.TipoFrete__c = 'Normal';
        amostra.Status__c = 'Não Integrada';
        insert amostra;
        
        ItemAmostraFisica__c item = new ItemAmostraFisica__c();
        item.AmostraFisica__c = amostra.Id;
        item.Produto__c = pbEntry.Product2Id;
        item.Quantidade__c = 1;
        insert item;
    }
    
    @isTest
    public static void Execute() {
        Test.startTest();
        Test.setMock(HttpCalloutMock.class, new Amostra_Instituicao_Mock());        
        AmostraFisicaSAPIntegration.doIntegration([SELECT Id, Oportunidade__c, TipoFrete__c, Status__c, CreatedDate FROM AmostraFisica__c][0]);
        Test.stopTest();
    }
}