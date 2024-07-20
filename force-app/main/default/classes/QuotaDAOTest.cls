@isTest
/*******************************************************************************
*                     Copyright (C) 2012 - Cloud2b
*-------------------------------------------------------------------------------
* COVERAGE TEST FOR QuotaDAO.cls
* 
* NAME: QuotaDAOTest.cls
* AUTHOR: CARLOS CARVALHO                            DATE: 05/02/2013
*******************************************************************************/
private class QuotaDAOTest {

    static testMethod void myUnitTest() {
        //Initialize a String list
        List< String > lListStr = new List< String >();
        //Initialize a string variable
        String lStr = null;
        //Invoke getListQuotaByIdProductCurrentYear method
        QuotaDAO.getListQuotaByIdProductCurrentYear(lListStr, lStr);
        //Invoke getListQuotaByIdQuota method
        QuotaDAO.getListQuotaByIdQuota(lListStr);
        //Invoke getListQuotaByIdRepCurrentYear method
        QuotaDAO.getListQuotaByIdRepCurrentYear(lListStr, lStr);
    }
}