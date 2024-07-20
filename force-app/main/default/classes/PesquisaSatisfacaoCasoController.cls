public class PesquisaSatisfacaoCasoController {
    @AuraEnabled
    public static void saveRate(String recordId, Integer rateToSave){
        Case cas = [SELECT NotaSatisfacao__c FROM Case WHERE Id = :recordId];
        cas.NotaSatisfacao__c = rateToSave;
        update cas;
    }
}