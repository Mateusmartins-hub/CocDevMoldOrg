public with sharing class ProdutoDistribuicaoGratuitaVF {
    public Boolean isSelected {get; set;}
    public Boolean isNewRecord {get; set;}
    public OpportunityLineItem oppLineItem {get; set;}
    public BR_ProdutoDistribuicaoGratuita__c prodDistribuicaoGratuita {get; set;}
    public String produtoERP {get;set;}
    public String nomeProduto {get; set;}
    public String idProduto {get; set;}
    public String nomeCurso {get; set;}
    public String Observacoesproduto {get; set;}
    public String nomeDisciplina {get; set;}
    public String isbn {get; set;}
    public String cpfLink {get; set;}
    //public String tipoProduto {get;set;}
    public String titulo {get;set;}
    public Boolean produtoAdicional { get; set; }

    public ProdutoDistribuicaoGratuitaVF() {
        this.prodDistribuicaoGratuita = new BR_ProdutoDistribuicaoGratuita__c();
        this.prodDistribuicaoGratuita.BR_FormaEnvio__c = 'PAC';
    }

    public ProdutoDistribuicaoGratuitaVF(BR_ProdutoDistribuicaoGratuita__c prodDistribuicaoGratuita){
        this.prodDistribuicaoGratuita = prodDistribuicaoGratuita;
        this.nomeProduto = prodDistribuicaoGratuita.BR_ProdutoDistribuicaoGratuita__r.Name;
        this.nomeCurso = prodDistribuicaoGratuita.BR_Curso__r.Name;
        this.nomeDisciplina = prodDistribuicaoGratuita.BR_Disciplina__r.Name;
        this.produtoAdicional = prodDistribuicaoGratuita.BR_Produto_Adicional__c;
        this.isSelected = true;
        this.isNewRecord = false;
    }

    public ProdutoDistribuicaoGratuitaVF(OpportunityLineItem oppLineItem, Boolean isAmostraFisica) {
        this.isNewRecord = true;
        this.isSelected = false;
        this.oppLineItem = oppLineItem;
        this.prodDistribuicaoGratuita = new BR_ProdutoDistribuicaoGratuita__c();
            this.nomeProduto = oppLineItem.PricebookEntry.Product2.Name;
        this.nomeCurso = oppLineItem.BR_Curso__r.Name;
        this.nomeDisciplina = oppLineItem.BR_Disciplina__r.Name;
        this.Observacoesproduto = oppLineItem.Observacoes_produto_restrito__c;
        //this.tipoProduto = oppLineItem.PricebookEntry.Product2.BR_Tipo_Produto__c;
        this.produtoERP = oppLineItem.BR_ERP_Product_Code__c;
        this.titulo = oppLineItem.PricebookEntry.Product2.BR_Titulo__c;

        if(isAmostraFisica){
            this.loadDataOppDistribGratuitaAmostraFisica(oppLineItem);
        }
        else{
            this.loadDataOppDistribGratuitaAmostraVirtual(oppLineItem);
        }
    }

    public void loadDataOppDistribGratuitaAmostraFisica(OpportunityLineItem oppLineItem) {
        this.prodDistribuicaoGratuita.BR_ProdutoDistribuicaoGratuita__c = oppLineItem.PricebookEntry.Product2Id;
        this.prodDistribuicaoGratuita.BR_Curso__c = oppLineItem.BR_Curso__c;
        this.prodDistribuicaoGratuita.BR_Disciplina__c = oppLineItem.BR_Disciplina__c;
        this.prodDistribuicaoGratuita.BR_NAlunos__c = oppLineItem.N_Alunos__c;
        this.prodDistribuicaoGratuita.BR_FormaEnvio__c = 'PAC';
        this.prodDistribuicaoGratuita.BR_Link__c = oppLineItem.PricebookEntry.Product2.BR_Link__c;
    }

    public void loadDataOppDistribGratuitaAmostraVirtual(OpportunityLineItem oppLineItem) {
        this.prodDistribuicaoGratuita.BR_ProdutoDistribuicaoGratuita__c = oppLineItem.PricebookEntry.Product2Id;
        this.prodDistribuicaoGratuita.BR_Curso__c = oppLineItem.BR_Curso__c;
        this.prodDistribuicaoGratuita.BR_Disciplina__c = oppLineItem.BR_Disciplina__c;
        this.prodDistribuicaoGratuita.BR_NAlunos__c = oppLineItem.N_Alunos__c;
        this.prodDistribuicaoGratuita.BR_FormaEnvio__c = 'PAC';
        this.isbn = oppLineItem.PricebookEntry.Product2.BR_ISBN__c;
        this.prodDistribuicaoGratuita.BR_Link__c = oppLineItem.PricebookEntry.Product2.BR_Link__c;
    }
}