@isTest
private class DistribuicaoGratuitaBOTest {

    @isTest 
    static void test_method_one() {

        User userToRun = [
    		SELECT Id FROM User WHERE Profile.Name LIKE '%admin%' AND ManagerId != null AND isActive = true LIMIT 1
		];

		System.runAs(userToRun){
                
            Test.startTest();

            IBGE_Code__c IBGE = new IBGE_Code__c (
                    City_name__c = 'São Paulo',
                    City_code__c = '50308',
                    UF_name__c ='São Paulo',
                    UF_acronym__c = 'SP',
                    Name = '3550308'
            );
            insert IBGE;

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
                    //RecordTypeID = '012d0000000gdJZAAY',
                    IBGE_Code__c = IBGE.ID
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
                    BR_Shipping_Address2__c = 'Residencial'
            );
            O.Description = 'Teste';
            Insert O;

            BR_DistribuicaoGratuita__c distGrat = new BR_DistribuicaoGratuita__c();

            distGrat.BR_Oportunidade__c = O.Id;

            distGrat.BR_Aos_Cuidados_de_Account_Contact__c =Account_Contact.Id;
            distGrat.RecordTypeId = RecordTypeUtil.getInstance().getRecordTypePorNome('BR_DistribuicaoGratuita__c',
                                                                                        'Amostra Virtual').getRecordTypeId();

            Insert distGrat;
            //linhas abaixo criadas para dar mais cobertura a classe DistribuicaoGratuitaDAO            
            DistribuicaoGratuitaDAO.getInstance().buscaRespostaAdocaoDistribuicao(distGrat.Id);
            DistribuicaoGratuitaDAO.getInstance().listaDistruibuicaoPorOpp(O.Id);
            //
            
            Id idRecTypeDistribuidor     = RecordTypeMemory.getRecType( 'Product2', 'Product_University' );
            Product2 prd = new Product2(
                Name = 'Livro Universitário',
                BR_Author_name__c = 'Autor Universitário',
                BR_ISBN__c = '9111111111111',
                BR_Linha_Negocio__c = '20',
                // Business_Line__c = 'Universitário',
                RecordTypeID = idRecTypeDistribuidor,
                BR_Edicao__c = '1');
            insert prd;
            
            BR_ProdutoDistribuicaoGratuita__c produtoDistGrat = new BR_ProdutoDistribuicaoGratuita__c();
            produtoDistGrat.BR_DistribuicaoGratuita__c = distGrat.Id;
            produtoDistGrat.BR_ProdutoDistribuicaoGratuita__c = prd.Id;
            produtoDistGrat.BR_Enviado__c = true;        
            Insert produtoDistGrat;
            
            List<BR_ProdutoDistribuicaoGratuita__c> lstPrdts = new List<BR_ProdutoDistribuicaoGratuita__c>();
            lstPrdts.add(produtoDistGrat);
            
            //linhas abaixo criadas para dar mais cobertura a classe DistribuicaoGratuitaDAO
            List<string> lstStringProd = new list<string>();
            lstStringProd.add(produtoDistGrat.id);
            List<BR_ProdutoDistribuicaoGratuita__c> lstBuscaProd =  DistribuicaoGratuitaDAO.getInstance().buscarProdDist(lstStringProd, distGrat.Id);
            
            AlcadasAprovador__c alcAp = new AlcadasAprovador__c();
            alcAp.CurrencyIsoCode = 'BRL';
            insert alcAp;
            
            AlcadasAprovadorDAO.getinstance().obterAlcadaAprovadorPorId(alcAp.Id);
            AlcadasAprovadorDAO.getinstance().obterListaAlcadaAprovadorPorCentroCusto('915302');
            
            //
            Map<Id,BR_ProdutoDistribuicaoGratuita__c> mapPrdts = new Map<Id,BR_ProdutoDistribuicaoGratuita__c>();
            BR_ProdutoDistribuicaoGratuita__c cloneProduct = produtoDistGrat.clone(true);
            cloneProduct.BR_Enviado__c = false;
            mapPrdts.put(cloneProduct.Id, cloneProduct);
                    DistribuicaoGratuitaBO.getInstance().alterarFaseDG(lstPrdts,mapPrdts);

            
            ProdutoDistribuicaoGratuitaVF prodDistGrat = new ProdutoDistribuicaoGratuitaVF();
            prodDistGrat.prodDistribuicaoGratuita = produtoDistGrat;
            prodDistGrat.nomeProduto = 'teste';
            prodDistGrat.nomeCurso = 'curso teste';
            prodDistGrat.nomeDisciplina = 'disciplina Teste';
            prodDistGrat.isSelected = true;
            prodDistGrat.isNewRecord = false;
            
            
            List<ProdutoDistribuicaoGratuitaVF> lProdDistGrat = new List<ProdutoDistribuicaoGratuitaVF>();
            lProdDistGrat.add(prodDistGrat);
            boolean emailAgrupado = true;
            
            DistribuicaoGratuitaBO.getInstance().saveDistribuicaoGratuita(distGrat,lProdDistGrat ,emailAgrupado);
            DistribuicaoGratuitaBO.getInstance().getDistribuicaoGratuitaById(distGrat.Id);

            Test.stopTest();
        }
    }
    

    @IsTest
    static void gerarLinkDistribuicaoTest() {
        List<String> links = new List<String>();
		String testLink = 'url_test.com.br';
        links.add(testLink);
        DistribuicaoGratuitaBO.getInstance().gerarLinkDistribuicao(links);
    }

    @IsTest
    static void buscarProdutosDistribuicaoTest() {
        User userToRun = [
    		SELECT Id FROM User WHERE Profile.Name LIKE '%admin%' AND ManagerId != null AND isActive = true LIMIT 1
		];

		System.runAs(userToRun){
            Opportunity opp = TestHelper.createOpportunity();
            insert opp;
            DistribuicaoGratuitaBO.getInstance().buscarProdutosDistribuicao(opp.Id);
        }
    }
    
    @IsTest
    static void onChangeStageTest(){

        User userToRun = [
    		SELECT Id FROM User WHERE Profile.Name LIKE '%admin%' AND ManagerId != null AND isActive = true LIMIT 1
		];

		System.runAs(userToRun){
            
            Opportunity opp = TestHelper.createOpportunity();
            
            insert opp;
            
            BR_DistribuicaoGratuita__c distGrat = new BR_DistribuicaoGratuita__c();
            distGrat.BR_StatusProcessoAprovacao__c = 'APROVADO';
            distGrat.BR_Oportunidade__c = opp.Id;
            insert distGrat;
            
            
            List<BR_DistribuicaoGratuita__c> lstOpps = new List<BR_DistribuicaoGratuita__c>();
            lstOpps.add(distGrat);
            
            Map<Id, BR_DistribuicaoGratuita__c> mapOpps = new Map<Id, BR_DistribuicaoGratuita__c>();
            BR_DistribuicaoGratuita__c dg = distGrat.clone(true);
            dg.BR_StatusProcessoAprovacao__c = '';
            mapOpps.put(dg.Id, dg);
            
            DistribuicaoGratuitaBO.getInstance().onChangeStage(lstOpps, mapOpps);
        }
    }
}