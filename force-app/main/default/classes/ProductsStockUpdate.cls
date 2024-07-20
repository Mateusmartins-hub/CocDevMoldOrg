public class ProductsStockUpdate {
    public static List<EstoqueProdutos__c> updateAllStocks() {
        Map<String, String> mapISBNQuantity = MakeEstoqueSAPRequest.getAllStocks();

        List<Product2> products = Product2DAO.getProductsByISBN(mapISBNQuantity.keySet());
        List<EstoqueProdutos__c> estoques = new List<EstoqueProdutos__c>();
        for (Product2 product : products) {
            if (mapISBNQuantity.containsKey(product.BR_ISBN__c)) {
                String quantidade = mapISBNQuantity.get(product.BR_ISBN__c).replaceFirst('^0+(?!$)', '');
                EstoqueProdutos__c estoque = new EstoqueProdutos__c();
                estoque.Quantidade__c = Decimal.valueOf(quantidade.replace(',', '.'));
                estoque.Produto__c = product.Id;

                estoques.add(estoque);
            }
        }
        return estoques;
    }
}