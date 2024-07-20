@isTest
public class CadastroClienteControllerTest {
    
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
    static void cadastroPF(){
        
        User u = [select id, email from User where UserName = 'standarduser2@pearson.br' limit 1];
        System.runAs(u){
            
            Test.startTest();
            
            CadastroClienteController ctrl = new CadastroClienteController();
            
            SolicitacaoCadastroCliente__c sol = new SolicitacaoCadastroCliente__c();
            sol.Unidade__c = 'COC';
            sol.BR_Status__c = 'Em Elaboração';
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
            sol.BR_CRTN__c = '8';
            sol.BR_GrupoClassificaContrib__c = 'Terceiro - MI';
            
            ctrl.showpageBlockPF = true;
            
            ctrl.CadCli = sol;
            
            ctrl.CustomSave();
            
            Test.stopTest();
            
        }
        
    }
    
    @IsTest
    static void cadastroPJ(){
        
        User u = [select id, email from User where UserName = 'standarduser2@pearson.br' limit 1];
        System.runAs(u){
            
            Test.startTest();
            
            CadastroClienteController ctrl = new CadastroClienteController();
            
            SolicitacaoCadastroCliente__c sol = new SolicitacaoCadastroCliente__c();
            sol.Unidade__c = 'COC';
            sol.BR_Status__c = 'Em Elaboração';
            sol.BR_CNPJ__c = '37.361.429/0001-14';
            sol.InscricaoEstadual__c = '123456';
            sol.BR_ClienteBloqueado__c = false;
            sol.BR_RazaoSocial__c = 'Cliente de Teste 001';
            sol.Tipo_de_Pessoa__c = 'Pessoa Jurídica';
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
            sol.BR_CRTN__c = '3';
            sol.BR_GrupoClassificaContrib__c = 'Terceiro - MI';
            
            ctrl.showpageBlockPF = true;
            
            ctrl.CadCli = sol;
            
            ctrl.CustomSave();
            
            Test.stopTest();
        }
        
    }
    
    @IsTest
    static void alterandoCadastroRejeitado(){
        User u = [select id, email from User where UserName = 'standarduser2@pearson.br' limit 1];
        System.runAs(u){
            
            Test.startTest();
            
            CadastroClienteController ctrl = new CadastroClienteController();
            
            SolicitacaoCadastroCliente__c sol = new SolicitacaoCadastroCliente__c();
            sol.Unidade__c = 'COC';
            sol.BR_Status__c = 'Rejeitado';
            sol.BR_CPF__c = '215.629.880-77';
            sol.InscricaoEstadual__c = 'ISENTO';
            sol.BR_ClienteBloqueado__c = false;
            sol.BR_Name__c = 'Cliente de Teste 001';
            sol.Tipo_de_Pessoa__c = 'Pessoa Física';
            sol.BR_GrupoAdminTesouro__c = 'Cliente Direto';
            sol.BR_Main_Address__c = 'Rua abcde';
            sol.BR_Main_Nbr__c = '123';
            sol.BR_Bairro__c = 'Bairro tal';
            sol.BR_Main_State__c = 'SP';
            sol.BR_Main_Zip_code__c = '05036-001';
            sol.BR_Main_Complement__c = 'complemento 1';
            sol.BR_Phone__c = '1999999-9999';
            sol.BR_email__c = 'email@valido.com.br';
            sol.BR_RegionalVendas__c = 'São Paulo';
            sol.BR_EscritorioVendas__c = 'EV01';
            sol.BR_EquipeVendas__c = '100';
            sol.BR_CRTN__c = '8';
            sol.BR_GrupoClassificaContrib__c = 'Terceiro - MI';
            
            ctrl.showpageBlockPF = true;
            
            ctrl.CadCli = sol;
            
            ctrl.CustomSave();
            
            Test.stopTest();
            
        }
    }
    
