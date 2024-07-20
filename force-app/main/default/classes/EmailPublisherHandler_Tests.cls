@isTest
private class EmailPublisherHandler_Tests {
    @testSetup static void setup() {       
		Account account = new Account();
		account.Name = 'Test Account';
		insert account;

		Contact contact = new Contact();
		contact.AccountId = account.Id;
		contact.LastName = 'TestLastName';
		insert contact;


		Case c = new Case();
		c.AccountId = account.Id;
        c.Description = 'Test Description';
		insert c;
    }
    
	@isTest
    static void Should_AddAccountsSchoolConsultantToCcAddresses_When_CasesAcccountHasASchoolConsultant() {
        Profile p = [SELECT Id FROM Profile WHERE Name='Standard User']; 
        User u = new User(
            Alias = 'standt',
            Email='standarduser@testorg.com', 
            EmailEncodingKey='UTF-8',
            LastName='Testing',
            LanguageLocaleKey='en_US', 
            LocaleSidKey='en_US',
            ProfileId = p.Id, 
            TimeZoneSidKey='America/Los_Angeles',
            UserName='standarduser@testorgcoc.com'
        );	
        
        insert u;
        
        List<Account> accounts = [SELECT Id FROM Account LIMIT 1];
        
        Account acct;
        
        if(!accounts.isEmpty()) {
            acct = new Account(Id = accounts.get(0).Id, Consultor_Escolar__c = u.Id);
            update acct;
            acct = [SELECT Id, Consultor_Escolar__r.Email FROM Account WHERE Id =: acct.Id];
        } else {
            Assert.fail('Expected an account to exist');
        }
              
        List<Case> cases = [SELECT Id FROM Case LIMIT 1];
        
        EmailMessage emailMessage;
        
        if(!cases.isEmpty()) {
       		List<QuickAction.QuickActionDefaults> defaults = new list<QuickAction.QuickActionDefaults>();
        	QuickAction.SendEmailQuickActionDefaults sendEmailDefaults = Test.newSendEmailQuickActionDefaults(cases.get(0).Id, null);
        	defaults.add(sendEmailDefaults);
        	Test.startTest();
        		EmailPublisherHandler defaultClass = new EmailPublisherHandler();
        		defaultClass.onInitDefaults(defaults);
    		Test.stopTest();
    		emailMessage = (EmailMessage) sendEmailDefaults.getTargetSObject();
        } else {
            Assert.fail('Expected a case to exist');
        }
        
        Assert.isNotNull(emailMessage, 'Expected an email message to be sent');
        Assert.areEqual(acct.Consultor_Escolar__r.Email, emailMessage.CcAddress, 'Expected School Consultant to be added to Cc addresses');
    }
    
    @isTest
    static void ShouldNot_AddAccountsSchoolConsultantToCcAddresses_When_CasesAcccountDoesNotHaveASchoolConsultant() {
        List<Case> cases = [SELECT Id FROM Case LIMIT 1];
        
        EmailMessage emailMessage; 
        
        if(!cases.isEmpty()) {
       		List<QuickAction.QuickActionDefaults> defaults = new list<QuickAction.QuickActionDefaults>();
        	QuickAction.SendEmailQuickActionDefaults sendEmailDefaults = Test.newSendEmailQuickActionDefaults(cases.get(0).Id, null);
        	defaults.add(sendEmailDefaults);
        	Test.startTest();
        		EmailPublisherHandler defaultClass = new EmailPublisherHandler();
        		defaultClass.onInitDefaults(defaults);
    		Test.stopTest();
    		emailMessage = (EmailMessage) sendEmailDefaults.getTargetSObject();
        } else {
            Assert.fail('Expected a case to exist');
        }
        
        Assert.isNotNull(emailMessage, 'Expected an email message to be sent');
        Assert.isNull(emailMessage.CcAddress, 'There should have no Cc addresses');
    }
}