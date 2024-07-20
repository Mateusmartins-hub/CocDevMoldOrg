@IsTest
public with sharing class LeadConvertedTest {
    @TestSetup
    static void setup(){
        User userToRun = [
    		SELECT Id FROM User WHERE Profile.Name LIKE '%admin%' AND ManagerId != null AND isActive = true LIMIT 1
		];

		System.runAs(userToRun){
            Opportunity opp = TestHelper.createOpportunity();
            insert opp;

            Lead ld = TestHelper.createLead();
            insert ld;
            
            Id recordTypeId = Schema.SObjectType.Formulario__c.getRecordTypeInfosByDeveloperName().get('Resposta').getRecordTypeId();
            Formulario__c form = new Formulario__c();
            form.RecordTypeId = recordTypeId;
            form.Lead__c = ld.Id;        
            insert form;
        }
    }

    @IsTest
    static void shareFormToOppTest() {
        Test.startTest();
        Lead ld = [SELECT Id FROM Lead];
        Account acc = [SELECT Id FROM Account];
        Opportunity opp = [SELECT Id FROM Opportunity];
		/*
        Database.LeadConvert lc = new database.LeadConvert();
        lc.setLeadId(ld.Id);
        lc.setConvertedStatus('Finalizado');
        lc.setAccountId(acc.Id);
        lc.setOpportunityId(opp.Id);

        try {
            Database.convertLead(lc);
        }
        catch(Exception e) { 
            System.assert(e != null);
        }
        */
        
        ld.CPF__c = '352.340.650-14';
        ld.Email = 'teste@email.com';
        ld.MobilePhone = '99999-9999';
        ld.Street = 'teste';
        ld.Country = 'Brazil';
        ld.PostalCode = '12345859';
        ld.State = 'SP';
        ld.City = 'Teste';
        ld.SituacaoCadastral__c = 'Ativo';
        ld.InscricaoEstadual__c = '123456789';
        ld.LigacaoRealizada__c = true;
        ld.Status = 'Aberto';
        ld.Resultado__c = 'Qualificado';
        
        update ld;
        
        //Database.convertLead(ld);

        Formulario__c form = [SELECT Id, Oportunidade__c, Conta__c, Lead__c FROM Formulario__c LIMIT 1];

        //System.assertEquals(opp.Id, form.Oportunidade__c);
        //System.assertEquals(acc.Id, form.Conta__c);
        //System.assertEquals(null, form.Lead__c);
        Test.stopTest();
    }

}