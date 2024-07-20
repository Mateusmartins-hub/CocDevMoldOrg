trigger LayoutCasoTrigger on LayoutCaso__c (before insert, before update, before delete) {
	new LayoutCasoTriggerHandler().run();
}