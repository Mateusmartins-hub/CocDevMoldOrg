@IsTest
public class ProductsStockUpdateTest {

    @TestSetup
    static void makeData(){
        insert new IntegracaoEstoqueSAP__c(Name='test',ConnectionName__c = 'test', EndpointApplication__c='tes', EndpointKey__c='test',EndpointURL__c='https://integration.pearson.com.br/rfc',EndpointUser__c='test',RFC__c='test');

        Product2 prdt = TestHelper.createProduct();
        prdt.BR_ISBN__c = '9780074504093';
        insert prdt;

        PricebookEntry pbEntry = TestHelper.createPricebookEntry();
        pbEntry.Product2Id = prdt.Id;
        insert pbEntry;

        Pricebook2 pb = new Pricebook2();
        pb.Id = pbEntry.Pricebook2Id;
        pb.AmostraFisica__c = true;
        update pb;

        EstoqueProdutos__c ep = new EstoqueProdutos__c();
        ep.Produto__c = prdt.Id;
        insert ep;
        
        Profile prof = new Profile();
        

        User u = new User(
            ProfileId = [SELECT Id FROM Profile WHERE (UserType = 'Standard' AND PermissionsPrivacyDataAccess = true)].Id,
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
            ProfileId = [SELECT Id FROM Profile WHERE (UserType = 'Standard' AND PermissionsPrivacyDataAccess = true)].Id,
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
    }

    @IsTest
    static void updateStockOppTest() {
        Test.setMock(HttpCalloutMock.class, new MockCapturaSAP());

        Test.startTest();
        ProductsStockUpdate.updateAllStocks();
        Test.stopTest();
    }
}