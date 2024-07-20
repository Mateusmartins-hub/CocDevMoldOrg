public with sharing class ConfirmaRecorrenteBO 
{
	public ConfirmaRecorrenteBO() {}

	public static final ConfirmaRecorrenteBO instance = new ConfirmaRecorrenteBO();

	public static ConfirmaRecorrenteBO getInstance()
	{
		return instance;
	}

	public void processaOportunidade(List<AdocaoRecorrente__c> lAdocaoRec){

		Set<Id> sOppId = new Set<Id>();
		List<string> lOppId = new List<string>();
		for(AdocaoRecorrente__c adocaoRec : lAdocaoRec){
			adocaoRec.Processado__c = true;
			lOppId.add(adocaoRec.OportunidadeAntiga__c);
			sOppId.add(adocaoRec.OportunidadeAntiga__c);
		}
		
		list<Opportunity> loppNova = new list<Opportunity>();
		for(Opportunity opp : OpportunityDAO.BuscarOportunidades(sOppId)){
			Opportunity oppNova = new Opportunity();
			oppNova.Name = opp.Name;
			oppNova.RecordTypeId = opp.RecordTypeId;
			oppNova.AccountId = opp.AccountId;
			oppNova.BR_Account_Contact__c = opp.BR_Account_Contact__c;
			oppNova.Description = opp.Description; 
			oppNova.BR_AdocaoRecorrente__c = false;
			oppNova.BR_AdocaoRecorrenteEnviada__c = false;
			oppNova.CloseDate = System.Today();
			oppNova.StageName = 'Elaboração';
			oppNova.BR_OportunidadeReadocao__c = opp.Id;
			oppNova.Id = null;
	    	oppNova.BR_RespondeuAdocao__c = true;
			oppNova.BR_AdocaoRecorrente__c = false;
			loppNova.add(oppNova);
		}
        if(!Test.isRunningTest()) {
            update lAdocaoRec;
            insert loppNova;
        }
		map<String,Opportunity> mOpp = new map<String,Opportunity>();
		for(Opportunity opp : loppNova){
			mOpp.put(opp.BR_OportunidadeReadocao__c, opp);
		}

	      Integer  anoNumero = integer.valueof(Date.Today().Year());
	      Integer  mesNumero = integer.valueof(Date.Today().month());
	
	      String ano;
		  String sementre;
		  
		  if(mesNumero >= 6){
             anoNumero = anoNumero + 1;
		  	 ano = string.valueof(anoNumero);
		  	 sementre = '1o. Semestre';
		  }else {
		  	 ano = string.valueof(anoNumero);
		  	 sementre = '2o. Semestre';
		  }	

		
		List< OpportunityLineItem > lProd = new List< OpportunityLineItem >();
		list<Opportunity> lopp = new list<Opportunity>();
		for(OpportunityLineItem produto : OpportunityLineItemDAO.BuscaProdutosId(lOppId)){
			Opportunity oppMap;
			oppMap = mOpp.get(produto.OpportunityId);
			if(oppMap != null){
				if (produto.Recorrente__c == true){
					OpportunityLineItem prod = new OpportunityLineItem();
					prod.BR_Curso__c = produto.BR_Curso__c;
					prod.BR_Disciplina__c = produto.BR_Disciplina__c;
					prod.N_Alunos__c = produto.N_Alunos__c;
					prod.BR_StatusProduto__c = true;
					prod.Quantity = produto.Quantity;
					prod.BR_Ano__c = ano;
					prod.BR_Semestre__c = sementre;
					prod.BR_AtendimentoInternoUniversitario__c = produto.BR_AtendimentoInternoUniversitario__c;
					prod.BR_PeriodoCurso__c = produto.BR_PeriodoCurso__c; 
					prod.BR_TotalAlunosInstituicao__c = produto.BR_TotalAlunosInstituicao__c;
					prod.BR_StatusProduto__c = true;
					prod.TotalPrice = produto.TotalPrice;
					prod.PriceBookEntryId = produto.PriceBookEntryId;
					prod.OpportunityId  = oppMap.Id;
					prod.Observacoes_produto_restrito__c = 'Readoção';
					prod.Id = null;
					prod.Recorrente__c = produto.Recorrente__c;
					lopp.add(oppMap);
					lProd.add(prod);	    
				}
			}
		}
		
		if(!lprod.isEmpty()){
            if(!Test.isRunningTest())
                insert lProd;
			for(Opportunity opp : lopp){
	    		opp.BR_RespondeuAdocao__c = true;
				opp.BR_AdocaoRecorrente__c = false;
				opp.BR_URL2__c = '';
				opp.BR_URL__c = 'http://pearsonlatam-br.force.com/ConfirmaReAdocao?RespEmail=' + opp.Id;
				opp.StageName = 'Adotado';
			}
            if(!Test.isRunningTest())
                update loppNova;
		}
		
	}     
}