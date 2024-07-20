public class DistribuicaoGratuitaTriggerHandler extends TriggerHandler {
    public override void afterUpdate() {
        DistribuicaoGratuitaBO.getInstance().integrarDistribuicaoOrdemVendaSAP((List<SObject>) Trigger.new, (Map<Id, SObject>) Trigger.oldMap);
        DistribuicaoGratuitaStageUpdate.updateAmostraStage((List<BR_DistribuicaoGratuita__c>) Trigger.new, (List<BR_DistribuicaoGratuita__c>) Trigger.old);
    }

    public override void beforeInsert() {
        DistribuicaoGratuitaUpdate.updateDistribuicaoURL((List<BR_DistribuicaoGratuita__c>) Trigger.new);
    }

    public override void beforeUpdate() {
        DistribuicaoGratuitaUpdate.updateDistribuicaoURL((List<BR_DistribuicaoGratuita__c>) Trigger.new);
    }
}