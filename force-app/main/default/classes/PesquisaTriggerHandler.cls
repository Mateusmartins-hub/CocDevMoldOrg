public with sharing class PesquisaTriggerHandler extends TriggerHandler {

    public override void beforeUpdate() {
        PesquisasSegmento.validateQuantidadeAluno((List<Br_Pesquisa__c>) Trigger.new);
        PesquisasSegmento.validateAccountAndOpp((List<Br_Pesquisa__c>) Trigger.new);
    }
    public override void beforeInsert() {
        PesquisasSegmento.validateQuantidadeAluno((List<Br_Pesquisa__c>) Trigger.new);
        PesquisasSegmento.validateAccountAndOpp((List<Br_Pesquisa__c>) Trigger.new);
    }

}