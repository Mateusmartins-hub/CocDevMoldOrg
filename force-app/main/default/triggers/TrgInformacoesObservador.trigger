trigger TrgInformacoesObservador on InformacoesObservador__c (before insert, after insert, before update, after update, before delete) {
    new InformacoesObservadorTriggerHandler().run();
}