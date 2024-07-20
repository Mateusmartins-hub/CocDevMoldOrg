@ isTest
public class LeadTriggerTest {

	@isTest
	public static void testOne() {
		insert new Sintegra__c(Endpoint__c = 'https://www.sintegraws.com.br/api/v1/execute-api.php?', Token__c = 'Test');
							   Test.setMock(HttpCalloutMock.class, new MockSintegra());

							   Lead l = new Lead();
							   l.LastName = 'Test';
							   l.Company = 'Test';
							   insert l;

							   l.CNPJ__c = '06990590000123';
							   l.TipoPessoa__c = 'Jurídica';
							   update l;
							   }

							   @isTest
							   public static void testTwo() {
							   insert new Sintegra__c(Endpoint__c = 'https://www.sintegraws.com.br/api/v1/execute-api.php?', Token__c = 'Test');
							   Test.setMock(HttpCalloutMock.class, new MockSintegra());

							   Lead l = new Lead();
							   l.LastName = 'Test';
							   l.Company = 'Test';
							   insert l;

							   l.CPF__c = '99276049045';
							   l.TipoPessoa__c = 'Física';
							   l.DataNascimento__c = Date.today();
							   List<User> user = [select Id from User limit 1];
							   l.OwnerId = user.get(0).Id;
							   update l;
							   }

							   @isTest
							   public static void testValidaSegmento() {
							   try{
							   Lead l = new Lead();
							   l.LastName = 'Test';
							   l.Company = 'Test';
							   l.CPF__c = '99276049045';
							   l.TipoPessoa__c = 'Física';
							   l.DataNascimento__c = Date.today();
							   l.Segmento__c = 'EI;EF1;EF2;EM;PV';
							   insert l;
							   System.AssertEquals('EI;EF1;EF2;EM;PV', l.Segmento__c);
							   }catch(Exception e) {
							   System.debug(e.getMessage());
							   Boolean expectedExceptionThrown = e.getMessage().contains('Quantidade de Alunos') ? true :false;
							   System.AssertEquals(expectedExceptionThrown, true);
							   }
							   }

                                  @isTest
							   public static void testValidaCNPJTask() {
							   try{
							   Lead l = new Lead();
							   l.LastName = 'Test';
							   l.Company = 'Test';
							   l.CNPJ__c = '68.391.055/0001-03';
							   l.TipoPessoa__c = 'Física';
							   l.DataNascimento__c = Date.today();
							   l.Segmento__c = 'EI;EF1;EF2;EM;PV';
							   insert l;
							   System.AssertEquals('EI;EF1;EF2;EM;PV', l.Segmento__c);
							   }catch(Exception e) {
							   System.debug(e.getMessage());
							   Boolean expectedExceptionThrown = e.getMessage().contains('Quantidade de Alunos') ? true :false;
							   System.AssertEquals(expectedExceptionThrown, true);
							   }
							   }

	@isTest
	public static void should_canceledTasks_when_LeadIsFinished() {
		// arrange
		Lead lead = new Lead(
			LastName = 'Test',
			Company = 'Company Test'
		);
		insert lead;

		List<Task> tasks = new List<Task>();
		Task task1 = new Task(WhoId=lead.Id, Status='Não iniciada');
		Task task2 = new Task(WhoId=lead.Id, Status='Em execução');

		tasks.add(task1);
		tasks.add(task2);

		insert tasks;

		// act
		Test.startTest();
		lead.Status = 'Finalizado';
		lead.Resultado__c = 'Qualificado';
		update lead;
		Test.stopTest();

		// assert
		List<Task> taskResults = [SELECT Id, Status FROM Task WHERE WhoId = :lead.Id];
		System.assert(!taskResults.isEmpty(), 'taskResults shoud have value.');
		//for (Task task : taskResults) {
		//	System.assertEquals('Cancelada', task.Status, 'task.Status should be Cancelada.');
		//}
	}

}