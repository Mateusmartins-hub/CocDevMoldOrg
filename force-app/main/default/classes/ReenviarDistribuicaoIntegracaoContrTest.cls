@isTest
public class ReenviarDistribuicaoIntegracaoContrTest {
    
    @TestSetup
    static void testSetup() {
        
        
    }
    
    @isTest
    static void testOne() {  
        
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
            
        );
        insert u1;
        
        system.debug('TESTE - Aprovador criado');
        
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
        system.debug('TESTE - Solicitante criado.');
        
		System.runAs(u2) {
            
            //
            // Usuário corrente
            //
            System.debug('----------------------------- Usuário Corrente - RESIDENCIAL ----------');  
            System.debug('Current User: ' + UserInfo.getUserName());
            System.debug('Current Profile: ' + UserInfo.getProfileId()); 
            System.debug('u1.id:' + u1.id);
            System.debug('-----------------------------------------------------------------------');  
            
            /** Crio oportunidade e distribuição fictício para envio */
            list<IBGE_Code__c> IBGEList = [select City_name__c, City_code__c, UF_name__c, UF_acronym__c, Name from IBGE_Code__c where City_code__c = '50308' limit 1];
            IBGE_Code__c IBGE = null;
            
            if (IBGEList.isEmpty()){
                system.debug('TESTE - IBGE não existe, criando.');
                IBGE = new IBGE_Code__c (
                    City_name__c = 'São Paulo',
                    City_code__c = '50308',
                    UF_name__c ='São Paulo',
                    UF_acronym__c = 'SP',
                    Name = '3550308'
                );
                insert IBGE;
                system.debug('TESTE - IBGE criado.');
            } else 
                IBGE = IBGEList[0];
            
            list<Account> acc = [select id, Name from Account where BR_CPF__c = '909.599.820-78' limit 1];
            Account A = null;
                        
            if (acc.isEmpty()){
                system.debug('TESTE - account PF não existe. Criando.');
                //
                // PF        
                //
                A = new Account(
                    BR_Birthdate__c = '18/08/1990',
                    BR_CPF__c = '909.599.820-78',
                    BR_Integrate_to_SAP__c = false,
                    BR_Integrate_to_SSA__c = true,
                    BR_Main_Address__c = 'Rua Nelson Francisco',
                    BR_Main_City__c = 'São Paulo',
                    BR_Main_Complement__c = 'ap23',
                    BR_Main_Country__c = 'BR',
                    BR_Main_District__c = 'Limão',
                    BR_Main_Nbr__c = '666',
                    BR_Main_State__c = 'SP',
                    BR_Main_Zip_code__c = '05790-140',
                    Name = 'Roberto Carlos',
                    IBGE_Code__c = IBGE.ID
                );
                insert A;   
                system.debug('TESTE - account criado.');
            } else 
            	A = acc[0];
            
            // 
            //  Contato da conta 
            //
            Contact ctta = new Contact(BR_CPF__c = '312.609.558-50', LastName = 'Teste Last Name', AccountId = A.ID);
            insert ctta;
            Contact Contac = [SELECT ID, AccountId from  Contact where AccountId =: A.ID ];
            system.debug('TESTE - Contact.ID = ' + Contac.ID);
            
            list<Account> accPJ = [select id, Name from Account where BR_cnpj__c = '58.022.474/0001-14' limit 1];
            Account B;
            
            if (accPJ.isEmpty()){
                system.debug('TESTE - account PJ não existe. Criando.');
                //
                // PJ        
                //
                B = new Account(
                    BR_Account_Id_SSA__c = 'I66662',
                    BR_Birthdate__c = '18/08/1990',
                    BR_cnpj__c = '58.022.474/0001-14',
                    BR_Integrate_to_SAP__c = false,
                    BR_Integrate_to_SSA__c = true,
                    BR_Integration_Status_SSA__c = 'Integrado ERP',
                    BR_Integration_Status_SAP__c = '',
                    BR_Main_Address__c = 'Rua Nelson Francisco  ',
                    BR_Main_City__c = 'São Paulo',
                    BR_Main_Complement__c = 'ap666',

                    BR_Main_District__c = 'Limão',
                    BR_Main_Nbr__c = '666',
                    BR_Main_State__c = 'SP',
                    BR_Main_Zip_code__c = '05790-140',
                    BR_Account_email__c = 'teste@pearson.com',
                    BR_Area_code__c = 11.0,
                    Phone = '9999-9999',
                    BR_Company_Name__c  = 'Empresa X LTDA',
                    Name = 'Empresa X LTDA',
                    //RecordTypeID = '012d0000000gdJZAAY'
                    IBGE_Code__c = IBGE.ID
                );
                insert B;
                system.Debug('TESTE - Account PJ Criado.');
            } else 
                B = accPJ[0];
            
            //
            // Conta e Contato relação (PJ com PF)
            //
            Account_Contact__c Account_Contact = new Account_Contact__c(
                Account__c = B.ID,
                Contact__c = Contac.ID
            );
            Account_Contact.Email__c = 'teste@teste.com';
            Account_Contact.CPF__c = '50373666403';
            insert Account_Contact;
            
            system.debug('TESTE - adionado account contact.');
            
            Id tipoRegistro = RecordTypeMemory.getRecType('Opportunity', 'Oportunidade_de_Negocio_Pearson_English_EDU');
            
            // 
            //  Oportunidade
            //
            Opportunity opp = new Opportunity(
                BR_Shipping_Address__c = 'Residencial',
                ForecastCategoryName = 'Omitted',
                StageName  ='Elaboração', 
                AccountID = B.ID,
                Name = 'Oportunidade de TESTE',
                CloseDate = System.today(),
                BR_Contact__c = Contac.ID,
                BR_shipping_type__c = 'Sedex',
                RecordTypeId = tipoRegistro,  // Oportunidade_de_Negocio_Pearson_English_EDU
                BR_Account_Contact__c = Account_Contact.ID,
                //CurrencyIsoCode = 'BRL'
                CurrencyIsoCode = 'USD'
            );
            Insert opp;
            
            system.debug('TESTE - Oportunidade Criada.');
            
            
            //
            // Item da Oportunidade
            //
            PricebookEntry ent = TestHelper.createPricebookEntry();
            insert ent;
            
            OpportunityLineItem  oppLineItem = new OpportunityLineItem (
                PricebookEntryId =  ent.Id,
                OpportunityId = opp.ID,
                TotalPrice = 44.33,
                Quantity = 1.0,
                QtdDisp__c = 100,
                Observacoes_produto_restrito__c ='Não'                
            );
            Insert oppLineItem;
            system.debug('Line Item1.ID:' + oppLineItem.ID);
            
            BR_DistribuicaoGratuita__c dg1 = new BR_DistribuicaoGratuita__c();
            dg1.BR_Aos_Cuidados_de_Account_Contact__c = Account_Contact.Id;
            dg1.BR_CEP__c = '00000-000';
            dg1.BR_Cidade__c = 'SAO PAULO';
            dg1.BR_Email__c = 'teste@teste.com';
            dg1.BR_Estado__c = 'SP';
            dg1.BR_FormaEnvio__c = 'PAC';
            dg1.BR_Instituicao__c = b.Id;
            dg1.BR_IntegradoSucesso__c = false;
            dg1.BR_Integrar__c = true;
            dg1.BR_ErroIntegracao__c = false;
            dg1.BR_Logradouro__c = 'abc';
            dg1.BR_Oportunidade__c = opp.Id;
            dg1.BR_TipoEndereco__c = 'Residencial';
            dg1.BR_Pais__c = 'BR';
            //dg1.RecordTypeId = '0120V0000026BAfQAM';

            insert dg1; 
            system.debug('TESTE - Distribuição Gratuita Inserida.');
            
            BR_DistribuicaoGratuita__c dg2 = new BR_DistribuicaoGratuita__c();
            dg2.BR_Aos_Cuidados_de_Account_Contact__c = Account_Contact.Id;
            dg2.BR_CEP__c = '00000-000';
            dg2.BR_Cidade__c = 'SAO PAULO';
            dg2.BR_Email__c = 'teste@teste.com';
            dg2.BR_Estado__c = 'SP';
            dg2.BR_FormaEnvio__c = 'PAC';
            dg2.BR_Instituicao__c = b.Id;
            dg2.BR_IntegradoSucesso__c = false;
            dg2.BR_Integrar__c = true;
            dg2.BR_ErroIntegracao__c = false;
            dg2.BR_Logradouro__c = 'abc';
            dg2.BR_Oportunidade__c = opp.Id;
            dg2.BR_TipoEndereco__c = 'Comercial';
            dg2.BR_Pais__c = 'BR';
            //dg2.RecordTypeId = '0120V0000026BAfQAM';

            insert dg2; 
            system.debug('TESTE - Distribuição Gratuita Inserida 2.');
            
            BR_DistribuicaoGratuita__c dg3 = new BR_DistribuicaoGratuita__c();
            dg3.BR_Aos_Cuidados_de_Account_Contact__c = Account_Contact.Id;
            dg3.BR_CEP__c = '00000-000';
            dg3.BR_Cidade__c = 'SAO PAULO';
            dg3.BR_Email__c = 'teste@teste.com';
            dg3.BR_Estado__c = 'SP';
            dg3.BR_FormaEnvio__c = 'PAC';
            dg3.BR_Instituicao__c = b.Id;
            dg3.BR_IntegradoSucesso__c = false;
            dg3.BR_Integrar__c = true;
            dg3.BR_ErroIntegracao__c = true;
            dg3.BR_Logradouro__c = 'abc';
            dg3.BR_Oportunidade__c = opp.Id;
            dg3.BR_TipoEndereco__c = 'Comercial';
            dg3.BR_Pais__c = 'BR';
            //dg3.RecordTypeId = '0120V0000026BAfQAM';

            insert dg3; 
            system.debug('TESTE - Distribuição Gratuita Inserida 3. Distribuição com ERRO.');
            
            test.startTest();
            system.debug('TESTE - CHAMANDO REENVIO PARA INTEGRACAO LIGHTNING.');
            
			// envia distribuição com erro de integração            
            ReenviarDistribuicaoIntegracaoController.ReenviaIntegracao([SELECT Id FROM BR_DistribuicaoGratuita__c
                                                                        where BR_ErroIntegracao__c = true 
                                                                        and BR_Integrar__c = true 
                                                                        and BR_IntegradoSucesso__c = false
                                                                        and BR_Oportunidade__r.RecordTypeId =: tipoRegistro
                                                                        and BR_Oportunidade__r.StageName != 'Pedido Gerado' LIMIT 1].Id);
            // envia distribuição sem erro de integração
            ReenviarDistribuicaoIntegracaoController.ReenviaIntegracao([SELECT Id FROM BR_DistribuicaoGratuita__c
                                                                        where BR_ErroIntegracao__c = false 
                                                                        and BR_Integrar__c = true 
                                                                        and BR_IntegradoSucesso__c = false
                                                                        and BR_Oportunidade__r.RecordTypeId =: tipoRegistro
                                                                        and BR_Oportunidade__r.StageName != 'Pedido Gerado' LIMIT 1].Id);
            
            test.stopTest();
            
            system.debug('TESTE - chegou no final');
        }
        
    }
    
}