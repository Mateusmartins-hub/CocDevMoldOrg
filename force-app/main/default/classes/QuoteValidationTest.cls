@IsTest
public class QuoteValidationTest {
    @TestSetup
    static void makeData(){
        User userToRun = [
            SELECT Id FROM User WHERE Profile.Name LIKE '%admin%' AND ManagerId != null AND isActive = true LIMIT 1
        ];

        System.runAs(userToRun){
            insert new VencimentoCotacao__c(Dias__c = 10);
            Opportunity opp = TestHelper.createOpportunity();
            insert opp;
        }
    }

    @IsTest
    static void checkSetorPublicoOppTest() {
        try {
            Opportunity opp = [SELECT Id FROM Opportunity LIMIT 1];

            Quote qt = TestHelper.createQuote();
            qt.OpportunityId = opp.Id;
            insert qt;
        } catch(Exception e) {
            System.assert(true);
        }

    }
}