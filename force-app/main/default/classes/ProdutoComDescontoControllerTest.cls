@isTest
private class ProdutoComDescontoControllerTest {

    static testMethod void myUnitTest() {
            
        	
            /*
            Contact ctt = new Contact(BR_CPF__c = '312.609.558-50', LastName = 'Teste Last Name');
            insert ctt;
            Product2 prd = new Product2(Name = 'Teste Produto', BR_Product_Code__c = '9788576050315',RecordTypeId = '012d0000000gvQzAAI');
            insert prd;
            
            Produtos_com_desconto__c pcd = new Produtos_com_desconto__c();
            pcd.Professor__c = ctt.Id;
            pcd.Titulo__c = prd.Id;
            pcd.Desconto__c = 75;
            insert pcd;
            */
            
            //---------------------------------------------------------------------------------
            //
            // Produto Universitário
            //
            //---------------------------------------------------------------------------------
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
            
            // Pegar a lista de produto padrão
            Id pricebookId = Test.getStandardPricebookId();
            
            // Inserir o  preços padrão - universitário
            PricebookEntry standardPrice = new PricebookEntry(
                Pricebook2Id = pricebookId, 
                Product2Id = prd.Id,
                UnitPrice = 9.9, 
                IsActive = true
                // Name = 'Livro Universitário'
                );
            insert standardPrice;
            
            // Preço capa de universtário
            Pricebook2 capaPB = new Pricebook2(
                Name='Ensino Superior', 
                isActive=true);
            insert capaPB;
            
            // Inserir o preço de capa - universitário
            PricebookEntry capaPrice = new PricebookEntry(
                Pricebook2Id = capaPB.Id, 
                Product2Id = prd.Id,
                UnitPrice = 100, 
                IsActive = true
                //me = 'Livro Universitário'
                );
            insert capaPrice;
            
            ////
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
                RecordTypeID =  RecordTypeMemory.getRecType( 'Account', 'Academic_Account')
                );
            insert A;
        	System.debug('aqui '+ A);
            // Contato do professor
            //Contact ctta = new Contact(BR_CPF__c = '312.609.558-50', LastName = 'Teste Last Name', AccountId = A.ID);
            //insert ctta;
            Contact  ctt = [SELECT ID FROM Contact WHERE AccountId =: A.ID];
			
            Test.startTest();
            Test.setMock(HttpCalloutMock.class,new VendaEspecial_Mock());
    
            Produtos_com_desconto__c pcd = new Produtos_com_desconto__c();
            pcd.Data_do_pedido__c = System.now().addYears(-1);
            pcd.Professor__c = ctt.ID;
            pcd.Ativo__c = true;
            pcd.Titulo__c = prd.id; 
            pcd.Desconto__c = 75.0;
            insert pcd;
            
            Test.stopTest();
            
            ApexPages.StandardController sc = new ApexPages.StandardController(pcd); 
            ApexPages.currentPage().getParameters().put('id', pcd.Id);
            ProdutoComDescontoController pcdc = new ProdutoComDescontoController(sc);
            
