trigger EstoqueTrigger on EstoqueProdutos__c (before insert) {
    new EstoqueTriggerHandler().run();
}