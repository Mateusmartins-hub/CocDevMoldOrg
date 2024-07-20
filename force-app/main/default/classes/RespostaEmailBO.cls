public with sharing class RespostaEmailBO {

    private static final RespostaEmailBO instance = new RespostaEmailBO();

    private RespostaEmailBO(){   
    }

    public static RespostaEmailBO getInstance(){
        return instance;
    }
  
    public String validaPesquisaLivro(String oppId, String nmProd, String prodERP, String mDistGratId){
    	List<RespostaEmail__c> lResp = RespostaEmailDAO.getInstance().buscaPesquisaLivro(oppId, nmProd, prodERP);
    	String url;
    	if(lResp.isEmpty()){
    		
    		RespostaEmail__c respLivro = new RespostaEmail__c();
    		respLivro.BR_IdDistribuicaoGratuita__c = mDistGratId;
    		respLivro.Livro__c = nmProd;
    		respLivro.BR_CodigoProdutoERP__c = prodERP;
			respLivro.BR_IdOportunidade__c = oppId;
			insert respLivro;
			url = respLivro.Id;
    	}
    	return url;
    }
    public void gravaPesquisaLivro(PesquisaSatisfacaoLivroTO pesqSatisfaca){

        RespostaEmail__c respEmail = RespostaEmailDAO.getInstance().buscaEmail(pesqSatisfaca.respEmailId);

    	respEmail.PesquisaLivro__c = true;
    	upsert respEmail;
		
		PesquisaEmail__c pesquisa = new PesquisaEmail__c();
		pesquisa.BR_NomeLivro__c = respEmail.livro__c;
		pesquisa.BR_Resposta1__c = pesqSatisfaca.AvaliaLivro;
		pesquisa.BR_Pergunta1__c = pesqSatisfaca.Pergunta1;
		pesquisa.BR_Resposta2__c = pesqSatisfaca.adotaLivro;
		pesquisa.BR_Pergunta2__c = pesqSatisfaca.Pergunta2;
		pesquisa.BR_Resposta3__c = pesqSatisfaca.salaVirtual;
		pesquisa.BR_Pergunta3__c = pesqSatisfaca.Pergunta3;
		pesquisa.BR_Resposta4__c = pesqSatisfaca.seNao;
		pesquisa.BR_Pergunta4__c = pesqSatisfaca.Pergunta4;
		pesquisa.BR_Resposta5__c = pesqSatisfaca.seSim;
	 	pesquisa.BR_Pergunta5__c = pesqSatisfaca.Pergunta5;
		pesquisa.BR_Resposta6__c = pesqSatisfaca.recomenda;
	 	pesquisa.BR_Pergunta6__c = pesqSatisfaca.Pergunta6;
		pesquisa.BR_Observacao__c = pesqSatisfaca.comentario;
	 	pesquisa.BR_Pergunta7__c = pesqSatisfaca.Pergunta7;
		pesquisa.BR_RespostaEmail__c = pesqSatisfaca.respEmailId;
		insert pesquisa;   	

    }
    public void gravaPesquisaAtendimento(PesquisaSatisfacaoTO pesqSatisfaca, String oppId){

        RespostaEmail__c respEmail = new REspostaEmail__c(); //RespostaEmailDAO.getInstance().buscaEmail(pesqSatisfaca.respEmailId);
		respEmail.BR_IdOportunidade__c = oppId;
    	respEmail.PesquisaAtendimento__c = true;
    	insert respEmail;
		
		PesquisaEmail__c pesquisa = new PesquisaEmail__c();
		pesquisa.BR_Resposta1__c = pesqSatisfaca.Resposta1;
		pesquisa.BR_Pergunta1__c = pesqSatisfaca.Pergunta1;
		
		pesquisa.BR_Resposta2__c = pesqSatisfaca.Resposta2;
		pesquisa.BR_Pergunta2__c = pesqSatisfaca.Pergunta2;

		pesquisa.BR_Resposta3__c = pesqSatisfaca.Resposta3;
		pesquisa.BR_Pergunta3__c = pesqSatisfaca.Pergunta3;

		pesquisa.BR_Resposta4__c = pesqSatisfaca.Resposta4;
		pesquisa.BR_Pergunta4__c = pesqSatisfaca.Pergunta4;

		pesquisa.BR_Resposta5__c = pesqSatisfaca.Resposta5;
		pesquisa.BR_Pergunta5__c = pesqSatisfaca.Pergunta5;

		pesquisa.BR_Resposta6__c = pesqSatisfaca.Resposta6;
		pesquisa.BR_Pergunta6__c = pesqSatisfaca.Pergunta6;

		pesquisa.BR_Resposta7__c = pesqSatisfaca.Resposta7;
		pesquisa.BR_Pergunta7__c = pesqSatisfaca.Pergunta7;

		pesquisa.BR_Resposta8__c = pesqSatisfaca.Resposta8;
		pesquisa.BR_Pergunta8__c = pesqSatisfaca.Pergunta8;

		pesquisa.BR_Resposta9__c = pesqSatisfaca.Resposta9;
		pesquisa.BR_Pergunta9__c = pesqSatisfaca.Pergunta9;

		//pesquisa.BR_Resposta10__c = pesqSatisfaca.Resposta10;
		//pesquisa.BR_Pergunta10__c = pesqSatisfaca.Pergunta10;

		pesquisa.BR_Observacao__c = pesqSatisfaca.Resposta10;
		pesquisa.BR_Pergunta10__c = pesqSatisfaca.Pergunta10;
		pesquisa.BR_RespostaEmail__c = respEmail.Id;

		insert pesquisa;    	

    }
}