@isTest
public class AdicionarProdutosCotacaoControllerTest {

    @testSetup
    static void testSetup() {

        User userToRun = [
            SELECT Id FROM User WHERE Profile.Name LIKE '%admin%' AND ManagerId != null AND isActive = true LIMIT 1
        ];
      
        System.runAs(userToRun){
            insert new VencimentoCotacao__c(Dias__c = 10);

            Product2 p = TestHelper.createProduct();
            insert p;

            Opportunity op = TestHelper.createOpportunity();
            insert op;

            Quote cot = new Quote();
            cot.Name = 'Test';
            cot.OpportunityId = op.Id;
            cot.RecordTypeId = Schema.SObjectType.Quote.getRecordTypeInfosByDeveloperName().get('Padrao').getRecordTypeId();
            insert cot;
        }
    }

    @isTest
    static void testGetProducts() {
        AdicionarProdutosCotacaoController.getProducts(Test.getStandardPricebookId());
    }

    @isTest
    static void testGetPricebooks() {
        AdicionarProdutosCotacaoController.getPricebooks();
    }

    @isTest
    static void testGetPricebook2Id() {
        AdicionarProdutosCotacaoController.getPricebook2Id([SELECT Id FROM Quote][0].Id);
    }

    @isTest
    static void testGetQuoteId() {
        Product2 p = [SELECT Id FROM Product2 LIMIT 1][0];

        PricebookEntry pbEntry = new PricebookEntry();
        pbEntry.Pricebook2Id = Test.getStandardPricebookId();
        pbEntry.Product2Id = p.Id;
        pbEntry.UnitPrice = 2.0;
        pbEntry.IsActive = true;
        insert pbEntry;

        Quote cot = [SELECT Id FROM Quote][0];
        cot.Pricebook2Id = Test.getStandardPricebookId();
        update cot;

        QuoteLineItem qI = new QuoteLineItem();
        qI.QuoteId = cot.Id;
        qI.PricebookEntryId = pbEntry.Id;
        qI.Quantity = 1;
        qI.UnitPrice = 1.0;
        qI.Discount = 0;
        qI.Product2Id = p.Id;
        qI.ValorVendaDesconto__c = 1.0;
        insert qI;

        AdicionarProdutosCotacaoController.getQuoteId(cot.Id);
        AdicionarProdutosCotacaoController.getQuoteId(qI.Id);
    }

    @isTest
    static void testGetQuoteLineItems() {
        Product2 p = [SELECT Id FROM Product2 LIMIT 1][0];

        PricebookEntry pbEntry = new PricebookEntry();
        pbEntry.Pricebook2Id = Test.getStandardPricebookId();
        pbEntry.Product2Id = p.Id;
        pbEntry.UnitPrice = 2.0;
        pbEntry.IsActive = true;
        insert pbEntry;

        Quote cot = [SELECT Id FROM Quote][0];
        cot.Pricebook2Id = Test.getStandardPricebookId();
        update cot;

        QuoteLineItem qI = new QuoteLineItem();
        qI.QuoteId = cot.Id;
        qI.PricebookEntryId = pbEntry.Id;
        qI.Quantity = 1;
        qI.UnitPrice = 1.0;
        qI.Discount = 0;
        qI.Product2Id = p.Id;
        qI.ValorVendaDesconto__c = 1.0;
        insert qI;

        AdicionarProdutosCotacaoController.getQuoteLineItems(cot.Id);
    }

    @isTest
    static void testSavePricebookNItems() {
        Product2 p = [SELECT Id FROM Product2 LIMIT 1][0];

        PricebookEntry pbEntry = new PricebookEntry();
        pbEntry.Pricebook2Id = Test.getStandardPricebookId();
        pbEntry.Product2Id = p.Id;
        pbEntry.UnitPrice = 2.0;
        pbEntry.IsActive = true;
        insert pbEntry;

        AdicionarProdutosCotacaoController.QuoteItem q = new AdicionarProdutosCotacaoController.QuoteItem();
        q.Product2Id = p.Id;
        q.PricebookEntryId = pbEntry.Id;
        q.ProductCode = 'Test';
        q.ProductName = 'Test';
        q.Quantity = 1;
        q.PricebookPrice = 1;
        q.DiscountPercentage = 0.1;
        q.UnitDiscountPrice = 0.09;
        q.TotalWithoutDiscountPrice = 0.09;
        q.TotalDiscountPrice = 0.09;
        q.SuggestedPrice = 0.09;
        q.PotentialProfit = 0.09;

        String jsonItems = JSON.serialize(new List<AdicionarProdutosCotacaoController.QuoteItem> {q});
        AdicionarProdutosCotacaoController.savePricebookNItems([SELECT Id FROM Quote][0].Id, Test.getStandardPricebookId(), jsonItems);
    }

    @isTest
    static void testGetRecordTypeName() {
        Quote cot = [SELECT Id FROM Quote LIMIT 1];

        String recordTypeName = AdicionarProdutosCotacaoController.getRecordTypeName(cot.Id);
        System.assertEquals('Padrao', recordTypeName);
    }
}