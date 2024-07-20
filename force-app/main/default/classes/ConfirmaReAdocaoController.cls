public class ConfirmaReAdocaoController {
	
    public String professor {get;set;}
    public String oportunidade  {get;set;}
    public String instituicao  {get;set;}
    public list<AdocaoRecorrente__c> lAdRec {get;set;}
 // public List< OpportunityLineItem > lProduto {get;set;}
	public List<ConfirmaAdocaoTO> lprodAdocao  {get;set;}
    public Opportunity opp  {get;set;}
	public Boolean habilitaBotao   {get;set;}
	public Boolean adotou   {get;set;}

    private String respEmailId {get;set;}

    public ConfirmaReAdocaoController() {

    	//this.lProduto = new List<OpportunityLineItem>();
    	this.lprodAdocao = new List<ConfirmaAdocaoTO>();
        respEmailId = ApexPages.currentPage().getParameters().get('RespEmail');
        list<AdocaoRecorrente__c> lAdRec = new list<AdocaoRecorrente__c>();  
        this.opp = OpportunityDAO.buscaOportunidade(respEmailId);
    	lAdRec = [select Id, OportunidadeAntiga__c from AdocaoRecorrente__c where OportunidadeAntiga__c =: this.opp.Id ];
    	
		if (!lAdRec.isEmpty()){
			ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.INFO, 'Adoção confirmada com sucesso' ));
	        habilitaBotao = false;
		/*}
		if(this.opp.BR_AdocaoRecorrente__c  == true){
	        habilitaBotao = false;
			ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.INFO, 'Adoção confirmada com sucesso' )); */
		}else{
	        habilitaBotao = true;
		}

        Contact contato = [Select Name From Contact Where Id=: opp.BR_Account_Contact__r.Contact__c];
        professor = contato.name;
        oportunidade = respEmailId;
		Account acc = AccountDAO.buscaConta(opp.AccountId);
		instituicao = acc.name;
		//this.lProduto = OpportunityLineItemDAO.BuscaProdutos(respEmailId);
		for(OpportunityLineItem oppLineItem : OpportunityLineItemDAO.BuscaProdutos(respEmailId)){
			ConfirmaAdocaoTO confAdocao = new ConfirmaAdocaoTO();
			confAdocao.idProduto = oppLineItem.Id;
			confAdocao.numeroProdutoERP = oppLineItem.BR_ERP_Product_Code__c; 
			confAdocao.Livro = oppLineItem.NomeProduto__c;
			confAdocao.Curso = oppLineItem.BR_Curso__r.Name;
			confAdocao.disciplina = oppLineItem.BR_Disciplina__r.Name;
			confAdocao.numeroAluno = oppLineItem.N_Alunos__c;
			confAdocao.Adota = oppLineItem.BR_StatusProduto__c;
			if(oppLineItem.BR_StatusProduto__c == true){
				this.lprodAdocao.add(confAdocao); 
			}
			
		}
     	 ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.INFO, 'Se as informações listadas abaixo estiverem desatualizadas, entre em contato conosco e informe os dados corretos: pearsonuniversidades@pearson.com'));	
				
    }

    public PageReference confirmarSalvar() {
    	
    	list<AdocaoRecorrente__c> lAdRec = [select Id, OportunidadeAntiga__c from AdocaoRecorrente__c where OportunidadeAntiga__c =: this.opp.Id ];
    	
		//if(opp.BR_AdocaoRecorrente__c == true){
		if (!lAdRec.isEmpty()){
			ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.INFO, 'Adoção confirmada com sucesso' ));
			return null;
		}
		
		adotou = false;
		this.opp.BR_RespondeuAdocao__c = true;
		this.opp.BR_AdocaoRecorrenteEnviada__c = true;
		this.opp.BR_AdocaoRecorrente__c = true;
		update opp;
		
		List<OpportunityLineItem> lProduto = new List<OpportunityLineItem>();
		for(ConfirmaAdocaoTO confAdocao :this.lprodAdocao){
			    OpportunityLineItem oppLineItem = new OpportunityLineItem();
				oppLineItem.Id = confAdocao.idProduto  ;
				oppLineItem.BR_StatusProduto__c = confAdocao.Adota ;
				oppLineItem.Recorrente__c = confAdocao.Adota;
			if(confAdocao.Adota == true){
				adotou = true;
				lProduto.add(oppLineItem);
			}
		}	
		system.debug('this.lProduto ' + lProduto);
		string errMessage;
		if(!lProduto.isEmpty()){
			update lProduto;
		} 		
		if(adotou == true) {
			AdocaoRecorrente__c adRecor = new AdocaoRecorrente__c();
			adRecor.OportunidadeAntiga__c = this.opp.Id;
			adRecor.Processado__c = false;
			insert adRecor;
     		errMessage = 'Readoção confirmada com sucesso ';
		}else{
			errMessage = 'Obrigado por responder a adoção';
		}
		
        ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.INFO, errMessage));
        return null;
	} 
}