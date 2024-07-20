@isTest 
public class ContractBOTest {
    
    @isTest 
    static void test1() {
        Profile profile1 = [Select Id from Profile WHERE Name = 'System Administrator' OR Name = 'Administrador do Sistema' LIMIT 1];
        UserRole portalRole = [Select Id From UserRole Where PortalType = 'None' Limit 1];
        date tDate = date.today();
        date uDate = Date.today().addDays(30);
        
        User u = new User(
            UserRoleId = portalRole.Id,
            ProfileId = profile1.Id,
            Username = 'testtermsconditions12344231@kaplan.com',
            Alias = 'batman',
            Email='testtermsconditions1234423@kaplan.com',
            EmailEncodingKey='UTF-8',
            Firstname='Bruce',
            Lastname='Wayne',
            LanguageLocaleKey='en_US',
            LocaleSidKey='en_US',
            TimeZoneSidKey='America/Chicago',
            ManagerId = UserInfo.getUserId());
        insert u;
        
        System.runAs(u) {
            Account acc = new Account();
            
            acc.RecordTypeId = RecordTypeUtil.getInstance().getRecordTypePorNome('Account', 'Pessoa Física').getRecordTypeId();
            acc.Name = 'Teste Validação';
            acc.BR_Approval_status__c = 'Em elaboração';
            acc.BR_CPF__c = '433.354.278-23';
            acc.BR_Funcao__c = 'Professor';
            acc.BR_Gender__c = 'MASCULINO';
            acc.BR_Birthdate__c = '11/01/1988';
            acc.BR_LinhaDeNegocio__c = 'Educação Básica';
            acc.Phone = '5943-0222';
            acc.BR_Account_email__c = 'teste@validacao.com';
            acc.BR_Bairro__c = 'Teste';
            acc.BR_ShippingAddressComplement__c = 'N/A';
            acc.BR_Account_Id_SAP__c = '012345';
            acc.BillingStreet = 'Teste Rua 2';
            acc.BillingPostalCode = '00000-010';
            acc.BillingCountry = 'Brasil';
            
            insert acc;
            
            Opportunity op = new Opportunity();
            op.Name = 'T';
            op.AccountId = acc.Id;
            op.StageName = 'Enviado';
            op.CloseDate = System.today();
            op.CasoFechado__c = true;
            op.CotacaoGerada__c = true;
            op.AmostraFisicaEnviada__c = true;
            insert op;
            
            Contract c = new Contract();
            c.BR_Status_de_aprova_o_do_contrato__c = 'Aprovado';
            c.Status = 'Draft';
            c.AccountId = acc.Id;
            c.BR_Oportunidade_do_contrato__c = op.Id;
            insert c;
            
            c.Status = 'Activated';
            update c;
        }
    }
    
    @isTest
    static void test2() {        
        Profile profile1 = [Select Id from Profile WHERE Name = 'System Administrator' OR Name = 'Administrador do Sistema' LIMIT 1];
        UserRole portalRole = [Select Id From UserRole Where PortalType = 'None' Limit 1];
        date tDate = date.today();
        date uDate = Date.today().addDays(30);
        
        User u = new User(
            UserRoleId = portalRole.Id,
            ProfileId = profile1.Id,
            Username = 'testtermsconditions123456789@kaplan.com',
            Alias = 'batman',
            Email='testtermsconditions1234423@kaplan.com',
            EmailEncodingKey='UTF-8',
            Firstname='Bruce',
            Lastname='Wayne',
            LanguageLocaleKey='en_US',
            LocaleSidKey='en_US',
            TimeZoneSidKey='America/Chicago',
            ManagerId = UserInfo.getUserId());
        insert u;
        
        System.runAs(u) {
          /*  ParametrizacaoCasos__c param = new ParametrizacaoCasos__c();
            param.Tipo__c = 'Expansão';
            param.Subtipo__c = 'Novas Escolas';
            param.Detalhamento__c = 'Orientação / Treinamento';
            param.Detalhamento2__c = '';
            param.AreaDonaProcesso__c = 'Financeiro';
            insert param;
            
            GrupoSolucionador__c grupo0 = new GrupoSolucionador__c();
            grupo0.CamposObrigatorios__c = '';
            grupo0.Ordem__c = 0;
            grupo0.ParametrizacaoCasos__c = param.Id;
            grupo0.MinutosSLA__c = 720;
            insert grupo0;
            
            ParametrizacaoCasos__c param2 = new ParametrizacaoCasos__c();
            param2.Tipo__c = 'Programas & Serviços';
            param2.Subtipo__c = 'Consultoria Pedagógica';
            param2.Detalhamento__c = 'Implantação Pedagógica (1ª Visita)';
            param2.Detalhamento2__c = '';
            param2.AreaDonaProcesso__c = 'Financeiro';
            insert param2;
            
            GrupoSolucionador__c grupo2 = new GrupoSolucionador__c();
            grupo2.CamposObrigatorios__c = '';
            grupo2.Ordem__c = 0;
            grupo2.ParametrizacaoCasos__c = param2.Id;
            grupo2.MinutosSLA__c = 720;
            insert grupo2;
            
            ParametrizacaoCasos__c param3 = new ParametrizacaoCasos__c();
            param3.Tipo__c = 'Produtos Digitais';
            param3.Subtipo__c = 'Passaporte';
            param3.Detalhamento__c = 'Cadastro';
            param3.Detalhamento2__c = 'Cadastro de Escola Parceira';
            param3.AreaDonaProcesso__c = 'Financeiro';
            insert param3;
            
            GrupoSolucionador__c grupo3 = new GrupoSolucionador__c();
            grupo3.CamposObrigatorios__c = '';
            grupo3.Ordem__c = 0;
            grupo3.ParametrizacaoCasos__c = param3.Id;
            grupo3.MinutosSLA__c = 720;
            insert grupo3;
            */
            Account acc = new Account();
            
            acc.RecordTypeId = RecordTypeUtil.getInstance().getRecordTypePorNome('Account', 'Pessoa Física').getRecordTypeId();
            acc.Name = 'Teste Validação';
            acc.BR_Approval_status__c = 'Em elaboração';
            acc.BR_CPF__c = '433.354.278-23';
            acc.BR_Funcao__c = 'Professor';
            acc.BR_Gender__c = 'MASCULINO';
            acc.BR_Birthdate__c = '11/01/1988';
            acc.BR_LinhaDeNegocio__c = 'Educação Básica';
            acc.Phone = '5943-0222';
            acc.BR_Account_email__c = 'teste@validacao.com';
            acc.BR_Bairro__c = 'Teste';
            acc.BR_ShippingAddressComplement__c = 'N/A';
            acc.BR_Account_Id_SAP__c = '012345';
            acc.BillingStreet = 'Teste Rua 2';
            acc.BillingPostalCode = '00000-010';
            acc.BillingCountry = 'Brasil';
            
            insert acc;
            
            Opportunity op = new Opportunity();
            op.Name = 'T';
            op.AccountId = acc.Id;
            op.StageName = 'Enviado';
            op.CloseDate = System.today();
            insert op;
            
            Test.startTest();
            Contract c = new Contract();
            c.BR_Status_de_aprova_o_do_contrato__c = 'Aguardando finalização do processo';
            c.Status = 'Draft';
            c.AccountId = acc.Id;
            c.BR_Oportunidade_do_contrato__c = op.Id;
            insert c;
            
            c.BR_RecebidoConferido__c = true;
            update c;

            Test.stopTest();
        }
    }
}