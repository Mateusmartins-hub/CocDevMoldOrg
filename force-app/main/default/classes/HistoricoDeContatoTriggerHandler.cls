public with sharing class HistoricoDeContatoTriggerHandler extends TriggerHandler {

     public override void beforeInsert() {
         HistoricoDeContatoLigacaoRealizada.popularLigacaoRealizada((List<HistoricoDeContato__c>)Trigger.new);
    }

}