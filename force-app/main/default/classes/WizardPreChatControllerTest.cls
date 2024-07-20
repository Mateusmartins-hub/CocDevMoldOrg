@isTest
public class WizardPreChatControllerTest {
    
    @TestSetup
    static void setup(){
        
        Profile p = [SELECT Id FROM Profile WHERE (Name = 'System Administrator') or  (Name = 'Administrador do Sistema' ) limit 1];
       
        // User Test
        	User u = new User(
            Alias = 'standt1', 
            Email='standarduser1@pearson.br', 
            EmailEncodingKey='UTF-8', 
            LastName='Testing', 
            LanguageLocaleKey='pt_BR', 
            LocaleSidKey='pt_BR', 
            ProfileId = p.Id, 
            TimeZoneSidKey='America/Sao_Paulo', 
            UserName='standarduser1@pearson.br'
            
        );
		
		insert u;        
        
	}
    
    @IsTest
    static void testGetUserInfo(){
        
        User u = [select id, email from User where UserName = 'standarduser1@pearson.br' limit 1];
        
        System.runAs(u){
            
            Test.startTest();
            
            User currUser = WizardPreChatController.getUser();
            System.assert(currUser.Id == u.Id, 'Current User is undefined.');
                        
            Test.stopTest();           
            
        }
        
    }

}