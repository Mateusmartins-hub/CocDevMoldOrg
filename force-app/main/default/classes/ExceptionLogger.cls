/**
* Classe que implementa ações para o Exception Logger.
* @author Leonardo Santos
*/
public without sharing class ExceptionLogger {

    public static List<ExceptionLogger__c> allExceptions = new List<ExceptionLogger__c>();
    
    public static void log(String apexClassName, Database.Error error){

        ExceptionLogger__c exc = new ExceptionLogger__c(
            ApexClass__c = apexClassName,
            Description__c = error.getStatusCode() + ': ' + error.getMessage()
        );

        allExceptions.add(exc);
    }

    public static void log(String apexClassName, Exception e){

        ExceptionLogger__c exc = new ExceptionLogger__c(
            ApexClass__c = apexClassName,
            Description__c = e.getStackTraceString()
        );

        allExceptions.add(exc);
    }

    public static void save(){

        upsert allExceptions;
    }

}