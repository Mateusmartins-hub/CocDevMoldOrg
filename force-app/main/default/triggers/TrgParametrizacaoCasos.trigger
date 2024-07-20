trigger TrgParametrizacaoCasos on ParametrizacaoCasos__c (before insert, before update, after insert, after update) {
    new ParametrizacaoCasosTriggerHandler().run();
}