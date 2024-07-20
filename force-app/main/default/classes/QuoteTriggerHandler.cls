public class QuoteTriggerHandler extends TriggerHandler{
    public override void beforeUpdate() {
        QuoteFieldUpdate.updateNameField((List<Quote>) Trigger.new);      
        QuoteFieldUpdate.updateQuotesAccordingToCommercialPolicies((List<Quote>) Trigger.new);
    }

    public override void afterUpdate() {
        QuoteFieldUpdate.syncOppAfterApproval((Map<Id, Quote>) Trigger.oldMap, (List<Quote>) Trigger.new);
        if (!System.isFuture())
            QuoteFieldUpdate.updateContratoFinalizado((Map<Id, Quote>) Trigger.oldMap, (List<Quote>) Trigger.new);
        
    }

    public override void beforeInsert() {
        QuoteFieldUpdate.updateNameField((List<Quote>) Trigger.new);
        QuoteFieldUpdate.updatePrizeField((List<Quote>) Trigger.new);
        QuoteFieldUpdate.updateRecordType((List<Quote>) Trigger.new);
        QuoteValidation.checkSetorPublicoOpp((List<Quote>) Trigger.new);
        QuoteFieldUpdate.updateQuotesAccordingToCommercialPolicies((List<Quote>) Trigger.new);
    }

    public override void afterInsert() {
        QuoteFieldUpdate.updateManagerField((List<Quote>) Trigger.new);
        QuoteFieldUpdate.createProducts((List<Quote>) Trigger.new);
    }
}