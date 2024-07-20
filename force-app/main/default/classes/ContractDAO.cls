public with sharing class ContractDAO {
    public static List<Contract> getContractsRelatedToOpportunities(Set<Id> oppsIds) {
		return [SELECT BR_Oportunidade_do_contrato__c
		        FROM Contract
				WHERE BR_Oportunidade_do_contrato__c
				IN :oppsIds];
	}	
}