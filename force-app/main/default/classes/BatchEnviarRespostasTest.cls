@isTest
public class BatchEnviarRespostasTest {

    @isTest
    public static void test(){
        
        TestHelper.createCustomSettingsRA();
        TestHelper.createCaseRA();
        Test.startTest();
        
        ScheduledEnviarRespostas sch = new ScheduledEnviarRespostas();
        sch.scheduleNowExecution();
        
        BatchEnviarRespostas batch = new BatchEnviarRespostas();
        Database.executeBatch(batch);
        Test.stopTest();

    }
    
}