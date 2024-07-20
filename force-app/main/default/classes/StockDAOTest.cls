@isTest
/*******************************************************************************
*                     Copyright (C) 2012 - Cloud2b
*-------------------------------------------------------------------------------
* COVERAGE TEST FOR StockDAO.cls
* 
* NAME: StockDAOTest.cls
* AUTHOR: CARLOS CARVALHO                            DATE: 15/02/2013
*******************************************************************************/
private class StockDAOTest {

    static testMethod void myUnitTest() {
        //Initialize a String list
        List< String > lListStr = new List< String >();
        //Invoke getListStockBy method
        List< Stock__c > listStock = StockDAO.getListStockBy(lListStr, lListStr);
    }
}