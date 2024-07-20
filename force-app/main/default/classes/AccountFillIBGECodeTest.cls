/*******************************************************************************
*                     Copyright (C) 2013 - Cloud2b
*-------------------------------------------------------------------------------
*
* Test class for tests and coverage of the trigger AccountFillIBGECode.
*
* NAME: AccountFillIBGECodeTest.cls
* AUTHOR: MARCOS DOBROWOLSKI                        DATE: 2013/07/16
*
*******************************************************************************/

@isTest
private class AccountFillIBGECodeTest {

  static testMethod void myUnitTest() {

    // Retrieves a RecordTypeId
    Id recTypeAcc = RecordTypeMemory.getRecType( 'Account', 'School' );

    // Creates an IBGE Code
    IBGE_Code__c ibgeCode = SObjectInstance.getIBGECode();
    Database.insert( ibgeCode );
        
    // Creates an Account
    Account acc = SObjectInstance.getAccount( recTypeAcc );
      acc.BR_Main_City__c = 'São Paulo';
      acc.BR_Main_State__c = 'SP';
      
    Test.startTest();  
      Database.insert( acc );
    Test.stopTest();
  }
}