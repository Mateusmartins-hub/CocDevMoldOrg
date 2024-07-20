@isTest
public with sharing class ProximidadeVisitaJobTest {
    @isTest
    static void testOne() {
        
        SugestaoVisita__c visita = new SugestaoVisita__c();
        visita.DataConfirmada__c = Date.today();
        visita.Data1__c = Date.today();
        visita.Data2__c = Date.today() + 1;
        visita.Data3__c = Date.today() + 2;
        visita.DataConfirmada__c = Date.today() + 2;

        Lead lead = TestHelper.createLead();
        lead.Email = 'email@email.com';
        insert lead;
        visita.Lead__c = lead.Id;
        insert visita;

        Test.StartTest();
        ProximidadeVisitaJob sh1 = new ProximidadeVisitaJob();
        
        String sch = '0 11 * * * ?'; 
        //ProximidadeVisitaJob.scheduleIt(); 
        system.schedule('Consulta_Proximidade_Visita - ' + System.now(), sch, sh1); 
        VerificaProximidadeVisita.estaProxima();
        Test.stopTest();
    }
}