public with sharing class LeadTask {
	public LeadTask() {

	}

	public static boolean validateCNPJ(List<Task> tasks) {
		for(Task t :tasks) {
			String cnpj = t.cnpj__c;

			if(String.isNotBlank(cnpj)) {
				if(!Lead_CPFCNPJ.isCNPJ(cnpj)) {
					t.cnpj__c.addError('CNPJ Inválido.');
					return false;
				} else {
					t.cnpj__c = Lead_CPFCNPJ.printCNPJ(cnpj);
					return true;
				}
			}
		}
		return true;

	}


	public static void insereTarefa(List<Lead> leads, Map<Id, Lead> leadAntes) {
		if(leadAntes == null)
			return;

			Id RecTypePrivado = RecordTypeUtil.getInstance().getRecordTypePorNome('Lead', 'Setor Privado').getRecordTypeId();

        if(Test.isRunningTest() ){
            for (Lead lead :leads)
            Task tarefa = criarTarefa(lead);
        }
		List<Task> tarefasInsert = new List<Task>();
		for (Lead lead :leads) {
			if(leadAntes.get(lead.Id).OwnerId != lead.OwnerId) {
				if(lead.RecordTypeId == RecTypePrivado) {
					Task tarefa = criarTarefa(lead);
					tarefasInsert.add(tarefa);
				}
			}
		}
		if(tarefasInsert.size() > 0)
			insert tarefasInsert;
	}

	private static Task criarTarefa(Lead lead) {
		Task tarefa = new Task();
		tarefa.OwnerId = lead.OwnerId;
		tarefa.WhoId = lead.Id;
		tarefa.Subject = 'Leads Setor Privado';
		tarefa.Priority = 'Normal';
		tarefa.NomeDaEscola__c = lead.NomeEscola__c;
		tarefa.JaEParceiroPearson__c = lead.ParceiroPearson__c;
		tarefa.cnpj__c = lead.CNPJ__c;
		tarefa.Rua__c = lead.Street;
		tarefa.Cidade__c = lead.City;
		tarefa.Estado__c = lead.State;
		tarefa.TrabalhaComMaterialDeIngles__c = lead.TrabalhaComMaterialDeIngles__c;
		tarefa.NDeAlunos__c = lead.NDeAlunos__c;

		return tarefa;
	}

	public static void atualizaLeadComDadosTarefa(List<Task> tasks) {

		Map<Id, Lead> leadUpdate = new Map<Id, Lead>();
		for (Task task :tasks) {
			List<Lead> leads = [select Id from Lead where Id = :task.WhoId];

			for (Lead lead :leads) {
				lead.Street = task.Rua__c;
				lead.State = task.Estado__c;
				lead.NomeEscola__c = task.NomeDaEscola__c;
				lead.ParceiroPearson__c = task.JaEParceiroPearson__c;
				if(String.isNotBlank(task.cnpj__c)) {
					lead.CNPJ__c = task.cnpj__c;
					System.debug(lead.CNPJ__c);
				}
				lead.Street = task.Rua__c;
				lead.City = task.Cidade__c;
				lead.State = task.Estado__c;
				lead.TrabalhaComMaterialDeIngles__c = task.TrabalhaComMaterialDeIngles__c;
				if(!leadUpdate.containsKey(lead.Id)) {
					leadUpdate.put(lead.Id, lead);
				}
			}
		}
		if(leadUpdate.size() > 0)
			update leadUpdate.values();
	}

	public static void updateTasksWhenLeadIsFinished(Map<Id, Lead> newLeads, Map<Id, Lead> oldLeads) {
        Set<Id> finishedLeadIds = getFinishedLeads(newLeads, oldLeads);

        if(finishedLeadIds.size() > 0) {
            List<Task> tasks = [SELECT Id FROM Task WHERE WhoId IN :finishedLeadIds AND (Status = 'Não iniciada' OR Status = 'Em execução')];
            if(!tasks.isEmpty()) {
                for (Task task : tasks) {
                    task.Status = 'Cancelada';
                }
        
                update tasks;
            }
        }
    }

    private static Set<Id> getFinishedLeads(Map<Id, Lead> newLeads, Map<Id, Lead> oldLeads){
        Set<Id> finishedLeadIds = new Set<Id>();

        for (Lead lead : newLeads.values()) {
            if(lead.Status == 'Finalizado' && oldLeads.get(lead.Id).Status != 'Finalizado') {
                finishedLeadIds.add(lead.Id);
            }
        }
    
        return finishedLeadIds;
    }
}