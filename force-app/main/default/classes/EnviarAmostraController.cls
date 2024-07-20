public class EnviarAmostraController {

    @AuraEnabled
    public static void salvar(String idObjeto) {
        Amostra_Virtual__c amostra = [SELECT Id FROM Amostra_Virtual__c WHERE Id =: idObjeto];
        amostra.Enviado__c = true;
        amostra.UltimaDataEnvio__c = System.now();
        update amostra;
    }
}