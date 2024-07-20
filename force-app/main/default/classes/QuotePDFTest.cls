@IsTest
public class QuotePDFTest {
    @IsTest
    static void sendQuoteEmailTest() {
        User userToRun = [
            SELECT Id FROM User WHERE Profile.Name LIKE '%admin%' AND ManagerId != null AND isActive = true LIMIT 1
        ];

        System.runAs(userToRun){
            insert new VencimentoCotacao__c(Dias__c = 10);

            Account_Contact__c ctc = TestHelper.createAccountContact();        
            ctc.Email__c = 'test@email.com';
            insert ctc;

            Opportunity opp = TestHelper.createOpportunity();
            opp.AccountId = ctc.Account__c;
            insert opp;

            Quote qt = TestHelper.createQuote();
            qt.OpportunityId = opp.Id;
            insert qt;

            List<String> qtIds = new List<String>();
            qtIds.add(qt.Id);

            Test.startTest();
            QuotePDF.sendQuoteToContact(qtIds);
            Test.stopTest();
        }
    }

    @IsTest
    static void getQuotePDFTest() {
        Blob qtPDF = QuotePDF.getQuotePDF;
    } 

    @IsTest
    static void getPDFURL() {

        User userToRun = [
            SELECT Id FROM User WHERE Profile.Name LIKE '%admin%' AND ManagerId != null AND isActive = true LIMIT 1
        ];

        System.runAs(userToRun){
            insert new VencimentoCotacao__c(Dias__c = 10);

            Account_Contact__c ctc = TestHelper.createAccountContact();        
            ctc.Email__c = 'test@email.com';
            insert ctc;

            Opportunity opp = TestHelper.createOpportunity();
            opp.AccountId = ctc.Account__c;
            insert opp;

            Quote qt = TestHelper.createQuote();
            qt.OpportunityId = opp.Id;
            insert qt;

            String qtPDF = QuotePDF.getPDFURL(qt.Id);
        }
    }
}