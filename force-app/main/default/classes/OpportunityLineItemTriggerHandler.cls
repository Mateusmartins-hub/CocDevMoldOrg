public class OpportunityLineItemTriggerHandler extends TriggerHandler {
    public override void beforeUpdate() {
        OpportunityLineItemBO.getInstance().updateSalesPrice((List<OpportunityLineItem>) Trigger.new);
        OpportunityLineItemBO.updateDiscountsNewOpps((List<OpportunityLineItem>) Trigger.new);
        OpportunityLineItemCheck.checkForAmostraAutorizada((List<OpportunityLineItem>) Trigger.new);
    }

    public override void beforeInsert() {
        OpportunityLineItemBO.getInstance().updateSalesPrice((List<OpportunityLineItem>) Trigger.new);
        OpportunityLineItemBO.updateDiscountsNewOpps((List<OpportunityLineItem>) Trigger.new);
        OpportunityLineItemCheck.checkForAmostraAutorizada((List<OpportunityLineItem>) Trigger.new);
    }

    public override void beforeDelete(){
        OpportunityLineItemBO.getInstance().processaDadosOportunidadeRelacionada((List<OpportunityLineItem>) Trigger.new, (Map <Id, OpportunityLineItem>) Trigger.oldMap, (Boolean) Trigger.isDelete);
    }

    public override void afterInsert() {
        OpportunityLineItemBO.getInstance().processaDadosOportunidadeRelacionada((List<OpportunityLineItem>) Trigger.new, (Map <Id, OpportunityLineItem>) Trigger.oldMap, (Boolean) Trigger.isDelete);
    }

}