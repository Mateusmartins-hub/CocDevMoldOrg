global with sharing class ProductsStockResource {
    global class ProductStockInfo {
        webservice String idProduto;
        webservice Integer quantidade;
    }
    
    webservice static String insertProductStocks(List<ProductStockInfo> productStocks) {
        
        List<EstoqueProdutos__c> stocksToInsert = new List<EstoqueProdutos__c>();
        
        try {
            for (ProductStockInfo ps : productStocks){
                EstoqueProdutos__c ep  = new EstoqueProdutos__c();
                ep.Produto__c = ps.idProduto;
                ep.Quantidade__c = ps.quantidade;
                
                stocksToInsert.add(ep);
            }
            
            
            
            List<Database.UpsertResult> upsertResults = Database.upsert(stocksToInsert, EstoqueProdutos__c.Id.getDescribe().getSObjectField(), false);
            
            String erros = '';
            for (Database.UpsertResult r : upsertResults) {
                if (!r.isSuccess()) {
                    for (Database.Error e : r.getErrors()) { 
                        erros+=e.getMessage();
                    }
                }
            }
            return 'OK';
        } catch (Exception e) {
            return e.getMessage();
        }        
    }
}