    @IsTest
    static void cpfInvalido(){
        User u = [select id, email from User where UserName = 'standarduser2@pearson.br' limit 1];
        System.runAs(u){
            
            Test.startTest();
            
            CadastroClienteController ctrl = new CadastroClienteController();
            
            SolicitacaoCadastroCliente__c sol = new SolicitacaoCadastroCliente__c();
            sol.Unidade__c = 'COC';
            sol.BR_Status__c = 'Em Elaboração';
            sol.BR_CPF__c = '215.666.880-11';
            sol.InscricaoEstadual__c = 'ISENTO';
            sol.BR_ClienteBloqueado__c = false;
            sol.BR_Name__c = 'Cliente de Teste 001';
            sol.Tipo_de_Pessoa__c = 'Pessoa Física';
            sol.BR_GrupoAdminTesouro__c = 'Cliente Direto';
            sol.BR_Main_Address__c = 'Rua abcde';
            sol.BR_Main_Nbr__c = '123';
            sol.BR_Bairro__c = 'Bairro tal';
            sol.BR_Main_State__c = 'SP';
            sol.BR_Main_Zip_code__c = '05036-001';
            sol.BR_Main_Complement__c = 'complemento 1';
            sol.BR_Phone__c = '1999999-9999';
            sol.BR_email__c = 'email@valido.com.br';
            sol.BR_RegionalVendas__c = 'São Paulo';
            sol.BR_EscritorioVendas__c = 'EV01';
            sol.BR_EquipeVendas__c = '100';
            sol.BR_CRTN__c = '8';
            sol.BR_GrupoClassificaContrib__c = 'Terceiro - MI';
            
            ctrl.showpageBlockPF = true;
            
            ctrl.CadCli = sol;
            
            ctrl.CustomSave();
            
            Test.stopTest();
        }
    }
    
    @IsTest
    static void cnpjInvalido(){
        User u = [select id, email from User where UserName = 'standarduser2@pearson.br' limit 1];
        System.runAs(u){
            
            Test.startTest();
            
            CadastroClienteController ctrl = new CadastroClienteController();
            
            SolicitacaoCadastroCliente__c sol = new SolicitacaoCadastroCliente__c();
            sol.Unidade__c = 'COC';
            sol.BR_Status__c = 'Em Elaboração';
            sol.BR_CNPJ__c = '37.361.429/0002-00';
            sol.InscricaoEstadual__c = '123456';
            sol.BR_ClienteBloqueado__c = false;
            sol.BR_RazaoSocial__c = 'Cliente de Teste 001';
            sol.Tipo_de_Pessoa__c = 'Pessoa Jurídica';
            sol.BR_GrupoAdminTesouro__c = 'Cliente Direto';
            sol.BR_Main_Address__c = 'Rua abcde';
            sol.BR_Main_Nbr__c = '123';
            sol.BR_Bairro__c = 'Bairro tal';
            sol.BR_Main_State__c = 'SP';
            sol.BR_Main_Zip_code__c = '05036-001';
            sol.BR_Main_Complement__c = 'complemento 1';
            sol.BR_Phone__c = '1999999-9999';
            sol.BR_email__c = 'email@valido.com.br';
            sol.BR_RegionalVendas__c = 'São Paulo';
            sol.BR_EscritorioVendas__c = 'EV01';
            sol.BR_EquipeVendas__c = '100';
            sol.BR_CRTN__c = '3';
            sol.BR_GrupoClassificaContrib__c = 'Terceiro - MI';
            
            ctrl.showpageBlockPF = false;
            
            ctrl.CadCli = sol;
            
            ctrl.CustomSave();
            
            Test.stopTest();
        }
    }
    
    @IsTest
    static void semPreenchimento(){
        
        User u = [select id, email from User where UserName = 'standarduser2@pearson.br' limit 1];
        System.runAs(u){
            
            Test.startTest();
            
            CadastroClienteController ctrl = new CadastroClienteController();
            
            SolicitacaoCadastroCliente__c sol = new SolicitacaoCadastroCliente__c();
                        
            ctrl.showpageBlockPF = true;
            
            ctrl.CadCli = sol;
            
            ctrl.CustomSave();
            
            Test.stopTest();
        }
        
    }
    
