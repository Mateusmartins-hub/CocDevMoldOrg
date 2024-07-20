public with sharing class LeadCadencia {
	public static void insereTarefasCadencia(List<Lead> leads) {
		// Recupera a lista de Cadências cadastradas.
        List<Cadencia__c> lstCadencia = [SELECT id, TipoCaptacao__c, TipoLead__c, HoraLimite__c, (SELECT Id, Assunto__c, DataEspecifica__c, DiaUtil__c FROM TarefasCadencia__r WHERE Ativo__c = TRUE) FROM Cadencia__c WHERE Ativo__c = TRUE];   
        
        // Realiza o processo somente se houver Cadência ativa cadastrada.
        if(lstCadencia.size() == 0)
			return;
        // Recupera os RecordTypes de Lead.
        Map<Id, RecordType> recTypeLead = new Map<Id, RecordType>([SELECT Id, Name FROM RecordType WHERE SObjectType = 'Lead']);
        
        // Recupera o Calendário.
        BusinessDays calendario = new BusinessDays('Brazil');
        
        // Recupera o tipo de Tarefa (Task) a ser cadastrado.
		Id recTypeTarefaLead = RecordTypeUtil.getInstance().getRecordTypePorNome('Task', 'Tarefa Lead').getRecordTypeId();

        // Instancia a lista de Tarefas a serem armazenadas.
		List<Task> tarefasInsert = new List<Task>();
        
        // Cria as Tarefas conforme a Cadência relativa ao Lead (é feito match pelo Tipo de Captação e pelo Tipo de Lead)
		for (Lead lead :leads) {
            for (Cadencia__c cadencia : lstCadencia){
                if(lead.Tipo_de_Captacao__c == cadencia.TipoCaptacao__c && recTypeLead.get(lead.RecordTypeId).Name == cadencia.TipoLead__c) {
                    for (TarefaCadencia__c trfCadencia : cadencia.TarefasCadencia__r) {
                    	Task tarefa = criarTarefaCadencia(lead, cadencia, trfCadencia, recTypeTarefaLead, calendario);
                        tarefasInsert.add(tarefa);
                    }
                }
            }
		}
        
        // Grava as Tarefas criadas.
		if(tarefasInsert.size() > 0)
			insert tarefasInsert;
	}

	private static Task criarTarefaCadencia(Lead lead, Cadencia__c cadencia, TarefaCadencia__c trfCadencia, Id recTypeTarefaLead, BusinessDays calendario) {
		// Instancia a Tarefa conforme a Cadência e demais parâmetros.
        Task tarefa = new Task();
		tarefa.OwnerId = lead.OwnerId;
		tarefa.WhoId = lead.Id;
		tarefa.Subject = trfCadencia.Assunto__c;
		tarefa.Priority = 'Normal';
        tarefa.Status = 'Não iniciada';
        tarefa.RecordTypeId = recTypeTarefaLead;
        
        Time tmCreatedLead = Time.newInstance(lead.CreatedDate.hour(), lead.CreatedDate.minute(), lead.CreatedDate.second(), lead.CreatedDate.millisecond());
		
        // Quando o parâmetro de tempo da Cadência for "Dia útil", a Data de vencimento da Tarefa considerará a quantidade
        // de dias úteis especificada. Caso contrário, considerará a "Data específica".
        if(trfCadencia.DiaUtil__c != NULL)
            tarefa.ActivityDate = calendario.addDays(lead.CreatedDate, trfCadencia.DiaUtil__c.intValue()).date();
        else
            tarefa.ActivityDate = trfCadencia.DataEspecifica__c;
           
        // Independente do parâmetro de tempo da Cadência (Dia útil ou Data específica), se o Lead for criado após a "Hora limite"
        // especificada na Cadência, o início da contagem de dias será somente o dia seguinte (ou seja, D+1). 
        if(tmCreatedLead > cadencia.HoraLimite__c)
        	tarefa.ActivityDate = calendario.addDays(tarefa.ActivityDate, 1).date();
        
		return tarefa;
	}
}