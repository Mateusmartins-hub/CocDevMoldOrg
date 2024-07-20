public class QuoteDAO {
    public static Quote getQuoteById(Id id) {
        List<Quote> lstQuotes = [SELECT Id, Status, OpportunityId, AccountId FROM Quote WHERE Id = :id];

        if (lstQuotes.size() < 1)
            return null;
        else
            return lstQuotes[0];
    }

    public static List<Quote> getQuoteByIds(List<String> quoteIds) {
        return [SELECT Id, Status, OpportunityId, AccountId, OwnerId, Owner.Name, Owner.Email FROM Quote WHERE Id in :quoteIds];
    }
}