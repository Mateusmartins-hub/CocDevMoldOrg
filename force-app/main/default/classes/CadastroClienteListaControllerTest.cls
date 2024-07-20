@IsTest
public class CadastroClienteListaControllerTest {
    
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
    
    @IsTest
    static void listaSolicitacoes(){
        
        User u = [select id, email from User where UserName = 'standarduser2@pearson.br' limit 1];
        System.runAs(u){
            Test.startTest();
            
            SolicitacaoCadastroCliente__c sol = new SolicitacaoCadastroCliente__c();
            sol.Unidade__c = 'COC';
            sol.BR_Status__c = 'Enviado para Integração';
            sol.BR_CPF__c = '215.629.880-77';
            sol.InscricaoEstadual__c = 'ISENTO';
            sol.BR_ClienteBloqueado__c = false;
            sol.BR_Name__c = 'Cliente de Teste 001';
            sol.Tipo_de_Pessoa__c = 'Pessoa Física';
            sol.BR_GrupoAdminTesouro__c = 'Cliente Direto';
            sol.BR_Main_Address__c = 'Rua abcde';
            sol.BR_Main_Nbr__c = '123';
            sol.BR_Bairro__c = 'Bairro tal';
            sol.BR_Main_City__c = 'São Paulo';
            sol.BR_Main_State__c = 'SP';
            sol.BR_Main_Zip_code__c = '05036-001';
            sol.BR_Main_Complement__c = 'complemento 1';
            sol.BR_Phone__c = '1999999-9999';
            sol.BR_email__c = 'email@valido.com.br';
            sol.BR_RegionalVendas__c = 'São Paulo';
            sol.BR_EscritorioVendas__c = 'EV01';
            sol.BR_EquipeVendas__c = '100';
            sol.BR_CRTN__c = 'Demais Empresas';
            sol.BR_GrupoClassificaContrib__c = 'Terceiro - MI';
            
            insert sol;
            
            CadastroClienteListaController ctrl = new CadastroClienteListaController();
            Test.stopTest();
        }
        
    }
}