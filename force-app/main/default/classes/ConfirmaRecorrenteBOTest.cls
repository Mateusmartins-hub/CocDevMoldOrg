@IsTest
public class ConfirmaRecorrenteBOTest {
    @TestSetup
    static void makeData(){

        User userToRun = [
    		SELECT Id FROM User WHERE Profile.Name LIKE '%admin%' AND ManagerId != null AND isActive = true LIMIT 1
		];

		System.runAs(userToRun){
                
            Opportunity opp = TestHelper.createOpportunity();
            insert opp;

            Test.setMock(HttpCalloutMock.class, new MockCapturaSAP());
            OpportunityLineItem prod = TestHelper.createOpportunityLineItem();
            prod.OpportunityId = opp.Id;
            prod.Recorrente__c = true;
            insert prod;
        }
    }

    @IsTest
    static void processaOportunidadeTest() {
        AdocaoRecorrente__c adocao = new AdocaoRecorrente__c();
        adocao.OportunidadeAntiga__c = [SELECT Id FROM Opportunity LIMIT 1][0].Id;
        
        List<AdocaoRecorrente__c> listAdocoes = new List<AdocaoRecorrente__c>{adocao};
        
        ConfirmaRecorrenteBO.getInstance().processaOportunidade(listAdocoes);
    }

}