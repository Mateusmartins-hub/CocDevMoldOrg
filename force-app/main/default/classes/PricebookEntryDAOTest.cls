@isTest
/*******************************************************************************
*                     Copyright (C) 2012 - Cloud2b
*-------------------------------------------------------------------------------
* COVERAGE TEST FOR PricebookEntryDAO.cls
* 
* NAME: PricebookEntryDAOTest.cls
* AUTHOR: CARLOS CARVALHO                            DATE: 05/02/2013
*******************************************************************************/
private class PricebookEntryDAOTest {

    static testMethod void myUnitTest() {
    	//Initialize a new String list
    	List< String > lListStr = new List< String >();
    	//Invoke getListPricebookEntryById method
        List< PricebookEntry > lList = PricebookEntryDAO.getListPricebookEntryById( lListStr );
        PricebookEntry ent = TestHelper.createPricebookEntry();
        insert ent;
        System.debug('AQUI ' +ent.Id);
        List< PricebookEntry > lListByPricebookId = PricebookEntryDAO.getListPricebookEntryByPricebookId( ent.Id, 'descricao teste', '1' );
    }
}