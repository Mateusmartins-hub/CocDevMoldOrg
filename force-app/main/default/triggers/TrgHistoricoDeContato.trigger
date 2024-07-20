trigger TrgHistoricoDeContato on HistoricoDeContato__c (before insert, before update, before delete, after insert, after update, after delete, after undelete) {
    new HistoricoDeContatoTriggerHandler().run();
}