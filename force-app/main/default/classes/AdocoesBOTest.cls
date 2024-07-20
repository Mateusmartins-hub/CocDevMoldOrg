@isTest
private class AdocoesBOTest {
    
    static testMethod void myUnitTest() {
        
        String Year = string.valueof(Date.Today().Year());
        
        Product2 prod = InstanceToClassCoverage.createProduct2();
        prod.BR_ISBN__c = '123321';
        
        insert prod;
        
        Id RecTypeAccSch              = RecordTypeMemory.getRecType('Account', 'School');
        
        Account acc = InstanceToClassCoverage.createAccount();
        acc.RecordTypeId = RecTypeAccSch;
        acc.BR_Main_State__c = 'SP';
        insert acc;	
        
        Contact cont = InstanceToClassCoverage.createIndividuo();
        insert cont;
        
        Id RecTypeAccSchSeg              = RecordTypeMemory.getRecType('Account_Segmentation__c', 'School_Segmentation');
        
        Account_Segmentation__c accSeg = InstanceToClassCoverage.createAccountSeg();
        accSeg.Account__c = acc.Id;
        accSeg.Current_year__c = Year;
        accSeg.BR_Adult_Level_0__c = 4;
        accSeg.BR_Pre_Primary_2__c = 3;
        accSeg.Nbr_of_students_EM_3rd_year__c = 5;
        accSeg.Nbr_of_students_Terceirao__c = 5;
        accSeg.RecordTypeId = RecTypeAccSchSeg;
        insert accSeg;
        
        Course_Structure_Discipline__c course = InstanceToClassCoverage.createCourse();
        course.Type__c = 'CURSO';
        course.BR_Active_indicator__c = true;
        insert course;
        
        Course_Structure_Discipline__c discipline = InstanceToClassCoverage.createCourse();
        discipline.Type__c = 'DISCIPLINA';
        discipline.BR_Active_indicator__c = true;
        insert discipline;
        
        Id RecTypeAdoIdiomasPearson   = RecordTypeMemory.getRecType('Adocoes_Cs__c', 'AdocaoIdiomasPearson');
        
        Adocoes_Cs__c ado = InstanceToClassCoverage.createAdocao();
        ado.Institui_o__c = acc.Id;
        ado.Curso__c = course.Id;
        ado.Disciplina__c = discipline.Id;
        ado.adocao__c = prod.Id;
        ado.Per_odo_do_Curso__c = 'Anual';
        ado.Segmento__c = 'ELT';    
        ado.RecordTypeId = RecTypeAdoIdiomasPearson;
        ado.N_mero_de_Alunos__c = 300;
        ado.Ano__c = Year;
        
        insert ado;
        List<Adocoes_Cs__c> lstAdo = new List<Adocoes_Cs__c>();
        lstAdo.add(ado);
        
        AdocoesBO.getInstance().calculaQuadrante(lstAdo);
    }
    
    static testMethod void atualizaOwner(){
        
        List<Opportunity> lstOpportunity = new List<Opportunity>();
        
        List<string> opp = new List<string>{'0060V00000xZnS0'};
            
            lstOpportunity = OpportunityDAO.getListOppById(opp);
        
        AdocoesBO.getInstance().atualizaOwner(lstOpportunity);
    }
    
