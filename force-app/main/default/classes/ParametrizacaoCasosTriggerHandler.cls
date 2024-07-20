public class ParametrizacaoCasosTriggerHandler extends TriggerHandler {
	public override void beforeUpdate() {
       ParametrizacaoCasosBO.validar((List<ParametrizacaoCasos__c>)Trigger.new);
    }
    
    public override void beforeInsert() {
       ParametrizacaoCasosBO.validar((List<ParametrizacaoCasos__c>)Trigger.new);
    }
    
    public override void afterInsert() {
       ParametrizacaoCasosBO.inserirGrupoZero((List<ParametrizacaoCasos__c>)Trigger.new);
    }
}