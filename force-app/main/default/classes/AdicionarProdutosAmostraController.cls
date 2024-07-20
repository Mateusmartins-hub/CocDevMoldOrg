public class AdicionarProdutosAmostraController {

    private class AmostraException extends Exception {}

    @AuraEnabled
    public static List<PricebookEntry> getProducts(String pricebook2Id) {
        List<PricebookEntry> prods = [SELECT Id, UnitPrice, Product2.Name, Product2.ProductCode, Product2.Id FROM PricebookEntry WHERE Pricebook2Id =: pricebook2Id  and product2.isactive = true and isactive = true and pricebook2.isactive = true];
        return prods;
    }

    @AuraEnabled
    public static List<Pricebook2> getPricebooks() {
        List<Pricebook2> retorno = [SELECT Id, Name FROM Pricebook2 WHERE IsActive = true AND AmostraFisica__c = true];
        return retorno;
    }

    @AuraEnabled
    public static String getPricebook(String id) {
        AmostraFisica__c amostra;
        amostra = [SELECT Id, Pricebook__c FROM AmostraFisica__c WHERE Id =: id][0];
        return amostra.Pricebook__c;
    }

    @AuraEnabled
    public static String getAmostraId(String id) {
        try{
            AmostraFisica__c amostra = [SELECT Id FROM AmostraFisica__c WHERE Id =: id][0];
            return amostra.Id;
        }catch(Exception e) {}

        try{
            ItemAmostraFisica__c itemAmostra = [SELECT Id, AmostraFisica__c FROM ItemAmostraFisica__c WHERE Id =: id];
            return itemAmostra.AmostraFisica__c;
        }catch(Exception e) {}

        return 'error';
    }

    @AuraEnabled
    public static List<AmostraItem> getAmostraLineItems(String id) {
        AmostraFisica__c amostra;
        try{
            amostra = [SELECT Id, (SELECT Id,
                                        Produto__c,
                                        Produto__r.Name,
                                        Quantidade__c,
                                        ValorUnitario__c,
                                        ValorTotal__c
                                        FROM ItensAmostraFisica__r)
                   FROM AmostraFisica__c WHERE Id =: id][0];
        } catch(Exception e) {
            System.debug(e.getMessage());
        }

        List<AmostraItem> amostraItems = new List<AmostraItem>();

        for(ItemAmostraFisica__c i : amostra.ItensAmostraFisica__r) {
            AmostraItem amostraItem = new AmostraItem();
            amostraItem.Id = i.Id;
            amostraItem.Quantity = Integer.ValueOf(i.Quantidade__c);
            amostraItem.PricebookPrice = i.ValorUnitario__c;
            amostraItem.TotalWithoutDiscountPrice = i.ValorUnitario__c * i.Quantidade__c;
            amostraItem.ProductName = i.Produto__r.Name;
            amostraItem.Product2Id =  i.Produto__c;

            amostraItems.add(amostraItem);
        }
        return amostraItems;
    }

    @AuraEnabled
    public static void savePricebookNItems(String id, String pricebookId, String jsonItems) {
        try{

            List<AmostraItem> items = (List<AmostraItem>)JSON.deserialize(jsonItems, List<AmostraItem>.class);
            validateStockQuantity(items);

            AmostraFisica__c amostra;
            amostra = [SELECT Id, Pricebook__c, (SELECT Id, Produto__c FROM ItensAmostraFisica__r) FROM AmostraFisica__c WHERE Id =: id][0];
            amostra.Pricebook__c = pricebookId;
            update amostra;


            List<ItemAmostraFisica__c> itemsToUpsert = new List<ItemAmostraFisica__c>();
            Set<String> productsIds = new Set<String>();
            for(AmostraItem i : items) {
                ItemAmostraFisica__c itemAmostra = new ItemAmostraFisica__c ();
                productsIds.add(i.Product2Id);

                if(i.ProductName != i.Id)
                    itemAmostra.Id = i.Id;

                if(String.isBlank(itemAmostra.Id)) {
                    itemAmostra.AmostraFisica__c = id;
                    itemAmostra.Produto__c = i.Product2Id;
                    itemAmostra.ValorUnitario__c = i.PricebookPrice;
                }
                itemAmostra.Quantidade__c = i.Quantity;
                itemsToUpsert.add(itemAmostra);
            }

            List<ItemAmostraFisica__c> itemsAmostra = amostra.ItensAmostraFisica__r;            
            List<ItemAmostraFisica__c> itemsToDelete = new List<ItemAmostraFisica__c>();
            for (ItemAmostraFisica__c itemAmostra : itemsAmostra) {
                if (!productsIds.contains(itemAmostra.Produto__c))
                    itemsToDelete.add(itemAmostra);
            }

            delete itemsToDelete;
            upsert itemsToUpsert;

        } catch(Exception e){
            throw new AuraHandledException(e.getMessage().substringAfter(',').substringBefore(': ['));
        }
    }

    private static void validateStockQuantity(List<AmostraItem> amostraItems) {
        Set<Id> productsIds = new Set<Id>();
        for (AmostraItem item : amostraItems) {
            productsIds.add(item.Product2Id);
        }

        List<EstoqueProdutos__c> estoques = (EstoqueProdutosDAO.getEstoqueFromProductsId(productsIds));

        Map<Id, EstoqueProdutos__c> mapProductEstoque = new Map<Id, EstoqueProdutos__c>();
        for (EstoqueProdutos__c estoque : estoques) {
            mapProductEstoque.put(estoque.Produto__c, estoque);
        }

        for (AmostraItem item : amostraItems) {
            EstoqueProdutos__c estoque = mapProductEstoque.get(item.Product2Id);

            if (estoque != null && estoque.Quantidade__c < item.Quantity)
                throw new AmostraException('Quantidade no estoque é menor que a quantidade de itens ('+ item.ProductName + ')');
        }
    }

    public class AmostraItem {
        @AuraEnabled
        public String Id;
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
        public Double TotalWithoutDiscountPrice;
    }
}