@isTest
private class OpportunityTest {

    static testMethod void myUnitTest() {
		User userToRun = [
			SELECT Id FROM User WHERE Profile.Name LIKE '%admin%' AND ManagerId != null AND isActive = true LIMIT 1
		];

		System.runAs(userToRun){
			Opportunity opp = new Opportunity(
						Name = 'Test Class Opp Name',
						StageName = 'Sem Interesse',
						CloseDate = System.Today()
			);
			opp.Description = 'Teste';
			insert opp;
			//Teste de trigger
			try {
				delete opp; 
			} catch (Exception e) {
				System.debug('');
			}
		}
    }
}