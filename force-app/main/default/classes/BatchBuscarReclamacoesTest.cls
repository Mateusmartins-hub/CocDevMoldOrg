@isTest
public class BatchBuscarReclamacoesTest {

    @isTest
    public static void test(){
        TestHelper.createCustomSettingsRA();
        
        Test.startTest();
        ScheduledBuscarReclamacoes sch = new ScheduledBuscarReclamacoes();
        sch.scheduleNowExecution();
        BatchBuscarReclamacoes batch = new BatchBuscarReclamacoes();
        Database.executeBatch(batch);
        Test.stopTest();
    }
}