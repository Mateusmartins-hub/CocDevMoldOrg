/**
 * Created by re035946 on 09/02/2018.
 */
public class PlanoAcaoDAO {
    public List<FR_Plano_de_Acao__c> getListByConsultoriaId(String idConsultoria){
        return  [SELECT Id,
                RecordType.DeveloperName,
                Name,
                BR_Problema__c,
                BR_AssociadoProblema__c,
                BR_OQue__c,
                BR_Como__c,
                BR_Quem__c,
                BR_AteQuando__c,
                BR_Status__c,
                BR_TipoProblema__c,
                BR_Subtipo__c,
                BR_FUP__c
                FROM FR_Plano_de_Acao__c
                WHERE BR_FR_Plano_acao__c =:idConsultoria];
    }
}