public class ItemAmostraFisica_Produto {

    public static void validarEAtualizarValorUnitario(List<ItemAmostraFisica__c> itens) {
        Set<Id> produtosIds = new Set<Id>();
        for(ItemAmostraFisica__c i : itens) {
            produtosIds.add(i.Produto__c);
	        }
        
        List<PricebookEntry> prices = [SELECT Id, Product2Id, UnitPrice FROM PricebookEntry WHERE Pricebook2.AmostraFisica__c = true AND Product2Id IN: produtosIds];
        Map<Id, PricebookEntry> mapProds = new Map<Id, PricebookEntry>();
        
        for(PricebookEntry p : prices) {
            if(!mapProds.containsKey(p.Product2Id))
                mapProds.put(p.Product2Id, p);
        }
        
        for(ItemAmostraFisica__c i : itens) {
            if(i.Quantidade__c < 1){
                i.AddError('Quantidade deve ser maior ou igual a 1.'); continue;
            }
            
            if(!mapProds.containsKey(i.Produto__c)) {
                i.AddError('Este produto não existe no catálogo de preço para amostras físicas.'); continue;
            }
            PricebookEntry p = mapProds.get(i.Produto__c);            
            i.ValorUnitario__c = p.UnitPrice;
        }
    }
}