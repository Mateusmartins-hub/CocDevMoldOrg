public without sharing class AprovacaoCotacaoController {
    public String ObjectId {get;set;}
    public String AprovacaoResposta {get;set;}

    private class CotacaoException extends Exception {}

    public AprovacaoCotacaoController () {
        ObjectId = ApexPages.currentPage().getParameters().get('ObjectId');
        AprovacaoResposta = ApexPages.currentPage().getParameters().get('AprovacaoResposta');
    }

    public void InitPage() {
        if (ObjectId != null){
            if (AprovacaoResposta == 'aceitar')
                this.aprovarCotacao();
            else if (AprovacaoResposta == 'recusar')
                this.recusarCotacao();
            else
                throw new CotacaoException('Parâmetro inválido');
        } else
            throw new CotacaoException('Parâmetro inválido');
    }

    public void aprovarCotacao(){
        Quote qt = QuoteDAO.getQuoteById(ObjectId);
        qt.Status = 'Aprovado cliente';
        update qt;

        Opportunity opp = OpportunityDAO.buscaOportunidade(qt.OpportunityId);
        opp.CotacaoGerada__c = true;
        opp.AmostraFisicaEnviada__c = true;
        opp.StageName = 'Elaborando Contrato';
        opp.SyncedQuoteId = qt.Id;
        update opp;
        
        if(opp.RecordtypeId != OpportunityStagesCheck.RECORD_TYPE_OPORTUNIDADE_FRANQUIA_SKILL_ED) {
            Case cs = new Case();
            cs.Subject = 'Novo contrato';
            cs.Tipo__c =  'Serviço COC';
            cs.Subtipo__c = 'Atendimento';
            cs.BR_Oportunidade__c = opp.Id;
            cs.GrupoSolucionador__c = 'Cadastro / Gestão de Contratos';
            cs.AccountId = opp.AccountId;
            insert cs;
        }
    }

    public void recusarCotacao() {
        Quote qt = QuoteDAO.getQuoteById(ObjectId);
        qt.Status = 'Rejeitada';

        update qt;
    }
}