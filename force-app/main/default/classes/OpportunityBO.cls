public with sharing class OpportunityBO {
    
    private static final OpportunityBO instance = new OpportunityBO();
    public OpportunityBO(){}
    
    public static Boolean isProcessedByTrigger = false;
    
    public static OpportunityBO getInstance(){
        return instance;
    }   
    
    public void validateDeleteOpp(List<Opportunity> lstOpp){
        RecordType rt = [select Id, Name from RecordType where Name = 'Jornada dom'];
        for(Opportunity Opp : lstOpp){
        	if(Opp.Stagename != 'Elaboração' && Opp.Stagename != 'Interesse Inicial' 
               && Opp.Stagename != 'Visita Inicial' && Opp.Stagename != 'Interesse Inicial - Franquias'){
            	if(Opp.RecordTypeid != rt.id){
        			Opp.Stagename.addError('Não é possível excluir uma oportunidade que não esteja com a fase igual ELABORAÇÃO, INTERESSE INICIAL, VISITA INICIAL OU INTERESSE INICIAL - FRANQUIAS');    
                   }
               }
        }
    }
    
    public Opportunity getOpportunityById(String idOpp){
        return OpportunityDAO.getListOppById(new List<String>{idOpp})[0];
    }
    
    public void setDadosEmailToOpportunity(List<String> lstOpportunityId){
        if(OpportunityBO.isProcessedByTrigger) return;
        
        Map<String, String> mapDadosOppDadosEmail = new Map<String, String>();
        for(OpportunityLineItem oppLineItemCheck : OpportunityLineItemDAO.getListOliByIdsOpp(lstOpportunityId)){
            String dadosTabela = mapDadosOppDadosEmail.get(oppLineItemCheck.OpportunityId);
            if(dadosTabela == null){
                dadosTabela = '<table>';
                dadosTabela += '<tr>';
                dadosTabela += '<td><b>Produto ERP </b></td>';
                dadosTabela += '<td><b>Livro </b></td>';
                dadosTabela += '<td><b>Quantidade </b></td>';
                dadosTabela += '</tr>';
            }
            dadosTabela += '<tr>';
            dadosTabela += '<td>' + oppLineItemCheck.PricebookEntry.Product2.BR_ISBN__c + ' | </td>';
            dadosTabela += '<td>' + oppLineItemCheck.PricebookEntry.Product2.Name + ' | </td>';
            dadosTabela += '<td>' + oppLineItemCheck.Quantity + '</td>';
            dadosTabela += '</tr>';
            mapDadosOppDadosEmail.put(oppLineItemCheck.OpportunityId, dadosTabela);
        }
        
        List<Opportunity> lstOppToUpdate = new List<Opportunity>();
        for(String oppId : mapDadosOppDadosEmail.keySet()){
            String dadosTabela = (mapDadosOppDadosEmail.containsKey(oppId) ? mapDadosOppDadosEmail.get(oppId) + '</table>' : '');
            Opportunity oppToUpdate = new Opportunity(Id = oppId);
            oppToUpdate.BR_ProdutosEnvioEmail__c = dadosTabela;
            lstOppToUpdate.add(oppToUpdate);
        }
        
        update lstOppToUpdate;
        OpportunityBO.isProcessedByTrigger = true;
    }
    
    public void integrarDistribuicaoOrdemVendaSAP(List<SObject> listaOpp, Map<Id, SObject> mapOppsAnteriores)
    {
        Opportunity oppAnterior = null;
        Set<Id> idOportunidade = new Set<Id>();
        
        for(Opportunity item : (List<Opportunity>)listaOpp)
        {
            oppAnterior = (Opportunity)mapOppsAnteriores.get(item.Id);
            if(item.StageName == 'Amostra Autorizada' && oppAnterior.StageName != 'Amostra Autorizada')
            {
                idOportunidade.add(item.Id);
            }
        }
        
        if(!idOportunidade.isEmpty())
        {
            integrarDistribuicao(idOportunidade);
        }
    }
    
    @future(callout = true)
    private static void integrarDistribuicao(Set<Id> idOportunidade)
    {
        List<Opportunity> listaOportunidade = OpportunityDAO.BuscarOportunidades(idOportunidade);
        if(!listaOportunidade.isEmpty())
        {
            OpportunityBO.getInstance().integrarDistribuicaoOrdemVenda(listaOportunidade);
        }
    }
    
    public void integrarDistribuicao(List<BR_DistribuicaoGratuita__c> listaDistribuicao)
    {
        if(!listaDistribuicao.isEmpty())
        {
            OpportunityBO.getInstance().integrarDistribuicaoOrdemVenda(listaDistribuicao);
        }
    }
    
    public void integrarDistribuicaoOrdemVenda(List<Opportunity> listaOpp)
    {
        for(Opportunity opp : listaOpp)
        {
            List<BR_DistribuicaoGratuita__c> listaDistribuicao = new List<BR_DistribuicaoGratuita__c>();
            listaDistribuicao = DistribuicaoGratuitaDAO.getInstance().obterDistribuicaoGratuitaPorIdOportunidade(opp.Id);
            
            if(!listaDistribuicao.isEmpty())
            {
                integrarDistribuicaoOrdemVenda(listaDistribuicao);
            }
        }
    }
    
    public void integrarDistribuicaoOrdemVenda(List<BR_DistribuicaoGratuita__c> listaDistribuicao)
    {
        IntegracaoDistribOrdemVendaInterface integracao = (IntegracaoDistribOrdemVendaInterface)IntegracaoFactory.getConfPersonalizada('IntegracaoDistribuicaoOrdemVenda');
        
        List<BR_DistribuicaoGratuita__c> listaDistribuicaoSucesso = new List<BR_DistribuicaoGratuita__c>();
        List<BR_DistribuicaoGratuita__c> listaDistribuicaoErro = new List<BR_DistribuicaoGratuita__c>();
        
        if(!listaDistribuicao.isEmpty()){
            for(BR_DistribuicaoGratuita__c item: listaDistribuicao){
                IntegracaoDistribuicaoOrdemVendaTO ordemVendaTO = new IntegracaoDistribuicaoOrdemVendaTO(item);
                IntegracaoDistribOrdemVendaRetornoTO retorno = integracao.criar(ordemVendaTO);
                
                if(retorno.status.contains('OK')){
                    item.BR_IntegradoSucesso__c = true;
                    item.BR_Integrar__c = false;
                    item.BR_LogSistema__c = retorno.data.Exports.MENSAGEM;
                    item.BR_Transportadora__c = retorno.data.Exports.TRANSPORTADORA;
                    item.BR_NOrdemVenda__c = retorno.data.Exports.VBELN;
                    listaDistribuicaoSucesso.add(item);
                }
                else if(retorno.status.contains('ERRO') || retorno.status.contains('ERRO_INTEGRACAO')){
                    item.BR_IntegradoSucesso__c = false;
                    item.BR_Integrar__c = true;
                    item.BR_LogSistema__c = 'Erro na Integração';
                    item.BR_ErroIntegracao__c = true;
                    listaDistribuicaoErro.add(item);
                }
            }
        }
        
        if(!listaDistribuicaoSucesso.isEmpty()){
            update listaDistribuicaoSucesso;
        }
        
        if(!listaDistribuicaoErro.isEmpty()){
            update listaDistribuicaoErro;
        }
    }
}