public class ItemAmostraFisicaTriggerHandler extends TriggerHandler {

    public override void beforeInsert() {
        ItemAmostraFisica_Amostra.validarIntegracaoAmostra((List<ItemAmostraFisica__c>)Trigger.new);
        ItemAmostraFisica_Produto.validarEAtualizarValorUnitario((List<ItemAmostraFisica__c>)Trigger.new);
        ItemAmostraFisica_SaldoAmostra.validarEAtualizarSaldo((List<ItemAmostraFisica__c>)Trigger.new);
 //       ProductsStockUpdate.updateProductStockQuantityAmostra((List<ItemAmostraFisica__c>) Trigger.new);
    }

    public override void beforeUpdate() {
        ItemAmostraFisica_Amostra.validarIntegracaoAmostra((List<ItemAmostraFisica__c>)Trigger.new);
        ItemAmostraFisica_Produto.validarEAtualizarValorUnitario((List<ItemAmostraFisica__c>)Trigger.new);
        ItemAmostraFisica_SaldoAmostra.validarEAtualizarSaldo((List<ItemAmostraFisica__c>)Trigger.new, (Map<Id, ItemAmostraFisica__c>)Trigger.oldMap);
    }

    public override void beforeDelete() {
        ItemAmostraFisica_Amostra.validarIntegracaoAmostra((List<ItemAmostraFisica__c>)Trigger.old);
        ItemAmostraFisica_SaldoAmostra.retornarSaldo((List<ItemAmostraFisica__c>)Trigger.old);
    }
}