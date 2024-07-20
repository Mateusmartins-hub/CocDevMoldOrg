/*
* Classe de test
*/
@isTest
public class ValidateTest {
    
    static testMethod void CPFValido(){
        Profile p = [SELECT Id FROM Profile WHERE (Name = 'System Administrator') or  (Name = 'Administrador do Sistema' )];
        
        // usuário de teste
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
 
        // rodando o teste com o usuário criado
        System.runAs(u1){
         
            Test.startTest();
            
            System.assert(Validate.getInstance().isCPF('84960969040'),true);
            
            Test.stopTest();
            
        }
    }
    
    static testMethod void CPFInvalido(){
        Profile p = [SELECT Id FROM Profile WHERE (Name = 'System Administrator') or  (Name = 'Administrador do Sistema' )];
        
        // usuário de teste
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
 
        // rodando o teste com o usuário criado
        System.runAs(u1){
         
            Test.startTest();
            
            System.assertEquals(Validate.getInstance().isCPF('00000000000'),false);
            
            Test.stopTest();
            
        }
    }
    
    static testMethod void CPFValido_PrimeiroDigito(){
        Profile p = [SELECT Id FROM Profile WHERE (Name = 'System Administrator') or  (Name = 'Administrador do Sistema' )];
        
        // usuário de teste
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
 
        // rodando o teste com o usuário criado
        System.runAs(u1){
         
            Test.startTest();
            
            System.assertEquals(Validate.getInstance().isCPF('12345678909'),true);
            
            Test.stopTest();
            
        }
    }
    
    static testMethod void CPFInvalido_DigitoNaoConfere(){
        Profile p = [SELECT Id FROM Profile WHERE (Name = 'System Administrator') or  (Name = 'Administrador do Sistema' )];
        
        // usuário de teste
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
 
        // rodando o teste com o usuário criado
        System.runAs(u1){
         
            Test.startTest();
            
            System.assertEquals(Validate.getInstance().isCPF('84960969039'),false);
            
            Test.stopTest();
            
        }
    }
    
    static testMethod void CPFInvalido_ComPontucao(){
        Profile p = [SELECT Id FROM Profile WHERE (Name = 'System Administrator') or  (Name = 'Administrador do Sistema' )];
        
        // usuário de teste
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
 
        // rodando o teste com o usuário criado
        System.runAs(u1){
         
            Test.startTest();
            
            System.assertEquals(Validate.getInstance().isCPF('849.609.690-40'),false);
            
            Test.stopTest();
            
        }
    }
    
    static testMethod void CNPJValido(){
        Profile p = [SELECT Id FROM Profile WHERE (Name = 'System Administrator') or  (Name = 'Administrador do Sistema' )];
        
        // usuário de teste
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
 
        // rodando o teste com o usuário criado
        System.runAs(u1){
         
            Test.startTest();
            
            System.assertEquals(Validate.getInstance().isCNPJ('64103291000126'),true);
            
            Test.stopTest();
            
        }
    }
    
    static testMethod void CNPJInvalido(){
        Profile p = [SELECT Id FROM Profile WHERE (Name = 'System Administrator') or  (Name = 'Administrador do Sistema' )];
        
        // usuário de teste
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
 
        // rodando o teste com o usuário criado
        System.runAs(u1){
         
            Test.startTest();
            
            System.assertEquals(Validate.getInstance().isCNPJ('64103291000113'), false);
            
            Test.stopTest();
            
        }
    }
    
}