    @IsTest
    static void enviadoAprovacao(){
        User u = [select id, email from User where UserName = 'standarduser2@pearson.br' limit 1];
        System.runAs(u){
            
            Test.startTest();
            
            CadastroClienteController ctrl = new CadastroClienteController();
            
            SolicitacaoCadastroCliente__c sol = new SolicitacaoCadastroCliente__c();
            sol.Unidade__c = 'COC';
            sol.BR_Status__c = 'Em Análise de Cadastro';
            sol.BR_CPF__c = '215.629.880-77';
            sol.InscricaoEstadual__c = 'ISENTO';
            sol.BR_ClienteBloqueado__c = false;
            sol.BR_Name__c = 'Cliente de Teste 001';
            sol.Tipo_de_Pessoa__c = 'Pessoa Física';
            sol.BR_GrupoAdminTesouro__c = 'Cliente Direto';
            sol.BR_Main_Address__c = 'Rua abcde';
            sol.BR_Main_Nbr__c = '123';
            sol.BR_Bairro__c = 'Bairro tal';
            sol.BR_Main_State__c = 'SP';
            sol.BR_Main_Zip_code__c = '05036-001';
            sol.BR_Main_Complement__c = 'complemento 1';
            sol.BR_Phone__c = '1999999-9999';
            sol.BR_email__c = 'email@valido.com.br';
            sol.BR_RegionalVendas__c = 'São Paulo';
            sol.BR_EscritorioVendas__c = 'EV01';
            sol.BR_EquipeVendas__c = '100';
            sol.BR_CRTN__c = '8';
            sol.BR_GrupoClassificaContrib__c = 'Terceiro - MI';
            
            ctrl.showpageBlockPF = true;
            
            ctrl.CadCli = sol;
            
            ctrl.CustomSave();
            
            Test.stopTest();
            
        }
    }
    
    @IsTest
    static void cadastroBloqueio(){
        User u = [select id, email from User where UserName = 'standarduser2@pearson.br' limit 1];
        System.runAs(u){
            
            Test.startTest();
            
            CadastroClienteController ctrl = new CadastroClienteController();
            
            SolicitacaoCadastroCliente__c sol = new SolicitacaoCadastroCliente__c();
            sol.Unidade__c = 'COC';
            sol.BR_Status__c = 'Em Análise de Cadastro';
            sol.BR_CPF__c = '215.629.880-77';
            sol.InscricaoEstadual__c = 'ISENTO';
            sol.BR_ClienteBloqueado__c = true;
            sol.BR_Name__c = 'Cliente de Teste 001';
            sol.Tipo_de_Pessoa__c = 'Pessoa Física';
            sol.BR_GrupoAdminTesouro__c = 'Cliente Direto';
            sol.BR_Main_Address__c = 'Rua abcde';
            sol.BR_Main_Nbr__c = '123';
            sol.BR_Bairro__c = 'Bairro tal';
            sol.BR_Main_State__c = 'SP';
            sol.BR_Main_Zip_code__c = '05036-001';
            sol.BR_Main_Complement__c = 'complemento 1';
            sol.BR_Phone__c = '1999999-9999';
            sol.BR_email__c = 'email@valido.com.br';
            sol.BR_RegionalVendas__c = 'São Paulo';
            sol.BR_EscritorioVendas__c = 'EV01';
            sol.BR_EquipeVendas__c = '100';
            sol.BR_CRTN__c = '8';
            sol.BR_GrupoClassificaContrib__c = 'Terceiro - MI';
            
            ctrl.showpageBlockPF = true;
            
            ctrl.CadCli = sol;
            
            ctrl.CustomSave();
            
            Test.stopTest();
            
        }
    }
    
    @IsTest
    static void buscaCPF(){
        User u = [select id, email from User where UserName = 'standarduser2@pearson.br' limit 1];
        System.runAs(u){
            
            Test.startTest();
            
            Account acc = new Account();
            acc.BR_CPF__c = '501.094.890-71';
            acc.Name = 'Teste';
            insert acc;
            
            
            CadastroClienteController ctrl = new CadastroClienteController();
            SolicitacaoCadastroCliente__c sol = new SolicitacaoCadastroCliente__c();
            
            ctrl.showpageBlockPF = true;
            sol.BR_CPF__c = '501.094.890-71';
            
            ctrl.CadCli = sol;
           
            ctrl.SearchAccountByCpf();
            
            Test.stopTest();
            
        }
    }
    
