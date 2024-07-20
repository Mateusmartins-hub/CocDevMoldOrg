@IsTest
public class CadastroClienteIntegracaoSAPJobTest {
	
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
    static void integraSolicitacoes(){
        
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
            
            SolicitacaoCadastroCliente__c sol2 = new SolicitacaoCadastroCliente__c();
            sol2.Unidade__c = 'Wizard';
            sol2.BR_Status__c = 'Enviado para Integração';
            sol2.BR_CPF__c = '215.629.880-77';
            sol2.InscricaoEstadual__c = 'ISENTO';
            sol2.BR_ClienteBloqueado__c = false;
            sol2.BR_Name__c = 'Cliente de Teste 001';
            sol2.Tipo_de_Pessoa__c = 'Pessoa Física';
            sol2.BR_GrupoAdminTesouro__c = 'Cliente Direto';
            sol2.BR_Main_Address__c = 'Rua abcde';
            sol2.BR_Main_Nbr__c = '123';
            sol2.BR_Bairro__c = 'Bairro tal';
            sol2.BR_Main_City__c = 'São Paulo';
            sol2.BR_Main_State__c = 'SP';
            sol2.BR_Main_Zip_code__c = '05036-001';
            sol2.BR_Main_Complement__c = 'complemento 1';
            sol2.BR_Phone__c = '1999999-9999';
            sol2.BR_email__c = 'email@valido.com.br';
            sol2.BR_RegionalVendas__c = 'Acre';
            sol2.BR_EscritorioVendas__c = 'EV01';
            sol2.BR_EquipeVendas__c = '100';
            sol2.BR_CRTN__c = 'Pessoa Física';
            sol2.BR_GrupoClassificaContrib__c = 'Parceiros - MI';
            
            insert sol2;
            
            SolicitacaoCadastroCliente__c sol3 = new SolicitacaoCadastroCliente__c();
            sol3.Unidade__c = 'Yazigi';
            sol3.BR_Status__c = 'Enviado para Integração';
            sol3.BR_CPF__c = '215.629.880-77';
            sol3.InscricaoEstadual__c = 'ISENTO';
            sol3.BR_ClienteBloqueado__c = false;
            sol3.BR_Name__c = 'Cliente de Teste 001';
            sol3.Tipo_de_Pessoa__c = 'Pessoa Física';
            sol3.BR_GrupoAdminTesouro__c = 'Prefeituras';
            sol3.BR_Main_Address__c = 'Rua abcde';
            sol3.BR_Main_Nbr__c = '123';
            sol3.BR_Bairro__c = 'Bairro tal';
            sol3.BR_Main_City__c = 'São Paulo';
            sol3.BR_Main_State__c = 'SP';
            sol3.BR_Main_Zip_code__c = '05036-001';
            sol3.BR_Main_Complement__c = null;
            sol3.BR_Phone__c = '1999999-9999';
            sol3.BR_email__c = 'email@valido.com.br';
            sol3.BR_RegionalVendas__c = 'Bahia';
            sol3.BR_EscritorioVendas__c = 'EV01';
            sol3.BR_EquipeVendas__c = '100';
            sol3.BR_CRTN__c = 'Simples Nacional';
            sol3.BR_GrupoClassificaContrib__c = 'Parceiros - MI';
            
            insert sol3;
            
            SolicitacaoCadastroCliente__c sol4 = new SolicitacaoCadastroCliente__c();
            sol4.Unidade__c = 'COC';
            sol4.BR_Status__c = 'Enviado para Integração';
            sol4.BR_CNPJ__c = '37.361.429/0001-14';
            sol4.InscricaoEstadual__c = '123456';
            sol4.BR_ClienteBloqueado__c = false;
            sol4.BR_RazaoSocial__c = 'Cliente de Teste 001';
            sol4.Tipo_de_Pessoa__c = 'Pessoa Jurídica';
            sol4.BR_GrupoAdminTesouro__c = 'Prospecção';
            sol4.BR_Main_Address__c = 'Rua abcde';
            sol4.BR_Main_Nbr__c = '123';
            sol4.BR_Bairro__c = 'Bairro tal';
            sol4.BR_Main_City__c = 'São Paulo';
            sol4.BR_Main_State__c = 'SP';
            sol4.BR_Main_Zip_code__c = '05036-001';
            sol4.BR_Main_Complement__c = 'complemento 1';
            sol4.BR_Phone__c = '1999999-9999';
            sol4.BR_email__c = 'email@valido.com.br';
            sol4.BR_RegionalVendas__c = 'Minas Gerais';
            sol4.BR_EscritorioVendas__c = 'EV01';
            sol4.BR_EquipeVendas__c = '100';
            sol4.BR_CRTN__c = 'Simples Nacional';
            sol4.BR_GrupoClassificaContrib__c = 'Terceiro - MI';
            sol4.BR_ClienteBloqueado__c = true;
            
            insert sol4;
            
            SolicitacaoCadastroCliente__c sol5 = new SolicitacaoCadastroCliente__c();
            sol5.Unidade__c = 'NAME';
            sol5.BR_Status__c = 'Enviado para Integração';
            sol5.BR_CPF__c = '215.629.880-77';
            sol5.InscricaoEstadual__c = 'ISENTO';
            sol5.BR_ClienteBloqueado__c = false;
            sol5.BR_Name__c = 'Cliente de Teste 00112345678901234567890123456';
            sol5.Tipo_de_Pessoa__c = 'Pessoa Física';
            sol5.BR_GrupoAdminTesouro__c = 'Professor';
            sol5.BR_Main_Address__c = 'Rua abcde';
            sol5.BR_Main_Nbr__c = '123';
            sol5.BR_Bairro__c = 'Bairro tal';
            sol5.BR_Main_City__c = 'São Paulo';
            sol5.BR_Main_State__c = 'SP';
            sol5.BR_Main_Zip_code__c = '05036-001';
            sol5.BR_Main_Complement__c = 'complemento 1';
            sol5.BR_Phone__c = '1999999-9999';
            sol5.BR_email__c = 'email@valido.com.br';
            sol5.BR_RegionalVendas__c = 'São Paulo';
            sol5.BR_EscritorioVendas__c = 'EV01';
            sol5.BR_EquipeVendas__c = '100';
            sol5.BR_CRTN__c = 'Demais Empresas';
            sol5.BR_GrupoClassificaContrib__c = 'Terceiro - MI';
            
            insert sol5;
            
            SolicitacaoCadastroCliente__c sol6 = new SolicitacaoCadastroCliente__c();
            sol6.Unidade__c = 'HED';
            sol6.BR_Status__c = 'Enviado para Integração';
            sol6.BR_CPF__c = '215.629.880-77';
            sol6.InscricaoEstadual__c = 'ISENTO';
            sol6.BR_ClienteBloqueado__c = false;
            sol6.BR_Name__c = 'Cliente de Teste 00112345678901234567890123456';
            sol6.Tipo_de_Pessoa__c = 'Pessoa Física';
            sol6.BR_GrupoAdminTesouro__c = 'Professor';
            sol6.BR_Main_Address__c = 'Rua abcde';
            sol6.BR_Main_Nbr__c = '123';
            sol6.BR_Bairro__c = 'Bairro tal';
            sol6.BR_Main_City__c = 'São Paulo';
            sol6.BR_Main_State__c = 'SP';
            sol6.BR_Main_Zip_code__c = '05036-001';
            sol6.BR_Main_Complement__c = 'complemento 1';
            sol6.BR_Phone__c = '1999999-9999';
            sol6.BR_email__c = 'email@valido.com.br';
            sol6.BR_RegionalVendas__c = 'São Paulo';
            sol6.BR_EscritorioVendas__c = 'EV01';
            sol6.BR_EquipeVendas__c = '100';
            sol6.BR_CRTN__c = 'Demais Empresas';
            sol6.BR_GrupoClassificaContrib__c = 'Terceiro - MI';
            
            insert sol6;
            
            SolicitacaoCadastroCliente__c sol7 = new SolicitacaoCadastroCliente__c();
            sol7.Unidade__c = 'Skill';
            sol7.BR_Status__c = 'Enviado para Integração';
            sol7.BR_CPF__c = '215.629.880-77';
            sol7.InscricaoEstadual__c = 'ISENTO';
            sol7.BR_ClienteBloqueado__c = false;
            sol7.BR_Name__c = 'Cliente de Teste Marca Skill';
            sol7.Tipo_de_Pessoa__c = 'Pessoa Física';
            sol7.BR_GrupoAdminTesouro__c = 'Professor';
            sol7.BR_Main_Address__c = 'Rua abcde';
            sol7.BR_Main_Nbr__c = '123';
            sol7.BR_Bairro__c = 'Bairro tal';
            sol7.BR_Main_City__c = 'São Paulo';
            sol7.BR_Main_State__c = 'SP';
            sol7.BR_Main_Zip_code__c = '05036-001';
            sol7.BR_Main_Complement__c = 'complemento 1';
            sol7.BR_Phone__c = '1999999-9999';
            sol7.BR_email__c = 'email@valido.com.br';
            sol7.BR_RegionalVendas__c = 'São Paulo';
            sol7.BR_EscritorioVendas__c = 'EV01';
            sol7.BR_EquipeVendas__c = '100';
            sol7.BR_CRTN__c = 'Demais Empresas';
            sol7.BR_GrupoClassificaContrib__c = 'Terceiro - MI';
            
            insert sol7;   
            
            SolicitacaoCadastroCliente__c sol8 = new SolicitacaoCadastroCliente__c();
            sol8.Unidade__c = 'Dom Bosco';
            sol8.BR_Status__c = 'Enviado para Integração';
            sol8.BR_CPF__c = '215.629.880-77';
            sol8.InscricaoEstadual__c = 'ISENTO';
            sol8.BR_ClienteBloqueado__c = false;
            sol8.BR_Name__c = 'Cliente de Teste Marca Skill';
            sol8.Tipo_de_Pessoa__c = 'Pessoa Física';
            sol8.BR_GrupoAdminTesouro__c = 'Professor';
            sol8.BR_Main_Address__c = 'Rua abcde';
            sol8.BR_Main_Nbr__c = '123';
            sol8.BR_Bairro__c = 'Bairro tal';
            sol8.BR_Main_City__c = 'São Paulo';
            sol8.BR_Main_State__c = 'SP';
            sol8.BR_Main_Zip_code__c = '05036-001';
            sol8.BR_Main_Complement__c = 'complemento 1';
            sol8.BR_Phone__c = '1999999-9999';
            sol8.BR_email__c = 'email@valido.com.br';
            sol8.BR_RegionalVendas__c = 'São Paulo';
            sol8.BR_EscritorioVendas__c = 'EV01';
            sol8.BR_EquipeVendas__c = '100';
            sol8.BR_CRTN__c = 'Demais Empresas';
            sol8.BR_GrupoClassificaContrib__c = 'Terceiro - MI';
            
            insert sol8; 
            
            SolicitacaoCadastroCliente__c sol9 = new SolicitacaoCadastroCliente__c();
            sol9.Unidade__c = 'Atitude';
            sol9.BR_Status__c = 'Enviado para Integração';
            sol9.BR_CPF__c = '215.629.880-77';
            sol9.InscricaoEstadual__c = 'ISENTO';
            sol9.BR_ClienteBloqueado__c = false;
            sol9.BR_Name__c = 'Cliente de Teste Marca Skill';
            sol9.Tipo_de_Pessoa__c = 'Pessoa Física';
            sol9.BR_GrupoAdminTesouro__c = 'Professor';
            sol9.BR_Main_Address__c = 'Rua abcde';
            sol9.BR_Main_Nbr__c = '123';
            sol9.BR_Bairro__c = 'Bairro tal';
            sol9.BR_Main_City__c = 'São Paulo';
            sol9.BR_Main_State__c = 'SP';
            sol9.BR_Main_Zip_code__c = '05036-001';
            sol9.BR_Main_Complement__c = 'complemento 1';
            sol9.BR_Phone__c = '1999999-9999';
            sol9.BR_email__c = 'email@valido.com.br';
            sol9.BR_RegionalVendas__c = 'São Paulo';
            sol9.BR_EscritorioVendas__c = 'EV01';
            sol9.BR_EquipeVendas__c = '100';
            sol9.BR_CRTN__c = 'Demais Empresas';
            sol9.BR_GrupoClassificaContrib__c = 'Terceiro - MI';
            
            insert sol9;
            
            SolicitacaoCadastroCliente__c sol10 = new SolicitacaoCadastroCliente__c();
            sol10.Unidade__c = 'Corporate';
            sol10.BR_Status__c = 'Enviado para Integração';
            sol10.BR_CPF__c = '215.629.880-77';
            sol10.InscricaoEstadual__c = 'ISENTO';
            sol10.BR_ClienteBloqueado__c = false;
            sol10.BR_Name__c = 'Cliente de Teste Marca Skill';
            sol10.Tipo_de_Pessoa__c = 'Pessoa Física';
            sol10.BR_GrupoAdminTesouro__c = 'Professor';
            sol10.BR_Main_Address__c = 'Rua abcde';
            sol10.BR_Main_Nbr__c = '123';
            sol10.BR_Bairro__c = 'Bairro tal';
            sol10.BR_Main_City__c = 'São Paulo';
            sol10.BR_Main_State__c = 'SP';
            sol10.BR_Main_Zip_code__c = '05036-001';
            sol10.BR_Main_Complement__c = 'complemento 1';
            sol10.BR_Phone__c = '1999999-9999';
            sol10.BR_email__c = 'email@valido.com.br';
            sol10.BR_RegionalVendas__c = 'São Paulo';
            sol10.BR_EscritorioVendas__c = 'EV01';
            sol10.BR_EquipeVendas__c = '100';
            sol10.BR_CRTN__c = 'Demais Empresas';
            sol10.BR_GrupoClassificaContrib__c = 'Terceiro - MI';
            
            insert sol10;
            
            SolicitacaoCadastroCliente__c sol11 = new SolicitacaoCadastroCliente__c();
            sol11.Unidade__c = 'Coleção Mentes';
            sol11.BR_Status__c = 'Enviado para Integração';
            sol11.BR_CPF__c = '215.629.880-77';
            sol11.InscricaoEstadual__c = 'ISENTO';
            sol11.BR_ClienteBloqueado__c = false;
            sol11.BR_Name__c = 'Cliente de Teste Marca Skill';
            sol11.Tipo_de_Pessoa__c = 'Pessoa Física';
            sol11.BR_GrupoAdminTesouro__c = 'Professor';
            sol11.BR_Main_Address__c = 'Rua abcde';
            sol11.BR_Main_Nbr__c = '123';
            sol11.BR_Bairro__c = 'Bairro tal';
            sol11.BR_Main_City__c = 'São Paulo';
            sol11.BR_Main_State__c = 'SP';
            sol11.BR_Main_Zip_code__c = '05036-001';
            sol11.BR_Main_Complement__c = 'complemento 1';
            sol11.BR_Phone__c = '1999999-9999';
            sol11.BR_email__c = 'email@valido.com.br';
            sol11.BR_RegionalVendas__c = 'São Paulo';
            sol11.BR_EscritorioVendas__c = 'EV01';
            sol11.BR_EquipeVendas__c = '100';
            sol11.BR_CRTN__c = 'Demais Empresas';
            sol11.BR_GrupoClassificaContrib__c = 'Terceiro - MI';
            
            insert sol11;
            
            SolicitacaoCadastroCliente__c sol12 = new SolicitacaoCadastroCliente__c();
            sol12.Unidade__c = 'Leitura e Companhia';
            sol12.BR_Status__c = 'Enviado para Integração';
            sol12.BR_CPF__c = '215.629.880-77';
            sol12.InscricaoEstadual__c = 'ISENTO';
            sol12.BR_ClienteBloqueado__c = false;
            sol12.BR_Name__c = 'Cliente de Teste Marca Skill';
            sol12.Tipo_de_Pessoa__c = 'Pessoa Física';
            sol12.BR_GrupoAdminTesouro__c = 'Professor';
            sol12.BR_Main_Address__c = 'Rua abcde';
            sol12.BR_Main_Nbr__c = '123';
            sol12.BR_Bairro__c = 'Bairro tal';
            sol12.BR_Main_City__c = 'São Paulo';
            sol12.BR_Main_State__c = 'SP';
            sol12.BR_Main_Zip_code__c = '05036-001';
            sol12.BR_Main_Complement__c = 'complemento 1';
            sol12.BR_Phone__c = '1999999-9999';
            sol12.BR_email__c = 'email@valido.com.br';
            sol12.BR_RegionalVendas__c = 'São Paulo';
            sol12.BR_EscritorioVendas__c = 'EV01';
            sol12.BR_EquipeVendas__c = '100';
            sol12.BR_CRTN__c = 'Demais Empresas';
            sol12.BR_GrupoClassificaContrib__c = 'Terceiro - MI';
            
            insert sol12;
            
            CadastroClienteIntegracaoSAPJob.getInstance().integra();
                        
            Test.stopTest();
            
        }
    }
    
    @IsTest
    static void integraSAP(){
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
            
            CadastroClienteIntegracaoSAPJob.sendToSAP(sol.Id);
            CadastroClienteIntegracaoSAPJob.NumeroApenas('a/a');
                       
            Test.stopTest();
        }
    }
    
    @IsTest 
    static void agendaTarefa(){
        User u = [select id, email from User where UserName = 'standarduser2@pearson.br' limit 1];
        System.runAs(u){
            Test.startTest();
            
            String id = CadastroClientesSAPTASK.scheduleIt();
            System.abortJob(id);
            
            CadastroClientesSAPTASK task = new CadastroClientesSAPTASK();
            task.execute(null);
            
            Test.stopTest();
        }
    }
}