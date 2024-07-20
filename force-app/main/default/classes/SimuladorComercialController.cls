public class SimuladorComercialController {
	
	private Id oppId;
	public Simulador_Comercial__c[] itemSimulador {get;set;}
	private List<Opportunity> opp;
	
	public Decimal sumCT{get;set;}
	public Decimal sumRT{get;set;}
	public Decimal sumLucro{get;set;}
	public Decimal sumSaldoFinal{get;set;}
	public Decimal sumFatPadrao{get;set;}
	public Decimal sumFatDesconto{get;set;}
	
	public SimuladorComercialController(){
		List<String> lstOppLiId = new List<String>();

		oppId = ApexPages.currentPage().getParameters().get('id');
		lstOppLiId.add(oppId);
		
		itemSimulador = SimuladorComercialDAO.getInstance().getItensByOppId(oppId);
		opp = OpportunityDAO.getListOppById(lstOppLiId);
		
		for(AggregateResult ar: SimuladorComercialDAO.getInstance().getSumCustoTotalByOppId(oppId)){
			sumCT = (Decimal) ar.get('CustoTotal');
		}
		
		for(AggregateResult ar: SimuladorComercialDAO.getInstance().getSumReceitaTotalByOppId(oppId)){
			sumRT = (Decimal) ar.get('ReceitaTotal');
		}
		
		for(AggregateResult ar: SimuladorComercialDAO.getInstance().getSumLucroByOppId(oppId)){
			sumLucro = (Decimal) ar.get('Lucro');
		}
		
		for(AggregateResult ar: SimuladorComercialDAO.getInstance().getSumSaldoTotalByOppId(oppId)){
			sumSaldoFinal = (Decimal) ar.get('SaldoTotal');
		}
		
		for(AggregateResult ar: SimuladorComercialDAO.getInstance().getSumFatPadraoByOppId(oppId)){
			sumFatPadrao = (Decimal) ar.get('FatPadrao');
		}
		
		for(AggregateResult ar: SimuladorComercialDAO.getInstance().getSumFatDescontoByOppId(oppId)){
			sumFatDesconto = (Decimal) ar.get('FatDesconto');
		}
	}
	
	public Boolean getExibeAjusteNEG(){
		if(sumSaldoFinal < 0){
			return true;
		}else{
			return false;
		}
	}
	
	public Boolean getExibeAjustePOS(){
		if(sumSaldoFinal >= 0){
			return true;
		}else{
			return false;
		}
	}
	
	public Boolean getBloqueiaBotao(){
		Boolean bloqueia = false;
		
		for(Opportunity lstOpp : opp){
			bloqueia = lstOpp.BR_Imprimir_Proposta_Comercial_K12__c;
		}
		
		return bloqueia;
	}
	
	public PageReference salvar(){
		update itemSimulador;
		PageReference nextPage = new PageReference('/apex/SimuladorComercial?id=' + oppId);
		nextPage.setRedirect(true);
		return nextPage;
	}
	
	public PageReference addProdutos(){
		
		return new PageReference('/apex/opportunityProductEntry?id=' + oppId); 
	}
	
	public PageReference carregarProdutos(){
		List<OpportunityLineItem> oppLI = new List<OpportunityLineItem>();
		List<Simulador_Comercial__c> forDeletion = new List<Simulador_Comercial__c>();
		List<String> lstOppId = new List<String>();
		
		Integer contador = 0;
		Boolean deletar = true;
		
		lstOppId.add(oppId);
		oppLI = OpportunityLineItemDAO.getListOliByIdsOpp(lstOppId);
		
		for(OpportunityLineItem lstOppLI : oppLI){
			
			contador = SimuladorComercialDAO.getInstance().getCountByOppPrdId(lstOppLI.OpportunityId, lstOppLI.PricebookEntry.Product2Id);
			
			if (contador == 0){
				itemSimulador.add(new Simulador_Comercial__c(Oportunidade__c = lstOppLI.OpportunityId, Produto__c = lstOppLI.PricebookEntry.Product2Id, Alunos__c = lstOppLI.Quantity, Segmento__c = lstOppLI.PricebookEntry.Product2.BR_segmento__c, Serie__c = lstOppLI.PricebookEntry.Product2.BR_serie__c,Tabela_Pearson__c = lstOppLI.UnitPrice));	
			}
		}
		upsert itemSimulador;
		
		for(Simulador_Comercial__c sc : itemSimulador){
			for(OpportunityLineItem lstOppLI : oppLI){
				if(sc.Produto__c == lstOppLI.PricebookEntry.Product2Id){
					sc.Alunos__c = lstOppLI.Quantity;
					deletar = false;
				}
			}
			
			if(deletar){
				forDeletion.add(sc);
			}
			deletar = true;
		}
		update itemSimulador;
		delete forDeletion;
		
		PageReference nextPage = new PageReference('/apex/SimuladorComercial?id=' + oppId);
		nextPage.setRedirect(true);
		return nextPage;
	}
	
	public PageReference fechar(){
		return new PageReference('/' + oppId);
	}
}