     @IsTest
    static void buscaCNPJ(){
        User u = [select id, email from User where UserName = 'standarduser2@pearson.br' limit 1];
        System.runAs(u){
            
            Test.startTest();
            
            Account acc = new Account();
            acc.BR_CNPJ__c = '96.458.434/0001-09';
            acc.Name = 'Teste';
            insert acc;
            
            CadastroClienteController ctrl = new CadastroClienteController();
            SolicitacaoCadastroCliente__c sol = new SolicitacaoCadastroCliente__c();
            
            sol.BR_CNPJ__c = '96.458.434/0001-09';
            
            ctrl.CadCli = sol;
           
            ctrl.SearchAccountByCnpj();
            
            Test.stopTest();
            
        }
    }
    
    @IsTest
    static void escritorioVendaPickList(){
        User u = [select id, email from User where UserName = 'standarduser2@pearson.br' limit 1];
        System.runAs(u){
            
            Test.startTest();
            
            SolicitacaoCadastroCliente__c sol = new SolicitacaoCadastroCliente__c();
            CadastroClienteController ctrl = new CadastroClienteController();
            
            sol.Unidade__c = 'COC';
            ctrl.CadCli = sol;
            ctrl.getEscritorioVenda();
            
            sol.Unidade__c = 'Skill';
            ctrl.CadCli = sol;
            ctrl.getEscritorioVenda();
            
            sol.Unidade__c = 'Wizard';
            ctrl.CadCli = sol;
            ctrl.getEscritorioVenda();
            
            sol.Unidade__c = 'Yazigi';
            ctrl.CadCli = sol;
            ctrl.getEscritorioVenda();
            
            sol.Unidade__c = 'HED';
            ctrl.CadCli = sol;
            ctrl.getEscritorioVenda();
            
            sol.Unidade__c = 'ERR';	//tipo inválido
            ctrl.CadCli = sol;
            ctrl.getEscritorioVenda();
            
            Test.stopTest();
            
        }
    }
    
    @IsTest
    static void equipeVendaPickList(){
        User u = [select id, email from User where UserName = 'standarduser2@pearson.br' limit 1];
        System.runAs(u){
            
            Test.startTest();
            
            SolicitacaoCadastroCliente__c sol = new SolicitacaoCadastroCliente__c();
            CadastroClienteController ctrl = new CadastroClienteController();
            
            ctrl.selectedEscritorioVenda = 'WZ';
            ctrl.getEquipeVenda();
            
            ctrl.selectedEscritorioVenda = 'YZ';
            ctrl.getEquipeVenda();
            
            ctrl.selectedEscritorioVenda = 'SK';
            ctrl.getEquipeVenda();
            
            ctrl.selectedEscritorioVenda = 'EV01';
            ctrl.getEquipeVenda();
            
            ctrl.selectedEscritorioVenda = 'AA'; // não existe, é pra cair no else
            ctrl.getEquipeVenda();
            
            Test.stopTest(); 
        }
    }
    
    @IsTest
    static void solicitante(){
        User u = [select id, email from User where UserName = 'standarduser2@pearson.br' limit 1];
        System.runAs(u){
            
            Test.startTest();
            
            CadastroClienteController ctrl = new CadastroClienteController();
            
            ctrl.getSolicitante();
            
            Test.stopTest(); 
        }
    }
    
    @IsTest
    static void profile(){
        User u = [select id, email from User where UserName = 'standarduser2@pearson.br' limit 1];
        System.runAs(u){
            
            Test.startTest();
            
            CadastroClienteController ctrl = new CadastroClienteController();
            
            ctrl.getProfileApproverName();
            
            Test.stopTest(); 
        }
    }
    

}