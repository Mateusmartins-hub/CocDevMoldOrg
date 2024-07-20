trigger QuoteTrigger on Quote (before update, after update, before insert, after insert, before delete) {
    new QuoteTriggerHandler().run();
}