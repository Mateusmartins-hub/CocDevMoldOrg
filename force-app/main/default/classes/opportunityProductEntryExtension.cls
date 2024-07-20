public with sharing class opportunityProductEntryExtension {

    public Opportunity theOpp {get;set;}
    public String searchString {get;set;}
    public opportunityLineItem[] shoppingCart {get;set;}
    public priceBookEntry[] AvailableProducts {get;set;}
    public Pricebook2 theBook {get;set;}

    public String toSelect {get; set;}
    public String toUnselect {get; set;}
    
    //public integer variavel {get; set;}
    public Decimal Total {get;set;}
    public Boolean overLimit {get;set;}
    //public Boolean multipleCurrencies {get; set;}
    public Boolean adocaoConfirmada {get;set;}
    public Boolean visualizaBtnAdocao {get;set;}
    public Boolean visualizaCampos {get;set;}
    public boolean displayPopup {get; set;}
    public boolean tiraColunaEDU {get; set;}
    private Boolean forcePricebookSelection = false;
    public Boolean RecTypeSelected {get; set;}
    private Id tROppNegPearsonEnglish;
	private Id recTypeSampleOrderUn {get;set;}


    private opportunityLineItem[] forDeletion = new opportunityLineItem[]{};


    public opportunityProductEntryExtension(ApexPages.StandardController controller) {

        // Need to know if org has multiple currencies enabled
        //multipleCurrencies = UserInfo.isMultiCurrencyOrganization();

        // Get information about the Opportunity being worked on
        //if(multipleCurrencies)
        //    theOpp = database.query('select Id, Pricebook2Id, Pricebook2.Name, CurrencyIsoCode, RecordType.Name from Opportunity where Id = \'' + controller.getRecord().Id + '\' limit 1');
        //else
        	theOpp = [select Id, RecordTypeId, Pricebook2Id, PriceBook2.Name,RecordType.Name, Cod_Local_do_Estoque__c,
        	            BR_Desconto_EI__c,BR_Desconto_EF__c,BR_Desconto_EM__c,Desconto_PV__c,BR_Desconto_1_ano__c,
        	            BR_ConfirmarAdocao__c, BR_Compras_atraves_de__c, StageName, BR_Distribuidor__c,BR_PrevisaoCompra__c
        	            from Opportunity where Id = :controller.getRecord().Id limit 1];
            if(theOpp.RecordType.Name == 'Oportunidade de Negócio Pearson English EDU'){
				RecTypeSelected = true;
				this.tiraColunaEDU = false;
			}else{
				RecTypeSelected = false;
				this.tiraColunaEDU = true;
    		}
        // If products were previously selected need to put them in the "selected products" section to start with
        shoppingCart = [select Id, Quantity, BR_Ano__c, BR_Semestre__c, BR_Curso__c, BR_Disciplina__c, N_Alunos__c, QtdDisp__c,
                        TotalPrice, UnitPrice, Description, Discount, PriceBookEntryId, PriceBookEntry.Name, PriceBookEntry.IsActive,
                        PriceBookEntry.Product2Id, PriceBookEntry.Product2.Name, PriceBookEntry.Product2.BR_Nivel__c,
                        PriceBookEntry.Product2.BR_Edicao__c, PriceBookEntry.Product2.BR_Complemento__c, PriceBookEntry.PriceBook2Id,
                        Observacoes_produto_restrito__c,PriceBookEntry.Product2.BR_Product_Code__c,BR_StatusProduto__c, BR_PrecoNegociado__c
                        from opportunityLineItem where OpportunityId=:theOpp.Id];

        // Check if Opp has a pricebook associated yet
        if(theOpp.Pricebook2Id == null){
        //    Pricebook2[] activepbs = [select Id, Name from Pricebook2 where isActive = true limit 2];
        //    if(activepbs.size() == 2){
               forcePricebookSelection = true;
                theBook = new Pricebook2();
        //    }
        //    else{
        //        theBook = activepbs[0];
        //    }
        }
        else{
            theBook = theOpp.Pricebook2;
        }

        if(!forcePricebookSelection)
            {updateAvailableList();}

        init();
    }

    private void init(){
        this.adocaoConfirmada = false;
        this.displayPopup = false;
        this.visualizaCampos = false;
		
        Id tipoRegistro = RecordTypeMemory.getRecType('Opportunity', 'Oportunidade_de_Negocio_Pearson_English_EDU');
        this.visualizaBtnAdocao = theOpp.RecordTypeId == tipoRegistro;
        this.tROppNegPearsonEnglish = tipoRegistro;

        Id idTipoSolucoes = RecordTypeMemory.getRecType('Opportunity', 'Sample_Order_University');
        this.visualizaCampos = theOpp.RecordTypeId == idTipoSolucoes;
		this.recTypeSampleOrderUn = idTipoSolucoes;
    }

    // this is the 'action' method on the page
    public PageReference priceBookCheck(){

        // if the user needs to select a pricebook before we proceed we send them to standard pricebook selection screen
        if(forcePricebookSelection){
            return changePricebook();
        }
        //else{

            //if there is only one active pricebook we go with it and save the opp
        //    if(theOpp.pricebook2Id != theBook.Id){
        //        try{
                  theOpp.Pricebook2Id = theBook.Id;
                   update(theOpp);
        //        }
        //        catch(Exception e){
        //            ApexPages.addMessages(e);
        //        }
        //    }

            return null;
        //}
    }

    public String getChosenCurrency(){

        //if(multipleCurrencies)
        //    return (String)theOpp.get('CurrencyIsoCode');
        //else
            return '';
    }

    public Boolean getRenderiza(){
        //System.debug(theOpp.RecordType.Name);
        if(theOpp.RecordType.Name == 'Oportunidade de Negócio Pearson English EDU' ||
           theOpp.RecordType.Name == 'Sample Order - Languages' ||
           theOpp.RecordType.Name == 'Sample Order - University')
            return True;
        else
        	return False;
    }

    public Boolean getRecTypeInListGroup(){
        if('Oportunidade de Vendas - NAME Consultoria'.equals(theOpp.RecordType.Name) ||
                'Oportunidade de Vendas - NAME'.equals(theOpp.RecordType.Name) ||
                'Oportunidade de Retenção K12 NAME'.equals(theOpp.RecordType.Name) ||
				'Oportunidade de Upsell'.equals(theOpp.RecordType.Name)) {
            return true;
        } else {
            return false;
        }
    }
    public Boolean getIsOpSOUniversity(){
     //   if(theOpp.RecordType.Name == 'Sample Order - University')
         return True;
        //else
            return False;
    }

    public void updateAvailableList() {

        // We dynamically build a query string and exclude items already in the shopping cart
        String qString = 'select Id, Pricebook2Id, IsActive, Product2.Name, Product2.BR_segmento__c,Product2.Family, Product2.IsActive, Product2.Description, UnitPrice, Product2.BR_Nivel__c, Product2.BR_Edicao__c ,Product2.BR_Complemento__c, Product2.BR_Product_Code__c, Product2.BR_Author_name__c, Product2.BR_Produto_com_restricao__c, Product2.Sample_use_exclusive__c, Product2.BR_Flag_Bloqueado__c from PricebookEntry where IsActive=true and Product2.IsActive = true and Pricebook2Id = \'' + theBook.Id + '\'';
        //if(multipleCurrencies)
        //    qstring += ' and CurrencyIsoCode = \'' + theOpp.get('currencyIsoCode') + '\'';

        // note that we are looking for the search string entered by the user in the name OR description
        // modify this to search other fields if desired
        if(searchString!=null){
            qString+= ' and (Product2.Descricao_Concatenado__c like \'%' + searchString + '%\' or ProductCode like \'%' + searchString + '%\' or Product2.BR_Author_name__c like \'%' + searchString + '%\')';
            system.debug(qString);
        }

        Set<Id> selectedEntries = new Set<Id>();
        for(opportunityLineItem d:shoppingCart){
            selectedEntries.add(d.PricebookEntryId);
        }
        System.Debug('selectedEntries: ' + selectedEntries);
        System.Debug('RT Opp: ' + theOpp.RecordTypeId + ' RT: ' + this.tROppNegPearsonEnglish);
        if (theOpp.RecordTypeId != this.recTypeSampleOrderUn){
        	if(selectedEntries.size()>0){
	            String tempFilter = ' and Id not in (';
	            for(Id i : selectedEntries){
	                tempFilter+= '\'' + (String)i + '\',';
	            }
	            String extraFilter = tempFilter.substring(0,tempFilter.length()-1);
	            extraFilter+= ')';

	            qString+= extraFilter;
	        }
        }

        qString+= ' order by Product2.Name';
        qString+= ' limit 101';

        //system.debug('qString:' +qString);        
        AvailableProducts = database.query(qString);

        // We only display up to 100 results... if there are more than we let the user know (see vf page)
        if(AvailableProducts.size()==101){
            AvailableProducts.remove(100);
            overLimit = true;
        }
        else{
            overLimit=false;
        }
    }

    public void addToShoppingCart(){

        // This function runs when a user hits "select" button next to a product

        for(PricebookEntry d : AvailableProducts){
            Boolean exibeEstoque = getRenderiza();
            captura_estoque_SAP A = new captura_estoque_SAP();

            if((String)d.Id==toSelect){

        		if(exibeEstoque){
        			A.ISBN = d.Product2.BR_Product_Code__c;
    				A.Local_Estoque = (theopp.Cod_Local_do_Estoque__c == null? 'PE01' :  theopp.Cod_Local_do_Estoque__c);
        			A.parseJSONResponse();
        		}

				Id RTOppVendCOC   = RecordTypeMemory.getRecType('Opportunity', 'Sales_Opportunities_COC');
				Id RTOppVendPD    = RecordTypeMemory.getRecType('Opportunity', 'Sales_Opportunities_Pueri_Domus');
				Id RTOppVendDB    = RecordTypeMemory.getRecType('Opportunity', 'Sales_Opportunities_Dom_Bosco');
				Id RTOppVendA    = RecordTypeMemory.getRecType('Opportunity', 'Sales_Opportunities_Atitude');
                Id RTOppExES    = RecordTypeMemory.getRecType('Opportunity', 'Sales_Opportunities_Solutions');
                Id RTOppExES1    = RecordTypeMemory.getRecType('Opportunity', 'Oportunidade_de_Solu_o');

				//Adiciona as informações de desconto para oportunidade de vendas com base no valor que foi preenchido na oportunidade.
				if(theOpp.RecordTypeId == RTOppVendCOC || theOpp.RecordTypeId == RTOppVendPD || theOpp.RecordTypeId == RTOppExES || theOpp.RecordTypeId == RTOppExES1 ||theOpp.RecordTypeId == RTOppExES || theOpp.RecordTypeId == RTOppVendDB || theOpp.RecordTypeId == RTOppVendA){
					shoppingCart.add(new opportunityLineItem(OpportunityId=theOpp.Id, PriceBookEntry=d, PriceBookEntryId=d.Id, UnitPrice=d.UnitPrice, Discount=theOpp.BR_Desconto_1_ano__c));
				//Atualiza valor de estoque para ser exibida nos pedidos de amostra.
				}else if (exibeEstoque){
					shoppingCart.add(new opportunityLineItem(OpportunityId=theOpp.Id, PriceBookEntry=d, PriceBookEntryId=d.Id, UnitPrice=d.UnitPrice, QtdDisp__c=A.Qtd));
				//Casos que não se enquadram nas regras acima.
				}else{
					shoppingCart.add(new opportunityLineItem(OpportunityId=theOpp.Id, PriceBookEntry=d, PriceBookEntryId=d.Id, UnitPrice=d.UnitPrice));
				}
            }
        }

        updateAvailableList();
    }


    public PageReference removeFromShoppingCart(){

        // This function runs when a user hits "remove" on an item in the "Selected Products" section
if(toUnselect != null && shoppingCart!= null){
    if(shoppingCart.get(Integer.valueOf(toUnselect)) != null){
if(shoppingCart.get(Integer.valueOf(toUnselect)).Id != null){
			forDeletion.add(shoppingCart.get(Integer.valueOf(toUnselect)));
}
				shoppingCart.remove(Integer.valueOf(toUnselect));
			}
		}

			
        updateAvailableList();

        return null;
    }

    public PageReference onSave(){

		system.debug('onsave!');

		system.debug('theOpp.BR_Distribuidor__c ' + theOpp.BR_Distribuidor__c);
		system.debug('theOpp.BR_Compras_atraves_de__c ' + theOpp.BR_Compras_atraves_de__c);
		//if (theOpp.RecordType.Name == 'Oportunidade de Negócio Pearson English EDU'){
			//for(opportunityLineItem oppLine :shoppingCart){
			//	oppLine.N_Alunos__c = oppLine.Quantity;  
			//}
		//}

		

        // If previously selected products are now removed, we need to delete them
        if(forDeletion.size()>0)
            delete(forDeletion);

        // Previously selected products may have new quantities and amounts, and we may have new products listed, so we use upsert here
        try{
            if(shoppingCart.size()>0)
                upsert(shoppingCart);

            //if(theOpp != null)
            //    upsert(theOpp);


            if(this.adocaoConfirmada)
            {
                system.debug('this.adocaoConfirmada onsave!');
                theOpp.BR_ConfirmarAdocao__c = true;
                theOpp.StageName = 'Adoção Realizada';
                upsert(theOpp);
                system.debug('obj oportunidade atualizada: ' + JSON.serialize(theOpp));
            }
            else
            {
                if(theOpp != null)
                    upsert(theOpp);

            }
        }
        catch(Exception e){
            System.debug('deu exception: ');

            System.debug('ERRO: ' + e.getStackTraceString() + 'LINHA: ' + e.getLineNumber() + 'MSG: ' + e.getMessage());

            displayPopup = false;
            ApexPages.addMessages(e);
            return null;
        }

        String priceBookId = PricebookDAO.getInstance().findByName('Ensino Superior').Id;

       	if(theOpp.pricebook2Id == priceBookId){
        	return new PageReference('/apex/createDisciplinePage?oppId=' + ApexPages.currentPage().getParameters().get('Id'));
        }else{
        	return new PageReference('/' + ApexPages.currentPage().getParameters().get('Id'));
        }
    }

    public PageReference onCancel(){

        // If user hits cancel we commit no changes and return them to the Opportunity   
        return new PageReference('/' + ApexPages.currentPage().getParameters().get('Id'));
    }

    public PageReference sim(){

        try {
            this.adocaoConfirmada = true;
            return onSave();
        }
       catch(Exception e){
          ApexPages.addMessages(e);
           displayPopup = false;
            return null;
        }
    }

    public void closePopup() {
        displayPopup = false;
    }
    public void showPopup() {
  
		//	if (theOpp.BR_Compras_atraves_de__c == 'Distribuidor'){
				//if (theOpp.BR_Distribuidor__c == null ){
		         //  displayPopup = false;
	    		//	ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.INFO, 'Se quiser Confirmar a adoção deve preencher o campo "Distribuidor"'));
               // }
				//else{
					//upsert(theOpp);
				    Boolean quantidadeOk = true;
		
			       // for(opportunityLineItem item : shoppingCart){
			
			         //   system.debug('item.Quantity ' + item.Quantity);
			           // if(item.Quantity == null){
			             //   quantidadeOk = false;
			               // break;
			            //}
			        //}
			
			        displayPopup = quantidadeOk;
/*
			        try {
			            if(!quantidadeOk){
			                upsert(shoppingCart);
			                system.debug('teste atualizou campo');
			            }
			            else{
			                displayPopup = quantidadeOk;
			            }
			        }
			        catch(Exception e) {
			            displayPopup = false;
			            ApexPages.addMessages(e);
			        }
				*/	
				//}
			

    		
            
    }

    public PageReference changePricebook(){

        // This simply returns a PageReference to the standard Pricebook selection screen
        // Note that is uses retURL parameter to make sure the user is sent back after they choose

        PageReference ref = new PageReference('/oppitm/choosepricebook.jsp');
        ref.getParameters().put('id',theOpp.Id);
        ref.getParameters().put('retURL','/apex/opportunityProductEntry?id=' + theOpp.Id);

        return ref;
    }
}