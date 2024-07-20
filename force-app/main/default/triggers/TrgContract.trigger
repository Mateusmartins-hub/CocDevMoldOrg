trigger TrgContract on Contract (before insert, before update, after update, after insert, before delete) {
    new ContractTriggerHandler().run();
}