    static testmethod void criarAdocoesAPartirDeOportunidadeIdiomas(){
      
        Test.setMock(HttpCalloutMock.class, new MockCapturaSAP());
         Profile p = [SELECT Id FROM Profile WHERE (Name = 'System Administrator') or  (Name = 'Administrador do Sistema' )];         
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
            //UserRoleId = '00Ed0000000FURnEAO'
            // ManagerId ='005d0000001oExKAAU' // **** MUITO IMPORTANTE - APROVADOR
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
            UserRoleId = [SELECT Id FROM UserRole WHERE Name = 'Brazil Global'][0].Id,
            ManagerId = u1.id  
        );
        insert u2;
        // rodando com o usuário solicitante
        System.runAs(u2) {
            
            System.debug('----------------------------- Usuário Corrente - INST------- ----------');  
            System.debug('Current User: ' + UserInfo.getUserName());
            System.debug('Current Profile: ' + UserInfo.getProfileId()); 
            System.debug('u1.id:' + u1.id);
            System.debug('-----------------------------------------------------------------------');      
            
            //
            //  IBGE  
            //
            IBGE_Code__c IBGE = new IBGE_Code__c (
                City_name__c = 'São Paulo',
                City_code__c = '50308',
                UF_name__c ='São Paulo',
                UF_acronym__c = 'SP',
                Name = '3550308'
            );
            insert IBGE;
            
            //
            // PF        
            //
            Account A = new Account(
                BR_Account_Id_SSA__c = 'P6666',
                BR_Birthdate__c = '18/08/1990',
                BR_CPF__c = '178.170.628-03',
                BR_Integrate_to_SAP__c = false,
                BR_Integrate_to_SSA__c = true,
                BR_Integration_Status_SSA__c = 'Integrado ERP',
                BR_Main_Address__c = 'Rua Nelson Francisco  ',
                BR_Main_City__c = 'São Paulo',
                BR_Main_Complement__c = 'ap23',
                BR_Main_Country__c = 'BR',
                BR_Main_District__c = 'Limão',
                BR_Main_Nbr__c = '666',
                BR_Main_State__c = 'SP',
                BR_Main_Zip_code__c = '05790-140',
                Name = 'Roberto Carlos',
                IBGE_Code__c = IBGE.ID,
                RecordTypeID = Schema.SobjectType.Account.getRecordTypeInfosByDeveloperName().get('Academic_Account').getRecordTypeId() //'012d0000000gQD8'
            );
            insert A;
            
            system.debug('account id ' + A.Id);
            //linhas abaixo criadas para dar mais cobertura a classe 
            set<Id> setIds = new set<Id>();
            setIds.add(A.Id);
            List<AccountTeamMember> membros = AccountTeamMemberDAO.getMemberTeamListByAccountId(A.Id);
            List<AccountTeamMember> membrosAccountIdAndRole = AccountTeamMemberDAO.getMemberTeamListByAccountIdAndRole(A.Id, 'Inside Sales HED');
            List<AccountTeamMember> membrosSetAccIdAndRole = AccountTeamMemberDAO.getMemberTeamListBySetAccIdAndRole(setIds, 'Inside Sales HED');
            
            // 
            //  Contato da conta 
            //
            //Contact Contac = [SELECT ID, AccountId from  Contact where AccountId =: A.ID ];
            //System.Debug('Contact.ID = ' + Contac.ID);     
            
            //
            // PJ        
            //
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
                BR_Account_email__c = 'jose.kleber@pearson.com',
                BR_Area_code__c = 11.0,
                Phone = '9999-9999',
                BR_Company_Name__c  = 'Empresa X LTDA',
                Name = 'Empresa X LTDA',
                RecordTypeID = Schema.SobjectType.Account.getRecordTypeInfosByDeveloperName().get('Academic_Account').getRecordTypeId(), //'012d0000000gdJZAAY'
                IBGE_Code__c = IBGE.ID
            );
            insert B;
            system.debug('JK Account : ' + B.Id);
            //
            // Conta e Contato relação (PJ com PF)
            // 
            /*
            Account_Contact__c Account_Contact = new Account_Contact__c(
                Account__c = B.ID,
                Contact__c = Contac.ID
            );
            Account_Contact.Email__c = 'teste@teste.com';
            Account_Contact.CPF__c = '50373666403';
            insert Account_Contact;
            */
            // 
            //  Oportunidade - Instituicao
            //
            Opportunity O = new Opportunity(
                BR_Shipping_Address__c = 'Instituição',
                ForecastCategoryName = 'Omitted',
                StageName = 'Apresentação Inicial', 
                AccountID = B.ID,
                Name = 'Instituicao Idiomas',
                CloseDate = System.today(),
                //BR_Contact__c = Contac.ID,
                BR_shipping_type__c = 'Retira',
                RecordTypeId =  Schema.SobjectType.Opportunity.getRecordTypeInfosByDeveloperName().get('Oportunidade_de_Negocio_Pearson_English_EDU').getRecordTypeId(),  //[SELECT Id FROM RecordType WHERE Name LIKE 'Oportunidade de Negócio%' LIMIT 1][0].Id,
                //BR_Account_Contact__c = Account_Contact.ID,
                BR_Shipping_Address2__c = 'Residencial',
                BR_Ano__c = '2021',
                BR_Compras_atraves_de__c = 	'Distribuidor',
                BR_Distribuidor__c = 'DISAL',
                BR_ConfirmarAdocao__c = true,
                BR_PrevisaoCompra__c = Date.today(),
                BR_ConfirmacaoAdocaoEnviada__c = true,
                CurrencyIsoCode = 'BRL',
                Pricebook2Id = Test.getStandardPricebookId()
            );
             
