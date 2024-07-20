@isTest
/**********************************************************************************
*                         Copyright 2012 - Cloud2b
***********************************************************************************
* TEST CLASS FOR EventCreateAudity.trigger
*
* NAME: EventCreateAudityTest
* AUTHOR: CARLOS CARVALHO                              DATE: 29/01/2013
***********************************************************************************/
 
private class EventCreateAudityTest {
    static Group g;
    static QueueSobject q;
    
    static testMethod void myUnitTest() { 
    	//Create a new Group
    	g = new Group();
    	g.Name = 'Auditoria';
    	g.Type = 'Queue';
    	Database.Saveresult[] resultsGroup =  Database.insert( new Group[]{ g }, false);
    	
    	//Create a new QueueSobjectd
    	q = new QueueSobject();
    	q.QueueId = g.Id;
    	q.SobjectType = 'Auditoria__c';
    	Database.Saveresult[] resultsQueue =  Database.insert(new QueueSobject[]{ q }, false );
    	 
    }
    
    static testMethod void myUnitTest2(){
    	//Create a new Event
        Event e = new Event();
        e.subject = 'Teste';
        e.OwnerId = Userinfo.getUserId();
        e.StartDateTime = System.now();
        e.EndDateTime = System.now();
        e.BR_Create_Audit__c = true;
        Database.Saveresult[] resultsEvent =  Database.insert( new Event[]{ e } , false );
    }
}