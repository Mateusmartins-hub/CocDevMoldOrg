trigger TrgGrupoSolucionador on GrupoSolucionador__c (before insert, before update, after insert, after update) {
    new GrupoSolucionadorTriggerHandler().run();
}