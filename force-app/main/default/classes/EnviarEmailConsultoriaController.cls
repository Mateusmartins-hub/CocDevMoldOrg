public class EnviarEmailConsultoriaController {

    @AuraEnabled
    public static String EnviarEmail(Id idConsultoria)
    {
        return BotaoJavaScript.enviarEmail(idConsultoria);
    }
}