@isTest
public class EventTriggerHandlerTest {

    @testSetup
    public static void Setup()
    {
        Formulario__c formConsultor = TestHelper.createFormularioVisitaExpansaoConsultor();
        Formulario__c formCliente = TestHelper.createFormularioVisitaExpansaoCliente();
        insert formCliente;
        insert formConsultor;
    }
    
    @isTest
    public static void Executar()
    {

        User userToRun = [
    		SELECT Id FROM User WHERE Profile.Name LIKE '%admin%' AND ManagerId != null AND isActive = true LIMIT 1
		];

		System.runAs(userToRun){
            Opportunity op = TestHelper.createOpportunity();
            insert op;
            
            Event e = TestHelper.createEvent();
            e.RecordTypeId = Schema.SObjectType.Event.getRecordTypeInfosByDeveloperName().get('VisitaExpansao').getRecordTypeId();
            e.WhatId = op.Id;
            
            insert e;
            
            e.BR_FinalCheckinDate__c = DateTime.now();
            e.Description = 'teste';
            update e;
            
            delete e;
        }
    }
    
    @isTest
    public static void ExecuteAccount()
    {
        Account ac = TestHelper.createAccount();
        insert ac;
        
        Event e = TestHelper.createEvent();
        e.RecordTypeId = Schema.SObjectType.Event.getRecordTypeInfosByDeveloperName().get('VisitaExpansao').getRecordTypeId();
        e.WhatId = ac.Id;
        
        insert e;
        
        e.BR_FinalCheckinDate__c = DateTime.now();
        e.Description = 'teste';
        update e;
    }
    
    @isTest
    public static void ExecuteLead()
    {
        Lead ld = TestHelper.createLead();
        insert ld;
        
        Event e = TestHelper.createEvent();
        e.RecordTypeId = Schema.SObjectType.Event.getRecordTypeInfosByDeveloperName().get('VisitaExpansao').getRecordTypeId();
        e.WhoId = ld.Id;
        
        insert e;
        
        e.BR_FinalCheckinDate__c = DateTime.now();
        e.Description = 'teste';
        update e;
    }
}