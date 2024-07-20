@IsTest
public class ClienteSAPJobTest {

	@IsTest
	public static void testOne() {
		
		Test.startTest();
		ClienteSAPJob.execute(null);
		Test.stopTest();
	}
}