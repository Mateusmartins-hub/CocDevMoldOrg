@isTest(SeeAllData = true)
private class opportunityProductEntryExtensionTest {

    static testMethod void myUnitTest() {

		User userToRun = [
            SELECT Id FROM User WHERE Profile.Name LIKE '%admin%' AND ManagerId != null AND isActive = true LIMIT 1
        ];

        System.runAs(userToRun){
				
			//Create a custom pricebook
			Pricebook2 pb = [select id from Pricebook2 where IsStandard = true limit 1];
			Id tipoRegistro = RecordTypeMemory.getRecType('Opportunity', 'Sales_Opportunities_Dom_Bosco');
			Product2 prd = new Product2(Name = 'Teste Product');
			insert prd;
			
			PricebookEntry pbe = new PricebookEntry();
			pbe.UnitPrice = 10;
			pbe.IsActive = true;
			pbe.UseStandardPrice = false;
			pbe.Pricebook2Id = pb.Id;
			pbe.Product2Id = prd.Id;
			insert pbe;
			
			Opportunity opp = new opportunity(name = 'Teste Opp');
			opp.StageName = 'Elaboração';
				opp.RecordTypeId = tipoRegistro;
			opp.CloseDate = System.Today();
			opp.Pricebook2Id = pb.Id;
			opp.Description = 'TESTE';
			opp.BR_Compras_atraves_de__c='Distribuidor';
			opp.BR_PrevisaoCompra__c=null;
			insert opp;
			
			OpportunityLineItem oppLi = new OpportunityLineItem(
				PriceBookEntryId=pbe.Id, 
				OpportunityId=opp.Id, 
				Quantity=1,
				TotalPrice=99);
	
			
			insert oppLi;
			
			ApexPages.StandardController sc = new ApexPages.StandardController(opp); 
			opportunityProductEntryExtension oppPEE = new opportunityProductEntryExtension(sc);
			
			oppPEE.searchString = 'Teste';
			oppPEE.addToShoppingCart();
			oppPEE.removeFromShoppingCart();
			oppPEE.getChosenCurrency();
			oppPEE.getIsOpSOUniversity();
			oppPEE.getRecTypeInListGroup();
			oppPEE.getRenderiza();
			oppPEE.changePricebook();
			oppPEE.priceBookCheck();
			oppPEE.onCancel();
			oppPEE.onSave();
		}

    }
    
     static testMethod void myUnitTest2() {

		User userToRun = [
            SELECT Id FROM User WHERE Profile.Name LIKE '%admin%' AND ManagerId != null AND isActive = true LIMIT 1
        ];

        System.runAs(userToRun){
				
			Id tipoRegistro = RecordTypeMemory.getRecType('Opportunity', 'Oportunidade_de_Solu_o');

			Pricebook2 pb = [select id from Pricebook2 where IsStandard = true limit 1];
			
			Product2 prd = new Product2(Name = 'Teste Product');
			insert prd;
		
			PricebookEntry pbe = new PricebookEntry();
			pbe.UnitPrice = 10;
			pbe.IsActive = true;
			pbe.UseStandardPrice = false;
			pbe.Pricebook2Id = pb.Id;
			pbe.Product2Id = prd.Id;
			insert pbe;
			
			Opportunity opp = new opportunity(name = 'Teste Opp');
			opp.StageName = 'Elaboração';
			opp.CloseDate = System.Today();
			opp.Pricebook2Id = pb.Id;
			opp.Description = 'TESTE';
			opp.BR_Compras_atraves_de__c='Distribuidor';
			opp.BR_PrevisaoCompra__c=null;
			opp.BR_Desconto_EM_2_Ano__c=12;
			opp.Desconto_PV__c =12;
			insert opp;
			
			OpportunityLineItem oppLi = new OpportunityLineItem(PriceBookEntryId=pbe.Id, OpportunityId=opp.Id, Quantity=1, TotalPrice=99);
			insert oppLi;
			
			ApexPages.StandardController sc = new ApexPages.StandardController(opp); 
			opportunityProductEntryExtension oppPEE = new opportunityProductEntryExtension(sc);
			
			oppPEE.searchString = 'Teste';
			oppPEE.addToShoppingCart();
			oppPEE.removeFromShoppingCart();
			oppPEE.getChosenCurrency();
			oppPEE.getRenderiza();
			oppPEE.changePricebook();
			oppPEE.priceBookCheck();
			oppPEE.onCancel();
			oppPEE.onSave();
		}
     }

