/**********************************************************************************
*                         Copyright 2012 - Cloud2b
***********************************************************************************
* Responsável pelo teste de cobertura do seguinte código: ContactUpdateAccountData.
* NAME: ContactUpdateAccountDataTest.cls
* AUTHOR: CARLOS CARVALHO                            DATE: 12/12/2012
*
***********************************************************************************/
@IsTest
public class ContactUpdateAccountDataTest {

    static testMethod void myUnitTest() {
		
		try{
			//valiable declaration
			RecordType recType = [SELECT Id FROM RecordType WHERE SobjectType = 'Account' AND DeveloperName = 'Academic_Account'];
			
			Account lAcc = new Account();
			lAcc.Recordtypeid = recType.Id;
			lAcc.Name = 'teste teste';
			lAcc.BR_CPF__c = '843.129.367-57';
			insert lAcc;

			Semaphore.fAlreadyExecution = new Set< String >();
			ContactBO.shouldUpdateRelated = false;
			
			Contact lCon = new Contact();
			lCon.AccountId = lAcc.id;
			lCon.LastName = 'LastName';
			lCon.FirstName = 'FirstName';
			lCon.BR_CPF__c = '843.129.367-57';
			insert lCon;
		}
		catch(Exception e){}
        
    }
}