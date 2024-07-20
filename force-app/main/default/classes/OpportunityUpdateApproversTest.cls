@isTest
/*******************************************************************************
*                     Copyright (C) 2012 - Cloud2b
*-------------------------------------------------------------------------------
* COVERAGE TEST FOR OpportunityUpdateApprovers.cls
* 
* NAME: OpportunityUpdateApproversTest.trigger
* AUTHOR: CARLOS CARVALHO                            DATE: 18/02/2013
*******************************************************************************/
private class OpportunityUpdateApproversTest {

    static testMethod void myUnitTest() {
        
        //Variables Declaration 
        Profile perfil;
        Id idRecTypeRep, idRecTypeProd, idRecTypeOpp, idRecTypeAseg;
        User user, manager, masterManager;
        Account acc;
        Opportunity opp;
        Account_Segmentation__c aseg;
        
        //Get RecordTypeId from Account and opoortunity
        idRecTypeRep = RecordTypeMemory.getRecType( 'Account', 'School');
        idRecTypeOpp = RecordTypeMemory.getRecType( 'Opportunity', 'Sample_Order_COC');
        idRecTypeProd = RecordTypeMemory.getRecType( 'Product2', 'Product_University');
        idRecTypeAseg = RecordTypeMemory.getRecType( 'Account_Segmentation__c', 'School_Segmentation');
        
        //Get id administrator profile
        perfil = SObjectInstance.getProfile( 'System Administrator', 'Administrador do sistema' );
      
        //Create a new user
        user = SObjectInstance.getUser( 'teste34@pearson.br', 'teste@1234.com.br', perfil.Id );
        
        //Create a new user
        manager = SObjectInstance.getUser( 'teste35@pearson.br', 'teste@1233.com.br', perfil.Id );
        
        //Create a new user
        masterManager = SObjectInstance.getUser( 'teste36@pearson.br', 'teste@1232.com.br', perfil.Id );
        
        //Start test 
        Test.startTest();
        
        //try to insert user
        Database.SaveResult[] resultsUser = Database.insert( new User[]{ user }, false );
        //Verify user sucess
        System.assert( resultsUser[0].isSuccess());
        
        //Create a new Account
        acc = SObjectInstance.getAccount(idRecTypeRep);
        
        //Reset the arrayList
        Database.SaveResult[] resultsAcc = Database.insert( new Account[]{ acc }, false );
        //Verify Account sucess
        System.assert( resultsAcc[0].isSuccess());
        
        //Crerate a new Account Segmentation
        aseg = SObjectInstance.getAccountSegmentation( acc.Id , idRecTypeAseg );
        aseg.Current_year__c = String.valueOf(System.today().year());
        
        //Reset the arrayList
        Database.SaveResult[] resultsAseg = Database.insert( new Account_Segmentation__c[]{ aseg }, false );
        //Verify Account_Segmentation__c sucess
        System.assert( resultsAseg[0].isSuccess());
        
        //Create a new opportunity
        opp = SObjectInstance.getOpportunity( acc.Id, idRecTypeOpp );
        opp.OwnerId = user.Id;
        opp.BR_Account_Segmentation__c = aseg.Id;
        
        //Reset the arrayList
        Database.SaveResult[] resultsOpp = Database.insert( new Opportunity[]{ opp }, false );
        //Verify Opportunity sucess
        System.assert( resultsAseg[0].isSuccess());
        
        //Stop test
        Test.stopTest();
    }
}