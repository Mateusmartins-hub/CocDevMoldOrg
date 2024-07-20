@isTest
public class ExceptionLoggerTest {
    
    @isTest
    static void shouldLogWithDatabaseError(){

        Account acc = new Account();
        Database.saveResult sr = Database.insert(acc, false);

        Test.startTest();

        for(Database.Error err : sr.getErrors()) {
            ExceptionLogger.log('ExceptionLoggerTest', err);
        }

        System.assertEquals(1, ExceptionLogger.allExceptions.size());

        Test.stopTest();
    }

    @isTest
    static void shouldLogWithException(){

        try{
            Account acc = new Account();
            insert acc;
        }
        catch(Exception e){
            Test.startTest();

            ExceptionLogger.log('ExceptionLoggerTest', e);
        
            System.assertEquals(1, ExceptionLogger.allExceptions.size());

            Test.stopTest();
        }
    }
    
    @isTest
    static void shouldSaveException(){

        ExceptionLogger__c exc = new ExceptionLogger__c(
            ApexClass__c = 'TestClass',
            Description__c = 'Test'
        );

        ExceptionLogger.allExceptions.add(exc);

        Test.startTest();
        ExceptionLogger.save();

        List<ExceptionLogger__c> savedExceptions = [
            SELECT Id FROM ExceptionLogger__c
        ];

        System.assertEquals(1, savedExceptions.size());

        Test.stopTest();
    }

}