public without sharing class EmailsOuvidoriaDAO {
    public static Map<String, DeParaEmailToCase__mdt> mapearDeParaEmailCamposCaso() {
        Map<String, DeParaEmailToCase__mdt> mapRetorno = new Map<String, DeParaEmailToCase__mdt>();
        
        for(DeParaEmailToCase__mdt email : [SELECT MasterLabel, GrupoSolucionadorEmail__c, LinhaNegocio__c, Ouvidoria__c, Marca__c FROM DeParaEmailToCase__mdt]) {
            mapRetorno.put(email.MasterLabel, email);
        }
        
        return mapRetorno;
    }
}