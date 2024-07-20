trigger OpportunityLineItemTrigger on OpportunityLineItem (after insert, after update, before insert, before update, after delete) {
    new OpportunityLineItemTriggerHandler().run();                                    
}