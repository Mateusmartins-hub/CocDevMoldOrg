@IsTest
public with sharing class OpportunityLineItemCheckTest {

    @isTest
    static void checkForAmostraAutorizadaTest() {

        User userToRun = [
            SELECT Id FROM User WHERE Profile.Name LIKE '%admin%' AND ManagerId != null AND isActive = true LIMIT 1
        ];

        System.runAs(userToRun){
                
            Opportunity opp = TestHelper.createOpportunity();
            opp.RecordTypeId  = OpportunityStagesCheck.RECORD_TYPE_OPORTUNIDADE_SETOR_PRIVADO;
            opp.StageName = 'Contato Inicial - Vendas';
            opp.Probability = 5;
            insert opp;

            Test.setMock(HttpCalloutMock.class, new MockCapturaSAP());
            OpportunityLineItem item = TestHelper.createOpportunityLineItem();
            item.OpportunityId = opp.Id;
            try {
                insert item;
                //System.assert(false);
            } catch(Exception err) {
                System.debug(err.getMessage());            
            }
        }
    }
}