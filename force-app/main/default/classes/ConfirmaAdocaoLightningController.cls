public with sharing class ConfirmaAdocaoLightningController {
    @AuraEnabled
    public static void ConfirmaAdocao(string idOportunidade)
    {
        Opportunity op = new Opportunity();
        op.Id = idOportunidade;
        op.BR_ConfirmarAdocao__c = true;
        op.StageName = 'Adoção Realizada'; 

        update op;
    }

    @AuraEnabled
    public static Opportunity BuscaOportunidade(string idOportunidade)
    {
        return OpportunityDAO.buscaOportunidade(idOportunidade);
    }

    @AuraEnabled
    public static List<OpportunityLineItem> BuscaProdutos(string idOportunidade)
    {
        return OpportunityLineItemDAO.BuscaProdutos(idOportunidade);
    }
}