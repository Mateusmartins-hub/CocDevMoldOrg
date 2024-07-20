public class AdocoesDAO 
{
	private static AdocoesDAO instance = new AdocoesDAO();

	private AdocoesDAO(){ }

	public static AdocoesDAO getInstance()
	{
		return instance;
	}

	public List<Adocoes_Cs__c> getAdocoes(List<String> lstContactsIds, Integer ano)
	{
		return [Select 
					Id, 
					Name,
					Prof_Contato__c,
					Institui_o__c,
					Curso__c,
					Curso__r.Name,
					Disciplina__c,
					Disciplina__r.Name,
					RecordTypeId,
					RecordType.DeveloperName,
					Adocao_Concatenado__c,
					Semestre__c,
					AnoNumerico__c,
					Ano__c,
					N_mero_de_Alunos__c,
					Editora__c,
					Expectativa_de_Compra__c,
					Per_odo_do_Curso__c
				From
					Adocoes_Cs__c
				Where 
					Prof_Contato__c IN: lstContactsIds
				And	AnoNumerico__c >=: ano
				];
	}

	public List<Adocoes_Cs__c> getAdocoes(List<String> lstContactsIds)
	{
		return [Select 
					Id, 
					Name,
					Prof_Contato__c,
					Institui_o__c,
					Curso__c,
					Curso__r.Name,
					Disciplina__c,
					Disciplina__r.Name,
					RecordTypeId,
					RecordType.DeveloperName,
					Adocao_Concatenado__c,
					Semestre__c,
					AnoNumerico__c,
					Ano__c,
					N_mero_de_Alunos__c,
					Editora__c,
					Expectativa_de_Compra__c,
					Per_odo_do_Curso__c
				From
					Adocoes_Cs__c
				Where 
					Prof_Contato__c IN: lstContactsIds
				];
	}

	public List<AggregateResult> getAdocoesAgrupadasAccountContact(List<String> lstContactsIds, String instituicaoId)
	{
		return [Select 
					COUNT(Id) totalAdocao,
					Prof_Contato__c prof
				From
					Adocoes_Cs__c
				Where 
					Prof_Contato__c IN: lstContactsIds
				And Institui_o__c =: instituicaoId	
				Group By 
					Prof_Contato__c,
					Institui_o__c
				];
	}

	public List<Adocoes_Cs__c> getAdocoesByLstOpportunityId(List<String> lstOppId){
		return [SELECT Id, Name, BR_OportunidadeRelacionada__c, BR_OportunidadeRelacionada__r.OwnerId 
				  FROM Adocoes_Cs__c
				 WHERE BR_OportunidadeRelacionada__c IN: lstOppId];
	}
}