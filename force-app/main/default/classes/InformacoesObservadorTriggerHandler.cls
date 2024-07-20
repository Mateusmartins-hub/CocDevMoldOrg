public class InformacoesObservadorTriggerHandler extends TriggerHandler {
    public override void afterInsert() {
        InformacoesObservadorBO.enviarEmailObservadores((List<InformacoesObservador__c>)Trigger.new);
        Set<Id> infosIds = new Set<Id>();
        
        for(InformacoesObservador__c i : (List<InformacoesObservador__c>)Trigger.new)
            infosIds.add(i.Id);
        
        InformacoesObservadorBO.compartilharCaso(infosIds); 
    }
}