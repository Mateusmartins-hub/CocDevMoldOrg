public class PesquisaSatisfacaoLivroController {

    public String AvaliaLivro {get;set;}
    public String adotaLivro  {get;set;}
    public String salaVirtual  {get;set;}
    public String seNao {get;set;}
    public String seSim {get;set;}
    public String recomenda {get;set;}
    public String mensagem {get;set;}
    public String comentario {get;set;}
    public String livro {get;set;}
    public String titulo{get;set;}
    public Boolean tela1 {get;set;}
    public Boolean tela2 {get;set;}

    private String respEmailId {get;set;}
    private String oppId {get;set;}
    public List<SelectOption> lstAvaliaLivro {get;set;}
    public List<SelectOption> lstAdotaLivro {get;set;}
    public List<SelectOption> lstSalaVirtual {get;set;}
    public List<SelectOption> lstSeNao {get;set;}
    public List<SelectOption> lstSeSim {get;set;}
    public List<SelectOption> lstRecomenda {get;set;}

    public PesquisaSatisfacaoLivroController() {

        respEmailId = ApexPages.currentPage().getParameters().get('RespEmail');
        RespostaEmail__c respEmail = RespostaEmailDAO.getInstance().buscaEmail(respEmailId);
        livro = respEmail.Livro__c;
        oppId = respEmail.BR_IdOportunidade__c;
        
		titulo = 'Pesquisa de Satisfação: ' + livro;
        
        lstAvaliaLivro = new List<SelectOption>();
        lstAdotaLivro = new List<SelectOption>();
        lstSalaVirtual = new List<SelectOption>();
        lstSeNao = new List<SelectOption>();
        lstSeSim = new List<SelectOption>();
        lstRecomenda = new List<SelectOption>();
        tela1 = true;
        
        lstAvaliaLivro.add(new SelectOption('-', '-'));
        for(Integer i = 0; i < 11; i++){
            lstAvaliaLivro.add(new SelectOption(String.valueof(i),String.valueof(i)));
        }

        lstAdotaLivro.add(new SelectOption('-', '-'));
        lstAdotaLivro.add(new SelectOption('Sim', 'Sim'));
        lstAdotaLivro.add(new SelectOption('Não', 'Não'));

        lstSalaVirtual.add(new SelectOption('-', '-'));
        lstSalaVirtual.add(new SelectOption('Sim', 'Sim'));
        lstSalaVirtual.add(new SelectOption('Não', 'Não'));

        lstSeNao.add(new SelectOption('-', '-'));
        lstSeNao.add(new SelectOption('Não conheço este recurso', 'Não conheço este recurso'));
        lstSeNao.add(new SelectOption('Não tenho cadastro', 'Não tenho cadastro'));
        lstSeNao.add(new SelectOption('Não precisei deste recurso', 'Não precisei deste recurso'));

        lstSeSim.add(new SelectOption('-', '-'));
        for(Integer i = 0; i < 11; i++){
            lstSeSim.add(new SelectOption(String.valueof(i),String.valueof(i)));
        }

        lstRecomenda.add(new SelectOption('-', '-'));
        for(Integer i = 0; i < 11; i++){
            lstRecomenda.add(new SelectOption(String.valueof(i),String.valueof(i)));
        }

    }
    public PageReference confirmarSalvar() {

	    String errMessage = validaCampos();
	
        if(String.isNotBlank(errMessage)){
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, errMessage));
            return null;

        }else{
        	
			PesquisaSatisfacaoLivroTO pesqSatisfacao = montaRespPesquisa();
			
        	RespostaEmailBO.getInstance().gravaPesquisaLivro(pesqSatisfacao);
  			
        	Opportunity opp = OpportunityDAO.buscaOportunidade(oppId);
        	
        	Account_Contact__c contato = AccountContactDAO.getInstance().buscaContatosIstituicao(opp.BR_Account_Contact__c);
        	if(contato.BR_QuantidadeRespondidaEmail__c == null){
        		contato.BR_QuantidadeRespondidaEmail__c = 0;
        	}
        	contato.BR_QuantidadeRespondidaEmail__c  = contato.BR_QuantidadeRespondidaEmail__c  + 1;
        	update contato;

  			tela1 = true;
        	PageReference pageRef = new PageReference('?RespEmail=' + respEmailId);
        	system.debug('pageRef ' + pageRef);
        							
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.INFO, 'Pesquisa registrada com sucesso '));
            return null;
        }
    }

   public PesquisaSatisfacaoLivroTO montaRespPesquisa() {

		PesquisaSatisfacaoLivroTO  pesqSatisfacao = new PesquisaSatisfacaoLivroTO ();	
    	pesqSatisfacao.respEmailId = respEmailId;
    	
		pesqSatisfacao.Pergunta1 = '1. Em uma escala de 1 a 10, como você avalia o livro recebido, de um modo geral?';
    	pesqSatisfacao.AvaliaLivro = AvaliaLivro;
		pesqSatisfacao.Pergunta2 = '2. O livro foi adotado na ementa do curso?';
		pesqSatisfacao.adotaLivro = adotaLivro;
		pesqSatisfacao.Pergunta3 = '3. Você utilizou a Sala Virtual para baixar Materiais de Apoio do livro recebido?';
		pesqSatisfacao.salaVirtual = salaVirtual;
		pesqSatisfacao.Pergunta4 = '4. Se não, porque?';
		pesqSatisfacao.seNao = seNao;
		pesqSatisfacao.Pergunta5 = '5. Se sim, qual o seu grau de satisfação em relação ao conteúdo baixado?';
		pesqSatisfacao.seSim = seSim;
		pesqSatisfacao.Pergunta6 = '6. Qual a probabilidade de você recomendar os livros da Pearson a um colega professor?';
		pesqSatisfacao.recomenda = recomenda;
		pesqSatisfacao.Pergunta7 = '7. Se tiver algum comentário, reclamação, sugestão ou elogio sobre o livro, sinta-se a vontade para compartilhar conosco.';
   		pesqSatisfacao.comentario = comentario;
   		return pesqSatisfacao;
   }
   public String validaCampos() {

		String errMessage = '';
		if(AvaliaLivro == '-'){
			return errMessage = 'Preencher Primeira pergunta antes de salvar';
		}
		if(adotaLivro == '-'){
			return errMessage = 'Preencher Segunda pergunta antes de salvar';
		}
		if(salaVirtual == '-'){
			return errMessage = 'Preencher Terceira pergunta antes de salvar';
		}
		if(seNao == '-' && salaVirtual == 'Não'){
			return errMessage = 'Preencher Quarta pergunta antes de salvar';
		}
		if(seSim == '-' && salaVirtual == 'Sim'){
			return errMessage = 'Preencher Quinta pergunta antes de salvar';
		}
		if(recomenda == '-'){
			return errMessage = 'Preencher Sexta pergunta antes de salvar';
		}
   		
		return errMessage;
   	
   }


}