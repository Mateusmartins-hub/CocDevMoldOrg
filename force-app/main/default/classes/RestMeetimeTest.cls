@isTest
public class RestMeetimeTest {
    
    
    @testSetup static void testSetup() {
        
         User u = new User(
            ProfileId = [SELECT Id FROM Profile WHERE Name = 'Brazil Global'].Id,
            FirstName = 'Sales',
            LastName = 'Manager',
            Email = 'salesmanager@test.com',
            Username = 'salesmanager@testtest.com' + System.currentTimeMillis(),
            CompanyName = 'TEST',
            Title = 'title',
            Alias = 'alias',
            TimeZoneSidKey = 'America/Los_Angeles',
            EmailEncodingKey = 'UTF-8',
            LanguageLocaleKey = 'en_US',
            LocaleSidKey = 'en_US',
            IsActive = true
        );
        insert u;   
        
        User u2 = new User(
            ProfileId = [SELECT Id FROM Profile WHERE Name = 'Brazil Global'].Id,
            FirstName = 'Sales',
            LastName = 'Man',
            ManagerId = u.Id,
            Email = 'salesman@test.com',
            Username = 'salesman@testtest.com' + System.currentTimeMillis(),
            CompanyName = 'TEST',
            Title = 'title',
            Alias = 'alias',
            TimeZoneSidKey = 'America/Los_Angeles',
            EmailEncodingKey = 'UTF-8',
            LanguageLocaleKey = 'en_US',
            LocaleSidKey = 'en_US',
            IsActive = true
        );
        insert u2;     
    }
    
    
    static testMethod void testPost() {
        Test.startTest();
        RestRequest req = new RestRequest(); 
        RestResponse res = new RestResponse();
        
        req.addHeader('httpMethod', 'POST');
        req.requestUri = '/services/apexrest/MeetimeApi/';       
        String json = '{"event":"LEAD.WON","prospection":{"id":2128318,"lead":{"id":1924635,"email":"matheus.salesf@hotmail.com","firstName":"Matheus","name":"Sales","company":"Sottelli","phones":[],"position":"Desenvolvedor","site":"www.sottelli.com","state":"SP","city":"Campinas","twitter":null,"facebook":null,"linkedIn":null,"annotations":"","customFields":{"marcaSf":"e9304b37-b6de-490a-9892-eb71a6f01732","origemDoLead":"Meetime"},"publicUrl":"https://meetime.com.br/dashboard/public/leads/EDFOjVE9W3uglUZk62eGp69IPfghsZm-mX4BMsU5--4"},"cadence":{"id":5555,"name":"Inbound  Ativo"},"originType":"IMPORTED_MANUALLY","inbound":false,"startDate":"2020-01-31T17:07:10.492Z","endDate":"2020-01-31T18:32:27.713Z","status":"WON","salesman":{"id":12829,"name":"Sales Man"},"activities":[],"extraActivities":[],"origin":{"campaign":null,"source":null,"conversion":null,"channel":"UNKNOWN"}}}';
        
        req.requestBody = Blob.valueof(json);
        RestContext.request = req; 
        RestContext.response = res;
                
        RestMeetime.doPost();
        Test.stopTest();
    }
}