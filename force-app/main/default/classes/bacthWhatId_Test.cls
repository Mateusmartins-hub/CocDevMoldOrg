@isTest 
public class bacthWhatId_Test {
    
    @isTest public static void test_1(){
        Account acc = new Account();
        acc.Name = 'teste';
        insert acc;
        acc.IdSegregacao__c = acc.Id;
        
        update acc;
        
        Event e = new Event();
        e.OldWhatId__c = acc.IdSegregacao__c;
        e.ActivityDate = System.today();
        e.ActivityDateTime = System.now();
        e.DurationInMinutes = 60;
        insert e;
        
        bacthWhatId b = new bacthWhatId('001');
        Test.startTest();
        Database.executeBatch(b); 
        Test.stopTest();
    }
    
    @isTest public static void test_2(){
        User userToRun = [
            SELECT Id FROM User WHERE Profile.Name LIKE '%admin%' AND ManagerId != null AND isActive = true LIMIT 1
        ];
        
        System.runAs(userToRun){
            Opportunity opp = new Opportunity();
            opp.Name = 'Teste';
            opp.StageName = 'Closed';
            opp.CloseDate = System.today();
            insert opp;
            opp.IdSegregacao__c = opp.Id;
            
            update opp;
            
            Event e = new Event();
            e.OldWhatId__c = opp.IdSegregacao__c;
            e.ActivityDate = System.today();
            e.ActivityDateTime = System.now();
            e.DurationInMinutes = 60;
            insert e;
            
            bacthWhatId b = new bacthWhatId('006');
            Test.startTest();
            Database.executeBatch(b); 
            Test.stopTest();
        }
    }
    
    @isTest public static void test_3(){
        User userToRun = [
            SELECT Id FROM User WHERE Profile.Name LIKE '%admin%' AND ManagerId != null AND isActive = true LIMIT 1
        ];
        
        System.runAs(userToRun){
            Product2 obj = new Product2();
            obj.Name = 'Test';
            insert obj;
            obj.IdSegregacao__c = obj.Id;
            
            update obj;
            
            Event e = new Event();
            e.OldWhatId__c = obj.IdSegregacao__c;
            e.ActivityDate = System.today();
            e.ActivityDateTime = System.now();
            e.DurationInMinutes = 60;
            insert e;
            
            bacthWhatId b = new bacthWhatId('01t');
            Test.startTest();
            Database.executeBatch(b); 
            Test.stopTest();
        }
    }
    
    @isTest public static void test_4(){
        
        Account acc = new Account();
        acc.Name = 'teste';
        insert acc;
        
        BR_Procedimento_Pedag_gico__c obj = new BR_Procedimento_Pedag_gico__c();
        obj.BR_Conta__c = acc.Id;
        insert obj;
        obj.IdSegregacao__c = 'a0711000009MZEUEA4';
        update obj;
        
        Event e = new Event();
        e.OldWhatId__c = obj.IdSegregacao__c;
        e.ActivityDate = System.today();
        e.ActivityDateTime = System.now();
        e.DurationInMinutes = 60;
        insert e;
        
        bacthWhatId b = new bacthWhatId('a07');
        Test.startTest();
        Database.executeBatch(b); 
        Test.stopTest();
        
    }
    
    @isTest public static void test_5(){
        
        BR_Relat_rio_de_Visita_Pedag_gica__c obj = new BR_Relat_rio_de_Visita_Pedag_gica__c();
        insert obj;
        obj.IdSegregacao__c = 'a0811000009MZEUEA4';
        update obj;
        
        Event e = new Event();
        e.OldWhatId__c = obj.IdSegregacao__c;
        e.ActivityDate = System.today();
        e.ActivityDateTime = System.now();
        e.DurationInMinutes = 60;
        insert e;
        
        bacthWhatId b = new bacthWhatId('a08');
        Test.startTest();
        Database.executeBatch(b); 
        Test.stopTest();
        
    }
    @isTest public static void test_6(){
        
        Account acc = new Account();
        acc.Name = 'teste';
        insert acc;
        
        BR_Procedimento_NAME__c obj = new BR_Procedimento_NAME__c();
        obj.BR_Conta__c =  acc.Id;
        insert obj;
        obj.IdSegregacao__c = 'a0B11000009MZEUEA4';
        update obj;
        
        Event e = new Event();
        e.OldWhatId__c = obj.IdSegregacao__c;
        e.ActivityDate = System.today();
        e.ActivityDateTime = System.now();
        e.DurationInMinutes = 60;
        insert e;
        
        bacthWhatId b = new bacthWhatId('a0B');
        Test.startTest();
        Database.executeBatch(b); 
        Test.stopTest();
        
    }
    