            pcdc.getpcd();
            pcdc.save();
            pcdc.cancel();
    }

    static testMethod void myUnitTest2() {
        
            /*
            Contact ctt = new Contact(BR_CPF__c = '312.609.558-50', LastName = 'Teste');
            insert ctt;
            Product2 prd = new Product2(Name = 'Teste Produto', BR_Product_Code__c = '9788576050315',RecordTypeId = '012d0000000gvQzAAI');
            insert prd;
            
            Produtos_com_desconto__c pcd = new Produtos_com_desconto__c();
            pcd.Professor__c = ctt.Id;
            pcd.Titulo__c = prd.Id;
            insert pcd;
            */
            
            //---------------------------------------------------------------------------------
            //
            // Produto Universitário
            //
            //---------------------------------------------------------------------------------
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
            
            // Pegar a lista de produto padrão
            Id pricebookId = Test.getStandardPricebookId();
            
            // Inserir o  preços padrão - universitário
            PricebookEntry standardPrice = new PricebookEntry(
                Pricebook2Id = pricebookId, 
                Product2Id = prd.Id,
                UnitPrice = 9.9, 
                IsActive = true
                // Name = 'Livro Universitário'
                );
            insert standardPrice;
            
            // Preço capa de universtário
            Pricebook2 capaPB = new Pricebook2(
                Name='Ensino Superior', 
                isActive=true);
            insert capaPB;
            
            // Inserir o preço de capa - universitário
            PricebookEntry capaPrice = new PricebookEntry(
                Pricebook2Id = capaPB.Id, 
                Product2Id = prd.Id,
                UnitPrice = 100, 
                IsActive = true
                //me = 'Livro Universitário'
                );
            insert capaPrice;
            
            ////
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
                RecordTypeID =  RecordTypeMemory.getRecType( 'Account', 'Academic_Account')
                );
            insert A;
            // Contato do professor
            //Contact ctta = new Contact(BR_CPF__c = '312.609.558-50', LastName = 'Teste Last Name', AccountId = A.ID);
            //insert ctta;
            Contact  ctt = [SELECT ID FROM Contact WHERE AccountId =: A.ID];
    
            Test.startTest();
            Test.setMock(HttpCalloutMock.class,new VendaEspecial_Mock());
    
            Produtos_com_desconto__c pcd = new Produtos_com_desconto__c();
            pcd.Data_do_pedido__c = System.now().addYears(-1);
            pcd.Professor__c = ctt.ID;
            pcd.Ativo__c = true;
            pcd.Titulo__c = prd.id; 
            pcd.Desconto__c = 75.0;
            insert pcd;
            
            Test.stopTest();
            
            ApexPages.StandardController sc = new ApexPages.StandardController(pcd);         	
            ApexPages.currentPage().getParameters().put('id', null);
            ProdutoComDescontoController pcdc = new ProdutoComDescontoController(sc);
            
            pcdc.getpcd();
            pcdc.save();
            pcdc.cancel();

    }

    static testMethod void myUnitTest3() {
            
            /*
            Contact ctt = new Contact(LastName = 'Teste Last Name');
            insert ctt;
            Product2 prd = new Product2(Name = 'Teste Produto', RecordTypeId = '012d0000000gvQzAAI');
            insert prd;
            
            Produtos_com_desconto__c pcd = new Produtos_com_desconto__c();
            pcd.Professor__c = ctt.Id;
            pcd.Titulo__c = prd.Id;
            pcd.Desconto__c = 75;
            insert pcd;
            */
            
            //---------------------------------------------------------------------------------
            //
            // Produto Universitário
            //
            //---------------------------------------------------------------------------------
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
            
            // Pegar a lista de produto padrão
            Id pricebookId = Test.getStandardPricebookId();
            
            // Inserir o  preços padrão - universitário
            PricebookEntry standardPrice = new PricebookEntry(
                Pricebook2Id = pricebookId, 
                Product2Id = prd.Id,
                UnitPrice = 9.9, 
                IsActive = true
                // Name = 'Livro Universitário'
                );
            insert standardPrice;
            
            // Preço capa de universtário
            Pricebook2 capaPB = new Pricebook2(
                Name='Ensino Superior', 
                isActive=true);
            insert capaPB;
            
            // Inserir o preço de capa - universitário
            PricebookEntry capaPrice = new PricebookEntry(
                Pricebook2Id = capaPB.Id, 
                Product2Id = prd.Id,
                UnitPrice = 100, 
                IsActive = true
                //me = 'Livro Universitário'
                );
            insert capaPrice;
            
            ////
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
                RecordTypeID =  RecordTypeMemory.getRecType( 'Account', 'Academic_Account')
                );
            insert A;
            // Contato do professor
            //Contact ctta = new Contact(BR_CPF__c = '312.609.558-50', LastName = 'Teste Last Name', AccountId = A.ID);
            //insert ctta;
            Contact  ctt = [SELECT ID FROM Contact WHERE AccountId =: A.ID];
    
            Test.startTest();
            Test.setMock(HttpCalloutMock.class,new VendaEspecial_Mock());
    
            Produtos_com_desconto__c pcd = new Produtos_com_desconto__c();
            pcd.Data_do_pedido__c = System.now().addYears(-1);
            pcd.Professor__c = ctt.ID;
            pcd.Ativo__c = true;
            pcd.Titulo__c = prd.id; 
            pcd.Desconto__c = 75.0;
            insert pcd;
            
            Test.stopTest();
            
            ApexPages.StandardController sc = new ApexPages.StandardController(pcd); 
            ApexPages.currentPage().getParameters().put('id', pcd.Id);
            ProdutoComDescontoController pcdc = new ProdutoComDescontoController(sc);
            
            pcdc.getpcd();
            pcdc.save();
            pcdc.cancel();
    }    
}