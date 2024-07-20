public class EstoqueProdutosDAO  {
    public static List<EstoqueProdutos__c> getEstoqueFromProductsId(Set<Id> productIds) {
        return [SELECT Id, Produto__c, Quantidade__c, Produto__r.Name FROM EstoqueProdutos__c WHERE Produto__c IN :productIds];
    }    
}