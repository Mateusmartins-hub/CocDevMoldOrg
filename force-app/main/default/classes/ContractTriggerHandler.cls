public class ContractTriggerHandler extends TriggerHandler{
    public override void beforeUpdate() {
        ContractBO.ativacaoContrato((List<Contract>)Trigger.new);
        ContractBO.validacaoContratoCF((List<Contract>)Trigger.new, (Map<Id, Contract>) Trigger.oldMap);
    }
    public override void beforeInsert() {
        ContractBO.ativacaoContrato((List<Contract>)Trigger.new);
    }
}