@isTest(SeeAllData = true)
private class SimuladorComercialTest {
	static testMethod void myUnitTest() {

        User userToRun = [
            SELECT Id FROM User WHERE Profile.Name LIKE '%admin%' AND ManagerId != null AND isActive = true LIMIT 1
        ];

        System.runAs(userToRun){
            Pricebook2 prc = [select id from Pricebook2 where IsStandard = true limit 1];
            
            Product2 prd = new Product2(
                        Name = 'Test Class Product2 Name'
            );
            insert prd;
            
            PricebookEntry prcEntry = new PricebookEntry(
                Pricebook2Id = prc.id,
                Product2Id = prd.Id,
                UnitPrice = 10,
                IsActive = true,
                UseStandardPrice = false
            );
            insert prcEntry;
            
            Account acc = new Account(
                        RecordTypeID =  RecordTypeMemory.getRecType( 'Account', 'Academic_Account'),
                        Name = 'Test Class Account Name'
            );
            insert acc;
            
            Opportunity opp = new Opportunity(
                        RecordTypeId = RecordTypeMemory.getRecType( 'Opportunity', 'Sales_Opportunities_COC' ),
                        AccountId = acc.Id,
                        Pricebook2Id = prc.Id,
                        Name = 'Test Class Opp Name',
                        StageName = 'Interesse Inicial',
                        CloseDate = System.Today(),
                        BR_Imprimir_Proposta_Comercial_K12__c = true
            );
            opp.Description = 'Teste';
            insert opp;
            update opp;
            
            OpportunityLineItem oppLI = new OpportunityLineItem(
                        OpportunityId = opp.Id,
                        PricebookEntryId = prcEntry.Id,
                        Quantity = 5,
                        TotalPrice = 50
            );
            insert oppLI;
            update opp;	//Teste da trigger OpportunityTrigger
            
            ApexPages.currentPage().getParameters().put('id', opp.Id);
            SimuladorComercialController SimCom = new SimuladorComercialController();
            
            Boolean ExibeAjustNeg = SimCom.getExibeAjusteNEG();
            Boolean ExibeAjustPos = SimCom.getExibeAjustePOS();
            Boolean bloqBtn = SimCom.getBloqueiaBotao();
            
            PageReference carregarPrd = SimCom.carregarProdutos();
            PageReference salvar = SimCom.salvar();
            PageReference addPrd = SimCom.addProdutos();
            PageReference fechar = SimCom.fechar();
            
            opp.BR_Desconto_1_ano__c = 1;
            opp.BR_Desconto_2_ano__c = 2;
            opp.BR_Desconto_3_ano__c = 3;
            opp.BR_Desconto_4_ano__c = 4;
            opp.BR_Desconto_5_ano__c = 5;
            opp.BR_Ano_Inicio_do_contrato__c = '2015';
            opp.BR_Vigencia_do_contrato_anos__c = '03';
            opp.Description = 'Teste';
            
            update opp;
            
            ApexPages.StandardController sc = new ApexPages.StandardController(opp); 
            SimuladorComercialReportController SimComReport = new SimuladorComercialReportController(sc);
            
            String tiporeport = SimComReport.getTipoReport();
            List<SimuladorComercialReportController.ErrorMessage> erroMsg = SimComReport.getErroMsg();
            List<SimuladorComercialReportController.Data> desconto = SimComReport.getDesconto();
        }
    }
}