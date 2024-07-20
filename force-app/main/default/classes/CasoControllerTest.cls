@isTest
public class CasoControllerTest {
    
    
    @TestSetup 
    static void testSetup() {
        
        Profile p = [SELECT Id FROM Profile WHERE (Name = 'System Administrator') or  (Name = 'Administrador do Sistema' ) limit 1];
        
        // Aprovador 
        Test.startTest();
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
        Test.stopTest();
        
        System.runAs(u1){
                                
            ParametrizacaoCasos__c param = new ParametrizacaoCasos__c();
            param.Tipo__c = 'Cadastro';
            param.Subtipo__c = 'Novo Cadastro';
            param.Detalhamento__c = 'Material avariado';
            param.Detalhamento2__c = '';
            param.AreaDonaProcesso__c = 'Financeiro';
            insert param;
            
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
            
            Case caso = new Case();
            caso.AccountId = conta.Id;
            caso.Subject = 'Assunto Teste';
            caso.Description = 'Descrição Teste';
            caso.Tipo__c = 'Cadastro';
            caso.Subtipo__c = 'Novo Cadastro';
            caso.Detalhamento__c = 'Material avariado';
            caso.Detalhamento2__c = '';
            caso.BR_Complemento__c = 'Teste';
            caso.BR_CEP__c = '123';
            caso.OrdemGrupoSolucionador__c = 0;
            caso.GrupoSolucionador__c = 'Backoffice Comercial'; 
            insert caso;
            
            Account_Contact__c ctc = TestHelper.createAccountContact();
            ctc.Account__c = conta.Id;
            ctc.Email__c = 'teste@sottelli.com';
            insert ctc;

        }
        
    } 
    
    @isTest static void testarAceitarCaso() {
        Case caso = [SELECT Id FROM Case where Subject = 'Assunto Teste' limit 1];
        
        CasoController.AceitarCaso(caso.Id);
    }
    @isTest static void testarDeleteCase() {
        Case caso = [SELECT Id FROM Case where Subject = 'Assunto Teste' limit 1];
        
        CasoController.deleteCase(caso);
    }
    @isTest static void testarGetRecordTypeIdPadrao() {
        CasoController.getRecordTypeIdPadrao();
    }
    @isTest static void testarVerificaUsuarioAtualFila() {
        Case caso = [SELECT GrupoSolucionador__c FROM Case where Subject = 'Assunto Teste' limit 1];
        
        CasoController.verificaUsuarioAtualFila(caso.GrupoSolucionador__c);
    }
    @isTest static void testarBuscarGrupoSolucionadorAtual() {
        GrupoSolucionador__c grupo = [SELECT Id FROM GrupoSolucionador__c LIMIT 1];
        
        CasoController.buscarGrupoSolucionadorAtual(grupo.Id);
    }
    @isTest static void testarBuscarGrupo() {
        GrupoSolucionador__c grupo = [SELECT Id FROM GrupoSolucionador__c LIMIT 1];
        
        CasoController.buscarGrupo(grupo.Id);
    }
    @isTest static void testarSalvarInformacoes() {
        Case caso = [SELECT Id FROM Case where Subject = 'Assunto Teste' limit 1];
        CasoController.salvarInformacoes('[{"observador":"' + UserInfo.getUserId() + '","informacao":"Teste","casoId":"' + caso.Id + '"}]');
    }
    @isTest static void testarFecharCaso() {
        Case caso = [SELECT Id FROM Case];
        caso.AceitoPor__c = Null;
        update caso;
        
        CasoController.fecharCaso(caso.Id);
    }
    
    @isTest static void testarClonarCaso() {  

        User user = [SELECT Id, Email FROM User WHERE Email = 'standarduser1@pearson.br' LIMIT 1];

        List<Group> groups = [SELECT Id, name FROM Group WHERE name IN ('LN: Customer Care - ALL', 'Coordenadores Customer Care')];
        
        List<GroupMember> groupMembership = new List<GroupMember>();
        for(Group grp: groups){
            GroupMember groupMember = new GroupMember();
            groupMember.GroupId = grp.Id;
            groupMember.UserOrGroupId = user.Id;
            groupMembership.add(groupMember);
        }
        insert groupMembership;
        
        System.runAs(user){
            
            Test.startTest();
            Case caso = [SELECT Id FROM Case where Subject = 'Assunto Teste' limit 1];
            
            CasoController.clonarCaso(caso.Id);
            Test.stopTest();
    	}
    }

    @isTest static void testarCancelarCaso() {
        Case caso = [SELECT Id FROM Case];
        
        CasoController.cancelarCaso(caso.Id);
    }
    @isTest static void testarCriarComentario() {
        Case caso = [SELECT Id FROM Case];
        
        CasoController.criarComentario('Teste', caso.Id);
    }
    @isTest static void testarIsClassic() {
        CasoController.isClassic();
    }
    
