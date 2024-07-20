public class ConfirmaAdocaoController {

    public String professor {get;set;}
    public String oportunidade  {get;set;}
    public String instituicao  {get;set;}
    public List< OpportunityLineItem > lProduto {get;set;}
	public List<ConfirmaAdocaoTO> lprodAdocao  {get;set;}
    public Opportunity opp  {get;set;}
	public Boolean adotou   {get;set;}
	public Boolean habilitaBotao   {get;set;}
	
    private String disGrat {get;set;}
    private String respEmailId {get;set;}

    public ConfirmaAdocaoController() {

    	this.lProduto = new List<OpportunityLineItem>();
    	this.lprodAdocao = new List<ConfirmaAdocaoTO>();
        respEmailId = ApexPages.currentPage().getParameters().get('RespEmail');
    	disGrat =  ApexPages.currentPage().getParameters().get('disGrat');
    	if (disGrat == null) {
    		disGrat =  ' ';
    	}
    	 system.debug('disGrat ' + disGrat);
        /*RespostaEmail__c respEmail = RespostaEmailDAO.getInstance().buscaEmail(respEmailId);
        this.opp = OpportunityDAO.buscaOportunidade(respEmail.Oportunidade__c);*/

        this.opp = OpportunityDAO.buscaOportunidade(respEmailId);
		if(this.opp.StageName  == 'Adotado' || this.opp.StageName  == 'Pedido Gerado' || this.opp.StageName  == 'Enviado para Integração' ){
	        habilitaBotao = false;
			ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.INFO, 'Adoção confirmada com sucesso' ));
		}else{
			if (this.opp.StageName  == 'Não Adotado'){
		        habilitaBotao = false;
				ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.INFO, 'Oportunidade não foi adotada' ));
			}else{
		        habilitaBotao = true;
			}
		}
        
        system.debug('contato ' + opp.BR_Account_Contact__r.Contact__c);
        //Contact contato = ContatoDAO.buscaContato(opp.BR_Account_Contact__r.Contact__c); 
        Contact contato = [Select Name From Contact Where Id=: opp.BR_Account_Contact__r.Contact__c];
        professor = contato.name;
        //oportunidade = respEmail.Oportunidade__c;
        oportunidade = respEmailId;
		Account acc = AccountDAO.buscaConta(opp.AccountId);
		instituicao = acc.name;
		//this.lProduto = OpportunityLineItemDAO.BuscaProdutos(respEmail.Oportunidade__c);
		for(OpportunityLineItem oppLineItem : OpportunityLineItemDAO.BuscaProdutos(respEmailId)){
			ConfirmaAdocaoTO confAdocao = new ConfirmaAdocaoTO();
			confAdocao.idProduto = oppLineItem.Id;
			confAdocao.numeroProdutoERP = oppLineItem.BR_ERP_Product_Code__c; 
			confAdocao.Livro = oppLineItem.NomeProduto__c;
			confAdocao.Curso = oppLineItem.BR_Curso__r.Name;
			confAdocao.disciplina = oppLineItem.BR_Disciplina__r.Name;
			confAdocao.numeroAluno = oppLineItem.N_Alunos__c;
			confAdocao.Adota = oppLineItem.BR_StatusProduto__c;
			
			this.lprodAdocao.add(confAdocao); 
		}
		system.debug('this.lProduto ' + this.lProduto);
				
    }

    public PageReference confirmarSalvar() {
    	
		if(opp.BR_RespondeuAdocao__c == true){
			ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.INFO, 'Adoção confirmada com sucesso' ));
			return null;
		}
    	this.lProduto = new List<OpportunityLineItem>();

		for(ConfirmaAdocaoTO confAdocao :this.lprodAdocao){
		    OpportunityLineItem oppLineItem = new OpportunityLineItem();
			oppLineItem.Id = confAdocao.idProduto  ;
			oppLineItem.BR_StatusProduto__c = confAdocao.Adota ;
			if(confAdocao.Adota == true){
				adotou = true;
				this.lProduto.add(oppLineItem);
			}
		}	
		string errMessage;
    	update this.lProduto;
		
		if(adotou == true) {
			this.opp.BR_AdocaoRecorrente__c = false;
			this.opp.BR_URL__c = 'http://pearsonlatam-br.force.com/ConfirmaReAdocao?RespEmail=' + this.opp.Id;
			this.opp.StageName = 'Adotado';
			errMessage = 'Adoção confirmada com sucesso';
		}else{
			this.opp.BR_AdocaoRecorrente__c = false;
			this.opp.StageName = 'Não Adotado';
			errMessage = 'Obrigado por responder a adoção';
		}
		this.opp.BR_RespondeuAdocao__c = true;
		update this.opp;
		AdocaoOut.atualizaDistribuicao(this.opp.Id);		
		
    	Account_Contact__c contato = AccountContactDAO.getInstance().buscaContatosIstituicao(this.opp.BR_Account_Contact__c);
    	if(contato.BR_QuantidadeRespondidaEmail__c == null){
    		contato.BR_QuantidadeRespondidaEmail__c = 0;
    	}
    	contato.BR_QuantidadeRespondidaEmail__c  = contato.BR_QuantidadeRespondidaEmail__c  + 1;
    	update contato;

        ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.INFO, errMessage));
        return null;
    }

}