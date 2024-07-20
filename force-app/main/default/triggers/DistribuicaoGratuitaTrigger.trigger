trigger DistribuicaoGratuitaTrigger on BR_DistribuicaoGratuita__c(after update, before insert, before update) {
	new DistribuicaoGratuitaTriggerHandler().run();
}