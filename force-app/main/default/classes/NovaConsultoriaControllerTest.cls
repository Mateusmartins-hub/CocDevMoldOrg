@isTest
public class NovaConsultoriaControllerTest {

    static testMethod void testOne() {
        Account acc = TestHelper.createAccount();
        NovaConsultoriaController.fetchUser();
        NovaConsultoriaController.criarConsultoria(acc.Id);
        NovaConsultoriaController.getRecordTypes(new List<String> {'EDU Pearson English Pedagógico'});
    }
}