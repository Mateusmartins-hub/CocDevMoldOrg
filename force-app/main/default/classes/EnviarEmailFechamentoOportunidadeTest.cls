@isTest
public class EnviarEmailFechamentoOportunidadeTest {
	@isTest
	static void testOne() {

		User userToRun = [
            SELECT Id FROM User WHERE Profile.Name LIKE '%admin%' AND ManagerId != null AND isActive = true LIMIT 1
        ];

		System.runAs(userToRun){
			Map<Id, User> usuarios = new Map<Id, User>([select Id, email from User where ManagerId != null and IsActive  = true]);
			
			User user = new User();
			user.Id = new list<Id>(usuarios.keySet())[0];
			user.email = 'email@email.com';
			update user;
            
			Opportunity opp = TestHelper.createOpportunity();
			opp.CloseDate = Date.today().addDays(1);
			opp.OwnerId = user.Id;
			insert opp;
			
            Test.StartTest();
			VerificaProximidadeFechamentoOpp.scheduleIt();
			OrgWideEmailAddress owa = [select id, Address, DisplayName from OrgWideEmailAddress][0];

			EnviarEmailFechamentoOportunidade e = new EnviarEmailFechamentoOportunidade(owa);
			e.enviarEmail(new List<Opportunity>{ opp }, usuarios);
            
            EnviarEmailFechamentoOportunidade obj = new EnviarEmailFechamentoOportunidade();
            DataBase.executeBatch(obj);
            
			Test.stopTest();
		}
	}
}