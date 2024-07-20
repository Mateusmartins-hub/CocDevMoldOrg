public class AdicionarProdutosCotacaoController {

    @AuraEnabled
    public static List<PricebookEntry> getProducts(String pricebook2Id) {
        List<PricebookEntry> prods = [SELECT Id, UnitPrice, Product2.Name, Product2.ProductCode FROM PricebookEntry WHERE Pricebook2Id =: pricebook2Id  and product2.isactive = true and isactive = true and pricebook2.isactive = true];
        return prods;
    }

    @AuraEnabled
    public static List<Pricebook2> getPricebooks() {
        List<Pricebook2> retorno = [SELECT Id, Name FROM Pricebook2 WHERE IsActive = true];
        return retorno;
    }

    @AuraEnabled
    public static String getPricebook2Id(String id) {
        Quote cot;
        try{
            cot = [SELECT Id, Pricebook2Id FROM Quote WHERE Id =: id][0];
        }catch(Exception e) {}

        try{
            QuoteLineItem i = [SELECT Id, QuoteId FROM QuoteLineItem WHERE Id =: id];
            cot = [SELECT Id, Pricebook2Id FROM Quote WHERE Id =: i.QuoteId][0];
        }catch(Exception e) {}

        return cot.Pricebook2Id;
    }


    @AuraEnabled
    public static String getRecordTypeName(String id){
        Quote cot;
        try{
            cot = [SELECT RecordType.DeveloperName FROM Quote WHERE Id = :id][0];
        }catch(Exception e) {}

        try{
            QuoteLineItem i = [SELECT Id, QuoteId FROM QuoteLineItem WHERE Id =: id];
            cot = [SELECT RecordType.DeveloperName FROM Quote WHERE Id = :i.QuoteId][0];
        }catch(Exception e) {}

        return cot.RecordType.DeveloperName;
    }

    @AuraEnabled
    public static List<QuoteItem> getQuoteLineItems(String id) {
        Quote cot;
        try{
            cot = [SELECT Id, Pricebook2Id, (SELECT Id,
                                             PricebookEntryId,
                                             Discount,
                                             LucroPotencial__c,
                                             ListPrice,
                                             Product2Id,
                                             Product2.Name,
                                             Quantity,
                                             Subtotal,
                                             UnitPrice,
                                             ValorVendaDesconto__c,
                                             ValorSugerido__c,
                                             TotalPrice
                                             FROM QuoteLineItems)
                   FROM Quote WHERE Id =: id][0];
        }catch(Exception e) {}

        try{
            QuoteLineItem i = [SELECT Id, QuoteId FROM QuoteLineItem WHERE Id =: id];
            cot = [SELECT Id, Pricebook2Id, (SELECT Id,
                                             PricebookEntryId,
                                             Discount,
                                             LucroPotencial__c,
                                             ListPrice,
                                             Product2Id,
                                             Product2.Name,
                                             Quantity,
                                             Subtotal,
                                             UnitPrice,
                                             ValorVendaDesconto__c,
                                             ValorSugerido__c,
                                             TotalPrice
                                             FROM QuoteLineItems)
                   FROM Quote WHERE Id =: i.QuoteId][0];
        }catch(Exception e) {}

        List<QuoteItem> qis = new List<QuoteItem>();

        for(QuoteLineItem i : cot.QuoteLineItems) {
            QuoteItem qi = new QuoteItem();

            qi.Product2Id = i.Product2Id;
            qi.ProductName = i.Product2.Name;
            qi.Id = i.Id;
            qi.Quantity = Integer.ValueOf(i.Quantity);
            qi.PricebookPrice = i.UnitPrice;
            qi.DiscountPercentage = i.Discount / 100;
            qi.SuggestedPrice = i.ValorSugerido__c;
            qi.PotentialProfit = i.LucroPotencial__c;
            qi.UnitDiscountPrice = i.ValorVendaDesconto__c;
            qi.TotalWithoutDiscountPrice = i.UnitPrice * i.Quantity;
            qi.TotalDiscountPrice = i.ValorVendaDesconto__c * i.Quantity;

            qis.add(qi);
        }
        return qis;
    }

    @AuraEnabled
    public static String getQuoteId(String id) {
        Quote cot;
        try{
            cot = [SELECT Id, Pricebook2Id FROM Quote WHERE Id =: id][0];
        }catch(Exception e) {}

        try{
            QuoteLineItem i = [SELECT Id, QuoteId FROM QuoteLineItem WHERE Id =: id];
            cot = [SELECT Id, Pricebook2Id FROM Quote WHERE Id =: i.QuoteId][0];
        }catch(Exception e) {}

        return cot.Id;
    }

    @AuraEnabled
    public static void savePricebookNItems(String id, String pricebookId, String jsonItems) {
        try{
            Quote cot;
            try{
                cot = [SELECT Id, Pricebook2Id, (SELECT Id, Product2Id FROM QuoteLineItems) FROM Quote WHERE Id =: id][0];
            }catch(Exception e) {}

            try{
                QuoteLineItem i = [SELECT Id, QuoteId FROM QuoteLineItem WHERE Id =: id];
                cot = [SELECT Id, Pricebook2Id, (SELECT Id, Product2Id FROM QuoteLineItems) FROM Quote WHERE Id =: i.QuoteId][0];
            } catch(Exception e) {}

            cot.Pricebook2Id = pricebookId;
            update cot;

            List<QuoteItem> items = (List<QuoteItem>)JSON.deserialize(jsonItems, List<QuoteItem>.class);
            List<QuoteLineItem> qls = new List<QuoteLineItem>();
            Set<String> productsIds = new Set<String>();
            for(QuoteItem i : items) {
                QuoteLineItem ql = new QuoteLineItem();
                productsIds.add(i.Product2Id);

                if(i.ProductName != i.Id)
                    ql.Id = i.Id;

                if(String.isBlank(ql.Id)) {
                    ql.QuoteId = cot.Id;
                    ql.Product2Id = i.Product2Id;
                    ql.PricebookEntryId = i.PricebookEntryId;
                    ql.UnitPrice = i.PricebookPrice;
                }
                ql.Quantity = i.Quantity;
                ql.Discount = i.DiscountPercentage * 100;
                ql.ValorSugerido__c = i.SuggestedPrice;
                ql.LucroPotencial__c = i.PotentialProfit;
                ql.ValorVendaDesconto__c = i.UnitDiscountPrice;

                qls.add(ql);
            }

            List<QuoteLineItem> itemsQuote = cot.QuoteLineItems;
            List<QuoteLineItem> itemsToDelete = new List<QuoteLineItem>();
            for (QuoteLineItem itemQuote : itemsQuote) {
                if (!productsIds.contains(itemQuote.Product2Id))
                    itemsToDelete.add(itemQuote);
            }

            delete itemsToDelete;
            upsert qls;
        }catch(Exception e){
            System.debug(e.getMessage());
            System.debug(e.getLineNumber());
            throw new AuraHandledException(e.getMessage());
        }
    }

    public class QuoteItem {
        @AuraEnabled
        public String Id;
        @AuraEnabled
        public String PricebookEntryId;
        @AuraEnabled
        public String Product2Id;
        @AuraEnabled
        public String ProductCode;
        @AuraEnabled
        public String ProductName;
        @AuraEnabled
        public Integer Quantity;
        @AuraEnabled
        public Double PricebookPrice;
        @AuraEnabled
        public Double DiscountPercentage;
        @AuraEnabled
        public Double UnitDiscountPrice;
        @AuraEnabled
        public Double TotalWithoutDiscountPrice;
        @AuraEnabled
        public Double TotalDiscountPrice;
        @AuraEnabled
        public Double SuggestedPrice;
        @AuraEnabled
        public Double PotentialProfit;
    }

}