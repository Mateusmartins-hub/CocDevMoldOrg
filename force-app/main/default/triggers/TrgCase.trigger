trigger TrgCase on Case (before insert, before update, after insert, after update) {
    new CaseTriggerHandler().run();
}