@isTest
public class CaseBOTest {
    
    @TestSetup static void testSetup() {
        ParametrizacaoCasos__c param = new ParametrizacaoCasos__c();
        param.Tipo__c = 'Serviço COC';
        param.Subtipo__c = 'Atendimento';
        param.Detalhamento__c = 'Atendimento';
        param.Detalhamento2__c = '';
        param.AreaDonaProcesso__c = 'Financeiro';
        param.GrupoSolucionador1__c = 'Backoffice Comercial';
        param.TipoRegistroCaso__c = 'Padrão';
        insert param;
        
        GrupoSolucionador__c grupo0 = new GrupoSolucionador__c();
        grupo0.CamposObrigatorios__c = 'BR_CEP__c; BR_Complemento__c';
        grupo0.Ordem__c = 0;
        grupo0.ParametrizacaoCasos__c = param.Id;
        grupo0.MinutosSLA__c = 720;
        insert grupo0;
        
        GrupoSolucionador__c grupo = new GrupoSolucionador__c();
        grupo.CamposObrigatorios__c = 'BR_CEP__c; BR_Complemento__c';
        grupo.Ordem__c = 1;
        grupo.ParametrizacaoCasos__c = param.Id;
        grupo.GrupoSolucionador__c = 'Customer Care';
        grupo.MinutosSLA__c = 720;
        insert grupo;  
        
        GrupoSolucionador__c grupo2 = new GrupoSolucionador__c();
        grupo2.Ordem__c = 2;
        grupo2.ParametrizacaoCasos__c = param.Id;
        grupo2.GrupoSolucionador__c = 'Backoffice Comercial';
        grupo2.MinutosSLA__c = 720;
        insert grupo2;  
        
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
        caso.Tipo__c = 'Serviço COC';
        caso.Subtipo__c = 'Atendimento';
        caso.Detalhamento__c = 'Atendimento';
        caso.Detalhamento2__c = '';
        caso.BR_Complemento__c = 'Teste';
        caso.BR_CEP__c = '123';
        caso.OrdemGrupoSolucionador__c = 0;
        caso.GrupoSolucionador__c = 'Backoffice Comercial';
        insert caso;         
        
        Test.startTest();
        // setupFuture();
        Test.stopTest();
    } 

	@future    
    static void setupFuture() {
        List<Group> groups = [SELECT id, name FROM Group WHERE name LIKE '%LN: Customer Care%' OR name LIKE '%LN: Backoffice Comercial%'];
        		
        List<GroupMember> gms = new List<GroupMember>();
        for (Group g : groups) {
            GroupMember gm = new GroupMember();
            gm.GroupId = g.Id;
            gm.UserOrGroupId = system.UserInfo.GetUserId();
            
            gms.add(gm);
        }
        
        insert gms;
    }
    
    @isTest static void test1() {
        Case caso = [SELECT Id, AccountId, Tipo__c, Subtipo__c, Detalhamento__c, Detalhamento2__c, OrdemGrupoSolucionador__c FROM Case];
        
        GrupoSolucionador__c grupo = CasoController.buscarProxGrupo(caso.Tipo__c, caso.Subtipo__c, caso.Detalhamento__c, caso.Detalhamento2__c, caso.OrdemGrupoSolucionador__c)[0];
        update grupo;
        
        caso.OrdemGrupoSolucionador__c = grupo.Ordem__c;
        caso.GrupoSolucionador__c = grupo.GrupoSolucionador__c;
        update caso;
        
        LayoutCaso__c layout = new LayoutCaso__c();
        layout.CamposLayout__c = 'AccountId;Subtipo__c;Tipo__c;Detalhamento__c;Detalhamento2__c;Subject;Description';
        insert layout;
        
        SessaoLayoutCaso__c sessao = new SessaoLayoutCaso__c();
        sessao.CamposSessao__c = 'AccountId;Subtipo__c;Tipo__c;Detalhamento__c;Detalhamento2__c;Subject;Description';
        sessao.LayoutCaso__c = layout.Id;
        insert sessao;
        
        CaseBO.criarCaso('test', caso.AccountId);
        
        GrupoSolucionador__c grupoById = GrupoSolucionadorDAO.getGrupoSolucionadorById(grupo.Id);
        GrupoSolucionador__c grupoByCampos = GrupoSolucionadorDAO.getGrupoSolucionadorByCampos(caso.Tipo__c, caso.Subtipo__c, caso.Detalhamento__c, caso.Detalhamento2__c, 1);
        
    }
    
