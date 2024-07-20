@isTest
public class AgendamentoVisitaConsultorControllerTest {
    
    @testSetup
    public static void testSetup() {
        Account ac = new Account();
        ac.Name = 'test account';
        ac.BR_Account_email__c = 'email@email.com';
        insert ac;
        
        User man = new User(
            ProfileId = [SELECT Id FROM Profile WHERE Name = 'System Administrator' OR Name = 'Administrador do Sistema'].Id,
            LastName = 'Test',
            Email = 'test@test.com',
            Username = 'test@test.com' + System.currentTimeMillis(),
            CompanyName = 'Test',
            Title = 'Test',
            Alias = 'Test',
            TimeZoneSidKey = 'America/Los_Angeles',
            EmailEncodingKey = 'UTF-8',
            LanguageLocaleKey = 'en_US',
            LocaleSidKey = 'en_US'
        );
        insert man;
        
        User u = new User(
            ProfileId = [SELECT Id FROM Profile WHERE Name = 'System Administrator' OR Name = 'Administrador do Sistema'].Id,
            LastName = 'Test',
            Email = 'test@test.com',
            Username = 'test@test.com' + System.currentTimeMillis(),
            CompanyName = 'Test',
            Title = 'Test',
            Alias = 'Test',
            TimeZoneSidKey = 'America/Los_Angeles',
            EmailEncodingKey = 'UTF-8',
            LanguageLocaleKey = 'en_US',
            LocaleSidKey = 'en_US',
            ManagerId = man.Id
        );
        insert u;
        
        System.runAs(u) {
            Opportunity op = new Opportunity();
            op.AccountId = ac.Id;
            op.Name = 'Test'; 
            op.StageName = 'Visita Inicial'; 
            op.CloseDate = System.today().addDays(7);
            op.RecordTypeId = Schema.SObjectType.Opportunity.getRecordTypeInfosByDeveloperName().get('OportunidadeDeVendasSetorPrivado').getRecordTypeId();
            insert op;          
            
            Lead l = new Lead();
            l.Email = 'test@test.com';
            l.LastName = 'Test';
            l.Company = 'Test';
            l.LigacaoRealizada__c = true;
            insert l;
        }
    }
    
    @isTest
    public static void testOne() {
        AgendamentoVisitaConsultorController.getObject([SELECT Id FROM Lead].Id);
        AgendamentoVisitaConsultorController.getObject([SELECT Id FROM Opportunity].Id);
    }
    
    @isTest
    public static void testTwo() {
        Opportunity op = [SELECT Id FROM Opportunity][0];
        SugestaoVisita__c sug1 = new SugestaoVisita__c();
        sug1.Data1__c = Date.today().addDays(2);
        sug1.Data2__c = Date.today().addDays(3);
        sug1.Data3__c = Date.today().addDays(4);
        sug1.HoraInicialSugerida__c = Time.newInstance(8, 0, 0, 0);
        sug1.HoraFinalSugerida__c = Time.newInstance(11, 0, 0, 0);
        sug1.Oportunidade__c = op.Id;
        sug1.TipoVisita__c = 'Visita de Expansão';
        insert sug1;
        
        AgendamentoVisitaConsultorController.getObject(op.Id);
    }
    
    @isTest
    public static void testThree() {
        Lead ld = [SELECT Id FROM Lead][0];
        SugestaoVisita__c sug1 = new SugestaoVisita__c();
        sug1.Data1__c = Date.today().addDays(2);
        sug1.Data2__c = Date.today().addDays(3);
        sug1.Data3__c = Date.today().addDays(4);
        sug1.HoraInicialSugerida__c = Time.newInstance(8, 0, 0, 0);
        sug1.HoraFinalSugerida__c = Time.newInstance(11, 0, 0, 0);
        sug1.Lead__c = ld.Id;
        sug1.TipoVisita__c = 'Visita de Expansão';
        insert sug1;
        
        AgendamentoVisitaConsultorController.getObject(ld.Id);
    }
    
    @isTest
    public static void testFour() {
        Lead ld = [SELECT Id FROM Lead][0];
        SugestaoVisita__c sug1 = new SugestaoVisita__c();
        sug1.Data1__c = Date.today().addDays(2);
        sug1.Data2__c = Date.today().addDays(3);
        sug1.Data3__c = Date.today().addDays(4);
        sug1.HoraInicialSugerida__c = Time.newInstance(8, 0, 0, 0);
        sug1.HoraFinalSugerida__c = Time.newInstance(11, 0, 0, 0);
        sug1.Lead__c = ld.Id;
        sug1.TipoVisita__c = 'Visita de Expansão';
        insert sug1;
        
        AgendamentoVisitaConsultorController.Objeto obj = AgendamentoVisitaConsultorController.getObject(ld.Id);
        AgendamentoVisitaConsultorController.saveSugestionsAndSendEmail(obj, 'VisitaExpansao');
    }    
    
    @isTest
    public static void testFive() {
        Opportunity opp = [SELECT Id FROM Opportunity][0];
		Account acc = TestHelper.createAccount();
        insert acc;
        
        opp.AccountId = acc.Id;
        update opp;
            
        AgendamentoVisitaConsultorController.Objeto obj = AgendamentoVisitaConsultorController.getObject(opp.Id);        
    } 
}