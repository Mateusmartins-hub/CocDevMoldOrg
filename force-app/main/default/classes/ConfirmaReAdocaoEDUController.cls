public class ConfirmaReAdocaoEDUController {
	
    public String professor {get;set;}
    public String oportunidade  {get;set;}
    public String instituicao  {get;set;}
    public List< OpportunityLineItem > lProduto {get;set;}
	public List<ConfirmaAdocaoTO> lprodAdocao  {get;set;}
    public Opportunity opp  {get;set;}

    private String respEmailId {get;set;}

    public ConfirmaReAdocaoEDUController() {

    	this.lProduto = new List<OpportunityLineItem>();
    	this.lprodAdocao = new List<ConfirmaAdocaoTO>();
        respEmailId = ApexPages.currentPage().getParameters().get('RespEmail');

        this.opp = OpportunityDAO.buscaOportunidade(respEmailId);

        Contact contato = [Select Name From Contact Where Id=: opp.BR_Account_Contact__r.Contact__c];
        professor = contato.name;
        oportunidade = respEmailId;
		Account acc = AccountDAO.buscaConta(opp.AccountId);
		instituicao = acc.name;

		this.lProduto = OpportunityLineItemDAO.BuscaProdutos(respEmailId);
		for(OpportunityLineItem oppLineItem : this.lProduto){
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
    	
		string errMessage = 'Adoção Confirmada com sucesso';
		for(OpportunityLineItem produto : this.lProduto){
			produto.BR_StatusProduto__c = true;
		}
		Update this.lProduto;
		
		this.opp.BR_URL__c = 'http://pearsonlatam-br.force.com/ConfirmaReAdocaoEDU??RespEmail=' + this.opp.Id;
		update this.opp;
		
        ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.INFO, errMessage));
        return null;
	} 
	
    public PageReference naoConfirmaAdocao() {
    	
		string errMessage = 'Adoção não confirmada';
		for(OpportunityLineItem produto : this.lProduto){
			produto.BR_StatusProduto__c = false;
		}
		Update this.lProduto;

        ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.INFO, errMessage));
        return null;
	} 
}