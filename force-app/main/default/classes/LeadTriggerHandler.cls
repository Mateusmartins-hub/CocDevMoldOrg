public class LeadTriggerHandler extends TriggerHandler {
    
    public override void beforeInsert() {
        Lead_CPFCNPJ.validateCPFCNPJ((List<Lead>)Trigger.new);
        Lead_Status.popularStatusConformeOrigem((List<Lead>)Trigger.new);
        Lead_Status.updateLeadStatus((List<Lead>)Trigger.new);        
        LeadSegmento.validateQuantidadeAluno((List<Lead>)Trigger.new);
        Lead_Momento.DefineMomento((List<Lead>)Trigger.new);
        Lead_EmailTransport.CopyEmailTransport((List<Lead>)Trigger.new);
        LeadBO.setLeadData((List<Lead>)Trigger.new);
    }
     
    public override void beforeUpdate() {
        Lead_CPFCNPJ.validateCPFCNPJ((List<Lead>)Trigger.new);
        Lead_Status.validarStatus((List<Lead>)Trigger.new, (Map<Id, Lead>)Trigger.OldMap);        
        //Lead_Sintegra.integrarSintegra((List<Lead>)Trigger.new);
        LeadConverted.shareFormToOpp((List<Lead>)Trigger.new); 
        LeadConverted.validate((List<Lead>)Trigger.new, (Map<Id, Lead>)Trigger.oldMap);
        LeadSegmento.validateQuantidadeAluno((List<Lead>)Trigger.new);
       // LeadConverted.populaQuantidadeAlunos((List<Lead>)Trigger.new, (Map<Id, Lead>)Trigger.oldMap);
        //LeadConverted.populaOportunidade((List<Lead>)Trigger.new, (Map<Id, Lead>)Trigger.oldMap);
    }
    public override void afterUpdate() {
        RDStationProcess.leadNotQualified((Map<Id, Lead>)Trigger.oldMap, (Map<Id, Lead>)Trigger.newMap);
        LeadTask.updateTasksWhenLeadIsFinished((Map<Id, Lead>)Trigger.newMap, (Map<Id, Lead>)Trigger.oldMap);
    }
    
    public override void afterInsert() {
        LeadCadencia.insereTarefasCadencia((List<Lead>)Trigger.new);
    }
}