public class LayoutCasoTriggerHandler extends TriggerHandler {
	
    public override void beforeUpdate() 
    {
        LayoutCasoBO.Validar((List<LayoutCaso__c>)Trigger.new);
    }
    
    public override void beforeInsert() 
    {
        LayoutCasoBO.Validar((List<LayoutCaso__c>)Trigger.new);
    }
    
    public override void beforeDelete() 
    {
        LayoutCasoBO.ValidarExclusao((List<LayoutCaso__c>)Trigger.old);
    }
}