@isTest
public class AgendamentoVisitaControllerTest {
    
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
            
            SugestaoVisita__c sug1 = new SugestaoVisita__c();
            sug1.Oportunidade__c = op.Id;
            sug1.Data1__c = Date.today().addDays(2);
            sug1.Data2__c = Date.today().addDays(3);
            sug1.Data3__c = Date.today().addDays(4);
            sug1.TipoVisita__c = 'Visita de Expansão';
            insert sug1;
            
            Lead l = new Lead();
            l.Email = 'test@test.com';
            l.LastName = 'Test';
            l.Company = 'Test';
            insert l;
            
            SugestaoVisita__c sug2 = new SugestaoVisita__c();
            sug2.Lead__c = l.Id;
            sug2.Data1__c = Date.today().addDays(2);
            sug2.Data2__c = Date.today().addDays(3);
            sug2.Data3__c = Date.today().addDays(4);
            sug2.TipoVisita__c = 'Visita de Expansão';
            insert sug2;            
        }
    }
    
    @isTest
    public static void testOne() {
        Lead l = [SELECT Id FROM Lead][0];
        
        PageReference pageRef = Page.AgendamentoVisita;
        pageRef.getParameters().put('ld', String.valueOf(l.Id));
        Test.setCurrentPage(pageRef);
        
        AgendamentoVisitaController con = new AgendamentoVisitaController();
    }
    
    @isTest
    public static void testTwo() {
        Opportunity op = [SELECT Id FROM Opportunity][0];
        
        SugestaoVisita__c sug = [SELECT Id FROM SugestaoVisita__c WHERE Oportunidade__c =: op.Id];
        sug.DataConfirmada__c = System.today();
        update sug;
        
        PageReference pageRef = Page.AgendamentoVisita;
        pageRef.getParameters().put('op', String.valueOf(op.Id));
        Test.setCurrentPage(pageRef);
        
        AgendamentoVisitaController con = new AgendamentoVisitaController();
    }
    
    @isTest
    public static void testThree() {
        Lead l = [SELECT Id FROM Lead][0];
        
        SugestaoVisita__c sug = [SELECT Id FROM SugestaoVisita__c WHERE Lead__c =: l.Id];
        sug.DataConfirmada__c = System.today();
        update sug;
        
        PageReference pageRef = Page.AgendamentoVisita;
        pageRef.getParameters().put('ld', String.valueOf(l.Id));
        Test.setCurrentPage(pageRef);
        
        AgendamentoVisitaController con = new AgendamentoVisitaController();
    }
    
    @isTest
    public static void testFour() {
        Lead l = [SELECT Id FROM Lead][0];
        
        SugestaoVisita__c sug = [SELECT Id FROM SugestaoVisita__c WHERE Lead__c =: l.Id];
        sug.HoraInicialSugerida__c = Time.newInstance(8, 0, 0, 0);
        sug.HoraFinalSugerida__c = Time.newInstance(11, 0, 0, 0);
        update sug;
        
        PageReference pageRef = Page.AgendamentoVisita;
        pageRef.getParameters().put('ld', String.valueOf(l.Id));
        pageRef.getParameters().put('dtCnf', String.valueOf(DateTime.now().addDays(3).format('dd-MM-yyyy')));
        Test.setCurrentPage(pageRef);
        
        AgendamentoVisitaController con = new AgendamentoVisitaController();
        con.confirmarData();
    }
    
    @isTest
    public static void testFive() {
        Opportunity op = [SELECT Id FROM Opportunity][0];
        
        SugestaoVisita__c sug = [SELECT Id FROM SugestaoVisita__c WHERE Oportunidade__c =: op.Id];
        sug.HoraInicialSugerida__c = Time.newInstance(8, 0, 0, 0);
        sug.HoraFinalSugerida__c = Time.newInstance(11, 0, 0, 0);
        update sug;
        
        PageReference pageRef = Page.AgendamentoVisita;
        pageRef.getParameters().put('op', String.valueOf(op.Id));
        pageRef.getParameters().put('dtCnf', String.valueOf(DateTime.now().addDays(3).format('dd-MM-yyyy')));
        Test.setCurrentPage(pageRef);
        
        AgendamentoVisitaController con = new AgendamentoVisitaController();
        con.confirmarData();
    }
    
    @isTest
    public static void testSix() {
        Opportunity op = [SELECT Id FROM Opportunity][0];
        
        SugestaoVisita__c sug = [SELECT Id FROM SugestaoVisita__c WHERE Oportunidade__c =: op.Id];
        sug.HoraInicialSugerida__c = Time.newInstance(8, 0, 0, 0);
        sug.HoraFinalSugerida__c = Time.newInstance(11, 0, 0, 0);
        update sug;
        
        PageReference pageRef = Page.AgendamentoVisita;
        pageRef.getParameters().put('op', String.valueOf(op.Id));
        pageRef.getParameters().put('dtCnf', String.valueOf(DateTime.now().addDays(2).format('dd-MM-yyyy')));
        pageRef.getParameters().put('horarioSetado', '12h');
        Test.setCurrentPage(pageRef);
        
        AgendamentoVisitaController con = new AgendamentoVisitaController();
        con.enviarDatas();
    }
}