    @isTest static void test2() {
        Profile p = [SELECT Id FROM Profile WHERE (Name = 'System Administrator') or  (Name = 'Administrador do Sistema' )];
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

        Case caso = [SELECT Id, Tipo__c, Subtipo__c, Detalhamento__c, Detalhamento2__c, OrdemGrupoSolucionador__c FROM Case];        
        insert u;
        
        caso.Observadores__c = u.Id;
        update caso;
        
        LayoutCaso__c layout = new LayoutCaso__c();
        layout.CamposLayout__c = 'AccountId;Subtipo__c;Tipo__c;Detalhamento__c;Detalhamento2__c;Subject;Description';
        insert layout;
        
        SessaoLayoutCaso__c sessao = new SessaoLayoutCaso__c();
        sessao.CamposSessao__c = 'AccountId;Subtipo__c;Tipo__c;Detalhamento__c;Detalhamento2__c;Subject;Description';
        sessao.LayoutCaso__c = layout.Id;
        insert sessao;
    }
    
    @isTest static void test3() {
        try{
            update [SELECT Id FROM ParametrizacaoCasos__c LIMIT 1];
            ParametrizacaoCasos__c param = new ParametrizacaoCasos__c();
            param.Tipo__c = 'Serviço COC';
            param.Subtipo__c = 'Atendimento';
            param.Detalhamento__c = 'Atendimento';
            param.Detalhamento2__c = '';
            param.AreaDonaProcesso__c = 'Financeiro';
            insert param;  
        }catch(Exception e) {
            System.assertEquals('Insert failed. First exception on row 0; first error: FIELD_CUSTOM_VALIDATION_EXCEPTION, Já existe uma parametrização com essa árvore de assunto.: []', e.getMessage());
        }
    }
    
    @isTest static void test4() {
        Test.startTest();
        Case caso = [SELECT Id, OwnerId, Tipo__c, Subtipo__c, Detalhamento__c, Detalhamento2__c, OrdemGrupoSolucionador__c FROM Case];
        
        caso.OrdemGrupoSolucionador__c = 1;
        caso.GrupoSolucionador__c = 'Customer Care';
        caso.BR_CEP__c = '11';
        caso.BR_Complemento__c = '1';
        update caso;
        
        caso.Status = 'Aguardando Cliente';
        update caso;
        Test.stopTest();
    }
    
    @isTest static void test5() {
        Test.startTest();
        Case caso = [SELECT Id, Tipo__c, Subtipo__c, Detalhamento__c, Detalhamento2__c, OrdemGrupoSolucionador__c FROM Case];
        
        caso.Status = 'Aguardando Cliente';
        update caso;
        
        caso.Status = 'Novo';
        caso.Marca__c = 'Dom Bosco';
        update caso;
        Test.stopTest();
    }
    /*
    @isTest static void test6() {
        Test.startTest();
        Case caso = new Case();
        caso.Origin = 'Email';
        caso.Tipo__c = 'Serviço COC';
        caso.Subtipo__c = 'Atendimento';
        caso.Detalhamento__c = 'Atendimento';
        insert caso;
        
        caso.Marca__c = 'Dom Bosco';
        update caso;
      
        Test.stopTest();
    }*/
    
    @isTest static void test7() {
        
        Test.startTest();
        Account conta = new Account();
        conta.Name = 'Conta Teste';
        insert conta;
        
        Contact con = new Contact();
        con.AccountId = conta.Id;
        con.LastName = 'Test';
        con.Email = 'test@test.com';
        insert con;
        
        Case casoFechado = new Case();
        casoFechado.Status = 'Closed';
        casoFechado.AccountId = conta.Id;
        casoFechado.ContactId = con.Id;
        casoFechado.Subject = 'Assunto Teste';
        casoFechado.Description = 'Descrição Teste';
        casoFechado.Tipo__c = 'Serviço COC';
        casoFechado.Subtipo__c = 'Atendimento';
        casoFechado.Detalhamento__c = 'Atendimento';
        casoFechado.Detalhamento2__c = '';
        casoFechado.BR_Complemento__c = 'Teste';
        casoFechado.BR_CEP__c = '123';
        casoFechado.OrdemGrupoSolucionador__c = 0;
        casoFechado.GrupoSolucionador__c = 'Backoffice Comercial';
        insert casoFechado; 
        Test.stopTest();
    }
    
}