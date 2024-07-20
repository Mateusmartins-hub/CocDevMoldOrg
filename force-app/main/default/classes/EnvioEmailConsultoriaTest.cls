/**
 * Created by re035946 on 11/03/2018.
 */
@IsTest
private class EnvioEmailConsultoriaTest {
    @isTest static void test_method_one() {
        Test.startTest();
        Id idPessoaFisica = RecordTypeUtil.getInstance().getRecordTypePorNome('Account', 'Pessoa Física').getRecordTypeId();
        Account conta = new Account();
        conta.RecordTypeId = idPessoaFisica;
        conta.Name = 'ANHEMBI MORUMBI - CENTRO';
        conta.BR_Approval_status__c = 'Em elaboração';
        conta.BR_cnpj__c = '64.645.655/0001-08';
        conta.BR_Account_Id_SAP__c = '000000';
        conta.Phone = '96736-3333';
        conta.BR_Account_email__c = 'email@email.com.br';
        Database.insert(conta);

        FR_Procedimento_Franquias__c consultoria = new FR_Procedimento_Franquias__c();
        consultoria.BR_Conta__c = conta.Id;
        consultoria.BR_StatusConsultoria__c = 'Aberta';
        consultoria.BR_TipoConsultoria__c = 'Auditoria FR';
        Database.insert(consultoria);

        Contact contato = new Contact();
        contato.LastName = 'Contato Teste';
        contato.BR_CPF__c = '43335427823';
        contato.Phone = '01197877788';
        contato.Email = 'teste@validacao.com';
        contato.Fun_o__c = 'Coordenador Pedagógico';
        contato.AccountId = conta.Id;
        contato.BR_CPF__c = '030.363.876-17';
        contato.Phone = '0000-0000';
        insert contato;

        Profile p = [SELECT Id FROM Profile WHERE (Name = 'System Administrator') or  (Name = 'Administrador do Sistema' )];
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
            //UserRoleId = '00Ed0000000FURnEAO'
            // ManagerId ='005d0000001oExKAAU' // **** MUITO IMPORTANTE - APROVADOR
        );
        insert u1;

        Event event = new Event();
        event.BR_Create_Audit__c = true;
        event.BR_Source_Visit__c = 'Planejamento';
        event.BR_Tipo_da_Visita__c = 'Divulgação';
        event.BR_Visita_Realizada__c = true;
        event.Description = 'Teste';
        event.StartDateTime = Datetime.now();
        event.EndDateTime = Datetime.now();
        event.BR_TipoConsultoria__c = 'Evento Interno';
        Id recId = RecordTypeUtil.getInstance().getRecordTypePorNome('Event', 'Pedagógico FR').getRecordTypeId();
        //RecordType rt = [select Id,name,DeveloperName from RecordType where Name ='Pedagógico FR' and SobjectType = 'event'];
        event.RecordTypeId = recId;
        event.WhatId = consultoria.Id;
        event.BR_Contato__c = contato.Id;
        event.OwnerId = u1.Id;
        Database.insert(event);

        System.debug(JSON.serialize(event));

