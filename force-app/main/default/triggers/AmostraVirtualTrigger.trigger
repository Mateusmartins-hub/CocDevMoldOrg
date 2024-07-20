trigger AmostraVirtualTrigger on Amostra_Virtual__c (after delete, after insert, after undelete, 
after update, before delete, before insert, before update) {

	if(Trigger.isBefore){
		if(Trigger.isInsert){
			SYstem.Debug(trigger.new);
			AmostraVirtualBO.getInstance().gerarLink(Trigger.new);
		}
		
		if(Trigger.isUpdate){
			AmostraVirtualBO.getInstance().gerarLink(Trigger.new);
		}
	}
	
}