@IsTest
public class CheckinCheckoutControllerTest {
    @TestSetup
    static void makeData(){

        User userToRun = [
            SELECT Id FROM User WHERE Profile.Name LIKE '%admin%' AND ManagerId != null AND isActive = true LIMIT 1
        ];

        System.runAs(userToRun){
            Opportunity opp = TestHelper.createOpportunity();
            insert opp;

            Account acc = TestHelper.createAccount();
            insert acc;
            
            
            Event evt = new Event();
            evt.DurationInMinutes = 30;
            evt.StartDateTime = System.today();
            evt.WhatId = [SELECT Id FROM Opportunity LIMIT 1].Id;
            evt.Subject = 'Pedagógico';
            insert evt;
        }
    }

    @IsTest
    static void getUserEventsTest() {
        User userToRun = [
            SELECT Id FROM User WHERE Profile.Name LIKE '%admin%' AND ManagerId != null AND isActive = true LIMIT 1
        ];

        System.runAs(userToRun){
                
            List<CheckinCheckoutController.EventObj> listEvents = new List<CheckinCheckoutController.EventObj>();
            listEvents = CheckinCheckoutController.getUserEvents();
            //System.assert(listEvents.size() == 1);
        }
    }

    @IsTest
    static void makeCheckinCheckoutTest() {
        Event evt = [SELECT Id FROM Event LIMIT 1];
        Double lat = -22.901649499999998;
        Double lon = -47.0487198;
        CheckinCheckoutController.handleCheckinCheckout(String.valueOf(evt.Id), lat, lon);

        Location loc = Location.newInstance(lat, lon);
        evt = [SELECT Id, BR_InitialLocation__Latitude__s, BR_InitialLocation__Longitude__s  FROM Event LIMIT 1];

        Double actualLatitude = evt.BR_InitialLocation__Latitude__s;
        Double actualLongitude = evt.BR_InitialLocation__Longitude__s;

        System.assertEquals(loc.Latitude, actualLatitude);
        System.assertEquals(loc.Longitude, actualLongitude);

        CheckinCheckoutController.handleCheckinCheckout(String.valueOf(evt.Id), lat, lon);

        evt = [SELECT Id, BR_FinalLocation__Latitude__s, BR_FinalLocation__Longitude__s  FROM Event LIMIT 1];

        actualLatitude = evt.BR_FinalLocation__Latitude__s;
        actualLongitude = evt.BR_FinalLocation__Longitude__s;
        //System.assertEquals(loc.Latitude, actualLatitude);
        //System.assertEquals(loc.Longitude, actualLongitude);
    }

    @IsTest
    static void makeCheckinTest() {
        Event evt = [SELECT Id FROM Event LIMIT 1];
        Double lat = -22.901649499999998;
        Double lon = -47.0487198;
        CheckinCheckoutController.makeCheckin(String.valueOf(evt.Id), lat, lon);

        Location loc = Location.newInstance(lat, lon);
        evt = [SELECT Id, BR_InitialLocation__Latitude__s, BR_InitialLocation__Longitude__s  FROM Event LIMIT 1];

        Double actualLatitude = evt.BR_InitialLocation__Latitude__s;
        Double actualLongitude = evt.BR_InitialLocation__Longitude__s;

        //System.assertEquals(loc.Latitude, actualLatitude);
        //System.assertEquals(loc.Longitude, actualLongitude);
    }

    @IsTest
    static void makeCheckoutTest() {
        Event evt = [SELECT Id FROM Event LIMIT 1];
        Double lat = -22.901649499999998;
        Double lon = -47.0487198;
        CheckinCheckoutController.makeCheckout(String.valueOf(evt.Id), lat, lon);

        Location loc = Location.newInstance(lat, lon);
        evt = [SELECT Id, BR_FinalLocation__Latitude__s, BR_FinalLocation__Longitude__s  FROM Event LIMIT 1];

        Double actualLatitude = evt.BR_FinalLocation__Latitude__s;
        Double actualLongitude = evt.BR_FinalLocation__Longitude__s;

        //System.assertEquals(loc.Latitude, actualLatitude);
        //System.assertEquals(loc.Longitude, actualLongitude);
    }

    @IsTest
    static void hasResearchTest() { 
        Account acc = [SELECT Id FROM Account LIMIT 1];
        Boolean hasResearch = CheckinCheckoutController.hasResearch(acc.Id);
        //System.assert(!hasResearch);
    }
}