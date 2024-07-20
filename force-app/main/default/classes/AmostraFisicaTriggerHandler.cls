public class AmostraFisicaTriggerHandler extends TriggerHandler {

    public override void beforeInsert() {
        AmostraFisica_Pricebook.validarPricebook((List<AmostraFisica__c>)Trigger.new, (Map<Id, AmostraFisica__c>) Trigger.oldMap);
        AmostraFisica_Status.validarAmostraEntregue((List<AmostraFisica__c>)Trigger.new);
    }

    public override void beforeUpdate() {
        AmostraFisica_Pricebook.validarPricebook((List<AmostraFisica__c>)Trigger.new, (Map<Id, AmostraFisica__c>) Trigger.oldMap);
        //AmostraFisica_Status.validarAmostraEntregue((List<AmostraFisica__c>)Trigger.old);
        AmostraFisica_Status.blockChangesAfterIntegration((List<AmostraFisica__c>) Trigger.old, (Map<Id, AmostraFisica__c>) Trigger.newMap);
        AmostraFisicaTipoFrete.validarAmostra((List<AmostraFisica__c>)Trigger.new, (Map<Id,AmostraFisica__c>)Trigger.oldMap);

    }

    public override void beforeDelete() {
        AmostraFisica_Status.validarAmostraEntregue((List<AmostraFisica__c>)Trigger.old);

        Set<Id> ids = new Set<Id>();
        for(AmostraFisica__c i : (List<AmostraFisica__c>)Trigger.old) {
            ids.add(i.Id);
        }

        Map<Id, AmostraFisica__c> mapAmostras = new Map<Id, AmostraFisica__c>([SELECT Id, (SELECT Id, AmostraFisica__c, Quantidade__c, ValorUnitario__c, ValorTotal__c FROM ItensAmostraFisica__r) FROM AmostraFisica__c WHERE Id IN: ids]);

        for(AmostraFisica__c i : (List<AmostraFisica__c>)Trigger.old) {
            ItemAmostraFisica_SaldoAmostra.retornarSaldo(mapAmostras.get(i.Id).ItensAmostraFisica__r);
        }
    }

    public override void afterUpdate() {
        AmostraFisica_Status.enviarEmailConsultorAgendarVisita((List<AmostraFisica__c>) Trigger.new);
    }
}