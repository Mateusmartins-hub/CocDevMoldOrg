@isTest
public class EnviarEmailConsultoriaTest {

    @isTest
    public static void Executar()
    {
        FR_Procedimento_Franquias__c consult = TestHelper.CreateConsulting();
        insert consult;

        EnviarEmailConsultoriaController.EnviarEmail(consult.Id);
    }
}