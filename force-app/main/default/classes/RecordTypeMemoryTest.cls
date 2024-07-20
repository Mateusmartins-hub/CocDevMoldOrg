@isTest
/*******************************************************************************
*                     Copyright (C) 2012 - Cloud2b 
*-------------------------------------------------------------------------------
* COVERAGE TEST FOR RecordTypeMemory.cls
* NAME: RecordTypeForTest.cls
* AUTHOR: CARLOS CARVALHO                            DATE: 01/02/2013
*
*******************************************************************************/
private class RecordTypeMemoryTest {

    static testMethod void myUnitTest() {
    	//Simulate, invoke method 
    	try{
            Id lId = RecordTypeMemory.getRecType( 'Account', '' );
    	}catch( Exception e ){
    		System.debug( e.getMessage() );
    	}
    }
}