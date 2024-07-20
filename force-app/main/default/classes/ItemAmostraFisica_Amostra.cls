public class ItemAmostraFisica_Amostra {

    public static void validarIntegracaoAmostra(List<ItemAmostraFisica__c> itens) {
        Set<Id> amostrasIds = new Set<Id>();
        
        for(ItemAmostraFisica__c item : itens) {
            amostrasIds.add(item.AmostraFisica__c);
        }
        
        Map<Id, AmostraFisica__c> mapAmostras = new Map<Id, AmostraFisica__c>([SELECT Id, Status__c FROM AmostraFisica__c WHERE Id IN: amostrasIds]);
        
        for(ItemAmostraFisica__c item : itens) {
            if(mapAmostras.get(item.AmostraFisica__c).Status__c == 'Integrada')
                item.addError('Amostra física integrada. Não poderá ser realizada alterações.');
        }
    }
}