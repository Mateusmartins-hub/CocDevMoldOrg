@isTest(seeAllData=true)
/*******************************************************************************
*                     Copyright (C) 2012 - Cloud2b
*-------------------------------------------------------------------------------
* COVERAGE TEST FOR OpportunityVerifyQuotaFillRepresentant.trigger
* 
* NAME: OpportunityVerifyQuotaFillRepTest.cls
* AUTHOR: CARLOS CARVALHO                            DATE: 04/02/2013
*******************************************************************************/
private class OpportunityVerifyQuotaFillRepTest {

    static testMethod void myUnitTest() {
        
        //Variables Declaration 
        Profile perfil;
        Id idRecTypeRep, idRecTypeOpp, idRecTypeAseg;
        User user,manager,masterManager;
        Account acc;
        Opportunity opp;
        Account_Segmentation__c aseg;
        
        //Get RecordTypeId from Account and opoortunity
        idRecTypeRep = RecordTypeMemory.getRecType( 'Account', 'Languages');
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
        acc = new Account();
        acc.Name = 'teste';
        acc.BR_Title__c = 'Autor';
        acc.BR_Main_Sidewalk__c = 'Aeroporto';
        acc.RecordTypeId = idRecTypeRep;
        acc.BR_Account_Id_SAP__c = '1';
        acc.BR_Account_Id_SSA__c = '2';
        acc.BR_Main_City__c = 'São Paulo';
        acc.BR_Main_State__c = 'SP';
        Database.Saveresult resultAcc = Database.insert( acc , false );
        System.assert(resultAcc.isSuccess());
        
        //Crerate a new Account Segmentation
        aseg = SObjectInstance.getAccountSegmentation( acc.Id , idRecTypeAseg );
        aseg.Current_year__c = String.valueOf(System.today().year());
        Database.Saveresult resultAseg = Database.insert( aseg , false );
        System.assert(resultAseg.isSuccess());
        
        //Create a new opportunity
        opp = new Opportunity();
        opp.AccountId = acc.Id;
        opp.OwnerId = user.Id;
        opp.RecordTypeId = idRecTypeOpp;
        opp.BR_shipping_type__c = 'Correio';
        opp.BR_Shipping_Address__c = 'Residencial';
        opp.Name = 'Teste';
        opp.StageName = 'Elaboração';
        opp.CloseDate = System.today()+5;
        opp.BR_Account_Segmentation__c = aseg.Id;
        opp.Description = 'Teste';
        Database.Saveresult resultOpp = Database.insert( opp  , true );
        System.assert(resultOpp.isSuccess());
        
        //Update opportunity
        Database.Upsertresult resultOpp2 = Database.upsert( opp  , false );
        System.assert(resultOpp2.isSuccess());
        

    }
}