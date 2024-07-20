public class SaldoParaAmostrasTriggerHandler extends TriggerHandler {
    
    public override void beforeInsert() {
        SaldoAmostra_Funcionario.validarHierarquiaUsuario((List<SaldoParaAmostras__c>)Trigger.new);
        SaldoAmostra_Funcionario.validarRegistroExitente((List<SaldoParaAmostras__c>)Trigger.new);
        SaldoAmostra_Saldo.validarSaldoUsuarioEAtualizarSaldoRestante((List<SaldoParaAmostras__c>)Trigger.new, (Map<Id, SaldoParaAmostras__c>)Trigger.oldMap);
    	SaldoAmostra_Funcionario.atualizarProprietario((List<SaldoParaAmostras__c>)Trigger.new);
        
        for(SaldoParaAmostras__c s : (List<SaldoParaAmostras__c>)Trigger.new) {
            s.AtualizandoPelaTrigger__c = false;
        }
    }
    
    public override void afterInsert() {
    	SaldoAmostra_Funcionario.compartilharManager((List<SaldoParaAmostras__c>)Trigger.new);
    }
    
    public override void beforeUpdate() {
        SaldoAmostra_Funcionario.validarHierarquiaUsuario((List<SaldoParaAmostras__c>)Trigger.new);
        SaldoAmostra_Funcionario.validarRegistroExitente((List<SaldoParaAmostras__c>)Trigger.new);
        SaldoAmostra_Saldo.validarSaldoUsuarioEAtualizarSaldoRestante((List<SaldoParaAmostras__c>)Trigger.new, (Map<Id, SaldoParaAmostras__c>)Trigger.oldMap);
    	SaldoAmostra_Funcionario.atualizarProprietario((List<SaldoParaAmostras__c>)Trigger.new);
    	
        for(SaldoParaAmostras__c s : (List<SaldoParaAmostras__c>)Trigger.new) {
            s.AtualizandoPelaTrigger__c = false;
        }
    }
    
    public override void afterUpdate() {
    	SaldoAmostra_Funcionario.compartilharManager((List<SaldoParaAmostras__c>)Trigger.new);
    }
    
    public override void beforeDelete() {
        SaldoAmostra_Saldo.retornarSaldo((List<SaldoParaAmostras__c>)Trigger.old);
    }
}