        BR_Procedimento_Visita__c rel = new BR_Procedimento_Visita__c();
        rel.BR_NumeroAlunos__c = 10;
        rel.BR_Quantidade_de_Turmas_do_coordenador__c = 100;
        rel.BR_Retencao__c = 2;
        rel.BR_Frequencia__c = 3;
        rel.BR_ProfessorPossuiNumeroLimiteTurmas__c = 'Sim';
        rel.BR_ProfessoresPreparamAulas__c = 'Sim';
        rel.BR_TimePedagogicoPossuiCertificacaoUC__c = 'Sim';
        rel.BR_CoordenadorPedagogicoTreinaEquipe__c = 'Sim';
        rel.BR_EntregaRGM__c = 'Sim';
        rel.BR_RealizaAnaliseRGM__c = 'Sim';
        rel.BR_Quantidade_Turmas_1__c = 100;
        rel.BR_AlunoTurmaAlinhadoMetaFranqueadora__c = 'Sim';
        rel.BR_Rematricula__c = 4;
        rel.BR_Status1__c = 'TESTE';
        rel.BR_Status2__c = 'TESTE';
        rel.BR_Status3__c = 'TESTE';
        rel.BR_Status4__c = 'TESTE';
        rel.BR_Status5__c = 'TESTE';
        rel.BR_TimePedagogicoDevidamenteCapacitado__c = 'Sim';
        rel.BR_ModalidadeExperienciaQuePossui__c = 'Class';
        rel.BR_FR_Procedimento_Franquias_Visita__c = consultoria.Id;
        Id recId1 = RecordTypeUtil.getInstance().getRecordTypePorNome('BR_Procedimento_Visita__c', 'Consultoria Pedagógica FR').getRecordTypeId();
        //RecordType rect = [select Id,name,DeveloperName from RecordType where Name ='Consultoria Pedagógica FR' and SobjectType = 'BR_Procedimento_Visita__c'];
        rel.RecordTypeId = recId1;
        Database.insert(rel);
        Database.update(rel);

        BR_Procedimento_Visita__c rel2 = rel;
        Id recId2 = RecordTypeUtil.getInstance().getRecordTypePorNome('BR_Procedimento_Visita__c', 'Observação Sala de Aula FR').getRecordTypeId();
        //RecordType rect2 = [select Id,name,DeveloperName from RecordType where Name ='Observação Sala de Aula FR' and SobjectType = 'BR_Procedimento_Visita__c'];
        rel2.RecordTypeId = recId2;
        rel2.Id = null;
        Database.insert(rel2);

        BR_Procedimento_Visita__c rel4 = rel;
        Id recId4 = RecordTypeUtil.getInstance().getRecordTypePorNome('BR_Procedimento_Visita__c', 'Treinamento e Capacitação').getRecordTypeId();
        //RecordType rect4 = [select Id,name,DeveloperName from RecordType where Name ='Treinamento e Capacitação' and SobjectType = 'BR_Procedimento_Visita__c'];
        rel4.RecordTypeId = recId4;
        rel4.Id = null;
        Database.insert(rel4);

        FR_Plano_de_Acao__c plano = new FR_Plano_de_Acao__c();
        plano.BR_Problema__c = 'Problema';
        plano.BR_TipoProblema__c = '1. GESTÃO';
        plano.BR_OQue__c = 'oque:';
        plano.BR_Quem__c = 'quem?';
        plano.BR_Como__c = 'como?';
        plano.BR_AteQuando__c = Date.today();
        plano.BR_Status__c = 'Atrasado';
        plano.BR_FUP__c = 'FUP';
        plano.BR_FR_Plano_acao__c = consultoria.Id;
        Database.insert(plano);

        EnvioEmailConsultoriaController ctr = new EnvioEmailConsultoriaController();
        ctr.init(consultoria.Id);
        ctr.enviarEmailPedagogico();

