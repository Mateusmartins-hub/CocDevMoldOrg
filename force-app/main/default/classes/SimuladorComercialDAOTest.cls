@IsTest
public with sharing class SimuladorComercialDAOTest {

    @TestSetup
    static void makeData(){

        User userToRun = [
            SELECT Id FROM User WHERE Profile.Name LIKE '%admin%' AND ManagerId != null AND isActive = true LIMIT 1
        ];

        System.runAs(userToRun){

            Opportunity opp = TestHelper.createOpportunity();
            insert opp;

            Product2 prdt = TestHelper.createProduct();
            insert prdt;

            Simulador_Comercial__c sc = new Simulador_Comercial__c();
            sc.Oportunidade__c = opp.id;
            sc.Produto__c = prdt.id;
            insert sc;
        }
    }

    @IsTest
    static void getSimulationRelatedToOpportunitiesTest(){
        Opportunity opp = [SELECT Id FROM Opportunity];

        Set<Id> oppId = new Set<Id>();
        oppId.add(opp.Id);

        List<Simulador_Comercial__c> relatedSimulations = SimuladorComercialDAO.getSimulationRelatedToOpportunities(oppId);
        Simulador_Comercial__c relatedSimulation = relatedSimulations.get(0);

        System.assertEquals(relatedSimulation.Oportunidade__c, opp.Id);
    }

    @IsTest
    static void getItensByOppIdTest(){
        Opportunity opp = [SELECT Id FROM Opportunity];
        List<Simulador_Comercial__c> lstSc = SimuladorComercialDAO.getInstance().getItensByOppId(opp.Id);

        System.assertEquals(1, lstSc.size());
    }

    @IsTest
    static void getCountByOppPrdIdTest(){
        Opportunity opp = [SELECT Id FROM Opportunity];
        Product2 prdt = [SELECT Id FROM Product2];

        Integer totalSc = SimuladorComercialDAO.getInstance().getCountByOppPrdId(opp.Id, prdt.Id);

        System.assertEquals(1, totalSc);
    }

    @IsTest
    static void getSumCustoTotalByOppIdTest(){
        Opportunity opp = [SELECT Id FROM Opportunity];
        Product2 prdt = [SELECT Id FROM Product2];

        List<AggregateResult> result = SimuladorComercialDAO.getInstance().getSumCustoTotalByOppId(opp.Id);

        System.assertEquals(1, result.size());
    }

    @IsTest
    static void getSumReceitaTotalByOppIdTest(){
        Opportunity opp = [SELECT Id FROM Opportunity];
        Product2 prdt = [SELECT Id FROM Product2];

        List<AggregateResult> result = SimuladorComercialDAO.getInstance().getSumReceitaTotalByOppId(opp.Id);

        System.assertEquals(1, result.size());
    }

    @IsTest
    static void getSumLucroByOppIdTest(){
        Opportunity opp = [SELECT Id FROM Opportunity];
        Product2 prdt = [SELECT Id FROM Product2];

        List<AggregateResult> result = SimuladorComercialDAO.getInstance().getSumLucroByOppId(opp.Id);

        System.assertEquals(1, result.size());
    }

    @IsTest
    static void getSumSaldoTotalByOppIdTest(){
        Opportunity opp = [SELECT Id FROM Opportunity];
        Product2 prdt = [SELECT Id FROM Product2];

        List<AggregateResult> result = SimuladorComercialDAO.getInstance().getSumSaldoTotalByOppId(opp.Id);

        System.assertEquals(1, result.size());
    }
    
    @IsTest
    static void getSumFatPadraoByOppIdTest(){
        Opportunity opp = [SELECT Id FROM Opportunity];
        Product2 prdt = [SELECT Id FROM Product2];

        List<AggregateResult> result = SimuladorComercialDAO.getInstance().getSumFatPadraoByOppId(opp.Id);

        System.assertEquals(1, result.size());
    }

    @IsTest
    static void getSumFatDescontoByOppIdTest(){
        Opportunity opp = [SELECT Id FROM Opportunity];
        Product2 prdt = [SELECT Id FROM Product2];

        List<AggregateResult> result = SimuladorComercialDAO.getInstance().getSumFatDescontoByOppId(opp.Id);

        System.assertEquals(1, result.size());
    }
}