            try{
                Insert O;
                system.debug('O.ID:' + O.ID);
            }
            catch(Exception ex){
                system.debug('JK ' + ex.getMessage());
            }
            
            Product2 prd = new Product2(Name = 'Teste Product');
            insert prd;
            
            Product2 prd2 = new Product2(Name = 'Teste Product 2');
            insert prd2;
            
            PricebookEntry pe = new PricebookEntry();
            pe.Pricebook2Id = Test.getStandardPricebookId();
            pe.Product2Id = prd.id;
            pe.UnitPrice = 0.01;
            pe.IsActive = true;
            pe.CurrencyIsoCode = 'BRL';
            insert pe;
            
            PricebookEntry pe2 = new PricebookEntry();
            pe2.Pricebook2Id = Test.getStandardPricebookId();
            pe2.Product2Id = prd2.id;
            pe2.UnitPrice = 0.01;
            pe2.IsActive = true;
            pe2.CurrencyIsoCode = 'BRL';
            insert pe2;            
            //  
            //  Oportunidade - 1 item
            //                   
            OpportunityLineItem  O_item1 = new OpportunityLineItem (
                // Id = '00k11000003ipmjAAA',
                // BR_ERP_Product_Code__c = '9780131110410',
                PricebookEntryId = pe.Id,
                //OpportunityId = '00611000004RNFGAA4',
                OpportunityId = O.ID,
                Product2Id = prd.Id,
                TotalPrice = 10.66,
                Quantity = 1.0,
                Observacoes_produto_restrito__c ='Sim',
                BR_Ano__c = '2019',
                BR_StatusProduto__c = true
            );
            Insert O_item1;
            system.debug('O_item1.ID:' + O_item1.ID); 
            
            //  
            //  Oportunidade - 2 item
            //           
            OpportunityLineItem  O_item2 = new OpportunityLineItem (
                // Id = '00k11000003ipmAAAQ',
                //BR_ERP_Product_Code__c = '9780131106420',
                PricebookEntryId = pe2.Id,
                // OpportunityId = '00611000004RNFGAA4',
                OpportunityId = O.ID,
                Product2Id = prd2.Id,
                TotalPrice = 10.66,
                Quantity = 1.0,
                Observacoes_produto_restrito__c ='Sim',
                BR_Ano__c = '2019'
            );
            Insert O_item2;
            system.debug('O_item2.ID:' + O_item2.ID);
            
            O.StageName = 'Adoção Realizada';
            update O;
            
            List<Opportunity> lstOpportunity = new List<Opportunity>();
            Map<Id, Opportunity> mapOldValues = new Map<Id,Opportunity>();
                                        
            lstOpportunity = new List<Opportunity>{OpportunityDAO.buscaOportunidade(O.Id)};
            