        Test.stopTest();
    }
    
    @isTest static void test_method_two() {
        Test.startTest();
        Id idPessoaFisica = RecordTypeUtil.getInstance().getRecordTypePorNome('Account', 'Pessoa Física').getRecordTypeId();
        Account conta = new Account();
        conta.RecordTypeId = idPessoaFisica;
        conta.Name = 'ANHEMBI MORUMBI - CENTRO';
        conta.BR_Approval_status__c = 'Em elaboração';
        conta.BR_cnpj__c = '64.645.655/0001-08';
        conta.BR_Account_Id_SAP__c = '000000';
        conta.Phone = '96736-3333';
        conta.BR_Account_email__c = 'email@email.com.br';
        Database.insert(conta);

        FR_Procedimento_Franquias__c consultoria = new FR_Procedimento_Franquias__c();
        consultoria.BR_Conta__c = conta.Id;
        consultoria.BR_StatusConsultoria__c = 'Aberta';
        consultoria.BR_TipoConsultoria__c = 'Auditoria FR';
        Database.insert(consultoria);

        Contact contato = new Contact();
        contato.LastName = 'Contato Teste';
        contato.BR_CPF__c = '43335427823';
        contato.Phone = '01197877788';
        contato.Email = 'teste@validacao.com';
        contato.Fun_o__c = 'Coordenador Pedagógico';
        contato.AccountId = conta.Id;
        contato.BR_CPF__c = '030.363.876-17';
        contato.Phone = '0000-0000';
        insert contato;

        Profile p = [SELECT Id FROM Profile WHERE (Name = 'System Administrator') or  (Name = 'Administrador do Sistema' )];
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
            //UserRoleId = '00Ed0000000FURnEAO'
            // ManagerId ='005d0000001oExKAAU' // **** MUITO IMPORTANTE - APROVADOR
        );
        insert u1;

        Event event = new Event();
        event.BR_Create_Audit__c = true;
        event.BR_Source_Visit__c = 'Planejamento';
        event.BR_Tipo_da_Visita__c = 'Divulgação';
        event.BR_Visita_Realizada__c = true;
        event.Description = 'Teste';
        event.StartDateTime = Datetime.now();
        event.EndDateTime = Datetime.now();
        event.BR_TipoConsultoria__c = 'Evento Interno';
        Id recId = RecordTypeUtil.getInstance().getRecordTypePorNome('Event', 'Pedagógico FR').getRecordTypeId();
        //RecordType rt = [select Id,name,DeveloperName from RecordType where Name ='Pedagógico FR' and SobjectType = 'event'];
        event.RecordTypeId = recId;
        event.WhatId = consultoria.Id;
        event.BR_Contato__c = contato.Id;
        event.OwnerId = u1.Id;
        Database.insert(event);

        System.debug(JSON.serialize(event));

        BR_Procedimento_Visita__c rel = new BR_Procedimento_Visita__c();
        rel.BR_NumeroAlunos__c = 10;
        rel.BR_Quantidade_de_Turmas_do_coordenador__c = 100;
        rel.BR_Retencao__c = 2;
        rel.BR_Frequencia__c = 3;
        rel.BR_ProfessorPossuiNumeroLimiteTurmas__c = 'Sim';
        rel.BR_ProfessoresPreparamAulas__c = 'Sim';
        rel.BR_TimePedagogicoPossuiCertificacaoUC__c = 'Sim';
        rel.BR_CoordenadorPedagogicoTreinaEquipe__c = 'Sim';
        rel.BR_EntregaRGM__c = 'Sim';
        rel.BR_RealizaAnaliseRGM__c = 'Sim';
        rel.BR_Quantidade_Turmas_1__c = 100;
        rel.BR_AlunoTurmaAlinhadoMetaFranqueadora__c = 'Sim';
        rel.BR_Rematricula__c = 4;
        rel.BR_Status1__c = 'TESTE';
        rel.BR_Status2__c = 'TESTE';
        rel.BR_Status3__c = 'TESTE';
        rel.BR_Status4__c = 'TESTE';
        rel.BR_Status5__c = 'TESTE';
        rel.BR_TimePedagogicoDevidamenteCapacitado__c = 'Sim';
        rel.BR_ModalidadeExperienciaQuePossui__c = 'Class';
        rel.BR_FR_Procedimento_Franquias_Visita__c = consultoria.Id;
        // recId1 = RecordTypeUtil.getInstance().getRecordTypePorNome('BR_Procedimento_Visita__c', 'Consultoria Pedagógica FR').getRecordTypeId();
        RecordType rect = [SELECT Id, Name, DeveloperName FROM RecordType WHERE DeveloperName = 'CicloFormacaoNAME' AND SobjectType = 'BR_Procedimento_Visita__c'];
        rel.RecordTypeId = rect.Id;
        Database.insert(rel);

        BR_Procedimento_Visita__c rel2 = rel;
        Id recId2 = RecordTypeUtil.getInstance().getRecordTypePorNome('BR_Procedimento_Visita__c', 'Observação Sala de Aula FR').getRecordTypeId();
        //RecordType rect2 = [select Id,name,DeveloperName from RecordType where Name ='Observação Sala de Aula FR' and SobjectType = 'BR_Procedimento_Visita__c'];
        rel2.RecordTypeId = recId2;
        rel2.Id = null;
        Database.insert(rel2);

        BR_Procedimento_Visita__c rel4 = rel;
        Id recId4 = RecordTypeUtil.getInstance().getRecordTypePorNome('BR_Procedimento_Visita__c', 'Treinamento e Capacitação').getRecordTypeId();
        //RecordType rect4 = [select Id,name,DeveloperName from RecordType where Name ='Treinamento e Capacitação' and SobjectType = 'BR_Procedimento_Visita__c'];
        rel4.RecordTypeId = recId4;
        rel4.Id = null;
        Database.insert(rel4);

        FR_Plano_de_Acao__c plano = new FR_Plano_de_Acao__c();
        plano.BR_Problema__c = 'Problema';
        plano.BR_TipoProblema__c = '1. GESTÃO';
        plano.BR_OQue__c = 'oque:';
        plano.BR_Quem__c = 'quem?';
        plano.BR_Como__c = 'como?';
        plano.BR_AteQuando__c = Date.today();
        plano.BR_Status__c = 'Atrasado';
        //plano.BR_FUP__c = 'FUP';
        plano.BR_FR_Plano_acao__c = consultoria.Id;
        Database.insert(plano);

        EnvioEmailConsultoriaController ctr = new EnvioEmailConsultoriaController();
        ctr.init(consultoria.Id);
        ctr.enviarEmailPedagogico();

        Test.stopTest();
    }
    
    @isTest static void test_method_three() {
        Test.startTest();
        Id idPessoaFisica = RecordTypeUtil.getInstance().getRecordTypePorNome('Account', 'Pessoa Física').getRecordTypeId();
        Account conta = new Account();
        conta.RecordTypeId = idPessoaFisica;
        conta.Name = 'ANHEMBI MORUMBI - CENTRO';
        conta.BR_Approval_status__c = 'Em elaboração';
        conta.BR_cnpj__c = '64.645.655/0001-08';
        conta.BR_Account_Id_SAP__c = '000000';
        conta.Phone = '96736-3333';
        conta.BR_Account_email__c = 'email@email.com.br';
        Database.insert(conta);

        FR_Procedimento_Franquias__c consultoria = new FR_Procedimento_Franquias__c();
        consultoria.BR_Conta__c = conta.Id;
        consultoria.BR_StatusConsultoria__c = 'Aberta';
        consultoria.BR_TipoConsultoria__c = 'Auditoria FR';
        Database.insert(consultoria);

        Contact contato = new Contact();
        contato.LastName = 'Contato Teste';
        contato.BR_CPF__c = '43335427823';
        contato.Phone = '01197877788';
        contato.Email = 'teste@validacao.com';
        contato.Fun_o__c = 'Coordenador Pedagógico';
        contato.AccountId = conta.Id;
        contato.BR_CPF__c = '030.363.876-17';
        contato.Phone = '0000-0000';
        insert contato;

        Profile p = [SELECT Id FROM Profile WHERE (Name = 'System Administrator') or  (Name = 'Administrador do Sistema' )];
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
            //UserRoleId = '00Ed0000000FURnEAO'
            // ManagerId ='005d0000001oExKAAU' // **** MUITO IMPORTANTE - APROVADOR
        );
        insert u1;

        Event event = new Event();
        event.BR_Create_Audit__c = true;
        event.BR_Source_Visit__c = 'Planejamento';
        event.BR_Tipo_da_Visita__c = 'Divulgação';
        event.BR_Visita_Realizada__c = true;
        event.Description = 'Teste';
        event.StartDateTime = Datetime.now();
        event.EndDateTime = Datetime.now();
        event.BR_TipoConsultoria__c = 'Evento Interno';
        Id recId = RecordTypeUtil.getInstance().getRecordTypePorNome('Event', 'Pedagógico FR').getRecordTypeId();
        //RecordType rt = [select Id,name,DeveloperName from RecordType where Name ='Pedagógico FR' and SobjectType = 'event'];
        event.RecordTypeId = recId;
        event.WhatId = consultoria.Id;
        event.BR_Contato__c = contato.Id;
        event.OwnerId = u1.Id;
        Database.insert(event);

        System.debug(JSON.serialize(event));

        BR_Procedimento_Visita__c rel = new BR_Procedimento_Visita__c();
        rel.BR_NumeroAlunos__c = 10;
        rel.BR_Quantidade_de_Turmas_do_coordenador__c = 100;
        rel.BR_Retencao__c = 2;
        rel.BR_Frequencia__c = 3;
        rel.BR_ProfessorPossuiNumeroLimiteTurmas__c = 'Sim';
        rel.BR_ProfessoresPreparamAulas__c = 'Sim';
        rel.BR_TimePedagogicoPossuiCertificacaoUC__c = 'Sim';
        rel.BR_CoordenadorPedagogicoTreinaEquipe__c = 'Sim';
        rel.BR_EntregaRGM__c = 'Sim';
        rel.BR_RealizaAnaliseRGM__c = 'Sim';
        rel.BR_Quantidade_Turmas_1__c = 100;
        rel.BR_AlunoTurmaAlinhadoMetaFranqueadora__c = 'Sim';
        rel.BR_Rematricula__c = 4;
        rel.BR_Status1__c = 'TESTE';
        rel.BR_Status2__c = 'TESTE';
        rel.BR_Status3__c = 'TESTE';
        rel.BR_Status4__c = 'TESTE';
        rel.BR_Status5__c = 'TESTE';
        rel.BR_TimePedagogicoDevidamenteCapacitado__c = 'Sim';
        rel.BR_ModalidadeExperienciaQuePossui__c = 'Class';
        rel.BR_FR_Procedimento_Franquias_Visita__c = consultoria.Id;
        // recId1 = RecordTypeUtil.getInstance().getRecordTypePorNome('BR_Procedimento_Visita__c', 'Consultoria Pedagógica FR').getRecordTypeId();
        RecordType rect = [select Id,name,DeveloperName from RecordType where DeveloperName ='Diagnostico_Escolas' AND SobjectType = 'BR_Procedimento_Visita__c'];
        rel.RecordTypeId = rect.Id;
        Database.insert(rel);

        BR_Procedimento_Visita__c rel2 = rel;
        Id recId2 = RecordTypeUtil.getInstance().getRecordTypePorNome('BR_Procedimento_Visita__c', 'Observação Sala de Aula FR').getRecordTypeId();
        //RecordType rect2 = [select Id,name,DeveloperName from RecordType where Name ='Observação Sala de Aula FR' and SobjectType = 'BR_Procedimento_Visita__c'];
        rel2.RecordTypeId = recId2;
        rel2.Id = null;
        Database.insert(rel2);

        BR_Procedimento_Visita__c rel4 = rel;
        Id recId4 = RecordTypeUtil.getInstance().getRecordTypePorNome('BR_Procedimento_Visita__c', 'Treinamento e Capacitação').getRecordTypeId();
        //RecordType rect4 = [select Id,name,DeveloperName from RecordType where Name ='Treinamento e Capacitação' and SobjectType = 'BR_Procedimento_Visita__c'];
        rel4.RecordTypeId = recId4;
        rel4.Id = null;
        Database.insert(rel4);

        FR_Plano_de_Acao__c plano = new FR_Plano_de_Acao__c();
        plano.BR_Problema__c = 'Problema';
        plano.BR_TipoProblema__c = '1. GESTÃO';
        plano.BR_OQue__c = 'oque:';
        plano.BR_Quem__c = 'quem?';
        plano.BR_Como__c = 'como?';
        plano.BR_AteQuando__c = Date.today();
        plano.BR_Status__c = 'Atrasado';
        //plano.BR_FUP__c = 'FUP';
        plano.BR_FR_Plano_acao__c = consultoria.Id;
        Database.insert(plano);

        EnvioEmailConsultoriaController ctr = new EnvioEmailConsultoriaController();
        ctr.init(consultoria.Id);
        ctr.enviarEmailPedagogico();

        Test.stopTest();
    }
}