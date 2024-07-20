trigger TrgAmostraFisica on AmostraFisica__c (before insert, after insert, before update, after update, before delete) {
    new AmostraFisicaTriggerHandler().run(); 
}