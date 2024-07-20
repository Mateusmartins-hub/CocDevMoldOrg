@isTest
private class LogErroProcessamentoServiceTest {

    static testMethod void myUnitTest() {
        Test.startTest();
        //Variables Declaration 
        Profile perfil;
        Id idRecTypeRep, idRecTypeOpp, idRecTypeAseg;
        User user,manager,masterManager;
        Opportunity opp;
        Account_Segmentation__c aseg;
        
        //Get RecordTypeId from Account and opoortunity
        idRecTypeRep = RecordTypeMemory.getRecType( 'Account', 'Sales_Representative');
        idRecTypeOpp = RecordTypeMemory.getRecType( 'Opportunity', 'Sample_Order_University');
        idRecTypeAseg = RecordTypeMemory.getRecType( 'Account_Segmentation__c', 'School_Segmentation');
        
        //Get id administrator profile
        perfil = [Select Id From Profile Where Name = 'Administrador do sistema' OR Name = 'System Administrator'];
      
        //Create a new user with Manager
        user = SObjectInstance.getUser( 'teste34@pearson.br', 'teste@1234.com.br', perfil.Id );
        manager = SObjectInstance.getUser( 'teste35@pearson.br', 'teste@12345.com.br', perfil.Id );
        manager.CommunityNickname = 'teste35';
        Database.Saveresult resultUser = Database.insert( manager , false );
        System.assert(resultUser.isSuccess());
        
        masterManager = SObjectInstance.getUser( 'teste36@pearson.br', 'teste@12346.com.br', perfil.Id );
        masterManager.CommunityNickname = 'teste36';
        user.ManagerId = manager.Id;
        Database.Saveresult[] resultsUser = Database.insert( new User[]{ masterManager, user }, false );
        System.assert(resultsUser[0].isSuccess());
        System.assert(resultsUser[1].isSuccess());
        
        manager.ManagerId = masterManager.Id;
        Database.Upsertresult resultMM = Database.upsert( manager , false );
        System.assert(resultMM.isSuccess());
        
        //Create a new Account
        Account conta = new Account();
        conta.RecordTypeId = RecordTypeUtil.getInstance().getRecordTypePorNome('Account', 'Pessoa Física').getRecordTypeId();
        conta.Name = 'Teste Validação';
        conta.BR_Approval_status__c = 'Em elaboração';
        conta.BR_CPF__c = '43335427823';
        //conta.BR_Funcao__c = 'Professor';
        conta.BR_Gender__c = 'MASCULINO';
        conta.BR_Birthdate__c = '11/01/1988';
        //conta.BR_LinhaDeNegocio__c = 'Educação Básica';
        conta.Phone = '011959430222';
        conta.BR_Account_email__c = 'teste@validacao.com';
        conta.BR_Bairro__c = 'Teste';
        //conta.BR_ShippingAddressComplement__c = 'N/A';
        conta.BR_Account_Id_SAP__c = '012345';
        conta.BillingStreet = 'Teste Rua 2';
        conta.BillingPostalCode = '00000-010';
        conta.BillingCountry = 'Brasil';
        Database.Saveresult resultAcc = Database.insert( conta , false );
        //System.assert(resultAcc.isSuccess());
        
        //Crerate a new Account Segmentation
        aseg = SObjectInstance.getAccountSegmentation( conta.Id , idRecTypeAseg );
        aseg.Current_year__c = String.valueOf(System.today().year());
        Database.Saveresult resultAseg = Database.insert( aseg , false );
        //System.assert(resultAseg.isSuccess());
        
        //Create a new opportunity
        opp = new Opportunity();
        opp.AccountId = conta.Id;
        opp.OwnerId = user.Id;
        opp.RecordTypeId = idRecTypeOpp;
        opp.BR_shipping_type__c = 'Correio';
        opp.BR_Shipping_Address__c = 'Residencial';
        opp.Name = 'Teste';
        opp.StageName = 'Elaboração';
        opp.CloseDate = System.today()+5;
        opp.BR_Account_Segmentation__c = aseg.Id;
        opp.Description = 'teste';
        Database.Saveresult resultOpp = Database.insert( opp  , true );
        //System.assert(resultOpp.isSuccess());
        
        //Update opportunity
        Database.Upsertresult resultOpp2 = Database.upsert( opp  , false );
        //System.assert(resultOpp2.isSuccess());
        //List<Database.Error> errorSaveResult = resultOpp2.getErrors();
        Contact contato = new Contact();
        contato.FirstName = 'Primeiro nome contato';
        contato.LastName = 'Contato Teste';
        contato.BR_CPF__c = '433.354.278-23';
        contato.Phone = '9787-7788';
        contato.Email = 'teste@validacao.com';
        contato.Fun_o__c = 'Coordenador Pedagógico';
        contato.AccountId = conta.Id;
        Insert contato;
                             
        Case caso = TesteSetup.getInstance().criarCaso(conta, contato);
        /* caso.RecordTypeId = RecordTypeUtil.getInstance().getRecordTypePorNome('Case', 'Demandas - Aluno').getRecordTypeId();
        caso.AccountId = conta.Id;
        
        caso.ContactId = contato.Id;
        caso.Resumo__c = 'Teste';
        caso.BR_Grupo_Solucionador__c = 'Corporate Affairs';
        caso.BR_MarcaSegmentoNegocio__c = 'COC';
        caso.BR_NumeroMarco__c = '1';
        caso.SLATotal__c = '100';
        caso.Status = ' 1 - Aguardando Cliente';
        caso.Reason = 'Documento Enviado';
        caso.Origin = 'Telefone';
        caso.Priority = 'Média';
        caso.Type = 'Comercial';
        caso.Subtipo__c = 'Processo';
        caso.Detalhamento_del__c = 'Juizado Especial Civil';
        caso.BR_Detalhamento2__c = '';
        caso.Subject = 'Teste';
        caso.Description = 'Teste';
        caso.BR_Rua__c = 'Avenida Teste de classe';
        caso.BR_Numero__c = '666';
        caso.BR_CEP__c = '00000000';
        caso.BR_Bairro__c = 'Vale do Teste';
        caso.BR_CidadeConta__c = 'Teste de sucesso';
        caso.BR_EstadoConta__c = 'XX';
        caso.BR_InformacaoASerAlteradaIncorreta__c = 'teste'; */
        insert caso;
                     
        List<Opportunity> lOpp = new List<Opportunity>();
        lOpp.add(opp);
        LogErroProcessamentoService.getInstance().registrarNovaInstanciaLogErroParaOportunidadeAdocao(opp.id, 'Erro ao criar Adoção da oportunidade Status Adotado.', 'Erro');
        LogErroProcessamentoService.getInstance().criarNovoLogErroParaOportunidadeAdocao(opp.id, 'Erro ao criar Adoção da oportunidade Status Adotado.', 'Erro');
        LogErroProcessamentoService.getInstance().criarNovoLogErroParaCaso(caso.id, 'Erro ao criar Adoção da oportunidade Status Adotado.', 'Erro');
        Test.stopTest();
    }
}