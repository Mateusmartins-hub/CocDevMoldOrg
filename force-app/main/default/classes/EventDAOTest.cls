@IsTest
public with sharing class EventDAOTest {

    @IsTest
    static void getEventByConsultoriaIdTest(){

        User userToRun = [
    		SELECT Id FROM User WHERE Profile.Name LIKE '%admin%' AND ManagerId != null AND isActive = true LIMIT 1
		];

		System.runAs(userToRun){
            Opportunity opp = TestHelper.createOpportunity();
            insert opp;

            Event evt = TestHelper.createEvent();
            evt.WhatId = opp.Id;
            insert evt;
            
            List<Event> relatedEvents = EventDAO.getEventByConsultoriaId(opp.Id);
            
            System.assertEquals(1, relatedEvents.size());
        }
    }

    @IsTest
    static void getEventByIdTest(){
        Event evt = TestHelper.createEvent();
        insert evt;

        Event insertedEvent = EventDAO.getEventById(evt.id);

        System.assertEquals(evt.Id, insertedEvent.Id);
    }

    @IsTest
    static void getEventsByRelatedAndRecordTypeTest(){

        User userToRun = [
    		SELECT Id FROM User WHERE Profile.Name LIKE '%admin%' AND ManagerId != null AND isActive = true LIMIT 1
		];

		System.runAs(userToRun){
            Id evtRecordType = EventCheck.RECORD_TYPE_VISITA_PEDAGOGICA;
            
            Opportunity opp = TestHelper.createOpportunity();
            insert opp;
            
            Set<Id> oppIds = new Set<Id>();
            oppIDs.add(opp.Id);
            
            Event evt = TestHelper.createEvent();
            evt.WhatId = opp.Id;
            evt.RecordTypeId = evtRecordType;
            insert evt;
            
            List<Event> lstEvents = EventDAO.getEventsByRelatedAndRecordType(oppIds, evtRecordType);
            
            System.assertEquals(1, lstEvents.size());
        }
    }
}