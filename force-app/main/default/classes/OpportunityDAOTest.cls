@isTest
private class OpportunityDAOTest {

    static testMethod void myUnitTest() {
        User userToRun = [
            SELECT Id FROM User WHERE Profile.Name LIKE '%admin%' AND ManagerId != null AND isActive = true LIMIT 1
        ];

        System.runAs(userToRun){
            Opportunity op = TestHelper.CreateOpportunity();
            insert op;
        
            List<String> lListStr = new List<String>();
            Set<String> setStr = new Set<String>();
        
            OpportunityDAO.getListOppById(lListStr, setStr);
            OpportunityDAO.getListOppById(lListStr);
            OpportunityDAO.buscaProdutoEmailOportunidade(op.Id);
            OpportunityDAO.listarQuery('SELECT Id FROM Opportunity LIMIT 1');
            OpportunityDAO.buscaOportunidade(op.Id);
            OpportunityDAO.BuscarOportunidades(new Set<Id>{});
        }
    }

    @IsTest
    static void getOpportunitiesByEventIdAndRecordTypeTeste() {

        User userToRun = [
            SELECT Id FROM User WHERE Profile.Name LIKE '%admin%' AND ManagerId != null AND isActive = true LIMIT 1
        ];

        System.runAs(userToRun){
            Opportunity opp = TestHelper.createOpportunity();
            opp.RecordTypeId =  OpportunityStagesCheck.RECORD_TYPE_OPORTUNIDADE_SETOR_PRIVADO;
            insert opp;
            

            Event evt = TestHelper.createEvent();        
            evt.WhatId = opp.id;
            evt.RecordTypeID = EventCheck.RECORD_TYPE_VISITA_PEDAGOGICA;
            insert evt;
            
            List<Id> oppId = new List<Id>();
            oppid.add(evt.WhatId);
            
            List<Opportunity> relatedOpportunities = OpportunityDAO.getOpportunitiesByEventIdAndRecordType(oppId, OpportunityStagesCheck.RECORD_TYPE_OPORTUNIDADE_SETOR_PRIVADO);
            Opportunity relatedOpportunity = relatedOpportunities.get(0);
            
            System.assertEquals(evt.WhatId, relatedOpportunity.id);        
        }
    }
}