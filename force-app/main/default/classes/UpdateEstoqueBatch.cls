global class UpdateEstoqueBatch implements Database.Batchable<sObject>, Database.AllowsCallouts {

    global Database.QueryLocator start(Database.BatchableContext BC) {
        Set<String> setISBNs = MakeEstoqueSAPRequest.getAllStocks().keySet();
        System.debug(setISBNs);
        String query = 'SELECT Id, BR_ISBN__c, (SELECT Id FROM EstoquesProdutos__r) FROM Product2 WHERE BR_ISBN__c IN :setISBNs';
        return Database.getQueryLocator(query);
    }

    global void execute(Database.BatchableContext BC, List<Product2> scope) {
        Map<String, String> mapISBNQuantity = MakeEstoqueSAPRequest.getAllStocks();
        List<EstoqueProdutos__c> estoques = new List<EstoqueProdutos__c>();

        for (Product2 product : scope) {
            if (mapISBNQuantity.containsKey(product.BR_ISBN__c)) {
                String quantidade = mapISBNQuantity.get(product.BR_ISBN__c);
                
                EstoqueProdutos__c estoque = new EstoqueProdutos__c();

                if(product.EstoquesProdutos__r.size() > 0)
                    estoque.Id = product.EstoquesProdutos__r[0].Id;

                estoque.Quantidade__c = Decimal.valueOf(quantidade.replace(',', '.'));
                estoque.Produto__c = product.Id;           
                estoques.add(estoque);
            }
        }
        
        upsert estoques;
    }

    global void finish(Database.BatchableContext BC){
        System.debug('ACABOU O BATCH');
    }
}