trigger ContarVisitas on BR_Procedimento_Visita__c (before insert, 
	before update, 
	before delete, 
	after insert, 
	after update, 
	after delete, 
	after undelete){
	if (Trigger.isBefore)
            if (Trigger.isUpdate)
                ContarVisitasHandler.getInstance().beforeUpdate();
            else if (Trigger.isInsert)
                ContarVisitasHandler.getInstance().beforeInsert();
            else
                ContarVisitasHandler.getInstance().beforeDelete();
        else
            if (Trigger.isUpdate)
                ContarVisitasHandler.getInstance().afterUpdate();
            else if (Trigger.isInsert)
                ContarVisitasHandler.getInstance().afterInsert();
            else
                ContarVisitasHandler.getInstance().afterDelete();
}