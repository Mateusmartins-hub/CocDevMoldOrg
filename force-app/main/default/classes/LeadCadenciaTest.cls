@isTest
public class LeadCadenciaTest {
    
    @testSetup
    static void setup(){
       Cadencia__c cadencia = new Cadencia__c();
        cadencia.HoraLimite__c = Time.newInstance(17, 0, 0, 0);
        cadencia.TipoCaptacao__c = 'Inbound';
        cadencia.TipoLead__c = 'Governo';
        cadencia.Ativo__c = TRUE;
        insert cadencia;
        
        TarefaCadencia__c trfDiaUtil = new TarefaCadencia__c();
        trfDiaUtil.Cadencia__c = cadencia.Id;
        trfDiaUtil.Assunto__c = Util.generateRandomStringChar(10);
        trfDiaUtil.DiaUtil__c = 3;
        trfDiaUtil.DataEspecifica__c = NULL;
        trfDiaUtil.Ativo__c = TRUE;
        insert trfDiaUtil;
        
        TarefaCadencia__c trfDtEspecifica = new TarefaCadencia__c();
        trfDtEspecifica.Cadencia__c = cadencia.Id;
        trfDtEspecifica.Assunto__c = Util.generateRandomStringChar(10);
        trfDtEspecifica.DiaUtil__c = NULL;
        trfDtEspecifica.DataEspecifica__c = System.now().date();
        trfDtEspecifica.Ativo__c = TRUE;
        insert trfDtEspecifica;
    }

    @isTest
    static void insereTarefasCadenciaTest(){
        Id rtLead = Schema.SObjectType.Lead.getRecordTypeInfosByName().get('Governo').getRecordTypeId(); 
        List<Lead> lstLeads = new List<Lead>();
        
        for(Integer i = 0; i < 7; i++){
            Lead lead = new Lead();
            lead.FirstName = Util.generateRandomStringChar(10) + i;
            lead.LastName = Util.generateRandomStringChar(10) + i;
            lead.Company = Util.generateRandomStringChar(10) + i;
            lead.Email = Util.generateRandomStringChar(10) + i + '@test.com';
            lead.Tipo_de_Captacao__c = 'Inbound';
            lead.RecordTypeId = rtLead;
            lead.Origem_Inbound__c = Util.generateRandomStringChar(10);
            lead.Origem_da_ultima_conversao__c = Util.generateRandomStringChar(10);
			lstLeads.add(lead);            
        }
        
        Test.startTest();
        	insert lstLeads;
        Test.stopTest();
    }
    
    @isTest
    static void insereTarefasCadenciaReturnTest(){
        List<Cadencia__c> cadencias = [SELECT Id FROM Cadencia__c WHERE Ativo__c = TRUE];
        
        Id rtLead = Schema.SObjectType.Lead.getRecordTypeInfosByName().get('Governo').getRecordTypeId(); 
        List<Lead> lstLeads = new List<Lead>();
        
        for(Integer i = 0; i < 7; i++){
            Lead lead = new Lead();
            lead.FirstName = Util.generateRandomStringChar(10) + i;
            lead.LastName = Util.generateRandomStringChar(10) + i;
            lead.Company = Util.generateRandomStringChar(10) + i;
            lead.Email = Util.generateRandomStringChar(10) + i + '@test.com';
            lead.Tipo_de_Captacao__c = 'Inbound';
            lead.RecordTypeId = rtLead;
            lead.Origem_Inbound__c = Util.generateRandomStringChar(10);
            lead.Origem_da_ultima_conversao__c = Util.generateRandomStringChar(10);
			lstLeads.add(lead);            
        }
        
        Test.startTest();
            for(Cadencia__c cadencia : cadencias){
                cadencia.Ativo__c = FALSE;
            }
            update cadencias;
            
            insert lstLeads;
        Test.stopTest();
    }
}