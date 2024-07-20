@isTest
private class CreateTaskFinancialAnalysisTest {
    
    static testMethod void myUnitTest() {
        
        Opportunity opp = TestHelper.createOpportunityExpansaoEscolas(); 
        CreateTaskFinancialAnalysis.createTask(opp.id);
        
    }
}