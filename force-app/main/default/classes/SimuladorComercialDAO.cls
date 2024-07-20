public with sharing class SimuladorComercialDAO {
	private static SimuladorComercialDAO instance = new SimuladorComercialDAO();

	private SimuladorComercialDAO(){ }

	public static SimuladorComercialDAO getInstance()
	{
		return instance;
	}
	
	public List<Simulador_Comercial__c> getItensByOppId(Id oppId){
		
		return[SELECT 
				Oportunidade__c, 
				Produto__c, 
				Produto__r.Name,
				Segmento__c, 
				Serie__c, 
				Alunos__c, 
				Custo__c, 
				PV_Pais__c, 
				Margem__c, 
				Custo_Total__c, 
				Receita_Total__c, 
				Lucro__c, 
				PV_Pearson__c, 
				Pearson_x_Atual__c, 
				Saldo_Aluno__c, 
				Saldo_Total__c, 
				Tabela_Pearson__c,
				TKT_MED_Desconto__c,
				Faturamento_Padrao__c,
				Faturamento_Desconto__c
			  FROM Simulador_Comercial__c 
			  WHERE Oportunidade__c =: oppId];
	}

	public static List<Simulador_Comercial__c> getSimulationRelatedToOpportunities(Set<Id> oppsIds) {
		return [SELECT Oportunidade__c
		        FROM Simulador_Comercial__c
				WHERE Oportunidade__c
				IN :oppsIds];
	}
	
	public Integer getCountByOppPrdId(Id oppId, Id productId){
		return[SELECT count()
				FROM Simulador_Comercial__c
				WHERE Oportunidade__c =: oppId and Produto__c =: productId];
	}
	
	public List<AggregateResult> getSumCustoTotalByOppId(Id oppId){
		return[SELECT SUM(Custo_Total__c) CustoTotal 
				FROM Simulador_Comercial__c
				WHERE Oportunidade__c =: oppId];
	}
	
	public List<AggregateResult> getSumReceitaTotalByOppId(Id oppId){
		return[SELECT SUM(Receita_Total__c) ReceitaTotal 
				FROM Simulador_Comercial__c
				WHERE Oportunidade__c =: oppId];
	}
	
	public List<AggregateResult> getSumLucroByOppId(Id oppId){
		return[SELECT SUM(Lucro__c) Lucro 
				FROM Simulador_Comercial__c
				WHERE Oportunidade__c =: oppId];
	}
	
	public List<AggregateResult> getSumSaldoTotalByOppId(Id oppId){
		return[SELECT SUM(Saldo_Total__c) SaldoTotal 
				FROM Simulador_Comercial__c
				WHERE Oportunidade__c =: oppId];
	}
	
	public List<AggregateResult> getSumFatPadraoByOppId(Id oppId){
		return[SELECT SUM(Faturamento_Padrao__c) FatPadrao 
				FROM Simulador_Comercial__c
				WHERE Oportunidade__c =: oppId];
	}
	
	public List<AggregateResult> getSumFatDescontoByOppId(Id oppId){
		return[SELECT SUM(Faturamento_Desconto__c) FatDesconto 
				FROM Simulador_Comercial__c
				WHERE Oportunidade__c =: oppId];
	}
}