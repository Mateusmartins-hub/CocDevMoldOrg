public class EstoqueTriggerHandler extends TriggerHandler{
    public override void  beforeInsert() {
        EstoqueValidation.validateDuplicate((List<EstoqueProdutos__c>) Trigger.new);
    }
}