            AdocoesBO.getInstance().criarAdocoesAPartirDeOportunidade(lstOpportunity, mapOldValues);
        }
      
    }
    
    static testmethod void criarAdocoesAPartirDeOportunidade(){
        
        Test.setMock(HttpCalloutMock.class, new MockCapturaSAP());
        Profile p = [SELECT Id FROM Profile WHERE (Name = 'System Administrator') or  (Name = 'Administrador do Sistema' )];         
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
            //UserRoleId = '00Ed0000000FURnEAO'
            // ManagerId ='005d0000001oExKAAU' // **** MUITO IMPORTANTE - APROVADOR
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
            //UserRoleId = '00Ed0000000FURnEAO',
            ManagerId = u1.id  // '005d0000001oExKAAU'  // **** MUITO IMPORTANTE - APROVADOR
        );
        insert u2;
        // rodando com o usuário solicitante
        System.runAs(u2) {
            
            System.debug('----------------------------- Usuário Corrente - INST------- ----------');  
            System.debug('Current User: ' + UserInfo.getUserName());
            System.debug('Current Profile: ' + UserInfo.getProfileId()); 
            System.debug('u1.id:' + u1.id);
            System.debug('-----------------------------------------------------------------------');      
            
            //
            //  IBGE  
            //
            IBGE_Code__c IBGE = new IBGE_Code__c (
                City_name__c = 'São Paulo',
                City_code__c = '50308',
                UF_name__c ='São Paulo',
                UF_acronym__c = 'SP',
                Name = '3550308'
            );
            insert IBGE;
            
            //
            // PF        
            //
            Account A = new Account(
                BR_Account_Id_SSA__c = 'P6666',
                BR_Birthdate__c = '18/08/1990',
                BR_CPF__c = '178.170.628-03',
                BR_Integrate_to_SAP__c = false,
                BR_Integrate_to_SSA__c = true,
                BR_Integration_Status_SSA__c = 'Integrado ERP',
                BR_Main_Address__c = 'Rua Nelson Francisco  ',
                BR_Main_City__c = 'São Paulo',
                BR_Main_Complement__c = 'ap23',
                BR_Main_Country__c = 'BR',
                BR_Main_District__c = 'Limão',
                BR_Main_Nbr__c = '666',
                BR_Main_State__c = 'SP',
                BR_Main_Zip_code__c = '05790-140',
                Name = 'Roberto Carlos',
                IBGE_Code__c = IBGE.ID,
                RecordTypeID = Schema.SobjectType.Account.getRecordTypeInfosByDeveloperName().get('Academic_Account').getRecordTypeId() //'012d0000000gQD8'
            );
            insert A;
            
            system.debug('account id ' + A.Id);
            
            // 
            //  Contato da conta 
            //
            //Contact Contac = [SELECT ID, AccountId from  Contact where AccountId =: A.ID ];
            //System.Debug('Contact.ID = ' + Contac.ID);     
            
            //
            // PJ        
            //
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
                BR_Account_email__c = 'jose.kleber@pearson.com',
                BR_Area_code__c = 11.0,
                Phone = '9999-9999',
                BR_Company_Name__c  = 'Empresa X LTDA',
                Name = 'Empresa X LTDA',
                RecordTypeID = Schema.SobjectType.Account.getRecordTypeInfosByDeveloperName().get('Academic_Account').getRecordTypeId(),  //'012d0000000gQD8''012d0000000gdJZAAY',
                IBGE_Code__c = IBGE.ID
            );
            insert B;
            system.debug('JK Account : ' + B.Id);
            //
            // Conta e Contato relação (PJ com PF)
            // 
            /*
            Account_Contact__c Account_Contact = new Account_Contact__c(
                Account__c = B.ID,
                Contact__c = Contac.ID
            );
            Account_Contact.Email__c = 'teste@teste.com';
            Account_Contact.CPF__c = '50373666403';
            insert Account_Contact;
            */
            // 
            //  Oportunidade - Instituicao
            //
            Opportunity O = new Opportunity(
                //Id = '00611000004RNFGAA4',
                BR_Shipping_Address__c = 'Instituição',
                ForecastCategoryName = 'Omitted',
                // StageName  = 'Enviado para Integração',
                StageName = 'Elaboração', 
                AccountID = B.ID,
                Name = 'Instituicao Idiomas',
                CloseDate = System.today(),
                //BR_Contact__c = Contac.ID,
                BR_shipping_type__c = 'Retira',
                RecordTypeId = Schema.SobjectType.Opportunity.getRecordTypeInfosByDeveloperName().get('Sample_Order_University').getRecordTypeId(),//  '012d0000000gvQV',
                //BR_Account_Contact__c = Account_Contact.ID,
                // BR_Approver1__c = u2.id,
                // BR_Approver2__c = u1.id
                BR_Shipping_Address2__c = 'Residencial',
                CurrencyIsoCode = 'BRL',
                Pricebook2Id = Test.getStandardPricebookId()
            );
             
            try{
                Insert O;
                system.debug('O.ID:' + O.ID);
            }
            catch(Exception ex){
                system.debug('JK ' + ex.getMessage());
            }
            
              
            Product2 prd = new Product2(Name = 'Teste Product');
            insert prd;
            
            Product2 prd2 = new Product2(Name = 'Teste Product 2');
            insert prd2;
            
            PricebookEntry pe = new PricebookEntry();
            pe.Pricebook2Id = Test.getStandardPricebookId();
            pe.Product2Id = prd.id;
            pe.UnitPrice = 0.01;
            pe.IsActive = true;
            pe.CurrencyIsoCode = 'BRL';
            insert pe;
            
            PricebookEntry pe2 = new PricebookEntry();
            pe2.Pricebook2Id = Test.getStandardPricebookId();
            pe2.Product2Id = prd2.id;
            pe2.UnitPrice = 0.01;
            pe2.IsActive = true;
            pe2.CurrencyIsoCode = 'BRL';
            insert pe2;
            //  
            //  Oportunidade - 1 item
            //                   
            OpportunityLineItem  O_item1 = new OpportunityLineItem (
                // Id = '00k11000003ipmjAAA',
                // BR_ERP_Product_Code__c = '9780131110410',
                PricebookEntryId = pe.Id,
                //OpportunityId = '00611000004RNFGAA4',
                OpportunityId = O.ID,
                Product2Id = prd.Id,
                TotalPrice = 10.66,
                Quantity = 1.0,
                Observacoes_produto_restrito__c ='Sim'
                
            );
            Insert O_item1;
            system.debug('O_item1.ID:' + O_item1.ID); 
            
            //  
            //  Oportunidade - 2 item
            //           
            OpportunityLineItem  O_item2 = new OpportunityLineItem (
                // Id = '00k11000003ipmAAAQ',
                //BR_ERP_Product_Code__c = '9780131106420',
                PricebookEntryId = pe2.Id,
                // OpportunityId = '00611000004RNFGAA4',
                OpportunityId = O.ID,
                Product2Id = prd2.Id,
                TotalPrice = 10.66,
                Quantity = 1.0,
                Observacoes_produto_restrito__c ='Sim',
                BR_StatusProduto__c = true
            );
            Insert O_item2;
            system.debug('O_item2.ID:' + O_item2.ID);
                        
            O.StageName = 'Adotado';
            update O;
            
            List<Opportunity> lstOpportunity = new List<Opportunity>();
            Map<Id, Opportunity> mapOldValues = new Map<Id,Opportunity>();
                            
            lstOpportunity = new List<Opportunity>{OpportunityDAO.buscaOportunidade(O.Id)};
            
            //linhas abaixo criadas para dar mais cobertura a classe AdocoesDAO
            AdocoesBO.getInstance().criarAdocoesAPartirDeOportunidade(lstOpportunity, mapOldValues);
            List <String> lstContact = new list<string>();
            Contact Contac = [SELECT ID, AccountId from  Contact where AccountId =: A.ID ];
            lstContact.add(Contac.Id);
            List<Adocoes_Cs__c> lstAdogetAdocoes = AdocoesDAO.getInstance().getAdocoes(lstContact, 2020);
            List<Adocoes_Cs__c> lstStringAdogetAdocoes = AdocoesDAO.getInstance().getAdocoes(lstContact);
            List<AggregateResult> lstAdogetAdocoesAgrupadas = AdocoesDAO.getInstance().getAdocoesAgrupadasAccountContact(lstContact, '20203232');
            //
            
            AdocaoOut.atualizaDistribuicao(O.Id);
            Set<String> setOppsToDeleteAdocaoAntesCriarAdocao = new Set<String>();
            List<Adocoes_Cs__c> lstOppsToDelete = AdocoesDAO.getInstance().getAdocoesByLstOpportunityId(new List<String>(setOppsToDeleteAdocaoAntesCriarAdocao));
            AdocaoOut.exclui(lstOppsToDelete);
        }
        
        
        //delete A;
    }
    
    
}