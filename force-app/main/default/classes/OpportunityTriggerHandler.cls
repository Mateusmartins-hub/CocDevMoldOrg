public class OpportunityTriggerHandler extends TriggerHandler {

    public override void beforeInsert() {
        OpportunityUpdateURL.updateURLAdocao((List<Opportunity>) Trigger.new);
        OpportunityStagesCheck.setInitialStage((List<Opportunity>) Trigger.new);
        OpportunityStagesCheck.stagesCheck((List<Opportunity>) Trigger.new);
        OpportunityStagesCheck.ELTStagesCheck((List<Opportunity>) Trigger.new);
    }

    public override void afterInsert() {
 
    }

    public override void beforeUpdate() {
        OpportunityUpdateURL.updateURLAdocao((List<Opportunity>) Trigger.new);
        OpportunityStagesCheck.stagesCheck((List<Opportunity>) Trigger.new);
        OpportunityStagesCheck.ELTStagesCheck((List<Opportunity>) Trigger.new);
    }

    public override void afterUpdate() {
        List<Opportunity> lstOppUpdDiscount = new List<Opportunity>(); 
        for(Opportunity opp : (List<Opportunity>)trigger.new){
            if(opp.BR_Desconto_1_ano__c != ((Map<Id, Opportunity>) trigger.oldMap).get(opp.Id).BR_Desconto_1_ano__c){
                //OpportunityLineItemBO.getInstance().updateDiscountItem(opp.Id, opp.RecordTypeId, opp.BR_Desconto_1_ano__c);
                lstOppUpdDiscount.add(opp);
            }
        }
        
        OpportunityLineItemBO.getInstance().updateDiscountItem(lstOppUpdDiscount);
        AdocoesBO.getInstance().criarAdocoesAPartirDeOportunidade(Trigger.new, (Map<Id, Opportunity>)Trigger.oldMap);
        AdocoesBO.getInstance().atualizaOwner(Trigger.new);

        RDStationProcess.closeOpportunity((List<Opportunity>) Trigger.new);

    }

    public override void beforeDelete(){
        OpportunityBO.getInstance().validateDeleteOpp(Trigger.old); 
    }
}