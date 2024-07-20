@isTest
public class AccountBOTest {

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
    static void testCadastroPF(){
        
        User u = [select id, email from User where UserName = 'standarduser1@pearson.br' limit 1];
        Id idPessoaFisica = RecordTypeUtil.getInstance().getRecordTypePorNome('Account', 'Pessoa Física').getRecordTypeId();
        Id idPessoaJuridica = RecordTypeUtil.getInstance().getRecordTypePorNome('Account', 'Pessoa Jurídica').getRecordTypeId();
        
        system.debug('Id Pessoa Física: ' + idPessoaFisica );
        
        System.runAs(u){
            
            Test.startTest();
            
            Account ac = new Account();
       		ac.Name = 'test account';
        	ac.BR_Account_email__c = 'email@email.com';
            ac.TipoRegistroAuxiliar__c = 'PessoaFisica';
            ac.RecordTypeId = idPessoaFisica;
            ac.BR_CPF__c = 'XXXXXXXXXXX';
        	insert ac;
                        
            Account ac2 = new Account();
       		ac2.Name = 'test account 2';
        	ac2.BR_Account_email__c = 'email2@email.com';
            ac2.TipoRegistroAuxiliar__c = 'PessoaJuridica';
            ac2.RecordTypeId = idPessoaJuridica;
            ac2.BR_cnpj__c = 'XX.XXX.XXX/XXXX-XX';
        	insert ac2;
            
           	List<Account> lista = new List<Account>();
            lista.add(ac);
            lista.add(ac2);
            
            AccountBO.getInstance().preencherTipoRegistro(lista);
            
            Test.stopTest();           
            
        }
        
    }
    
    @IsTest
    static void TestpreencherCodigoIBGEConta(){
        User u = [select id, email from User where UserName = 'standarduser1@pearson.br' limit 1];
        Id idPessoaFisica = RecordTypeUtil.getInstance().getRecordTypePorNome('Account', 'Pessoa Física').getRecordTypeId();
        Id idPessoaJuridica = RecordTypeUtil.getInstance().getRecordTypePorNome('Account', 'Pessoa Jurídica').getRecordTypeId();
        
        System.runAs(u){
            
            Test.startTest();
            
            Account ac = new Account();
       		ac.Name = 'test account';
        	ac.BR_Account_email__c = 'email@email.com';
            ac.TipoRegistroAuxiliar__c = 'PessoaFisica';
            ac.BillingState = 'SP';
            ac.BillingCity = 'São Paulo';
            ac.RecordTypeId = idPessoaFisica;
        	insert ac;
                        
            Account ac2 = new Account();
       		ac2.Name = 'test account 2';
        	ac2.BR_Account_email__c = 'email2@email.com';
            ac2.TipoRegistroAuxiliar__c = 'PessoaJuridica';
            ac2.RecordTypeId = idPessoaJuridica;
            ac2.BillingState = 'RJ';
            ac2.BillingCity = 'Rio de Janeiro';
        	insert ac2;
            
            List<Account> lista = new List<Account>();
            lista.add(ac);
            lista.add(ac2);
            
            AccountBO.getInstance().preencherCodigoIBGEConta(lista);
            
            Test.stopTest();   
        }
    }
    
    @IsTest
    static void testCriaVinculoConsultoria(){
        
        User u = [select id, email from User where UserName = 'standarduser1@pearson.br' limit 1];
        
        System.runAs(u){
                       
            Test.startTest();            
            
            Account ac = new Account();
        	ac.Name = 'test account 2';
        	ac.BR_Account_email__c = 'email2@email.com';
            
        	insert ac;
            
            
            FR_Procedimento_Franquias__c consult = new FR_Procedimento_Franquias__c();
        	consult.BR_StatusConsultoria__c = 'Aberta';
        	consult.BR_TipoConsultoria__c = 'Pedagógico';
            consult.RecordTypeId = Schema.SobjectType.FR_Procedimento_Franquias__c.getRecordTypeInfosByDeveloperName().get('Pedagogico').getRecordTypeId(); //'0120V0000026BWEQA2';
            consult.BR_Conta__c = ac.id;
            insert consult;
            
           
            AccountBO.getInstance().criaVinculoConsultoria(ac.Id,'Pedagógico');
            
            Test.stopTest();
            
        }
        
    }
        
}