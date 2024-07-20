/*******************************************************************************
*                     Copyright (C) 2012 - Cloud2b
*-------------------------------------------------------------------------------
* COVERAGE TEST FOR SObjectInstance.cls
* 
* NAME: SObjectInstanceTest.cls
* AUTHOR: CARLOS CARVALHO                            DATE: 05/02/2013
*******************************************************************************/
@isTest(seeAllData=true)
private class SObjectInstanceTest {
 
    static testMethod void myUnitTest() {
    	//Invoke setTestClass method
        SObjectInstance.setTestClass();
    }
}