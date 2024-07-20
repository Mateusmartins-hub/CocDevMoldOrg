@isTest
public class DateUtilTest {
    @isTest 
    static void Test1()
    {
        String todate = '12/06/2021';  
		Date endDT = Date.parse( todate ); 
        String endDatetime= DateUtil.formatDate(endDT);
        
        Datetime dt = (DateTime) JSON.deserialize('"2018-10-01T00:00:00Z"', DateTime.class); //DateTime.parse('2021-09-17T20:09:37');
        String dtc = DateUtil.formatDate(dt);
    }
}