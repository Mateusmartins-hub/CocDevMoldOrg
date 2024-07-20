@isTest
public class BusinessDaysTest {
    static testMethod void testMethod1() {
        BusinessDays bd = new BusinessDays();
        
        Date today = Date.today();
        DateTime startTime = DateTime.newInstance(today.year(), today.month(), today.day(), 10, 0, 0);
        
        Test.StartTest();
        DateTime response1 = bd.addDays(startTime, 10);
        
        DateTime response2 = bd.subtractDays(startTime, 1);
        
        Boolean response3 = bd.isWorkingDay(response1);
        
        Integer response4 = bd.getNoOfBusinessDaysBetweenDates(response1, Date.today());
        Test.stopTest();
    }
  	
    @IsTest
    static void getNextWorkingDayTest(){
        BusinessDays bd = new BusinessDays();
        Datetime testDate = DateTime.newInstance(2019, 9, 27, 23, 59, 59);
        
        Datetime expectedNextDate = DateTime.newInstance(2019, 9, 30, 8, 0, 0);
        Datetime actualNextDate = bd.getNextWorkingDay(testDate);
        //System.assertEquals(expectedNextDate, actualNextDate);
    }
    
    @IsTest
    static void constructorTest() {
		BusinessDays bd = new BusinessDays('Brazil');
        System.assertNotEquals(bd.bHours, null);
    }
    
}