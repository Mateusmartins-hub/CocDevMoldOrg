@IsTest
public with sharing class ProcessInstanceDAOTest {    
    @IsTest
    static void getApprovedProcessByOppIdTest() {
        User userToRun = [
            SELECT Id FROM User WHERE Profile.Name LIKE '%admin%' AND ManagerId != null AND isActive = true LIMIT 1
        ];

        System.runAs(userToRun){
            Opportunity opp = TestHelper.createOpportunity();
            insert opp;    
            Set<Id> oppIds = new Set<Id>();
            oppIds.add(opp.Id);
            List<ProcessInstance> process = ProcessInstanceDAO.getApprovedProcessById(oppIds);
            System.assertEquals(0, process.size());
        }
    }
}