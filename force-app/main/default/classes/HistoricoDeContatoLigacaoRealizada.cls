public with sharing class HistoricoDeContatoLigacaoRealizada {

    public static void popularLigacaoRealizada(List<HistoricoDeContato__c> historicos) {

        List<Lead> leadsUpdate = new List<Lead>();
        
        for (HistoricoDeContato__c h : historicos){
            Lead l = [select Id,LigacaoRealizada__c from Lead where Id = :h.Lead__c];
            
            l.LigacaoRealizada__c = true;
            leadsUpdate.add(l);
        }

        update leadsUpdate;
        
    }

}