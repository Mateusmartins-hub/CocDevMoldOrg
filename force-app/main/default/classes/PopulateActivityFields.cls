@isTest
// test for the 'Populate Activity Fields' triggers
private class PopulateActivityFields {
    static testMethod void test() {
        // create dummy Event & Task
        Event e = new Event(ActivityDateTime=Date.Today(), Description='Test Event',
                            DurationInMinutes=10, Subject='Test Event', Type='Test Event'); 
        Task t = new Task(ActivityDate=Date.Today(), Description='Test Task',
                          Priority='Low', Status='Completed', Subject='Test Task',
                          Type='Test Task'); 
        insert e;
        insert t;

        // get the custom "Start Date/Time" field values
        DateTime dtmStart_e = [SELECT Start_Date_Time__c FROM Event WHERE
                               Id = :e.Id LIMIT 1].Start_Date_Time__c;
        DateTime dtmStart_t = [SELECT Start_Date_Time__c FROM Task WHERE
                               Id = :t.Id LIMIT 1].Start_Date_Time__c;

        // test "Start Date/Time"
         System.assert(dtmStart_e == e.StartDateTime );
      

    }
}