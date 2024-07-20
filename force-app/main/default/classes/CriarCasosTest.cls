@isTest
private class CriarCasosTest {
    @isTest
    static  void myUnitTest() {
        User u1 = new User(
            Alias = 'standt1', 
            Email='standarduser1@pearson.br', 
            EmailEncodingKey='UTF-8', 
            LastName='Testing', 
            LanguageLocaleKey='pt_BR', 
            LocaleSidKey='pt_BR', 
            ProfileId = UserInfo.getProfileId(), 
            TimeZoneSidKey='America/Sao_Paulo', 
            UserName='standarduser1@pearson.br'

        );
        u1.ManagerId = UserInfo.getUserId();
        insert u1;
        RecordType casoRT = [select id,Name from RecordType where SobjectType='Case' and DeveloperName='CasosK12' Limit 1];
        Group fila1 = [SELECT Id FROM Group WHERE DeveloperName = 'Gestao_Contratos' and Type = 'Queue'];
        Group fila2 = [SELECT Id FROM Group WHERE DeveloperName = 'Credito_e_Cobranca' and Type = 'Queue'];
        System.debug('fila1 - > : ' + fila1);
        
        Account B = new Account(
            BR_Account_Id_SSA__c = 'I66662',
            BR_Birthdate__c = '18/08/1990',
            BR_cnpj__c = '02.469.555/0001-02',
            BR_Integrate_to_SAP__c = false,
            BR_Integrate_to_SSA__c = true,
            BR_Integration_Status_SSA__c = 'Integrado ERP',
            BR_Integration_Status_SAP__c = '',
            BR_Main_Address__c = 'Rua Nelson Francisco  ',
            BR_Main_City__c = 'São Paulo',
            BR_Main_Complement__c = 'ap666',
            BR_Main_Country__c = 'BR',
            BR_Main_District__c = 'Limão',
            BR_Main_Nbr__c = '666',
            BR_Main_State__c = 'SP',
            BR_Main_Zip_code__c = '05790-140',
            BR_Account_email__c = 'robinson.mioshi@pearson.com',
            BR_Area_code__c = 11.0,
            Phone = '9999-9999',
            BR_Company_Name__c  = 'Empresa X LTDA',
            Name = 'Empresa X LTDA',
            RecordTypeID = RecordTypeUtil.getInstance().getRecordTypePorNome('Account', 'Pessoa Física').getRecordTypeId()
            //IBGE_Code__c = IBGE.ID
        );
        insert B;
        
        Contact contato = new Contact();
        contato.LastName = 'Contato Teste';
        contato.BR_CPF__c = '433.354.278-23';
        contato.Phone = '99787-7788';
        contato.Email = 'teste@validacao.com';
        contato.Fun_o__c = 'Coordenador Pedagógico';
        contato.AccountId = B.Id;
        
        insert contato;
        System.debug('acc: ' + B);
        
        
        Account_Contact__c Account_Contact = new Account_Contact__c(
            Account__c = B.ID,
            Contact__c = contato.ID
        );
        Account_Contact.Email__c = 'teste@teste.com';
        Account_Contact.CPF__c = '50373666403';
        
        insert Account_Contact;

        Opportunity O = new Opportunity(
            //Id = '00611000004RNFGAA4',
            BR_Shipping_Address__c = 'Instituição',
            StageName  = 'Elaboração',
            AccountID = B.ID,
            Name = 'Instituicao Idiomas',
            CloseDate = System.today(),
            ForecastCategoryName = 'Omitted',
            BR_Contact__c = contato.ID,
            BR_shipping_type__c = 'Retira',
            RecordTypeId = RecordTypeMemory.getRecType('Opportunity', 'Oportunidade_de_Negocio_Pearson_English_EDU'),
            BR_Account_Contact__c = Account_Contact.ID,
            // BR_Approver1__c = u2.id,
            // BR_Approver2__c = u1.id,
            BR_Shipping_Address2__c = 'Residencial',
            OwnerId = [SELECT Id FROM User WHERE UserName = 'standarduser1@pearson.br' LIMIT 1].Id
        );
        O.Description = 'Teste';
        Insert O;
        
        
        Product2 p2 = new Product2();
        p2.Name = 'Teste';
        insert p2;
        
        Pricebook2 pb = new Pricebook2();
        pb.Name = 'Teste';
        insert pb;
        
        PricebookEntry pbe = new PricebookEntry();
        pbe.UnitPrice = 10;
        pbe.Pricebook2Id = Test.getStandardPricebookId();
        pbe.Product2Id = p2.Id;
        pbe.IsActive = true;
        insert pbe;
        
        OpportunityLineItem item = new OpportunityLineItem();
        item.OpportunityId = O.Id;
        item.Quantity = 1.0;
        item.TotalPrice = 10;
        item.PricebookEntryId = pbe.Id;
        insert item;

        Test.startTest();
        Contract ctt = new Contract();
        ctt.name='Teste Validação';
        ctt.AccountId=B.Id;
        ctt.Status = 'Draft';
        ctt.StartDate = System.today();
        ctt.ContractTerm = 12;
        ctt.BR_Casos_etapa_2_criados__c = false;
        ctt.CurrencyIsoCode = 'BRL';
        ctt.BR_Status_de_aprova_o_do_contrato__c = 'Aguardando validação dos Sistemas';
        insert ctt;
		
        Contract ctt2 = [select id,BR_Oportunidade_do_contrato__c,BR_Status_de_aprova_o_do_contrato__c, BR_Casos_etapa_2_criados__c from Contract where id =: ctt.id];
        
        ctt2.BR_Oportunidade_do_contrato__c= O.id;
        ctt2.BR_Status_de_aprova_o_do_contrato__c = 'Aguardando criação do contrato';
        ctt2.BR_Casos_etapa_2_criados__c = false;
        update ctt2;

        System.debug('ctt: ' + ctt);
        System.debug('ctt.BR_Status_de_aprova_o_do_contrato__c' + ctt.BR_Status_de_aprova_o_do_contrato__c);
        System.debug('ctt.BR_Casos_etapa_2_criados__c' + ctt.BR_Casos_etapa_2_criados__c);
        
        
        List<Case> cases = new List<Case>();
        Case c = new Case();
        Case c2 = new Case();
        
        c.Subject = 'Análise de cadastro para novo contrato';
        c.Type = 'Cadastro';
        c.BR_Contrato__c = ctt.Id ;
        c.RecordTypeId = casoRT.id; 
        c.BR_Grupo_Solucionador__c = 'Gestao de Contratos';
        //c.Subtipo__c = 'Solicitação de cadastro';
        c.OwnerId = fila1.Id;
        c.AccountId = ctt.AccountId;
        c.Motivo__c = 'Solicitação';
        c.Origin = 'Contrato';
        c.Description = 'Caso criado automaticamente através da solicitação de Contrato para que seja analisada a necessidade de criação/Alteração de cadastro.';
        cases.add(c);
        //insert c;
        System.debug('C: ' + c);
        System.debug('AccountId: ' + c.AccountId);
        System.debug('fila1: ' + c.OwnerId);
        
        c2.Subject = 'Análise de cadastro para novo contrato';
        c2.Type = 'Cadastro';
        c2.BR_Contrato__c = ctt.Id ;
        c.RecordTypeId = casoRT.id; 
        c2.BR_Grupo_Solucionador__c = 'Gestao de Contratos';
        //c.Subtipo__c = 'Solicitação de cadastro';
        c2.OwnerId = fila2.Id;
        c2.AccountId = ctt.AccountId;
        c2.Motivo__c = 'Solicitação';
        c2.Origin = 'Contrato';
        c2.Description = 'Caso criado automaticamente através da solicitação de Contrato para que seja analisada a necessidade de criação/Alteração de cadastro.';
        cases.add(c2);
        //insert c2;
        System.debug('C2: ' + c2);
        insert cases;  
        
        
        Test.stopTest();
        
    }
}