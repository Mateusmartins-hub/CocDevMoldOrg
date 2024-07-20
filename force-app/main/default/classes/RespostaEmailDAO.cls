public class RespostaEmailDAO {
	private static final RespostaEmailDAO instance = new RespostaEmailDAO();
	private RespostaEmailDAO() {
	}

	public static RespostaEmailDAO getInstance(){
		return instance;
	}

	public List<RespostaEmail__c> buscaPesquisa(String idOportunidade){
		return [SELECT 	Id, 
						DataEnvioPrimeiroEmail__c,
						PesquisaAtendimento__c,
						PesquisaLivro__c
				  FROM RespostaEmail__c
				 WHERE BR_IdOportunidade__c =: idOportunidade];
	}

	public RespostaEmail__c buscaEmail(String id){
		return [SELECT 	Id, 
						Livro__c,
						BR_IdOportunidade__c,
						DataEnvioPrimeiroEmail__c,
						PesquisaAtendimento__c,
						PesquisaLivro__c
				  FROM RespostaEmail__c
				 WHERE Id =: id];
	}
    
	public List<RespostaEmail__c> buscaPesquisaLivro(String idOportunidade, String livro, String prodERP){
		return [SELECT 	Id, 
						DataEnvioPrimeiroEmail__c,
						PesquisaAtendimento__c,
						PesquisaLivro__c
				  FROM RespostaEmail__c
				 WHERE BR_IdOportunidade__c =: idOportunidade
				 and   Livro__c =: livro
				 and   BR_CodigoProdutoERP__c =: prodERP];
	}
}