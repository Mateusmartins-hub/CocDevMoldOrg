@IsTest
public with sharing class ContractDAOTest {

    @IsTest
    static void getContractsRelatedToOpportunitiesTest() {     
        
        User userToRun = [
    		SELECT Id FROM User WHERE Profile.Name LIKE '%admin%' AND ManagerId != null AND isActive = true LIMIT 1
		];

		System.runAs(userToRun){
                        
            Contract ct = TestHelper.createContract();                
            insert ct;
        
            Set<Id> oppId = new Set<Id>();
            oppId.add(ct.BR_Oportunidade_do_contrato__c); 

            List<Contract> relatedContracts = ContractDAO.getContractsRelatedToOpportunities(oppId);

            Contract relatedContract = relatedContracts.get(0);

            System.assertEquals(ct.BR_Oportunidade_do_contrato__c, relatedContract.BR_Oportunidade_do_contrato__c);
        }
    }
}