trigger TrgItemAmostraFisica on ItemAmostraFisica__c (before insert, after insert, before update, after update, before delete) {
    new ItemAmostraFisicaTriggerHandler().run(); 
}