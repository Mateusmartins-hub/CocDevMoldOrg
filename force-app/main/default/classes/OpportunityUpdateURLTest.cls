@IsTest
public with sharing class OpportunityUpdateURLTest {    

    @IsTest
    static void updateURLAdocaoTest() {

        User userToRun = [
            SELECT Id FROM User WHERE Profile.Name LIKE '%admin%' AND ManagerId != null AND isActive = true LIMIT 1
        ];

        System.runAs(userToRun){
            Test.setMock(HttpCalloutMock.class, new MockCapturaSAP());
            OpportunityLineItem prdt = TestHelper.createOpportunityLineItem();         
            insert prdt;
            
            Opportunity opp = [SELECT Id From Opportunity];
            
            Id tipoRegistro = RecordTypeMemory.getRecType('Opportunity', 'Oportunidade_de_Negocio_Pearson_English_EDU');
            opp.RecordTypeId = tipoRegistro;
            update opp;
            opp = [SELECT Id, BR_URL__c FROM opportunity];
            
            //System.AssertEquals('http://pearsonlatam-br.force.com/ConfirmaAdocaoEDU?RespEmail=' + opp.Id,  opp.BR_URL__c);
            
            
            Id tpRegistroSample = RecordTypeMemory.getRecType('Opportunity', 'Sample_Order_University');
            opp.RecordTypeId = tpRegistroSample;
            opp.BR_URL2__c = 'http://pearsonlatam-br.force.com/ConfirmaReAdocao?RespEmail=' + opp.Id;
            update opp;
            
            opp = [SELECT Id, BR_URL2__c FROM opportunity];
            
            //System.AssertEquals('http://pearsonlatam-br.force.com/PesquisaSatisfacao?RespEmail=' + opp.Id,  opp.BR_URL2__c);
            
            
            opp.StageName = 'Adotado';
            opp.BR_URL__c = 'http://pearsonlatam-br.force.com/ConfirmaReAdocao?RespEmail=' + opp.Id; 
            update opp;
            system.debug('aki ' + opp.BR_URL__c);
            opp = [SELECT Id, BR_URL__c FROM opportunity];
            System.AssertEquals('http://pearsonlatam-br.force.com/ConfirmaReAdocao?RespEmail=' + opp.Id, opp.BR_URL__c);        
        }
    }
}