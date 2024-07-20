public class GrupoSolucionadorTriggerHandler extends TriggerHandler {
	public override void beforeUpdate() {
        GrupoSolucionadorBO.preencherCampos((List<GrupoSolucionador__c>)Trigger.new);
    }
    
    public override void beforeInsert() {
        GrupoSolucionadorBO.preencherCampos((List<GrupoSolucionador__c>)Trigger.new);
    }
}