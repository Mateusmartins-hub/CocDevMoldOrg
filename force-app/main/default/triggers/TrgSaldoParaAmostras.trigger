trigger TrgSaldoParaAmostras on SaldoParaAmostras__c (before insert, after insert, before update, after update, before delete) {
    new SaldoParaAmostrasTriggerhandler().run();
}