@isTest
public class EnviarEmailNurseryControllerTest {

	@isTest
	static void testOne() {
        EnviarEmailNurseryController.getEmails();
	}

	@isTest
	static void testTwo() {
        Account acc = TestHelper.createAccount();
        insert acc;
        
        Contact con = TestHelper.createContact();
        con.AccountId = acc.Id;
        con.Email = 'test@test.com';
        insert con;
        
        Processo__c p = new Processo__c();
        p.Conta__c = acc.Id;
        insert p;
        
        EnviarEmailNurseryController.enviarEmail(p.Id, [SELECT Id FROM EmailTemplate WHERE Name = 'Visita agendada' LIMIT 1][0].Id);
	}

	@isTest
	static void testThree() {

		User userToRun = [
			SELECT Id FROM User WHERE Profile.Name LIKE '%admin%' AND ManagerId != null AND isActive = true LIMIT 1
		];

		System.runAs(userToRun){
			Account acc = TestHelper.createAccount();
			insert acc;
	
			Contact con = TestHelper.createContact();
			con.AccountId = acc.Id;
			con.Email = 'test@test.com';
			insert con;
			
			Opportunity op = TestHelper.createOpportunity();
			op.AccountId = acc.Id;
			insert op;
			
			Processo__c p = new Processo__c();
			p.Oportunidade__c = op.Id;
			insert p;
			
			EnviarEmailNurseryController.enviarEmail(p.Id, [SELECT Id FROM EmailTemplate WHERE Name = 'Visita agendada' LIMIT 1][0].Id);
	    }
	}

	@isTest
	static void testFour() {

        User userToRun = [
			SELECT Id FROM User WHERE Profile.Name LIKE '%admin%' AND ManagerId != null AND isActive = true LIMIT 1
		];

		System.runAs(userToRun){
                
            Account acc = TestHelper.createAccount();
            acc.BR_Account_email__c = 'test@test.com';
            insert acc;
            
            Opportunity op = TestHelper.createOpportunity();
            op.AccountId = acc.Id;
            insert op;
            
            Processo__c p = new Processo__c();
            p.Oportunidade__c = op.Id;
            insert p;
            
            EnviarEmailNurseryController.enviarEmail(p.Id, [SELECT Id FROM EmailTemplate WHERE Name = 'Visita agendada' LIMIT 1][0].Id);
        }
	}

	@isTest
	static void testFive() {
        Account acc = TestHelper.createAccount();
        acc.BR_Account_email__c = 'test@test.com';
        insert acc;
        
        Processo__c p = new Processo__c();
        p.Conta__c = acc.Id;
        insert p;
        
        EnviarEmailNurseryController.enviarEmail(p.Id, [SELECT Id FROM EmailTemplate WHERE Name = 'Visita agendada' LIMIT 1][0].Id);
	}
}