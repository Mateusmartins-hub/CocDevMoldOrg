public without sharing class AdocaoOut {
    
    public static List< OpportunityLineItem > getListOliByIdsOpp( set< String > aListIdsOpp ){
        system.debug('aListIdsOpp ' + aListIdsOpp);
               return [ SELECT Id, OpportunityId, Opportunity.AccountId, BR_AtendimentoInternoUniversitario__c, Opportunity.BR_Contact__c, BR_Curso__c, BR_Disciplina__c, PricebookEntry.Product2Id,
						   Opportunity.BR_Ano__c,BR_Ano__c, BR_PeriodoCurso__c, Opportunity.BR_PrevisaoCompra__c,BR_CanalVenda__c,Opportunity.Semestre__c,BR_Semestre__c, N_Alunos__c, BR_TotalAlunosInstituicao__c, BR_StatusProduto__c, BR_Segmento__c, Quantity,Opportunity.BR_Distribuidor__c
           FROM OpportunityLineItem WHERE OpportunityId IN: aListIdsOpp ];
    }
    
    public static Boolean atualiza( List<Adocoes_Cs__c> ladocao, Set<String> setOppsParaCriarAdocaoPearson){
        Boolean hasError = false;
        
        List<Database.SaveResult> svResNovasAdocoesPearson = new List<Database.SaveResult>();
        
        try{
            
            svResNovasAdocoesPearson =  Database.insert(ladocao, false);
            
             System.debug('>> svResNovasAdocoesPearson: ' + svResNovasAdocoesPearson);
            
            for(Database.SaveResult svResultCreateAdocaoPearson : svResNovasAdocoesPearson){
                System.debug('>> svResultCreateAdocaoPearson: ' + svResultCreateAdocaoPearson);
                if(!svResultCreateAdocaoPearson.isSuccess()){
                    for(Database.Error errorSaveResult : svResultCreateAdocaoPearson.getErrors()){ for(String idOpp : setOppsParaCriarAdocaoPearson){       LogErroProcessamentoService.getInstance().registrarNovaInstanciaLogErroParaOportunidadeAdocao(idOpp, 'Erro ao criar Adoção da oportunidade Status Adotado.', errorSaveResult.getMessage());
                        }
                    }
                    hasError = true;
                }
            }
        } catch(Exception ex){
            system.debug('JK olha o erro aqui ' + ex.getMessage());
        }
        return hasError;
    }
    
    public static Boolean exclui( List<Adocoes_Cs__c> lstOppsToDelete){
        
        List<Database.DeleteResult> lstDeleteRes = Database.delete(lstOppsToDelete, false);
        Boolean hasError = false;
        for(Database.DeleteResult delResult : lstDeleteRes){
            //System.debug('>> delResult: ' + delResult);
            if(!delResult.isSuccess()){   for(Database.Error errorDelete : delResult.getErrors()){ LogErroProcessamentoService.getInstance().registrarNovaInstanciaLogErroParaOportunidadeAdocao(delResult.getId(), 'Erro ao excluir Adoção da oportunidade.', errorDelete.getMessage());
                }
                hasError = true;
            }
        }
        return hasError;
    }
    
    public static void atualizaDistribuicao(Id oppId){
        
        list<BR_DistribuicaoGratuita__c>  lDistGrat = [SELECT Id, BR_RespondeuAdocao__c, BR_DetalheEnvio__c FROM BR_DistribuicaoGratuita__c  WHERE BR_Oportunidade__c =: oppId]; //DistribuicaoGratuitaDAO.getInstance().listaDistruibuicaoPorOpp(this.opp.Id);
        for(BR_DistribuicaoGratuita__c  distribuicaoGratuita : lDistGrat){        distribuicaoGratuita.BR_RespondeuAdocao__c = true;        distribuicaoGratuita.BR_DetalheEnvio__c = '5';
        }
        
        if(!lDistGrat.IsEmpty()){
            update lDistGrat;
        } 
        
    }   
    
}