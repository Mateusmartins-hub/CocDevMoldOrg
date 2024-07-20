trigger TrgProcesso on Processo__c (before insert, after insert, before update, after update, before delete) {
    new ProcessoTriggerHandler().run();
}