	static testmethod  void complementoController(){

		User userToRun = [
            SELECT Id FROM User WHERE Profile.Name LIKE '%admin%' AND ManagerId != null AND isActive = true LIMIT 1
        ];

			System.runAs(userToRun){

			Id tipoRegistro = RecordTypeMemory.getRecType('Opportunity', 'Sample_Order_University');

			Pricebook2 pb = [select id from Pricebook2 where IsStandard = true limit 1];

			Opportunity opp = new opportunity(name = 'Teste Opp');
			opp.RecordTypeId = tipoRegistro;
			opp.StageName = 'Elaboração';
			opp.CloseDate = System.Today();
			opp.Description = 'TESTE';
			opp.Pricebook2Id = pb.Id;
			insert opp;

			ApexPages.StandardController sc = new ApexPages.StandardController(opp);
			opportunityProductEntryExtension controller = new opportunityProductEntryExtension(sc);

			controller.searchString = 'Teste';
			controller.Total = 0.00;
			controller.getRenderiza();
			controller.updateAvailableList();
			controller.theOpp.RecordTypeId = tipoRegistro;
			controller.addToShoppingCart();
			controller.sim();
			controller.closePopup();
			controller.showPopup();
		}
	}
    /*
    static testmethod  void testetres(){

		Id tipoRegistro = RecordTypeMemory.getRecType('Opportunity', 'Sales_Opportunities_COC');
        	
        Id RTOppExCOC   = RecordTypeMemory.getRecType('Opportunity', 'Sales_Extension_COC');
		

		Pricebook2 pb = [select id from Pricebook2 where IsStandard = true limit 1];

		Opportunity opp = new opportunity(name = 'Teste Opp3');
		opp.RecordTypeId = tipoRegistro;
		opp.StageName = 'Elaboração';
		opp.CloseDate = System.Today();
		opp.Description = 'TESTE';
		opp.Pricebook2Id = pb.Id;
         opp.BR_Compras_atraves_de__c='Distribuidor';
        OPP.BR_Distribuidor__c=null;
        opp.BR_PrevisaoCompra__c=null;
        
		insert opp;
        
        
        Opportunity opp1 = new opportunity(name = 'Teste Opp4');
		opp1.RecordTypeId = RTOppExCOC;
		opp1.StageName = 'Elaboração';
		opp1.CloseDate = System.Today();
		opp1.Description = 'TESTE';
		opp1.Pricebook2Id = pb.Id;
         opp1.BR_Compras_atraves_de__c='Distribuidor';
        OPP1.BR_Distribuidor__c=null;
        opp1.BR_PrevisaoCompra__c=null;
         insert opp1;
        
        
         	PricebookEntry pbe = new PricebookEntry();
    	pbe.UnitPrice = 10;
    	pbe.IsActive = true;
    	pbe.UseStandardPrice = false;
    	pbe.Pricebook2Id = pb.Id;
         pbe.Product2Id = pb.Id;
        insert pbe;
        
      	OpportunityLineItem oppLi = new OpportunityLineItem(
            PriceBookEntryId=pbe.Id, 
            OpportunityId=opp.Id, 
            Quantity=1,
            TotalPrice=99);

    	
	
        	//OpportunityLineItem oppLi = new OpportunityLineItem(OpportunityId=opp.Id, Quantity=1, TotalPrice=99);
		//insert oppLi;
    	
      
		//ApexPages.StandardController sc = new ApexPages.StandardController(opp);
//opportunityProductEntryExtension controller = new opportunityProductEntryExtension(sc);

		//controller.searchString = 'Teste';
//		controller.Total = 0.00;
//controller.getRenderiza();
		//controller.updateAvailableList();
//controller.theOpp.RecordTypeId = tipoRegistro;
//		controller.sim();
//controller.closePopup();
//controller.showPopup();
}	
*/
}