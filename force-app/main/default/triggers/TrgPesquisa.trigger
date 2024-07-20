trigger TrgPesquisa on BR_Pesquisa__c (before insert, before update, before delete, after insert, after update, after delete, after undelete) {
    new PesquisaTriggerHandler().run();     
}