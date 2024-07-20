public with sharing class AmostraFisicaTipoFrete {

    public static void validarAmostra(List<AmostraFisica__c> amostrasDepois,Map<Id,AmostraFisica__c> amostrasAntes) {
        for(AmostraFisica__c aDepois : amostrasDepois) {
            AmostraFisica__c aAntes = amostrasAntes.get(aDepois.Id);
            if (aAntes.TipoFrete__c != aDepois.TipoFrete__c){
                aDepois.addError('O tipo de frete não pode ser alterado.');
            }
            
        }
    }

}