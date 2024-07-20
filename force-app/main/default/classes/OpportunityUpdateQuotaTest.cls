/*******************************************************************************
*                     Copyright (C) 2012 - Cloud2b
*-------------------------------------------------------------------------------
* COVERAGE TEST FOR OpportunityUpdateQuota.trigger
* 
* NAME: OpportunityUpdateQuotaTest.cls
* AUTHOR: CARLOS CARVALHO                            DATE: 05/02/2013
*******************************************************************************/
@isTest(seeAllData=true)
private class OpportunityUpdateQuotaTest {
  
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
        idRecTypeRep = RecordTypeMemory.getRecType( 'Account', 'Languages');
        idRecTypeOpp = RecordTypeMemory.getRecType( 'Opportunity', 'Sample_Order_Languages');
        idRecTypeProd = RecordTypeMemory.getRecType( 'Product2', 'Product_University');
        idRecTypeAseg = RecordTypeMemory.getRecType( 'Account_Segmentation__c', 'School_Segmentation');
        
        //Get id administrator profile
        perfil = SObjectInstance.getProfile( 'System Administrator', 'Administrador do sistema' );
      
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
        acc = SObjectInstance.getAccount(idRecTypeRep);
        acc.Business_Line__c = 'IDIOMAS';
        Database.Saveresult resultAcc = Database.insert( acc , false );
        System.debug(JSON.serialize(resultAcc.getErrors()));
        System.assert(resultAcc.isSuccess());
        
        //Crerate a new Account Segmentation
        aseg = SObjectInstance.getAccountSegmentation( acc.Id , idRecTypeAseg );
        aseg.Current_year__c = String.valueOf(System.today().year());
        Database.Saveresult resultAseg = Database.insert( aseg , true );
        System.assert(resultAseg.isSuccess());
        
        //Create a new opportunity
        opp = SObjectInstance.getOpportunity( acc.Id, idRecTypeOpp );
        opp.OwnerId = user.Id;
        opp.BR_Quota_update__c = true;
        opp.BR_rep__c = acc.Id;
        opp.BR_Account_Segmentation__c = aseg.Id;
        opp.Description = 'Teste';
        Database.Saveresult resultOpp = Database.insert( opp  , false );
        System.assert(resultOpp.isSuccess());
        
        opp.BR_Quota_update__c = true;
        Database.Upsertresult resultOpp2 = Database.upsert( opp  , false );
        System.assert(resultOpp2.isSuccess());
        
        //Create a new product
        prod = SObjectInstance.getProduct2( idRecTypeProd );
        prod.BR_segmento__c = 'EF2';
        Database.Saveresult resultProd = Database.insert( prod  , false );
        System.assert(resultProd.isSuccess());
        
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
        System.assert(resultPBE[0].isSuccess());
        System.assert(resultPBE[1].isSuccess());
        
        //Crerate a new OpportunityLineItem
        oli = SObjectInstance.getOpportunityLineItem( pbe2.Id, opp.Id, true );
        oli.BR_Segmentation__c = 'EF2';
        oli.BR_Serie__c = '7o ano';
        //Database.Saveresult resultOli = Database.insert( oli  , true );
        //System.assert(resultOli.isSuccess());
        oli.Quantity = 33;
        Database.Upsertresult resultOli2 = Database.upsert( oli  , false );
        //System.assert(resultOli2.isSuccess());
        
        //Cheange the recordtypeId of opportunity 
        idRecTypeOpp = RecordTypeMemory.getRecType('Opportunity', 'Sample_Order_Languages');
        opp.RecordTypeId = idRecTypeOpp;
        opp.BR_Quota_update__c = true;
        resultOpp2 = Database.upsert( opp  , false );
        System.assert(resultOpp2.isSuccess());
    }
}