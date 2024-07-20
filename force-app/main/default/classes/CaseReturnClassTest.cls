@isTest public class CaseReturnClassTest {
    @isTest static void test1() {
        Test.startTest();
        ParametrizacaoCasos__c param = new ParametrizacaoCasos__c();
        param.Tipo__c = 'Cadastro';
        param.Subtipo__c = 'Alteração de Cadastro';
        param.Detalhamento__c = 'Dados Cadastrais';
        param.Detalhamento2__c = '';
        param.AreaDonaProcesso__c = 'Financeiro';
        insert param;
        
        GrupoSolucionador__c grupo0 = new GrupoSolucionador__c();
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
        caso.Tipo__c = 'Contrato';
        caso.Subtipo__c = 'Distrato';
        caso.BR_Complemento__c = 'Teste';
        caso.BR_CEP__c = '123';
        caso.OrdemGrupoSolucionador__c = 0;
        caso.GrupoSolucionador__c = 'Backoffice Comercial'; 
        caso.AceitoPor__c = UserInfo.getUserId();
        
        insert caso;
        
        CaseReturnClass.returnToQueue(new List<Id> {caso.Id});
        Test.stopTest();
    }
}