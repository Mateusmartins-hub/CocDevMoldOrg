@isTest
public class OpportunityTriggerHandlerTest {
    
    @TestSetup
    static void setup(){
        Profile p = [SELECT Id FROM Profile WHERE (Name = 'System Administrator') or  (Name = 'Administrador do Sistema' ) limit 1];
        
        // Aprovador 
        User u1 = new User(
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
        insert u1;  
        
        // Solicitante
        User u2 = new User(
            Alias = 'standt2', 
            Email='standarduser2@pearson.br', 
            EmailEncodingKey='UTF-8', 
            LastName='Testing', 
            LanguageLocaleKey='pt_BR', 
            LocaleSidKey='pt_BR', 
            ProfileId = p.Id, 
            TimeZoneSidKey='America/Sao_Paulo', 
            UserName='standarduser2@pearson.br',
            ManagerId = u1.id 
        );
        insert u2;
    }
    
    @isTest
    static void shouldTestOpportunityHandler(){
        
        User u = [select id, email from User where UserName = 'standarduser2@pearson.br' limit 1];
        System.runAs(u){
            
            Opportunity opp = new Opportunity(
                Name = 'Test',
                StageName = 'Interesse Inicial',
                CloseDate = System.Today().addDays(30)
            );
            
            insert opp;
            
            List<Opportunity> opportunityAfterInsert = [SELECT Id FROM Opportunity];
            System.assertEquals(1, opportunityAfterInsert.size());
            
            opp.Name = 'Test2';
            update opp;
            
            List<Opportunity> opportunityAfterUpdate = [SELECT Id, Name FROM Opportunity];
            System.assertEquals('Test2', opportunityAfterUpdate[0].Name);
            
            delete opp;
            
            List<Opportunity> opportunityAfterDelete = [SELECT Id FROM Opportunity];
            System.assertEquals(0, opportunityAfterDelete.size());
            
        }
        
    }
}