    @isTest public static void test_7(){
        
        Account acc = new Account();
        acc.Name = 'teste';
        insert acc;
        
        BR_Procedimento_Visita__c obj = new BR_Procedimento_Visita__c();
        obj.BR_Conta__c =  acc.Id;
        insert obj;
        obj.IdSegregacao__c = 'a0c11000009MZEUEA4';
        update obj;
        
        Event e = new Event();
        e.OldWhatId__c = obj.IdSegregacao__c;
        e.ActivityDate = System.today();
        e.ActivityDateTime = System.now();
        e.DurationInMinutes = 60;
        insert e;
        
        bacthWhatId b = new bacthWhatId('a0c');
        Test.startTest();
        Database.executeBatch(b); 
        Test.stopTest();
        
    }
    
    @isTest public static void test_8(){
        
        Account acc = new Account();
        acc.Name = 'teste';
        insert acc;
        
        FR_Procedimento_Franquias__c obj = new FR_Procedimento_Franquias__c();
        obj.BR_Conta__c =  acc.Id;
        insert obj;
        obj.IdSegregacao__c = 'a0E11000009MZEUEA4';
        update obj;
        
        Event e = new Event();
        e.OldWhatId__c = obj.IdSegregacao__c;
        e.ActivityDate = System.today();
        e.ActivityDateTime = System.now();
        e.DurationInMinutes = 60;
        insert e;
        
        bacthWhatId b = new bacthWhatId('a0E');
        Test.startTest();
        Database.executeBatch(b); 
        Test.stopTest();
        
    }
    
    @isTest public static void test_9(){
        
        Account acc = new Account();
        acc.Name = 'teste';
        insert acc;
        
        Contact con = new Contact();
        con.AccountId = acc.Id;
        con.LastName = 'Test';
        con.Email = 'test@test.com';
        insert con;
        
        Account_Contact__c obj = new Account_Contact__c();
        obj.Account__c = acc.Id;
        obj.Contact__c = con.Id;
        insert obj;
        obj.IdSegregacao__c = 'a0R11000009MZEUEA4';
        update obj;
        
        Event e = new Event();
        e.OldWhatId__c = obj.IdSegregacao__c;
        e.ActivityDate = System.today();
        e.ActivityDateTime = System.now();
        e.DurationInMinutes = 60;
        insert e;
        
        bacthWhatId b = new bacthWhatId('a0R');
        Test.startTest();
        Database.executeBatch(b); 
        Test.stopTest();
        
    }
    
    @isTest public static void test_10(){
        FR_Procedimento_Franquias__c consult = new FR_Procedimento_Franquias__c();
        insert consult;
        
        FR_Plano_de_Acao__c obj = new FR_Plano_de_Acao__c();
        obj.BR_FR_Plano_acao__c = consult.Id;
        
        insert obj;
        obj.IdSegregacao__c = 'a0D11000009MZEUEA4';
        update obj;
        
        Event e = new Event();
        e.OldWhatId__c = obj.IdSegregacao__c;
        e.ActivityDate = System.today();
        e.ActivityDateTime = System.now();
        e.DurationInMinutes = 60;
        insert e;
        
        bacthWhatId b = new bacthWhatId('a0D');
        Test.startTest();
        Database.executeBatch(b); 
        Test.stopTest();
        
    }
    
    @isTest public static void test_11(){
        
        Visitas__c obj = new Visitas__c();
        insert obj;
        obj.IdSegregacao__c = 'a0Z11000009MZEUEA4';
        update obj;
        
        Event e = new Event();
        e.OldWhatId__c = obj.IdSegregacao__c;
        e.ActivityDate = System.today();
        e.ActivityDateTime = System.now();
        e.DurationInMinutes = 60;
        insert e;
        
        bacthWhatId b = new bacthWhatId('a0Z');
        Test.startTest();
        Database.executeBatch(b); 
        Test.stopTest();
        
    }
}