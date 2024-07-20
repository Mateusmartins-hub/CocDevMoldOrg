public with sharing class AreaVendaDAO {

	private static final AreaVendaDAO instance = new AreaVendaDAO();

	private AreaVendaDAO(){}

	public static AreaVendaDAO getInstance(){
		return instance;
	}

	public List<BR_AreaVenda__c> obterListaAreaVendaPorId(String idAreaVenda)
	{
		return [SELECT Id, Name, BR_CanalDistribuicao__c, BR_CodigoCanalDistribuicao__c, BR_CodigoOrganizacaoVenda__c,
					BR_CodigoSetorAtividade__c, BR_Conta__c, BR_OrganizacaoVenda__c, BR_SetorAtividade__c, OwnerId
				FROM BR_AreaVenda__c
				WHERE Id =: idAreaVenda];
	}

	public List<BR_AreaVenda__c> obterListaAreaVendaPorConta(String idConta)
		{
			return [SELECT Id, Name, BR_CodigoCanalDistribuicao__c, BR_CanalDistribuicao__c,
							BR_CodigoOrganizacaoVenda__c, BR_OrganizacaoVenda__c,
							BR_SetorAtividade__c, BR_CodigoSetorAtividade__c, BR_Conta__c, BR_Centro__c
					FROM BR_AreaVenda__c
					WHERE BR_Conta__c =: idConta];
		}
}