@isTest
public class AmostraFisica_PricebookTest {
    
    @testSetup
    static void testSetup() {
        User u = new User(
            ProfileId = [SELECT Id FROM Profile WHERE Name = 'Brazil Global'].Id,
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
            ProfileId = [SELECT Id FROM Profile WHERE Name = 'System Administrator' OR Name = 'Administrador do Sistema'].Id,
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
        
        System.runAs(u2) {
            Product2 p = TestHelper.createProduct();
            insert p;
            
            Opportunity op = TestHelper.createOpportunity();
            op.ownerId = u2.id;
            insert op;
            
            Pricebook2 pb = TestHelper.createPricebook();
            insert pb;
            
            AmostraFisica__c amostra = new AmostraFisica__c();
            amostra.Pricebook__c = pb.Id;
            amostra.Oportunidade__c = op.id;
            amostra.Status__c = 'Não integrada';
            insert amostra;
            
            PricebookEntry pbe = new PricebookEntry( Product2Id=p.id, UnitPrice=0,
                                                    PriceBook2Id=Test.getStandardPricebookId(),
                                                    UseStandardPrice=false,isActive=true);
            insert pbe;
            
            PricebookEntry pbEntry = new PricebookEntry();
            pbEntry.Pricebook2Id = pb.Id;
            pbEntry.Product2Id = p.Id;
            pbEntry.UnitPrice = 2.0;
            pbEntry.IsActive = true;
            insert pbEntry;             
        }
    }
    
    @isTest
    static void testOne() {
        AmostraFisica__c amostra = [SELECT Id FROM AmostraFisica__c][0];
        User u = [SELECT Id FROM User WHERE LastName = 'TestU2'][0];
        Product2 p = [SELECT Id FROM Product2 LIMIT 1][0];
        System.runAs(u) {
            ItemAmostraFisica__c itemAmostra = new ItemAmostraFisica__c();
            itemAmostra.AmostraFisica__c = amostra.Id;
            itemAmostra.Quantidade__C = 1;
            itemAmostra.ValorUnitario__c = 1.0;
            itemAmostra.Produto__c = p.Id;
            insert itemAmostra;

            update amostra;
        }
    }
}