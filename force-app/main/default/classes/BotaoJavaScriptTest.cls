@isTest
public class BotaoJavaScriptTest {
@TestSetup
    static void setup(){
        
        Profile p = [SELECT Id FROM Profile WHERE (Name = 'Comercial Franquias') or  (Name = 'Pedagógico Franquias') 
                     or (Name = 'Especializada FR') or (Name = 'Backoffice FR')
                     or (Name = 'Gerência Comercial FR') or (Name = 'Operacional FR')
                     or (Name = 'Planejamento FR') or (Name = 'ADM Franquias')
                     or (Name = 'Retenção FR') or (Name = 'Auditoria FR') or (Name = 'Consultoria Pedagógica ELT') limit 1];
       
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
        
        User u2 = new User(
            Alias = 'standt2', 
            Email='standarduser2@pearson.br', 
            EmailEncodingKey='UTF-8', 
            LastName='Testing 2', 
            LanguageLocaleKey='pt_BR', 
            LocaleSidKey='pt_BR', 
            ProfileId = p.Id, 
            TimeZoneSidKey='America/Sao_Paulo', 
            UserName='standarduser2@pearson.br'
            
        );
        insert u2;
        
	}
    
    @IsTest
    static void testOne(){
        
        User u = [select id, email from User where UserName = 'standarduser1@pearson.br' limit 1];
        Profile p = [select id,Name from Profile where Name = 'Comercial Franquias' limit 1];
        
        System.runAs(u){ // tem que rodar com o usuário que você selecionou 
            
        Test.startTest(); // aqui inicia o teste
            
            System.assertEquals('Comercial Franquias', p.Name);
            
            Account ac = new Account();
        	ac.Name = 'test account';
        	ac.BR_Account_email__c = 'email@email.com';
        	insert ac;
            
            FR_Procedimento_Franquias__c consulting = new FR_Procedimento_Franquias__c();
        	consulting.BR_StatusConsultoria__c = 'Aberta';
        	//consulting.RecordTypeId = '0120V0000026BWEQA2';
			consulting.BR_TipoConsultoria__c = 'Pedagógico';
        	consulting.BR_Conta__c = ac.Id;
            insert consulting;
                
            BotaoJavaScript.novaConsultoria(ac.Id); // depois que adicionar a consultoria, chamar o método informando o ID 
        
            Test.stopTest(); // aqui termina o teste
        }
    }
    
    @IsTest
    static void testTwo(){
        
        User u2 = [select id, email from User where UserName = 'standarduser1@pearson.br' limit 1];
        Profile p2 = [select id,Name from Profile where Name = 'Pedagógico Franquias' limit 1];
        
        System.runAs(u2){ // tem que rodar com o usuário que você selecionou 
            
        Test.startTest(); // aqui inicia o teste
            
            System.assertEquals('Pedagógico Franquias', p2.Name);
            
            Account ac2 = new Account();
        	ac2.Name = 'test account 2';
        	ac2.BR_Account_email__c = 'email2@email.com';
        	insert ac2;
            
            FR_Procedimento_Franquias__c consulting = new FR_Procedimento_Franquias__c();
        	consulting.BR_StatusConsultoria__c = 'Aberta';
        	//consulting.RecordTypeId = '0120V0000026BWEQA2';
			consulting.BR_TipoConsultoria__c = 'Pedagógico';
        	consulting.BR_Conta__c = ac2.Id;
            insert consulting;
                
            BotaoJavaScript.novaConsultoria(ac2.Id); // depois que adicionar a consultoria, chamar o método informando o ID 
        
            Test.stopTest(); // aqui termina o teste
        }
    }
        
    @IsTest
    static void testThree(){
        
        Profile p3 = [select id,Name from Profile where Name = 'Consultoria Pedagógica ELT' limit 1];
        User u3 = new User(
            Alias = 'standt1', 
            Email='standarduser3@pearson.br', 
            EmailEncodingKey='UTF-8', 
            LastName='Testing', 
            LanguageLocaleKey='pt_BR', 
            LocaleSidKey='pt_BR', 
            ProfileId = p3.Id, 
            TimeZoneSidKey='America/Sao_Paulo', 
            UserName='standarduser3@pearson.br'
        );
        insert u3;
 
        
        System.runAs(u3){ // tem que rodar com o usuário que você selecionou 
            
            Test.startTest(); // aqui inicia o teste
            
            System.assertEquals('Consultoria Pedagógica ELT', p3.Name);
            
            Account ac3 = new Account();
        	ac3.Name = 'test account 3';
        	ac3.BR_Account_email__c = 'email2@email.com';
        	insert ac3;
            
            FR_Procedimento_Franquias__c consulting = new FR_Procedimento_Franquias__c();
        	consulting.BR_StatusConsultoria__c = 'Aberta';
        	//consulting.RecordTypeId = '0120V0000026BWEQA2';
			consulting.BR_TipoConsultoria__c = 'Pedagógico';
        	consulting.BR_Conta__c = ac3.Id;
            insert consulting;
                
            BotaoJavaScript.novaConsultoria(ac3.Id); // depois que adicionar a consultoria, chamar o método informando o ID 
        
            Test.stopTest(); // aqui termina o teste
        }
    }
    
    @IsTest
    static void testFour(){
        
        Profile p4 = [SELECT Id FROM Profile WHERE Name LIKE '%admin%' LIMIT 1];
        
        User u4 = new User(
            Alias = 'standt1', 
            Email='standarduser4@pearson.br', 
            EmailEncodingKey='UTF-8', 
            LastName='Testing', 
            LanguageLocaleKey='pt_BR', 
            LocaleSidKey='pt_BR', 
            ProfileId = p4.Id, 
            TimeZoneSidKey='America/Sao_Paulo', 
            UserName='standarduser4@pearson.br'
        );
        insert u4;
        
        System.runAs(u4){ // tem que rodar com o usuário que você selecionou 
            
            Test.startTest(); // aqui inicia o teste
            
            Account ac3 = new Account();
        	ac3.Name = 'test account 3';
        	ac3.BR_Account_email__c = 'email2@email.com';
        	insert ac3;
            
            FR_Procedimento_Franquias__c consulting = new FR_Procedimento_Franquias__c();
        	consulting.BR_StatusConsultoria__c = 'Aberta';
        	//consulting.RecordTypeId = '0120V0000026BWEQA2';
			consulting.BR_TipoConsultoria__c = 'Pedagógico';
        	consulting.BR_Conta__c = ac3.Id;
            insert consulting;
                
            BotaoJavaScript.novaConsultoria(ac3.Id); // depois que adicionar a consultoria, chamar o método informando o ID 
        
            Test.stopTest(); // aqui termina o teste
        }
    }
    
    @IsTest
	static void testEnviarEmail() {
		FR_Procedimento_Franquias__c consult = TestHelper.CreateConsulting();
        insert consult;        

		Test.startTest();
        BotaoJavaScript.enviarEmail(consult.Id);
		
		Test.stopTest();
	}
    
    @IsTest
	static void testMontaErro2() {
        
        User u1 = [select id, email from User where UserName = 'standarduser1@pearson.br' limit 1];
        
		Test.startTest();
        
        System.runAs(u1){
            try
            {
                throw new DmlException('erro');
            }
            catch(DmlException ex)
            {  
                BotaoJavaScript.montaErro2('mensagem de erro de teste', ex);    
            }
             
        	//BotaoJavaScript.novaConsultoria('123456');
         }
		
		Test.stopTest();
	}
}