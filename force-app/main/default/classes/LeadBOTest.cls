@isTest
public class LeadBOTest {
	
    @isTest
    static void insertLeadHubSpot(){  
        Id rtLead = Schema.SObjectType.Lead.getRecordTypeInfosByName().get('Franquias').getRecordTypeId();
        
        String lastName = Util.generateRandomStringChar(10);
        Lead lead = new Lead();
        lead.FirstName = Util.generateRandomStringChar(10);
        lead.LastName = lastName;
        lead.Company = Util.generateRandomStringChar(10);
        lead.Email = Util.generateRandomStringChar(10) + '@test.com';
        lead.Tipo_de_Captacao__c = 'Inbound';
        lead.RecordTypeId = rtLead;
        lead.Origem_Inbound__c = Util.generateRandomStringChar(10);
        lead.OrigemInboundHubspot__c = 'Organic Social';
        lead.Origem_da_ultima_conversao__c = Util.generateRandomStringChar(10);
        
        Test.startTest();
            insert lead;
        Test.stopTest();
        
        Lead ld = [SELECT Origem_Inbound__c FROM Lead L WHERE L.LastName =: lead.lastName];
        
        //System.assertEquals(lead.OrigemInboundHubspot__c, ld.Origem_Inbound__c, 'The Lead.Origem_Inbound__c must be equals Lead.OrigemInboundHubspot__c.');
    }
}