@isTest
public class AmostraFisicaDAOTest {

    @TestSetup
    static void makeData() {
        User u = new User(ProfileId = [SELECT Id FROM Profile WHERE Name = 'Brazil Global'].Id, 
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
                          IsActive = true);
        insert u;
        User u2 = new User(ProfileId = [SELECT Id FROM Profile WHERE Name = 'System Administrator' OR Name = 'Administrador do Sistema' LIMIT 1].Id, 
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
                           ManagerId = u.Id);
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
    }
    
    @IsTest
    static void integrarAmostraFisicaTest() {
        User u = [SELECT Id FROM User WHERE LastName = 'TestU2'] [0];
        System.runAs(u) {
            Opportunity opp = TestHelper.createOpportunity();
            opp.OwnerId = u.Id;
            opp.BR_Shipping_Address__c = 'Instituição';
            insert opp;
            
            Account acc = [select BR_cnpj__c from Account where Id = :opp.AccountId];
            acc.BR_cnpj__c = '64.903.818/0001-05';
            acc.BR_Integrate_to_SAP__c=true;
            update acc;
            
            PricebookEntry pbEntry = TestHelper.createPricebookEntry();
            insert pbEntry;
            
            EstoqueProdutos__c est = new EstoqueProdutos__c();
            est.Produto__c = pbEntry.Product2Id;
            est.Quantidade__c = 10000;
            insert est;
            
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
            
            AmostraFisicaDAO.getAmostraFisicaById(amostra.Id);
            AmostraFisicaDAO.getAmostrasFisicasById(new Set<Id> {amostra.Id});
            AmostraFisicaDAO.getAmostrasFisicasItensById(new Set<Id> {amostra.Id});
        }
    }
}