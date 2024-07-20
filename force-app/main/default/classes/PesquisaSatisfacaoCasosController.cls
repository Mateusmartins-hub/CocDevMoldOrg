public without sharing class PesquisaSatisfacaoCasosController {
    @RemoteAction
    public static Boolean insertAval(Avalia_o__c aval){
        Boolean retorno = false;
        Avalia_o__c origem = [SELECT Id, Name, Flag__c, Resolvido__c, Aval_Atendimento__c, Caso__c FROM Avalia_o__c WHERE Caso__r.id = :aval.caso__c ORDER BY Name DESC LIMIT 1];
        if(origem.Flag__c){
            origem.Resolvido__c = aval.resolvido__c;
            origem.Aval_atendimento__c = aval.aval_atendimento__c;
            origem.Flag__c = false;
            origem.Sugestao__c = aval.sugestao__c;
            update origem;
            retorno = true;
        }
        return retorno;
    }
}