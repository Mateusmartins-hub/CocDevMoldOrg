public class ProcessoTriggerHandler extends TriggerHandler{
    public override void beforeUpdate() {
        ProcessoStagesCheck.nurseryStagesCheck((List<Processo__c>) Trigger.new);
    }

    public override void beforeInsert() {
        ProcessoStagesCheck.nurseryStagesCheck((List<Processo__c>) Trigger.new);
    }
}