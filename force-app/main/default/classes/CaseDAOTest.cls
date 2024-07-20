@isTest
public class CaseDAOTest {
    @isTest static void testar() {
        ParametrizacaoCasos__c param = new ParametrizacaoCasos__c();
        param.Tipo__c = 'Atendimento';
        param.Subtipo__c = 'Suporte';
        param.Detalhamento__c = '';
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
        caso.Tipo__c = 'Atendimento';
        caso.Subtipo__c = 'Suporte';
        caso.Detalhamento__c = '';
        caso.Detalhamento2__c = '';
        caso.BR_Complemento__c = 'Teste';
        caso.BR_CEP__c = '123';
        caso.OrdemGrupoSolucionador__c = 0;
        caso.GrupoSolucionador__c = 'Backoffice Comercial';
        insert caso; 
        
        CaseDAO.getInstance().buscaCasesPorId(caso.Id);
        CaseDAO.getInstance().atualizarCaso(caso);
        CaseDAO.getInstance().buscaCasesPorListaId(new List<String> {caso.Id});
        CaseDAO.getInstance().buscaCasoPorId(caso.Id);
        CaseDAO.getInstance().buscaTodosCamposCaseById(caso.Id);
        CaseDAO.getCaseById(caso.Id);
        CaseDAO.getInstance().getSubtipoListByType(null);
        CaseDAO.getInstance().getTypeList();
        CaseDAO.getCasesByIds(new Set<Id> {caso.Id});
    }
}