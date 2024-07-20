@isTest
public class LeadDAOTest {

    @testSetup
    public static void testSetup() {
        List<Lead> leadList = new List<Lead>();

        for (Integer i = 0; i <= 10; i++){
            Lead ld = TestHelper.createLead();
            leadList.add(ld);
        }

        insert leadList;        
    }
    @isTest
    public static void BuscaLeadTest() {
        Lead ld  = [SELECT Id FROM Lead LIMIT 1];        
        Lead leadResult = LeadDAO.BuscaLead(ld.Id);

        System.assertEquals(ld.Id, leadResult.Id);
    }

    @IsTest
    static void BuscarLeadsTest() {
        List<Lead> allLeads = [SELECT ID From Lead];
        Set<Id> leadIds  = new Set<Id>();

        for (Lead ld : allLeads){
            leadIds.add(ld.Id);
        }

        List<Lead> resultLeads = LeadDAO.BuscarLeads(leadIds);

        System.assertEquals(allLeads.size(), resultLeads.size());
    }

        @IsTest
    static void BuscarLeadPorIdTest() {
        List<Lead> allLeads = [SELECT ID From Lead];
        

        Lead resultLead = LeadDAO.BuscaApenasLeadPorId(allLeads[0].Id);

        System.assert(resultLead != null);
    }



    
}