@isTest
public class RDStationIntegrationTest {

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
            opp.MarcaFranquias__c = 'Wizard';
            insert opp;
            
            Account acc = new Account();
            acc.Id = opp.AccountId;
            acc.Marca__c = 'Wizard';
            update acc;
            
            Test.setMock(HttpCalloutMock.class, new RDStationIntegrationMock());
            Test.startTest();
            RDStationIntegration.returnOppToLead(opp);
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
            opp.MarcaFranquias__c = 'Skill';
            insert opp;
            
            Account acc = new Account();
            acc.Id = opp.AccountId;
            acc.Marca__c = 'Skill';
            update acc;
            
            Test.setMock(HttpCalloutMock.class, new RDStationIntegrationMock());
            Test.startTest();
            RDStationIntegration.returnOppToLead(opp);
            Test.stopTest();
        }
    }
    
    @isTest
    static void testThree() {

        User userToRun = [
            SELECT Id FROM User WHERE Profile.Name LIKE '%admin%' AND ManagerId != null AND isActive = true LIMIT 1
        ];

        System.runAs(userToRun){

            Opportunity opp = TestHelper.createOpportunity();
            opp.MarcaFranquias__c = 'Yázigi';
            insert opp;
            
            Account acc = new Account();
            acc.Id = opp.AccountId;
            acc.Marca__c = 'Yázigi';
            update acc;
            
            Test.setMock(HttpCalloutMock.class, new RDStationIntegrationMock());
            Test.startTest();
            RDStationIntegration.returnOppToLead(opp);
            Test.stopTest();
        }
    }
    
    @isTest
    static void testFour() {
        Test.setMock(HttpCalloutMock.class, new RDStationIntegrationMock());
        Test.startTest();
        RDStationTokensIntegration.getTokenAndGetCustomSettingsSkill();
        RDStationTokensIntegration.getTokenAndGetCustomSettingsWizard();
        RDStationTokensIntegration.getTokenAndGetCustomSettingsYazigi();
        Test.stopTest();
    }
}