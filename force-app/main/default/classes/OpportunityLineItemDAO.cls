public class OpportunityLineItemDAO {
     
    public static List<OpportunityLineItem> getListOliByIdsOpp(List<String> aListIdsOpp){
        return [SELECT Id, OpportunityId, Quantity, BR_Quota__c, PricebookEntryId, QuantityOld__c, Observacoes_produto_restrito__c,
                       PricebookEntry.Product2Id, UnitPrice, TotalPrice, Discount, Opportunity.BR_rep__c, Opportunity.RecordTypeId,
                       PricebookEntry.Product2.BR_segmento__c, PricebookEntry.Product2.BR_serie__c, PricebookEntry.Product2.Name,NomeProduto__c,
                       Opportunity.AccountId, Opportunity.BR_Contact__c, BR_Segmento__c, BR_Ano__c, BR_PeriodoCurso__c, BR_Semestre__c, N_Alunos__c, BR_CanalVenda__c,BR_ERP_Product_Code__c,
                       Opportunity.BR_Account_Contact__c, BR_AtendimentoInternoUniversitario__c, BR_Curso__c, BR_Disciplina__c, BR_TotalAlunosInstituicao__c,
                       BR_Curso__r.Name, BR_Disciplina__r.Name, Opportunity.BR_ValidaDistribuicaoGratuita__c,
                       PricebookEntry.Product2.BR_ISBN__c, PricebookEntry.Product2.BR_Titulo__c, Opportunity.BR_ContatoInstituicao__c, PricebookEntry.Product2.BR_Link__c,BR_StatusProduto__c,
                	   Opportunity.BR_Desconto_1_ano__c
           FROM OpportunityLineItem WHERE OpportunityId =: aListIdsOpp];
    }

    public static List<OpportunityLineItem> getListOliByIdsOpp(set<String> aListIdsOpp){    	
        return [SELECT Id, OpportunityId, Opportunity.AccountId, BR_AtendimentoInternoUniversitario__c, Opportunity.BR_Contact__c, BR_Curso__c, BR_Disciplina__c, PricebookEntry.Product2Id,
						BR_Ano__c, BR_PeriodoCurso__c, BR_Semestre__c, N_Alunos__c, BR_TotalAlunosInstituicao__c, BR_StatusProduto__c
           FROM OpportunityLineItem WHERE OpportunityId IN: aListIdsOpp];
    }

    public static List<OpportunityLineItem> getOpportunityLineItems(Set<String> setContasIds){   
        return [Select 
                    Id,
                    Opportunity.AccountId, 
                    Opportunity.CloseDate,
                    Opportunity.RespondeuCRC__c,
                    Opportunity.RecordType.DeveloperName,
                    Opportunity.BR_Contact__c,
                    PricebookEntry.Product2.Name,
                    PricebookEntry.Product2.BR_Author_name__c
                From
                    OpportunityLineItem
                WHERE   
                    Opportunity.AccountId IN: setContasIds
                And Opportunity.StageName = 'Pedido Gerado'
                And (Opportunity.RecordType.Name = 'Sample Order - Languages' or
                     Opportunity.RecordType.Name = 'Sample Order - University')
               ];
    }

    public static List<OpportunityLineItem> BuscaProdutos(String oppId){                  
        return [SELECT Id, OpportunityId, Quantity, TotalPrice, PriceBookEntryId, UnitPrice, BR_Curso__c, BR_Ano__c, BR_Semestre__c, BR_Disciplina__c, BR_Curso__r.Name, BR_Disciplina__r.Name, N_Alunos__c, BR_StatusProduto__c, BR_ERP_Product_Code__c,NomeProduto__c, Recorrente__c, PricebookEntry.Product2Id, PricebookEntry.Product2.Name, Opportunity.AccountId, BR_AtendimentoInternoUniversitario__c, Opportunity.BR_Contact__c, BR_PeriodoCurso__c, BR_TotalAlunosInstituicao__c        
           FROM OpportunityLineItem WHERE OpportunityId =: oppId];
    }

    public static List<OpportunityLineItem> BuscaProdutosId(list<String> lOppId){                  
        return [SELECT Id, OpportunityId, Quantity, TotalPrice, PriceBookEntryId, BR_Ano__c, BR_Semestre__c, UnitPrice, BR_Curso__c, BR_Disciplina__c, BR_Curso__r.Name, BR_Disciplina__r.Name, N_Alunos__c, BR_StatusProduto__c, BR_ERP_Product_Code__c,NomeProduto__c, Recorrente__c, PricebookEntry.Product2Id, PricebookEntry.Product2.Name, Opportunity.AccountId, BR_AtendimentoInternoUniversitario__c, Opportunity.BR_Contact__c, BR_PeriodoCurso__c, BR_TotalAlunosInstituicao__c       
           FROM OpportunityLineItem WHERE OpportunityId =: lOppId];
    }

    public static List<OpportunityLineItem> BuscaProdutosIncluir(String oppId){
        return [SELECT Id, OpportunityId, Quantity, TotalPrice, PriceBookEntryId, UnitPrice, BR_Curso__c, BR_Disciplina__c, N_Alunos__c, BR_StatusProduto__c, BR_ERP_Product_Code__c,NomeProduto__c
           FROM OpportunityLineItem WHERE OpportunityId =: oppId];
    }

    public static List<OpportunityLineItem> BuscaProdutoOportunidade(List<Id> produtoOportunidadeIds){
        return [SELECT Id, OpportunityId, Quantity, TotalPrice, PriceBookEntryId, UnitPrice, 
                	   ProductCode, Opportunity.Cod_Local_do_Estoque__c
                FROM OpportunityLineItem 
                WHERE Id IN: produtoOportunidadeIds];
    }

    public static List<OpportunityLineItem> ListaProdutosOportunidadesPorOportunidadesId(Set<Id> idsOportunidades) {
        return [SELECT Id, OpportunityId, Quantity, BR_Quota__c, PricebookEntryId, QuantityOld__c, Observacoes_produto_restrito__c,
                       PricebookEntry.Product2Id, UnitPrice, TotalPrice, Discount, Opportunity.BR_rep__c, Opportunity.RecordTypeId,
                       PricebookEntry.Product2.BR_segmento__c, PricebookEntry.Product2.BR_serie__c, PricebookEntry.Product2.Name,NomeProduto__c,
                       Opportunity.AccountId, Opportunity.BR_Contact__c, BR_Segmento__c, BR_Ano__c, BR_PeriodoCurso__c, BR_Semestre__c, N_Alunos__c, BR_CanalVenda__c,BR_ERP_Product_Code__c,
                       Opportunity.BR_Account_Contact__c, BR_AtendimentoInternoUniversitario__c, BR_Curso__c, BR_Disciplina__c, BR_TotalAlunosInstituicao__c,
                       BR_Curso__r.Name, BR_Disciplina__r.Name, Opportunity.BR_ValidaDistribuicaoGratuita__c,
                       PricebookEntry.Product2.BR_ISBN__c, PricebookEntry.Product2.BR_Titulo__c, Opportunity.BR_ContatoInstituicao__c, PricebookEntry.Product2.BR_Link__c,BR_StatusProduto__c
                FROM OpportunityLineItem 
                WHERE OpportunityId IN: idsOportunidades];
    }

    public static Map<Id, List<OpportunityLineItem>> ListaProdutosOportunidade(Set<Id> idsOportunidades) {
        Map<Id, List<OpportunityLineItem>> mapOpportunityLineItem = new Map<Id, List<OpportunityLineItem>>();
        
        List<OpportunityLineItem> prods = ListaProdutosOportunidadesPorOportunidadesId(idsOportunidades);

        for (OpportunityLineItem oli : prods) {
            if (!mapOpportunityLineItem.containsKey(oli.OpportunityId))
                mapOpportunityLineItem.put(oli.OpportunityId, new List<OpportunityLineItem>());

            mapOpportunityLineItem.get(oli.OpportunityId).add(oli);
        }

        return mapOpportunityLineItem;
    }

}