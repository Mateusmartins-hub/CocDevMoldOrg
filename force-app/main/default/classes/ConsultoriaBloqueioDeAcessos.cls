public class ConsultoriaBloqueioDeAcessos implements Schedulable, Database.Batchable<sObject> {

    private String query;

    public ConsultoriaBloqueioDeAcessos(){
        this.query = 'SELECT Id, BR_Conta__c, BR_Conta__r.Name FROM FR_Procedimento_Franquias__c WHERE Fase__c = \'Bloqueio de Acessos\' AND Caso_para_bloqueio_de_acessos__c = NULL AND Bloqueios_realizados__c = FALSE AND CreatedDate = LAST_YEAR';
    }

    public ConsultoriaBloqueioDeAcessos(String query){
        this.query = query;
    }

    public Database.Querylocator start(Database.BatchableContext BC) {   
        return Database.getQueryLocator(this.query);
    }

    public void execute(Database.BatchableContext BC, List<FR_Procedimento_Franquias__c> scope){

        Map<Id, Case> consultoriaPorCaso = new Map<Id, Case>();

        for(FR_Procedimento_Franquias__c consultoria: scope){
            Case caso = new Case(
                Tipo__c = 'Comercial',
                Subtipo__c	 = 'Retenção',
                Detalhamento__c = 'K12',
                Subject = 'Realizar o bloqueio de acesso: ' + consultoria.BR_Conta__r.Name,
                AccountId = consultoria.BR_Conta__c
            );

            consultoriaPorCaso.put(consultoria.Id, caso);
        }

        insert consultoriaPorCaso.values();

        for(FR_Procedimento_Franquias__c consultoria: scope){
            consultoria.Caso_para_bloqueio_de_acessos__c = consultoriaPorCaso.get(consultoria.Id).Id;
        }

        update scope;
        
    }

    public void finish(Database.BatchableContext BC){}
    
    public void execute(SchedulableContext SC) {
        Database.executeBatch(new ConsultoriaBloqueioDeAcessos());
    }

}