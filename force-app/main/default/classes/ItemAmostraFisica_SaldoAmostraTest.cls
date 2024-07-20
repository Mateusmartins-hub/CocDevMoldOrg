@isTest
public class ItemAmostraFisica_SaldoAmostraTest {
    
    @testSetup static void testSetup() {
        User u = new User(
            ProfileId = [SELECT Id FROM Profile WHERE Name = 'Standard User' OR Name = 'Usuário Padrão' LIMIT 1].Id,
            LastName = 'TestU1',
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
            LastName = 'TestU2',
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
        
        System.runAs(u2) {
            /*SaldoParaAmostras__c saldo = new SaldoParaAmostras__c();
            saldo.Funcionario__c = u.Id;
            saldo.Saldo__c = 100;
            insert saldo;*/
            
            SaldoParaAmostras__c saldo2 = new SaldoParaAmostras__c();
            saldo2.Funcionario__c = u2.Id;
            saldo2.Saldo__c = 100;
            insert saldo2;
        }
    }
    
    static testMethod void testOne() {
        User u = [SELECT Id FROM User WHERE LastName = 'TestU2'][0];
        System.runAs(u) {
            Opportunity opp = TestHelper.createOpportunity();
            opp.OwnerId = u.Id;
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
            insert amostra;
            
            ItemAmostraFisica__c item = new ItemAmostraFisica__c();
            item.AmostraFisica__c = amostra.Id;
            item.Produto__c = pbEntry.Product2Id;
            item.Quantidade__c = 1;
            insert item;
            
            item.Quantidade__c = 2;
            update item;
        }
    }
    
    static testMethod void testTwo() {
        User u = [SELECT Id FROM User WHERE LastName = 'TestU2'][0];
        System.runAs(u) {
            Opportunity opp = TestHelper.createOpportunity();
            opp.OwnerId = u.Id;
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
            insert amostra;
            
            ItemAmostraFisica__c item = new ItemAmostraFisica__c();
            item.AmostraFisica__c = amostra.Id;
            item.Produto__c = pbEntry.Product2Id;
            item.Quantidade__c = 1;
            insert item;
            update item;
            delete item;
        }
    }
}