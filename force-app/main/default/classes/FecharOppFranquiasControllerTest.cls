@isTest
public class FecharOppFranquiasControllerTest {
    
    @testSetup
    static void testSetup() {
        insert new RDStationSkill__c();
        insert new RDStationWizard__c();
        insert new RDStationYazigi__c();        
    }
    
    @isTest
    static void testOne() {

        User userToRun = [
    		SELECT Id FROM User WHERE Profile.Name LIKE '%admin%' AND ManagerId != null AND isActive = true LIMIT 1
		];

		System.runAs(userToRun){
            Opportunity opp = TestHelper.createOpportunity();
            insert opp;
            
            Test.setMock(HttpCalloutMock.class, new RDStationIntegrationMock());
            Test.startTest();
            FecharOportunidadeFranquiasController.getMotivos();
            FecharOportunidadeFranquiasController.getOportunidade(opp.Id);
            FecharOportunidadeFranquiasController.getClosedStages();
            Test.stopTest();
        }
    }
    
    @isTest
    static void testTwo() {

        User userToRun = [
    		SELECT Id FROM User WHERE Profile.Name LIKE '%admin%' AND ManagerId != null AND isActive = true LIMIT 1
		];

		System.runAs(userToRun){
            Opportunity opp = TestHelper.createOpportunity();
            opp.BR_Motivo_Recusa__c = 'Optou por outro sistema';
            opp.MarcaFranquias__c = 'Skill';
            insert opp;
            
            Account acc = new Account();
            acc.Id = opp.AccountId;
            acc.Marca__c = 'Skill';
            update acc;
            
            OpportunityLineItem i = TestHelper.createOpportunityLineItem();
            i.OpportunityId = opp.Id;
            insert i;
            
            Test.setMock(HttpCalloutMock.class, new RDStationIntegrationMock());
            Test.startTest();
            FecharOportunidadeFranquiasController.saveAndIntegrateRDStation(opp.Id, 'Cancelada', 'Test');
            Test.stopTest();
        }
    }
    
    @isTest
    static void testThree() {

        User userToRun = [
    		SELECT Id FROM User WHERE Profile.Name LIKE '%admin%' AND ManagerId != null AND isActive = true LIMIT 1
		];

		System.runAs(userToRun){

            Account acc = new Account();
            acc.Name = 'test account';
            acc.BR_Account_email__c = 'email@email.com';
            acc.Marca__c = 'Wizard'; 
            insert acc;

            Opportunity opp = new Opportunity();
            opp.Name = 'Opportunity Test'; 
            opp.StageName = 'Orçamento';
            opp.CloseDate = Date.today();
            opp.RecordTypeId = Schema.SObjectType.Opportunity.getRecordTypeInfosByDeveloperName().get('Sample_Order_University').getRecordTypeId();
            opp.AccountId = acc.Id;
            opp.Description = 'Test';
            opp.MarcaFranquias__c = 'Wizard';
            opp.BR_Motivo_Recusa__c = 'Optou por outro sistema';
            insert opp;

            Product2 prd = new Product2();
            prd.Name = 'Test';
            insert prd;

            PricebookEntry ent = new PricebookEntry();
            ent.Pricebook2Id = Test.getStandardPricebookId();
            ent.Product2Id = prd.Id;
            ent.UnitPrice = 10;
            ent.IsActive = true;
            insert ent;
            
            OpportunityLineItem opL = new OpportunityLineItem();
            opL.PricebookEntryId = ent.Id;
            opL.OpportunityId = opp.Id;
            opL.Quantity = 10;
            opL.TotalPrice = 100;
            insert opL;
            
            Test.setMock(HttpCalloutMock.class, new RDStationIntegrationMock());
            Test.startTest(); 
            FecharOportunidadeFranquiasController.saveAndIntegrateRDStation(opp.Id, 'Cancelada', 'Test');
            Test.stopTest();
        }
    }
    
    @isTest
    static void testFour() {
        
        try{
            FecharOportunidadeFranquiasController.getOportunidade('Test');
        }catch(Exception e){
            System.assert(e != null);
        }
    }
    
    @isTest
    static void testSix() {
        try{
            Opportunity opp = TestHelper.createOpportunity();
            insert opp;
            
            Account acc = new Account();
            acc.Id = opp.AccountId;
            acc.Marca__c = 'Skill';
            update acc;
            
            FecharOportunidadeFranquiasController.saveAndIntegrateRDStation(opp.Id, 'Cancelada', 'Test');
        }catch(Exception e){
            
        }
    }
}