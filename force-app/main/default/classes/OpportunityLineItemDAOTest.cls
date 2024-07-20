@isTest 
private class OpportunityLineItemDAOTest {

    static testMethod void myUnitTest() {
        OpportunityLineItemDAO.getListOliByIdsOpp(new List<String>());
        OpportunityLineItemDAO.getListOliByIdsOpp(new Set<String>());
        OpportunityLineItemDAO.getOpportunityLineItems(new Set<String>());
        OpportunityLineItemDAO.BuscaProdutos(null);
        OpportunityLineItemDAO.BuscaProdutosId(new List<String>());
        OpportunityLineItemDAO.BuscaProdutosIncluir(null);
        OpportunityLineItemDAO.BuscaProdutoOportunidade(new List<Id>());
        OpportunityLineItemDAO.ListaProdutosOportunidadesPorOportunidadesId(new Set<Id>());
        OpportunityLineItemDAO.ListaProdutosOportunidade(new Set<Id>());
    }
}