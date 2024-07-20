public class EmailMessageTriggerHandler extends TriggerHandler { 
    
    public override void beforeInsert() {
        EmailMessageBO.validarCasoFechado((List<EmailMessage>)Trigger.new);
    }
    
    public override void afterInsert() {
        EmailMessageBO.popularCamposCaso((List<EmailMessage>)Trigger.new); 
        EmailMessageBO.validarCasoAguardandoCliente((List<EmailMessage>)Trigger.new); 
    }
    
}