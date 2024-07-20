/*******************************************************************************
*                     Copyright (C) 2012 - Cloud2b
*-------------------------------------------------------------------------------
* COVERAGE TEST FOR AccountSegmentationDAO.cls
* 
* NAME: AccountSegmentationDAOTest.cls
* AUTHOR: CARLOS CARVALHO                            DATE: 07/02/2013
*******************************************************************************/
@isTest
private class AccountSegmentationDAOTest {

    static testMethod void myUnitTest() {
        
        //Initialize a String list
        List< String > lListStr = new List< String >();
        //Invoke getAccSegById method
        List< Account_Segmentation__c > listAccSeg = AccountSegmentationDAO.getAccSegById( lListStr );

    }
}