@isTest
public class ItemAmostraFisica_AmostraTest {

    static testMethod void testOne() {
        User u = new User(
            ProfileId = [SELECT Id FROM Profile WHERE (UserType = 'Standard' AND PermissionsPrivacyDataAccess = true) ORDER BY CreatedDate ASC LIMIT 1][0].Id,
            LastName = 'Test',
            Email = 'test@test.com',
            Username = 'test@testtest.com' + System.currentTimeMillis(),
            CompanyName = 'TEST',
            Title = 'title',
            Alias = 'alias',
            TimeZoneSidKey = 'America/Los_Angeles',
            EmailEncodingKey = 'UTF-8',
            LanguageLocaleKey = 'en_US',
            LocaleSidKey = 'en_US',
            IsActive = true
        );
        insert u;
        
        User u2 = new User(
            ProfileId = [SELECT Id FROM Profile WHERE Name = 'Brazil Global' LIMIT 1].Id,
            LastName = 'Test',
            Email = 'test@test.com',
            Username = 'test@testtest.com' + System.currentTimeMillis(),
            CompanyName = 'TEST',
            Title = 'title',
            Alias = 'alias',
            TimeZoneSidKey = 'America/Los_Angeles',
            EmailEncodingKey = 'UTF-8',
            LanguageLocaleKey = 'en_US',
            LocaleSidKey = 'en_US',
            ManagerId = u.Id
        );
        insert u2;
        
        System.runAs(u) {
            SaldoParaAmostras__c saldo = new SaldoParaAmostras__c();
            saldo.Funcionario__c = u.Id;
            saldo.Saldo__c = 1000;
            insert saldo;
            
            SaldoParaAmostras__c saldo2 = new SaldoParaAmostras__c();
            saldo2.Funcionario__c = u2.Id;
            saldo2.Saldo__c = 1000;
            insert saldo2;
        } 
        
        Product2 prod = TestHelper.createProduct();
        
        insert prod;
        
        Pricebook2 pb = new Pricebook2();
        pb.AmostraFisica__c = true;
        pb.Name = 'test';
        insert pb;
        
        PricebookEntry pbEntry = new PricebookEntry();
        pbEntry.Pricebook2Id = Test.getStandardPricebookId();
        pbEntry.Product2Id = prod.Id;
        pbEntry.UnitPrice = 2.0;
        pbEntry.IsActive = true;
        insert pbEntry;
        
        PricebookEntry pbEntry2 = new PricebookEntry();
        pbEntry2.Pricebook2Id = pb.Id;
        pbEntry2.Product2Id = prod.Id;
        pbEntry2.UnitPrice = 2.0;
        pbEntry2.IsActive = true;
        insert pbEntry2;
        
        System.runAs(u2) {  
            Opportunity op = TestHelper.createOpportunity();
            op.Pricebook2Id = pb.Id;
            insert op;
            
            AmostraFisica__c amostra = new AmostraFisica__c();
            amostra.TipoFrete__c = 'Normal';
            amostra.Oportunidade__c = op.Id;
            insert amostra;
            
            ItemAmostraFisica__c item = new ItemAmostraFisica__c();
            item.AmostraFisica__c = amostra.Id;
            item.Produto__c = prod.Id;
            item.Quantidade__c = 1;
            insert item;
            
            update item;
            
            delete item;
        }
    }
}