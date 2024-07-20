public class PesquisaSatisfacaoController {

    public PesquisaSatisfacaoTO pesqSat {get;set;}
    public Boolean tela1 {get;set;}
    public Boolean tela2 {get;set;}
    public Boolean tela3 {get;set;}
    public Boolean tela4 {get;set;}

    private String respEmailId {get;set;}
//    private String disGrat {get;set;}
    private Opportunity opp {get;set;}
    public List<SelectOption> lstPerg1 {get;set;}
    public List<SelectOption> lstPerg2 {get;set;}
    public List<SelectOption> lstPerg3 {get;set;}
    public List<SelectOption> lstPerg4 {get;set;}
    public List<SelectOption> lstPerg5 {get;set;}
    public List<SelectOption> lstPerg6 {get;set;}
    public List<SelectOption> lstPerg7 {get;set;}
    public List<SelectOption> lstPerg8 {get;set;}
    public List<SelectOption> lstPerg9 {get;set;}
    public List<SelectOption> lstPerg10 {get;set;}

    public PesquisaSatisfacaoController() {
    	
    	/*disGrat =  ApexPages.currentPage().getParameters().get('disGrat');
    	if (disGrat != null) {
    		disGrat =  ' ';
    	} */
        respEmailId = ApexPages.currentPage().getParameters().get('RespEmail');
        //RespostaEmail__c respEmail = RespostaEmailDAO.getInstance().buscaEmail(respEmailId);
		this.opp = new Opportunity();
        
		this.opp = OpportunityDAO.buscaOportunidade(respEmailId);
		system.debug('this.opp.BR_Account_Contact__c ' + this.opp.BR_Account_Contact__c);
        
        this.pesqSat = new PesquisaSatisfacaoTO(); 
        
        lstPerg1 = new List<SelectOption>();
        lstPerg2 = new List<SelectOption>();
        lstPerg3 = new List<SelectOption>();
        lstPerg4 = new List<SelectOption>();
        lstPerg5 = new List<SelectOption>();
        lstPerg6 = new List<SelectOption>();
        lstPerg7 = new List<SelectOption>();
        lstPerg8 = new List<SelectOption>();
        lstPerg9 = new List<SelectOption>();
        //lstPerg10 = new List<SelectOption>();
        tela1 = true;
        tela2 = false;
        tela3 = false;
        tela4 = false;
        
        lstPerg1.add(new SelectOption('-', '-'));
        for(Integer i = 0; i < 11; i++){
            lstPerg1.add(new SelectOption(String.valueof(i),String.valueof(i)));
        }

        lstPerg2.add(new SelectOption('-', '-'));
        lstPerg2.add(new SelectOption('Site da Pearson', 'Site da Pearson'));
        lstPerg2.add(new SelectOption('Catálogo Impresso', 'Catálogo Impresso'));
        lstPerg2.add(new SelectOption('Redes Sociais', 'Redes Sociais'));
        lstPerg2.add(new SelectOption('Outros Sites', 'Outros Sites'));
        lstPerg2.add(new SelectOption('Colegas', 'Colegas'));

        lstPerg3.add(new SelectOption('-', '-'));
        lstPerg3.add(new SelectOption('Totalmente satisfeito', 'Totalmente satisfeito'));
        lstPerg3.add(new SelectOption('Satisfeito', 'Satisfeito'));
        lstPerg3.add(new SelectOption('Indiferente', 'Indiferente'));
        lstPerg3.add(new SelectOption('Insatisfeito', 'Insatisfeito'));
 
        lstPerg4.add(new SelectOption('-', '-'));
        lstPerg4.add(new SelectOption('Sim', 'Sim'));
        lstPerg4.add(new SelectOption('Não', 'Não'));

        lstPerg5.add(new SelectOption('-', '-'));
        lstPerg5.add(new SelectOption('Sim', 'Sim'));
        lstPerg5.add(new SelectOption('Não', 'Não'));

       /* lstPerg6.add(new SelectOption('-', '-'));
        for(Integer i = 0; i < 11; i++){
            lstPerg6.add(new SelectOption(String.valueof(i),String.valueof(i)));
        }

        lstPerg7.add(new SelectOption('-', '-'));
        lstPerg7.add(new SelectOption('Sim', 'Sim'));
        lstPerg7.add(new SelectOption('Não', 'Não'));

        lstPerg8.add(new SelectOption('-', '-'));
        lstPerg8.add(new SelectOption('Definição de bibliografia para curso novo', 'Definição de bibliografia para curso novo'));
        lstPerg8.add(new SelectOption('Atualização de bibliografia de curso já existente', 'Atualização de bibliografia de curso já existente'));
        lstPerg8.add(new SelectOption('Uso pessoal', 'Uso pessoal'));

        lstPerg9.add(new SelectOption('-', '-'));
        lstPerg9.add(new SelectOption('Sim', 'Sim'));
        lstPerg9.add(new SelectOption('Não', 'Não'));

        lstPerg10.add(new SelectOption('-', '-'));
        lstPerg10.add(new SelectOption('Semestralmente', 'Semestralmente'));
        lstPerg10.add(new SelectOption('Anualmente', 'Anualmente'));
        lstPerg10.add(new SelectOption('A cada dois ou três anos', 'A cada dois ou três anos'));
        lstPerg10.add(new SelectOption('A cada quatro ou cinco anos', 'A cada quatro ou cinco anos'));
            */
        lstPerg6.add(new SelectOption('-', '-'));
        lstPerg6.add(new SelectOption('Sim', 'Sim'));
        lstPerg6.add(new SelectOption('Não', 'Não'));

        lstPerg7.add(new SelectOption('-', '-'));
        lstPerg7.add(new SelectOption('Definição de bibliografia para curso novo', 'Definição de bibliografia para curso novo'));
        lstPerg7.add(new SelectOption('Atualização de bibliografia de curso já existente', 'Atualização de bibliografia de curso já existente'));
        lstPerg7.add(new SelectOption('Uso pessoal', 'Uso pessoal'));

        lstPerg8.add(new SelectOption('-', '-'));
        lstPerg8.add(new SelectOption('Sim', 'Sim'));
        lstPerg8.add(new SelectOption('Não', 'Não'));

        lstPerg9.add(new SelectOption('-', '-'));
        lstPerg9.add(new SelectOption('Semestralmente', 'Semestralmente'));
        lstPerg9.add(new SelectOption('Anualmente', 'Anualmente'));
        lstPerg9.add(new SelectOption('A cada dois ou três anos', 'A cada dois ou três anos'));
        lstPerg9.add(new SelectOption('A cada quatro ou cinco anos', 'A cada quatro ou cinco anos'));
    }

    public PageReference ProximaFase() {

		String errMessage = '';
		 
	    if(tela1 == true){
	    	errMessage = validaTela1();
	    }

        if(String.isNotBlank(errMessage)){
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, errMessage));
        	PageReference pageRef = new PageReference('?RespEmail=' + respEmailId);
        	system.debug('pageRef ' + pageRef);
        							
            return null;

        }else{
            return null;
        }
    }

    public PageReference ProximaFase2() {
		String errMessage = '';
		 
	    if(tela2 == true){
	    	errMessage = validaTela2();
	    }

        if(String.isNotBlank(errMessage)){
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, errMessage));
        	PageReference pageRef = new PageReference('?RespEmail=' + respEmailId);
        	system.debug('pageRef ' + pageRef);
        							
            return null;

        }else{
            return null;
        }
    }

    public PageReference confirmarSalvar() {

		String errMessage = '';

	    if(tela3 == true){
	    	errMessage = validaTela3();
	    }
	
        if(String.isNotBlank(errMessage)){
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, errMessage));
        	PageReference pageRef = new PageReference('?RespEmail=' + respEmailId);
        	system.debug('pageRef ' + pageRef);
        							
            return null;

        }else{
        	
			montaRespPesquisa();
			
        	RespostaEmailBO.getInstance().gravaPesquisaAtendimento(pesqSat, respEmailId);
        	
        	//Opportunity opp = OpportunityDAO.buscaOportunidade(oppId);
        	
        	Account_Contact__c contato = AccountContactDAO.getInstance().buscaContatosIstituicao(this.opp.BR_Account_Contact__c);
        	if(contato.BR_QuantidadeRespondidaEmail__c == null){
        		contato.BR_QuantidadeRespondidaEmail__c = 0;
        	}
        	contato.BR_QuantidadeRespondidaEmail__c  = contato.BR_QuantidadeRespondidaEmail__c  + 1;
        	update contato;
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.INFO, 'Pesquisa registrada com sucesso '));
        	
            return null;
        }
    }

   public void montaRespPesquisa() {
   	
		pesqSat.Pergunta1 = '1. Como avalia o atendimento prestado pela nossa equipe, de um modo geral?';
		pesqSat.Pergunta2 = '2. Como soube da possibilidade de receber uma amostra de livro para avaliação?';
		pesqSat.Pergunta3 = '3. Qual a sua percepção com relação à agilidade no atendimento?';
		pesqSat.Pergunta4 = '4. O Executivo responsável pela sua região se mostrou empenhado em lhe apresentar o catálogo de livros, incluindo os lançamentos e títulos diferentes daqueles que você solicitou?';
		pesqSat.Pergunta5 = '5. Durante o processo de avaliação, a Pearson enviou comunicados de acompanhamento com o objetivo de orientá-lo e lembra-lo da importância de cumprir todas as etapas. Na sua opinião, esta comunicação foi eficiente?';
		/*pesqSat.Pergunta6 = '6. Como você avalia o mecanismo de envio das informações sobre a adoção proposto pela Pearson?';
		pesqSat.Pergunta7 = '7. O fato de o atendimento ter sido realizado à distância foi prejudicial de alguma forma?';
		pesqSat.Pergunta8 = '8. Qual a sua motivação em solicitar uma amostra para avaliação?';
		pesqSat.Pergunta9 = '9. A Instituição onde leciona permite que o professor faça a atualização da bibliografia dos cursos?';
		pesqSat.Pergunta10 = '10. Com qual frequência a instituição atualiza o acervo da biblioteca?';
		pesqSat.Pergunta11 = '11. Se tiver algum comentário, reclamação, sugestão ou elogio, sinta-se a vontade para compartilhar conosco.';
        */
		pesqSat.Pergunta6 = '6. O fato de o atendimento ter sido realizado à distância foi prejudicial de alguma forma?';
		pesqSat.Pergunta7 = '7. Qual a sua motivação ao solicitar uma amostra para avaliação?';
		pesqSat.Pergunta8 = '8. A Instituição onde leciona permite que o professor faça a atualização da bibliografia dos cursos?';
		pesqSat.Pergunta9 = '9. Com qual frequência a instituição atualiza o acervo da biblioteca?';
		pesqSat.Pergunta10 = '10. Se tiver algum comentário, reclamação, sugestão ou elogio, sinta-se à vontade para compartilhar conosco.';
   }
   public String validaTela1() {

		String errMessage = '';

		if(pesqSat.Resposta1 == '-'){
			return errMessage = 'Preencher Primeira pergunta antes de salvar';
		}
		if(pesqSat.Resposta2 == '-'){
			return errMessage = 'Preencher Segunda pergunta antes de salvar';
		}
		if(pesqSat.Resposta3 == '-'){
			return errMessage = 'Preencher Terceira pergunta antes de salvar';
		}
		if(pesqSat.Resposta4 == '-'){
			return errMessage = 'Preencher Quarta pergunta antes de salvar';
		}
		if(pesqSat.Resposta5 == '-'){
			return errMessage = 'Preencher Quinta pergunta antes de salvar';
		}
		if(pesqSat.Resposta6 == '-'){
			return errMessage = 'Preencher Sexta pergunta antes de salvar';
		}
	/*	if(pesqSat.Resposta7 == ''){
			return errMessage = 'Preencher Setima pergunta antes de salvar';
		} */
		if(errMessage == ''){
  			tela1 = false;
        	tela2 = true;
        	tela3 = false;
        	tela4 = false;
		}
   		
		return errMessage;
   	
   }
   public String validaTela2() {

		String errMessage = '';
		
		if(pesqSat.Resposta7 == ''){
			return errMessage = 'Preencher Setima pergunta antes de salvar';
		}
		if(pesqSat.Resposta8 == '-'){
			return errMessage = 'Preencher Oitava pergunta antes de salvar';
		}
		if(pesqSat.Resposta9 == '-'){
			return errMessage = 'Preencher Nona pergunta antes de salvar';
		}
		/*if(pesqSat.Resposta10 == '-'){
			return errMessage = 'Preencher Décima pergunta antes de salvar';
		} */
		if(errMessage == ''){
  			tela1 = false;
        	tela2 = false;
        	tela3 = true;
        	tela4 = false;
		}
   		
		return errMessage;
   	
   }

   public String validaTela3() {

		String errMessage = '';

		if(errMessage == ''){
  			tela1 = false;
        	tela2 = false;
        	tela3 = true;
		}
   		
		return errMessage;
   	
   }

}