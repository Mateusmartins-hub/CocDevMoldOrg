@IsTest
public with sharing class EventCheckTest {

    @IsTest
    static void checkOpportunityBeforeDeleteTest() {

        User userToRun = [
            SELECT Id FROM User WHERE Profile.Name LIKE '%admin%' AND ManagerId != null AND isActive = true LIMIT 1
        ];

        System.runAs(userToRun){

            Opportunity opp = TestHelper.createOpportunity();
            opp.RecordTypeId =  OpportunityStagesCheck.RECORD_TYPE_OPORTUNIDADE_SETOR_PRIVADO;

            insert opp;

            opp.StageName = 'Agendamento de visita pedagógica - Vendas';
            opp.Probability = 30;


            Event evt = TestHelper.createEvent(); 
            evt.RecordTypeId = EventCheck.RECORD_TYPE_VISITA_PEDAGOGICA;       
            evt.WhatId = opp.id;

            insert evt;

            update opp;

            try {            
                delete evt;
                //System.assert(false);

            } catch(Exception err) {
                System.debug(err.getMessage());                
            }
        }
    }

    @IsTest
    static void checkEventDeletionTrigger() {

        Event evt = TestHelper.createEvent(); 
        insert evt;        

        try {            
            delete evt;
        } catch(Exception err) {
            System.debug(err.getMessage());                
            //System.assert(false);
        }
    }
}