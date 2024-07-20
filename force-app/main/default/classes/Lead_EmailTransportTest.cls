@isTest
public class Lead_EmailTransportTest {

    @TestSetup
    static void setup(){
        Profile p = [SELECT Id FROM Profile WHERE (Name = 'System Administrator') or  
            (Name = 'Administrador do Sistema' ) limit 1];

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

    @isTest
    public static void CopyEmailTest() {
        User u = [select id, email from User 
            where UserName = 'standarduser1@pearson.br' limit 1];

        System.runAs(u){
            Test.startTest();

            //create a Lead

            Lead lead = new Lead();
            lead.LastName = 'Test';
            lead.Company = 'Test';
            lead.LeadSource = 'Recomendação';
            lead.Status = 'Aberto';
            lead.Email = 'teste@testelead.com.br';
            insert lead;

            // verify if emailtransport is fill

            Lead leadInserted = [select Id,BR_Email_Transporte__c from lead 
                where Email =: 'teste@testelead.com.br'];

            //System.assert(leadInserted.BR_Email_Transporte__c != null);

            Test.stopTest();
        } 
    }

}