/*******************************************************************************
*                     Copyright (C) 2012 - Cloud2b
*-------------------------------------------------------------------------------
* RESPONSIBLE TO PERFORM DML FUNCTION ON USER OBJECT..
*
* NAME: UserDAO.cls
* AUTHOR: CARLOS CARVALHO                            DATE: 01/02/2013
*******************************************************************************/
public class UserDAO {

	//Get User by list user Ids
	//@listIds (Lsit Id User)
	public static List< User > getListUserByIdsUsers( List< String > listIds ){

		List< User > lList = [ SELECT Id,
				BR_Account_ID_SAP__c,
				BR_Account_ID_SSA__c,
				ManagerId,
				Manager.ManagerId,
				CentroCusto_SAP__c,
				Email,
				FirstName,
				LastName
				FROM User
				Where Id =: listIds
		];

		return lList;
	}

	public static User getProfileIdByUserId(String userId){
		return [ SELECT Id,
				ProfileId
				FROM User
				Where Id =: userId limit 1];
	}

	public static User getUserByName(String nome){
		List<User> lstUser = new List<User>();

		lstuser = [SELECT Id,
				Name
				FROM User
				Where Name =: nome];

		if(lstUser.size() > 0){
			return lstUser.get(0);
		} else {
			return null;
		}
	}
}