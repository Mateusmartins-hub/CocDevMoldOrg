public class AmostraFisica_Pricebook {
    
    public static void validarPricebook(List<AmostraFisica__c> amostras, Map<Id, AmostraFisica__c> mapOldAmostras) {
        Set<Id> amostraIds = new Set<Id>();
        
        for(AmostraFisica__c a : amostras) {
            if(!String.isEmpty(a.id))
                amostraIds.add(a.Id);
        }
        
        Map<Id, List<ItemAmostraFisica__c>> mapItemsAmostras = new Map<Id, List<ItemAmostraFisica__c>>();
        
        for(ItemAmostraFisica__c i : [SELECT Id, AmostraFisica__c FROM ItemAmostraFisica__c WHERE AmostraFisica__c IN: amostraIds]) {
            if(!mapItemsAmostras.containsKey(i.AmostraFisica__c))
                mapItemsAmostras.put(i.AmostraFisica__c, new List<ItemAmostraFisica__c>());
            
            mapItemsAmostras.get(i.AmostraFisica__c).add(i);
        }
        
        Map<Id, Pricebook2> mapPricebooks = new Map<Id, Pricebook2>([SELECT Id FROM Pricebook2 WHERE AmostraFisica__c = true]);
        
        for(AmostraFisica__c a : amostras) {
            if(a.Pricebook__c != null && !mapPricebooks.containsKey(a.Pricebook__c)) {
                a.Pricebook__c.addError('Catálogo não é de amostra física, selecione um com o campo Amostra Física checado.');
            } else if(mapItemsAmostras.containsKey(a.Id) && mapItemsAmostras.get(a.Id).size() > 0 && mapOldAmostras.get(a.Id).Pricebook__c != a.Pricebook__c) {
                a.Pricebook__c.addError('Não é possível alterar o catálogo após um item ser adicionado.');
            }
        }
    }
}