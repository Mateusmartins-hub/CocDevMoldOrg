public with sharing class EventTriggerHandler extends TriggerHandler{

    public override void beforeUpdate(){
        Event_CheckinCheckOut.AtualizarCheckOut((List<Event>) Trigger.new);
    }

    public override void beforeDelete() {
        EventCheck.checkOpportunityBeforeDelete((List<Event>) Trigger.old);
    }
}