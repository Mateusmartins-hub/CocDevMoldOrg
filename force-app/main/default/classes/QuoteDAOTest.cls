@isTest
public class QuoteDAOTest {

    @isTest
    static void testOne() {

        User userToRun = [
            SELECT Id FROM User WHERE Profile.Name LIKE '%admin%' AND ManagerId != null AND isActive = true LIMIT 1
        ];

        System.runAs(userToRun){
            insert new VencimentoCotacao__c(Dias__c = 10);
            
            Quote qt = TestHelper.createQuote();
            insert qt;
            
            QuoteDAO.getQuoteById(qt.Id);
            QuoteDAO.getQuoteByIds(new List<String>{qt.Id});
        }
    }
}