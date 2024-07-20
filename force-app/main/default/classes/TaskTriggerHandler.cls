public with sharing class TaskTriggerHandler extends TriggerHandler {

    public override void beforeUpdate() {
        boolean cnpjValido = LeadTask.validateCNPJ((List<Task>)Trigger.new);
        if(!cnpjValido){
            return;
        }
        LeadTask.atualizaLeadComDadosTarefa((List<Task>)Trigger.new);
    }

     public override void beforeInsert() {
        boolean cnpjValido = LeadTask.validateCNPJ((List<Task>)Trigger.new);

    }


}