@isTest(seeAllData=true)
private class OpportunityUpdateStockTest {

    static testMethod void myUnitTest() {
        //Variables Declaration 
        Profile perfil;
        Id idRecTypeRep, idRecTypeProd, idRecTypeOpp, idRecTypeAseg;
        User user, manager, masterManager;
        Account acc;
        Opportunity opp;
        OpportunityLineItem oli;
        Product2 prod;
        Pricebook2 standardPB, customPB;
        PricebookEntry pbe, pbe2;
        Account_Segmentation__c aseg;
        
        //Get RecordTypeId from Account and opoortunity                
        idRecTypeRep	= Schema.SObjectType.Account.getRecordTypeInfosByDeveloperName().get('Sales_Representative').getRecordTypeId(); //RecordTypeMemory.getRecType( 'Account', 'Sales_Representative');
        idRecTypeOpp	= Schema.SObjectType.Opportunity.getRecordTypeInfosByDeveloperName().get('Sample_Order_COC').getRecordTypeId(); //RecordTypeMemory.getRecType( 'Opportunity', 'Sample_Order_COC');
        idRecTypeProd	= Schema.SObjectType.Product2.getRecordTypeInfosByDeveloperName().get('Product_University').getRecordTypeId(); //RecordTypeMemory.getRecType( 'Product2', 'Product_University');
        idRecTypeAseg	= Schema.SObjectType.Account_Segmentation__c.getRecordTypeInfosByDeveloperName().get('School_Segmentation').getRecordTypeId(); //RecordTypeMemory.getRecType( 'Account_Segmentation__c', 'School_Segmentation');
                
        //Get id administrator profile
        perfil = SObjectInstance.getProfile( 'System Administrator', 'Administrador do sistema' );
      
        //Create a new user with Manager
        user = SObjectInstance.getUser( 'teste34@pearson.br', 'teste@1234.com.br', perfil.Id );
        manager = SObjectInstance.getUser( 'teste35@pearson.br', 'teste@12345.com.br', perfil.Id );
        manager.CommunityNickname = 'teste35';
        Database.Saveresult resultUser = Database.insert( manager , false );
        //System.assert(resultUser.isSuccess());
        
        masterManager = SObjectInstance.getUser( 'teste36@pearson.br', 'teste@12346.com.br', perfil.Id );
        masterManager.CommunityNickname = 'teste36';
        user.ManagerId = manager.Id;
        user.BR_Account_ID_SAP__c = '1555';
        user.BR_Account_ID_SSA__c = '1555';
        Database.Saveresult[] resultsUser = Database.insert( new User[]{ masterManager, user }, false );
        //System.assert(resultsUser[0].isSuccess());
        //System.assert(resultsUser[1].isSuccess());
        
        manager.ManagerId = masterManager.Id;
        Database.Upsertresult resultMM = Database.upsert( manager , false );
        //System.assert(resultMM.isSuccess());
        
        //Create a new Account
        acc = TesteSetup.getInstance().criarConta(); //SObjectInstance.getAccount(idRecTypeRep);
        acc.Business_Line__c = 'IDIOMAS';
        acc.BR_Account_Id_SAP__c = '1555';
        acc.BR_Account_Id_SSA__c = '1555';
        Database.Saveresult resultAcc = Database.insert( acc , false );
        //System.assert(resultAcc.isSuccess());
        
        //Crerate a new Account Segmentation
        aseg = SObjectInstance.getAccountSegmentation( acc.Id , idRecTypeAseg );
        aseg.Current_year__c = String.valueOf(System.today().year());
        Database.Saveresult resultAseg = Database.insert( aseg , false );
        //System.assert(resultAseg.isSuccess());
        
        //Create a new opportunity
        opp = SObjectInstance.getOpportunity( acc.Id, idRecTypeOpp );
        opp.BR_rep__c = acc.Id;
        opp.OwnerId = user.Id;
        opp.BR_Quota_update__c = true;
        opp.BR_Account_Segmentation__c = aseg.Id;
        opp.Description = 'Teste';
        Database.Saveresult resultOpp = Database.insert( opp  , false );
        //System.assert(resultOpp.isSuccess());
        
        opp.BR_Quota_update__c = true;
        Database.Upsertresult resultOpp2 = Database.upsert( opp  , false );
        //System.assert(resultOpp2.isSuccess());
        
        //Create a new product
        prod = SObjectInstance.getProduct2( idRecTypeProd );
        prod.BR_segmento__c = 'EF2';
        Database.Saveresult resultProd = Database.insert( prod  , false );
        //System.assert(resultProd.isSuccess());
        
        //Get the Standard Pricebook
        standardPB = SObjectInstance.getPricebook2( true );
        
        //Create a new pricebook
        customPB = SObjectInstance.getCustomPricebook2();
        Database.Saveresult resultPB = Database.insert( customPB  , false );
        //System.assert(resultPB.isSuccess());
        
        //create a new Pricebookentry for Standard Pricebook
        pbe = SObjectInstance.getPricebookEntry( standardPB.Id, prod.Id );
        
        //Create a new PricebookEntry for Custom Pricebook
        pbe2 = SObjectInstance.getPricebookEntry( customPB.Id, prod.Id );
        Database.Saveresult[] resultPBE = Database.insert( new PricebookEntry[]{ pbe, pbe2 }  , false );
        /*System.assert(resultPBE[0].isSuccess());
        System.assert(resultPBE[1].isSuccess());*/
        
        //Crerate a new OpportunityLineItem
        oli = SObjectInstance.getOpportunityLineItem( pbe2.Id, opp.Id, true );
        oli.BR_Segmentation__c = 'EF2';
        oli.BR_Serie__c = '7o ano';
        Database.Saveresult resultOli = Database.insert( oli  , false );
        //System.assert(resultOli.isSuccess());
        Database.Upsertresult resultOli2 = Database.upsert( oli  , false );
        //System.assert(resultOli2.isSuccess());
        
        //Update opportunity 
        opp.BR_Stock_Update__c = true;
        resultOpp2 = Database.upsert( opp  , false );
        //System.assert(resultOpp2.isSuccess());
    }
}