    @isTest static void testarRetomarSLA() {
        User u = [select id, email from User where email = 'standarduser1@pearson.br' limit 1];
        System.runAs(u){
            
        Test.startTest();
        Case caso = [SELECT Id, Tipo__c, Subtipo__c, Detalhamento__c, Detalhamento2__c, OrdemGrupoSolucionador__c FROM Case]; 
        GrupoSolucionador__c grupo = CasoController.buscarProxGrupo(caso.Tipo__c, caso.Subtipo__c, caso.Detalhamento__c, caso.Detalhamento2__c, caso.OrdemGrupoSolucionador__c)[0];
        //GrupoSolucionador__c grupoAtual = [SELECT Id FROM GrupoSolucionador__c WHERE Ordem__c = 0];
        caso.OrdemGrupoSolucionador__c = grupo.Ordem__c;
        caso.GrupoSolucionador__c = grupo.GrupoSolucionador__c;
        update caso;
        
        CasoController.retomarSLA(caso.Id, grupo.Id); //grupoAtual.Id
        Test.stopTest();
    	}
    }

    @isTest static void testarConvertIdToEighteen() {
        Case caso = [SELECT Id FROM Case];
        
        CasoController.convertIdToEighteen(caso.Id);
    }
    @isTest static void testarBuscarProxGrupo() {
        Case caso = [SELECT Id, Tipo__c, Subtipo__c, Detalhamento__c, Detalhamento2__c FROM Case];
        
        CasoController.buscarProxGrupo(caso.Tipo__c, caso.Subtipo__c, caso.Detalhamento__c, caso.Detalhamento2__c, 1);
    }
    @isTest static void testarVerificaUltimoGrupo() {
        Case caso = [SELECT Id FROM Case];
        
        CasoController.verificaUltimoGrupo(caso.Id);
    }
    @isTest static void testarVerificaUsuarioGrupo() {
        Case caso = [SELECT Id FROM Case];
        
        CasoController.verificaUsuarioGrupo(caso.Id);
    }
    
    @isTest 
    static void testarGetCamposCaso() {  
        
        User u = [select id, email from User where email = 'standarduser1@pearson.br' limit 1];
        System.runAs(u){
            
        	Test.startTest();

            Case caso = [SELECT Id, Tipo__c, Subtipo__c, Detalhamento__c, Detalhamento2__c, OrdemGrupoSolucionador__c FROM Case];
             
            GrupoSolucionador__c grupo = CasoController.buscarProxGrupo(caso.Tipo__c, caso.Subtipo__c, caso.Detalhamento__c, caso.Detalhamento2__c, caso.OrdemGrupoSolucionador__c)[0];
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
            
            CasoController.getCamposCaso(caso.Id);
            
            Test.stopTest();
        }
    }   
    @isTest static void testarGetCamposCasoPt2() {  
        CasoController.getCamposCaso(null);
    }    
    @isTest static void testarEnviarEmailFechamento() {  
        CasoController.enviarEmailFechamento('matheus.sales@sottelli.com', 'matheus.sales@sottelli.com', 'test', [SELECT Id FROM Case LIMIT 1].Id);
    } 
    @isTest static void testarBuscarGruposDoUser() {  
        CasoController.buscarGruposDoUser(UserInfo.getUserId());
    }  
    @isTest static void testvalidateOneCase() {
        CaseAcceptClass.validateOneCase([SELECT Id, OwnerId FROM Case LIMIT 1]);
    }
    @isTest static void testRetornarFila() {
        Case caso = [SELECT Id FROM Case];
        
        CasoController.retornarFila(caso.Id);
    }
    @isTest static void testCarregarEmailsDe() {
        CasoController.carregarEmailsDe(true, 'Test', 'Test');
    }
    @isTest static void testarGetMethods() {
        Id casoId = [SELECT Id FROM Case].Id;
        
        CasoController.getCase(casoId);
        CasoController.getSLAs(casoId);
        CasoController.getEmails(casoId);
        CasoController.getComments(casoId);
        CasoController.getNotes(casoId);
        CasoController.getMaterials(casoId);
        CasoController.getActivities(casoId);
        CasoController.getSolutions(casoId);
        CasoController.getAttachments(casoId);
        CasoController.getCaseHistories(casoId);
        CasoController.getCaseApproveHistories(casoId);
        CasoController.getUser(UserInfo.getUserId());
        CasoController.getObservadores(casoId);
        CasoController.getCamposCasoDesativados(casoId);
        CasoController.getTipos();
        CasoController.getSubtipos('Cadastro');
        CasoController.getDetalhamentos('Cadastro', 'Novo Cadastro');
        CasoController.getDetalhamentos2('Cadastro', 'Novo Cadastro', 'Dados Cadastrais');
        
        CasoController.HistoricoCaso hc = new CasoController.HistoricoCaso(DateTime.now(), 
                                                                           'teste', 
                                                                           'teste', 
                                                                           'teste', 
                                                                           'teste');
    }
    
    @IsTest
    static void getMotivosNaoEnvioPesquisaTest() {
        CasoController.getMotivosNaoEnvioPesquisa();
    }
    
    @IsTest
    static void enviarPesquisaMotivoTest() {        
        User u = [select id, email from User where email = 'standarduser1@pearson.br' limit 1];
        System.runAs(u){                
            Test.startTest();
            	CasoController.enviarPesquisaMotivo([SELECT Id FROM Case LIMIT 1].Id, true, 'test');        
            Test.stopTest();
    	}
    }
}