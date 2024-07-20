/*******************************************************************************
*                     Copyright (C) 2013 - Cloud2b
*-------------------------------------------------------------------------------
*
* Test class for testing and coverage of TeacherCard's controller class.
*
* NAME: TeacherCardControllerTest.cls
* AUTHOR: MARCOS DOBROWOLSKI                        DATE: 2013/06/26
*
*******************************************************************************/

@isTest
private class TeacherCardControllerTest {
   
    static testMethod void myUnitTest() {
        
        User userToRun = [
            SELECT Id FROM User WHERE Profile.Name LIKE '%admin%' AND ManagerId != null AND isActive = true LIMIT 1
        ];
        
        System.runAs(userToRun){
            
            // Product, Pricebook and IBGE Code
            //Pricebook2 pb2 = [ SELECT IsStandard, Id FROM Pricebook2 WHERE IsStandard = true LIMIT 1 ];
            
            
            Id RecTypeProduct  = RecordTypeMemory.getRecType('Product2', 'Product_University'); 
            Product2 product = SObjectInstance.getProduct2( RecTypeProduct );
            Database.insert( product );
            
            PricebookEntry pbEntry = SObjectInstance.getPricebookEntry( Test.getStandardPricebookId(), product.Id );
            Database.insert( pbEntry );
            
            
            Product2 productD = SObjectInstance.getProduct2( RecTypeProduct );
            productD.BR_Digital_Product__c = true;
            Database.insert( productD );
            
            PricebookEntry pbEntryD = SObjectInstance.getPricebookEntry( Test.getStandardPricebookId(), productD.Id );
            Database.insert( pbEntryD );
            
            
            IBGE_Code__c ibgeCode = SObjectInstance.getIBGECode();
            Database.insert( ibgeCode );
            //---
            
            // Account (institution)
            Id recTypeUniversity = RecordTypeMemory.getRecType('Account', 'University');
            
            Account acc = SObjectInstance.getAccount( recTypeUniversity );
            acc.Adocoes_Imprimir__c = '2013';
            acc.BR_Main_City__c = 'São Paulo';
            acc.BR_Main_State__c = 'SP';
            Database.insert( acc );
            
            // Contact (teacher)
            Contact ctt = SObjectInstance.getContact( acc.Id );
            ctt.Adocoes_Imprimir__c = '2013';
            Database.insert( ctt );
            
            // Account-Contact
            Account_Contact__c acc_ctt = SObjectInstance.getAccountContact( ctt.Id, acc.Id );
            acc_ctt.Email__c = 'teste@teste.com';
            acc_ctt.CPF__c = '50373666403';
            Database.insert( acc_ctt );
            
            // Asset (adoption)
            Asset ast = new Asset();
            ast.AccountId = acc.Id;
            ast.ContactId = ctt.Id;
            ast.BR_Year__c = '2013';
            ast.Product2Id = product.Id;
            ast.Name = 'Asset Test';
            Database.insert( ast );
            
            // Opportunity (sample)
            Id RecTypeSampleOrder   = RecordTypeMemory.getRecType('Opportunity', 'Sample_Order_University'); 
            Id RecTypeStockWithdraw = RecordTypeMemory.getRecType('Opportunity', 'Sample_Order_Transit_Stock_Withdraw'); 
            Id idRecTypeRep = RecordTypeMemory.getRecType( 'Account', 'School');
            
            //Create a new Account
            Account accRep = SObjectInstance.getAccount(idRecTypeRep);
            accRep.Business_Line__c = 'IDIOMAS';
            accRep.BR_Account_Id_SAP__c = 'XPTOXPTO1'; //Não segue o padrão para não conflitar com dados reais.
            accRep.BR_Account_Id_SSA__c = 'XPTOXPTO2'; //Não segue o padrão para não conflitar com dados reais.
            Database.Saveresult resultAcc = Database.insert( accRep , true );
            System.assert(resultAcc.isSuccess());
            
            Opportunity opp1 = SObjectInstance.getOpportunity( acc.Id, RecTypeSampleOrder );
            opp1.BR_Request_Type__c = 'Amostra Livro';
            opp1.BR_Contact__c = ctt.Id;
            opp1.BR_rep__c = accRep.Id;
            opp1.Description = 'Teste';
            Database.insert( opp1 );
            
            OpportunityLineItem oppLI1 = SObjectInstance.getOpportunityLineItem( pbEntry.Id, opp1.Id, false );
            oppLI1.BR_Segmentation__c = 'Tertiary';
            oppLI1.Description = 'Teste';
            Database.insert( oppLI1 );
            
            Opportunity opp2 = SObjectInstance.getOpportunity( acc.Id, RecTypeSampleOrder );
            opp2.BR_Request_Type__c = 'Amostra Digital';
            opp2.BR_Contact__c = ctt.Id;
            opp2.BR_rep__c = accRep.Id;
            opp2.Description = 'Teste';
            Database.insert( opp2 );
            
            /*OpportunityLineItem oppLI2 = SObjectInstance.getOpportunityLineItem( pbEntryD.Id, opp2.Id, false );
oppLI2.BR_Segmentation__c = 'Tertiary';
Database.insert( oppLI2 ); */
            
            Opportunity opp3 = SObjectInstance.getOpportunity( acc.Id, RecTypeStockWithdraw );
            opp3.BR_Contact__c = ctt.Id;
            opp3.BR_rep__c = accRep.Id;
            opp3.Description = 'Teste';
            Database.insert( opp3 );
            
            OpportunityLineItem oppLI3 = SObjectInstance.getOpportunityLineItem( pbEntry.Id, opp3.Id, false );
            oppLI3.BR_Segmentation__c = 'Tertiary';
            oppLI3.Description = 'Teste';
            Database.insert( oppLI3 );
            //---
            
            Test.startTest();
            Apexpages.currentPage().getParameters().put('id', acc.Id);
            TeacherCardController controller = new TeacherCardController();
            
            Apexpages.currentPage().getParameters().put('id', ctt.Id);
            TeacherCardController controller2 = new TeacherCardController();
            Test.stopTest();
        }
    }
}