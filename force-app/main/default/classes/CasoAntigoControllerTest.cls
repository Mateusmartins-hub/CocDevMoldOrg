@isTest
public class CasoAntigoControllerTest {
    
     @TestSetup static void testSetup() {
         ParametrizacaoCasos__c param = new ParametrizacaoCasos__c();
         param.Tipo__c = 'Cadastro';
         param.Subtipo__c = 'Novo Cadastro';
         param.Detalhamento__c = 'Material avariado';
         param.Detalhamento2__c = '';
         param.AreaDonaProcesso__c = 'Financeiro';
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
         
         Test.startTest();
         // setupFuture();
         Test.stopTest();
     } 
    
    @future    
    static void setupFuture()
    {
        List<Group> groups = [SELECT id, name FROM Group WHERE name LIKE '%LN: Customer Care%' OR name LIKE '%LN: Backoffice Comercial%'];
        		
        List<GroupMember> gms = new List<GroupMember>();
        for (Group g : groups)
        {
            GroupMember gm = new GroupMember();
            gm.GroupId = g.Id;
            gm.UserOrGroupId = System.UserInfo.GetUserId();
            
            gms.add(gm);
        }
        
        insert gms;
    }
    
    @isTest static void testarGetOldCaseFields() {  
        
        Case caso = [SELECT Id, Tipo__c, Subtipo__c, Detalhamento__c, Detalhamento2__c, OrdemGrupoSolucionador__c FROM Case];
        
        GrupoSolucionador__c grupo = CasoController.buscarProxGrupo(caso.Tipo__c, caso.Subtipo__c, caso.Detalhamento__c, caso.Detalhamento2__c, caso.OrdemGrupoSolucionador__c)[0];
        caso.OrdemGrupoSolucionador__c = grupo.Ordem__c;
        caso.GrupoSolucionador__c = grupo.GrupoSolucionador__c;
        caso.Status = 'Novo';
        update caso;
        
        
        
        LayoutCaso__c layout = new LayoutCaso__c();
        layout.CamposLayout__c = 'AccountId;Subtipo__c;Tipo__c;Detalhamento__c;Detalhamento2__c;Subject;Description';
        layout.CasosAntigos__c = true;
        insert layout;
        
        SessaoLayoutCaso__c sessao = new SessaoLayoutCaso__c();
        sessao.CamposSessao__c = 'AccountId;Subtipo__c;Tipo__c;Detalhamento__c;Detalhamento2__c;Subject;Description';
        sessao.LayoutCaso__c = layout.Id;
        insert sessao;
        
        CasoAntigoController.getOldCaseFields();
        
        CasoAntigoController.HistoricoCaso hc = new CasoAntigoController.HistoricoCaso(DateTime.now(), 
                                                                                       'teste', 
                                                                                       'teste', 
                                                                                       'teste', 
                                                                                       'teste');

    }   
    
    @isTest static void testarFecharCaso() {
        Case caso = [SELECT Id FROM Case];
        
        CasoAntigoController.fecharCaso(caso.Id);
    }
    @isTest static void testarCancelarCaso() {
        Case caso = [SELECT Id FROM Case];
        
        CasoAntigoController.cancelarCaso(caso.Id);
    }
    @isTest static void testarSalvarInformacoes() {
        Case caso = [SELECT Id FROM Case];
        CasoAntigoController.salvarInformacoes('[{"observador":"' + UserInfo.getUserId() + '","informacao":"Teste","casoId":"' + caso.Id + '"}]');
    }
    @isTest static void testarVerificaUsuarioGrupo() {
        Case caso = [SELECT Id FROM Case];
        
        CasoAntigoController.verificaUsuarioGrupo(caso.Id);
    }
    @isTest static void testarGetMethods() {
        Id casoId = [SELECT Id FROM Case].Id;
        
        CasoAntigoController.getCase(casoId);
        CasoAntigoController.getSLAs(casoId);
        CasoAntigoController.getEmails(casoId);
        CasoAntigoController.getComments(casoId);
        CasoAntigoController.getNotes(casoId);
        CasoAntigoController.getMaterials(casoId);
        CasoAntigoController.getActivities(casoId);
        CasoAntigoController.getSolutions(casoId);
        CasoAntigoController.getAttachments(casoId);
        CasoAntigoController.getCaseHistories(casoId);
        CasoAntigoController.getCaseApproveHistories(casoId);
        CasoAntigoController.getUser(UserInfo.getUserId());
        CasoAntigoController.getObservadores(casoId);
    }
}