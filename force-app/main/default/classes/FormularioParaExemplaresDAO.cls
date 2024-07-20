public with sharing class FormularioParaExemplaresDAO {    
    /*
    public static List<Formulario__c> getFormsRelatedToOpportunities(Set<Id> oppsIds) {
		return [SELECT Id, Oportunidade__c FROM Formulario__c WHERE Oportunidade__c IN :oppsIds];
	}
	*/
	public static List<Formulario__c> getFormsRelatedToLeads(Set<Id> leadIds) {
		return [SELECT Id, Lead__c, Oportunidade__c, Conta__c FROM Formulario__c WHERE Lead__c IN :leadIds];
	}
}