public with sharing class AlcadasAprovadorDAO {

	private static final AlcadasAprovadorDAO instance = new AlcadasAprovadorDAO();

	private AlcadasAprovadorDAO(){}

	public static AlcadasAprovadorDAO getInstance(){
		return instance;
	}

	public AlcadasAprovador__c obterAlcadaAprovadorPorId(String alcadaAprovadorId){
		AlcadasAprovador__c alcadasAprovador = new AlcadasAprovador__c();
		alcadasAprovador = [SELECT
								Id,
								Name,
								RecordTypeId,
								Aprovador__c,
								BR_Aprovador2__c,
								BR_CentroCusto__c,
								BR_ValorDe__c,
								BR_ValorAte__c,
								BR_Ativo__c,
								BR_Chave__c,
								TipoAlcada__c
							FROM AlcadasAprovador__c
							WHERE Id =: alcadaAprovadorId];
		return alcadasAprovador;
	}

	public List<AlcadasAprovador__c> obterListaAlcadaAprovadorPorCentroCusto(String centroCusto){
		List<AlcadasAprovador__c> listaAprovador = new List<AlcadasAprovador__c>();
		listaAprovador = [SELECT
								Id, Name, Aprovador__c, BR_Aprovador2__c, BR_CentroCusto__c,
								BR_ValorDe__c, BR_ValorAte__c, BR_Ativo__c, BR_Chave__c, TipoAlcada__c
						  FROM AlcadasAprovador__c
						  WHERE BR_CentroCusto__c =: centroCusto];
		return listaAprovador;
	}

	public List<AlcadasAprovador__c> buscarAlcadasPorTipoRegistro(String nomeTipoRegistro)
	{
		return [SELECT Id, Aprovador__c, Cargo__c, Marca__c, Operador__c,
				Papel__c, Valor__c, RecordType.DeveloperName, TipoAlcada__c
				FROM AlcadasAprovador__c
				WHERE RecordType.DeveloperName =: nomeTipoRegistro
		ORDER BY Valor__c ASC];
	}
}