trigger criarContasAutomaticoTrigger on SolicitacaoCadastroCliente__c (before insert, 
	before update, 
	before delete, 
	after insert, 
	after update, 
	after delete, 
	after undelete){
	if (Trigger.isBefore)
            if (Trigger.isUpdate)
                criarContasAutomaticoHandler.getInstance().beforeUpdate();
            else if (Trigger.isInsert)
                criarContasAutomaticoHandler.getInstance().beforeInsert();
            else
                criarContasAutomaticoHandler.getInstance().beforeDelete();
        else
            if (Trigger.isUpdate)
                criarContasAutomaticoHandler.getInstance().afterUpdate();
            else if (Trigger.isInsert)
                criarContasAutomaticoHandler.getInstance().afterInsert();
            else
                criarContasAutomaticoHandler.getInstance().afterDelete();
}