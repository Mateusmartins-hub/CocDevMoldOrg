public class EstoqueValidation {
    public static void validateDuplicate(List<EstoqueProdutos__c> estoques) {
        Set<Id> productsIds = new Set<Id>();
        for (EstoqueProdutos__c estoque : estoques) {
            productsIds.add(estoque.Produto__c);
        }

        List<EstoqueProdutos__c> duplicatedEstoques = EstoqueProdutosDAO.getEstoqueFromProductsId(productsIds);

        System.debug(duplicatedEstoques);

        Set<Id> productsEstoques = new Set<Id>();
        for (EstoqueProdutos__c estoque : duplicatedEstoques) {
            productsEstoques.add(estoque.Produto__c);
        }

        for (EstoqueProdutos__c estoque :  estoques) {
            if (productsEstoques.contains(estoque.Produto__c)) {
                estoque.addError('Um estoque relacionado a esse produto já existe');
            }
        }
    }
}