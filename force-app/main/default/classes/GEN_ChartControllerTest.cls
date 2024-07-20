@isTest
public with sharing class GEN_ChartControllerTest {
    @isTest
    static void testData() {
        Date startDate = Date.today();
        Date endDate = startDate.addDays(7);

        Test.startTest();
        List<AggregateResult> result = GEN_ChartController.getCOsData(startDate, endDate);
        List<AggregateResult> result2 = GEN_ChartController.getCOsData(null, null);
        Test.stopTest(); 
    }
    
    /*@isTest
    static void testNodate() {
        Test.startTest();
        List<AggregateResult> result = GEN_ChartController.getCOs();
        Test.stopTest();
    }*/
}