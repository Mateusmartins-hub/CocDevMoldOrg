@isTest
public class Lead_StatusTest {

    @isTest
    public static void testOne() {
        Lead l = new Lead();
        l.LastName = 'Test';
        l.Company = 'Test';
        l.LeadSource = 'Contato Direto';
        
        Lead_Status.popularStatusConformeOrigem(new List<Lead>{l});
    }

    @isTest
    public static void testTwo() {
        Lead l = new Lead();
        l.LastName = 'Test';
        l.Company = 'Test';
        l.LeadSource = 'Recomendação';
        
        Lead_Status.popularStatusConformeOrigem(new List<Lead>{l});
    }

    @isTest
    public static void testThree() {
        Lead l = new Lead();
        l.LastName = 'Test';
        l.Company = 'Test';
        l.LeadSource = 'Recomendação';
        l.Status = 'Aberto';
        insert l;
		
        l.TipoPessoa__c = 'Pessoa Física';
        l.Status = 'Qualificado';
        
        Lead_Status.validarStatus(new List<Lead>{l}, new Map<Id, Lead>(new List<Lead>{l}));
    }

    @isTest
    public static void testFour() {
        Lead l = new Lead();
        l.LastName = 'Test';
        l.Company = 'Test';
        l.LeadSource = 'Contato Direto';
        l.LigacaoRealizada__c = true;                

        l = new Lead();
        l.LastName = 'Test';
        l.Company = 'Test';
        l.LeadSource = 'Contato Direto';
        l.LigacaoRealizada__c = false;
        insert l;
        l.LigacaoRealizada__c = true;
        update l;        
    }
}