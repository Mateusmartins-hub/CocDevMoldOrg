@IsTest
public with sharing class SObjectDAOTest {

    private class TestDAO extends SObjectDAO{}
    
    @IsTest
    static void shouldTestInsert_Success(){
        Account acc = new Account(Name = 'Test');

        TestDAO dao = new TestDAO();

        Database.SaveResult sr = dao.insertData(acc);
        System.assert(sr.isSuccess());
    }

    @IsTest
    static void shouldTestInsert_Error(){
        Account acc = new Account();

        TestDAO dao = new TestDAO();
        try{
            Database.SaveResult sr = dao.insertData(acc);
        }
        catch(Exception e){
            System.assert(e.getTypeName() == 'System.DmlException');
        }
    }

    @IsTest
    static void shouldTestBulkInsert_Success(){
        Account acc = new Account(Name = 'Test');

        TestDAO dao = new TestDAO();

        List<Database.SaveResult> results = dao.insertData(new List<Account>{acc});
        System.assert(results[0].isSuccess());
    }

    @IsTest
    static void shouldTestBulkInsert_Error(){
        Account acc = new Account();

        TestDAO dao = new TestDAO();
        try{
            List<Database.SaveResult> results = dao.insertData(new List<Account>{acc});
        }
        catch(Exception e){
            System.assert(e.getTypeName() == 'System.DmlException');
        }
    }

    @IsTest
    static void shouldTestUpdate_Success(){
        Account acc = new Account(Name = 'Test');
        insert acc;

        acc.Name = 'Test 2';

        TestDAO dao = new TestDAO();

        Database.SaveResult sr = dao.updateData(acc);
        System.assert(sr.isSuccess());
    }

    @IsTest
    static void shouldTestUpdate_Error(){
        Account acc = new Account(Name = 'Test');
        insert acc;

        acc.Name = null;

        TestDAO dao = new TestDAO();
        try{
            Database.SaveResult sr = dao.updateData(acc);
        }
        catch(Exception e){
            System.assert(e.getTypeName() == 'System.DmlException');
        }
    }

    @IsTest
    static void shouldTestBulkUpdate_Success(){
        Account acc = new Account(Name = 'Test');
        insert acc;

        acc.Name = 'Test 2';

        TestDAO dao = new TestDAO();

        List<Database.SaveResult> results = dao.updateData(new List<Account>{acc});
        System.assert(results[0].isSuccess());
    }

    @IsTest
    static void shouldTestBulkUpdate_Error(){
        Account acc = new Account(Name = 'Test');
        insert acc;

        acc.Name = null;

        TestDAO dao = new TestDAO();
        try{
            List<Database.SaveResult> results = dao.updateData(new List<Account>{acc});
        }
        catch(Exception e){
            System.assert(e.getTypeName() == 'System.DmlException');
        }
    }

    @IsTest
    static void shouldTestDeleteById_Success(){
        Account acc = new Account(Name = 'Test');
        insert acc;

        TestDAO dao = new TestDAO();

        Database.DeleteResult sr = dao.deleteData(String.valueOf(acc.Id));
        System.assert(sr.isSuccess());
    }

    @IsTest
    static void shouldTestDeleteById_Error(){
        Account acc = new Account(Name = 'Test');
        insert acc;

        Contact ctc = new Contact(LastName = 'Test');
        ctc.AccountId = acc.Id;
        insert ctc;

        Case cs = new Case();
        cs.ContactId = ctc.Id;
        cs.Subject = 'Test';
        insert cs;

        TestDAO dao = new TestDAO();
        try{
            Database.DeleteResult sr = dao.deleteData(String.valueOf(acc.Id));
        }
        catch(Exception e){
            System.assert(e.getTypeName() == 'System.DmlException');
        }
    }

    @IsTest
    static void shouldTestDelete_Success(){
        Account acc = new Account(Name = 'Test');
        insert acc;

        TestDAO dao = new TestDAO();

        List<Database.DeleteResult> sr = dao.deleteData(new List<String>{String.valueOf(acc.Id)});
        System.assert(sr[0].isSuccess());
    }

    @IsTest
    static void shouldTestDelete_Error(){
        Account acc = new Account(Name = 'Test');
        insert acc;

        Contact ctc = new Contact(LastName = 'Test');
        ctc.AccountId = acc.Id;
        insert ctc;

        Case cs = new Case();
        cs.ContactId = ctc.Id;
        cs.Subject = 'Test';
        insert cs;

        TestDAO dao = new TestDAO();
        try{
            List<Database.DeleteResult> sr = dao.deleteData(new List<String>{String.valueOf(acc.Id)});
        }
        catch(Exception e){
            System.assert(e.getTypeName() == 'System.DmlException');
        }
    }

    @IsTest
    static void shouldTestBulkDelete_Success(){
        Account acc = new Account(Name = 'Test');
        insert acc;

        TestDAO dao = new TestDAO();

        List<Database.DeleteResult> results = dao.deleteData(new List<Account>{acc});
        System.assert(results[0].isSuccess());
    }

    @IsTest
    static void shouldTestBulkDelete_Error(){
        Account acc = new Account(Name = 'Test');
        insert acc;

        Contact ctc = new Contact(LastName = 'Test');
        ctc.AccountId = acc.Id;
        insert ctc;

        Case cs = new Case();
        cs.ContactId = ctc.Id;
        cs.Subject = 'Test';
        insert cs;

        TestDAO dao = new TestDAO();
        try{
            List<Database.DeleteResult> results = dao.deleteData(new List<Account>{acc});
        }
        catch(Exception e){
            System.assert(e.getTypeName() == 'System.DmlException');
        }
    }

    


    
}