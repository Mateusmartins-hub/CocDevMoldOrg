public class QuoteValidation {
    public static void checkSetorPublicoOpp(List<Quote> quotes) {
        Set<Id> oppIds = new Set<Id>();
        for (Quote quote : quotes)
            oppIds.add(quote.OpportunityId);

        Map<Id,Opportunity> opps = new Map<Id,Opportunity>(OpportunityDAO.BuscarOportunidades(oppIds));

        for (Quote quote : quotes) {
            Opportunity opp = opps.get(quote.OpportunityId);
            
            if (opp.RecordTypeId == OpportunityStagesCheck.RECORD_TYPE_OPORTUNIDADE_SETOR_PUBLICO && (opp.StageName != 'Contrato Finalizado' && opp.StageName != 'Orçamento' && opp.StageName != 'Edital publicado')) {
                quote.addError('Para criar uma cotação, a oportunidade precisa estar, no mínimo, na fase orçamento.');
            }
        }
    }
}