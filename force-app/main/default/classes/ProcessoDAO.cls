public class ProcessoDAO {
    public static List<Processo__c> getProcessosByOppsIds(Set<Id> idsOpps) {
        return [SELECT Id FROM Processo__c WHERE Oportunidade__c IN :idsOpps];
    }
}