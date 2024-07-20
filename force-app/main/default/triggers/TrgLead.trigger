trigger TrgLead on Lead (before insert, after insert, before update, after update, before delete) {
    new LeadTriggerHandler().run(); 
}