@isTest
/*******************************************************************************
*                     Copyright (C) 2012 - Cloud2b
*-------------------------------------------------------------------------------
* COVERAGE TEST FOR UserDAO.cls
* 
* NAME: UserDAOTest.cls
* AUTHOR: CARLOS CARVALHO                            DATE: 01/02/2013
*******************************************************************************/
private class UserDAOTest { 

    @isTest static void myUnitTest() {
		Test.startTest();
		Profile p = [SELECT Id FROM Profile WHERE (Name = 'System Administrator') or  (Name = 'Administrador do Sistema' )];
		User u1 = new User(
				Alias = 'standt1',
				Email='standarduser1@pearson.br',
				EmailEncodingKey='UTF-8',
				LastName='Testing',
				LanguageLocaleKey='pt_BR',
				LocaleSidKey='pt_BR',
				ProfileId = p.Id,
				TimeZoneSidKey='America/Sao_Paulo',
				UserName='standarduser1@pearson.br'
			//UserRoleId = '00Ed0000000FURnEAO'
			// ManagerId ='005d0000001oExKAAU' // **** MUITO IMPORTANTE - APROVADOR
		);
		insert u1;
		//Initialize the list lListStr
    	List< String > lListStr = new List< String >();
    	//Invoke the getListUserByIdsUsers method
        List<User> lLsit = UserDAO.getListUserByIdsUsers( lListStr );
		User usuario = UserDAO.getProfileIdByUserId(u1.Id);
        User usuario2 = UserDAO.getUserByName(u1.Name);

		Test.stopTest();
	}
}