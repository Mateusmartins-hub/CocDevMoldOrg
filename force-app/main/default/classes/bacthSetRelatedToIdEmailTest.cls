@isTest
public class bacthSetRelatedToIdEmailTest {
    
    @TestSetup static void setup(){
        Account conta = new Account();
        conta.Name = 'Conta Teste';
        insert conta;
        
        Contact con = new Contact();
        con.AccountId = conta.Id;
        con.LastName = 'Test';
        con.Email = 'test@test.com';
        insert con;
        
        Case caso = new Case();
        caso.AccountId = conta.Id;
        caso.ContactId = con.Id;
        caso.Subject = 'Assunto Teste';
        caso.Description = 'Descrição Teste';
        caso.Tipo__c = 'Atendimento';
        caso.Subtipo__c = 'Suporte';
        caso.Detalhamento__c = '';
        caso.Detalhamento2__c = '';
        caso.BR_Complemento__c = 'Teste';
        caso.BR_CEP__c = '123';
        caso.OrdemGrupoSolucionador__c = 0;
        caso.GrupoSolucionador__c = 'Backoffice Comercial';
        insert caso; 
        
        Emailmessage em = new EmailMessage();
        em.RelatedToId__c = [SELECT Id FROM Case LIMIT 1].Id;
        insert em;
    }
    
    @isTest static void test1(){
        Test.startTest();
        Id idbatch = Database.executeBatch(new bacthSetRelatedToIdEmail(), 100);
        Test.stopTest();
    }
}