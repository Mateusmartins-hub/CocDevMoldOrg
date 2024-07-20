@isTest
/*******************************************************************************
*                     Copyright (C) 2012 - Cloud2b
*-------------------------------------------------------------------------------
* COVERAGE TEST FOR OpportunityUpdateContact.trigger
* 
* NAME: OpportunityUpdateContactTest.cls
* AUTHOR: CARLOS CARVALHO                            DATE: 08/02/2013
*******************************************************************************/
private class OpportunityUpdateContactTest {

    static testMethod void myUnitTest() {
        Test.startTest();
        //Variables Declaration 
        Profile perfil;
        Id idRecTypeRep, idRecTypeOpp,idRecTypeAseg;
        User user, manager, masterManager;
        Account acc;
        Opportunity opp;
        Account_Segmentation__c aseg;
        Account_Contact__c acon;
        Contact con;
        
        //Get RecordTypeId from Account and opoortunity
        idRecTypeRep = Schema.SObjectType.Account.getRecordTypeInfosByDeveloperName().get('Sales_Representative').getRecordTypeId(); 
        //RecordTypeMemory.getRecType( 'Account', 'Sales_Representative');        
        idRecTypeOpp = Schema.SObjectType.Opportunity.getRecordTypeInfosByDeveloperName().get('Sample_Order_COC').getRecordTypeId(); 
        //RecordTypeMemory.getRecType( 'Opportunity', 'Sample_Order_COC');
        idRecTypeAseg = Schema.SObjectType.Account_Segmentation__c.getRecordTypeInfosByDeveloperName().get('School_Segmentation').getRecordTypeId(); 
        //RecordTypeMemory.getRecType( 'Account_Segmentation__c', 'School_Segmentation');
                
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
        acc = TesteSetup.getInstance().criarConta(); //SObjectInstance.getAccount(idRecTypeRep);
        //insert acc;
        Database.Saveresult resultAcc = Database.insert( acc , false );
        System.assert(resultAcc.isSuccess());
        
        //Crerate a new Contact
        con = SObjectInstance.getContact( acc.Id );
        Database.Saveresult resultCon = Database.insert( con , false );
        System.assert(resultCon.isSuccess());
        
        //Crerate a new Account Segmentation
        aseg = SObjectInstance.getAccountSegmentation( acc.Id , idRecTypeAseg );
        aseg.Current_year__c = String.valueOf(System.today().year());
        Database.Saveresult resultAseg = Database.insert( aseg , false );
        System.assert(resultAseg.isSuccess());
        
        //Create a new Account Contact
        acon = SObjectInstance.getAccountContact( con.Id, acc.Id );
        acon.Email__c = 'teste@teste.com';
        acon.CPF__c = '50373666403';
        Database.Saveresult resultAcon = Database.insert( acon , false );
        System.assert(resultAcon.isSuccess());
        
        //Create a new opportunity
        opp = SObjectInstance.getOpportunity( acc.Id, idRecTypeOpp );
        opp.OwnerId = user.Id;
        opp.BR_Account_Segmentation__c = aseg.Id;
        opp.BR_Account_Contact__c = acon.Id;
        opp.Description = 'Teste';
        Database.Saveresult resultOpp = Database.insert( opp  , false );
        System.assert(resultOpp.isSuccess());
        Test.stopTest();
    }
}