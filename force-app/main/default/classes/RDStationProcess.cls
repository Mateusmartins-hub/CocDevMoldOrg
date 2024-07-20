public with sharing class RDStationProcess {
    
    public static void closeOpportunity(List<Opportunity> opportunities){

        Map<Id, Opportunity> oppWithAccounts = new Map<Id, Opportunity>([
            SELECT Id, Account.BR_Account_email__c
            FROM Opportunity
            WHERE Id IN :opportunities
        ]);

        for(Opportunity opp: opportunities){

            if(String.isBlank(opp.MarcaFranquias__c)){
                continue;
            }

            switch on opp.StageName {
                when 'Cancelada' {
                    if(String.isBlank(opp.BR_Motivo_Recusa__c)){
                        throw new RDStationApi.RDStationsApiException('Motivo da recusa não está preenchido!');
                    }

                    setOpportunityAsLost(oppWithAccounts.get(opp.Id).Account.BR_Account_email__c, opp.BR_Motivo_Recusa__c, opp.MarcaFranquias__c);
                    
                }
                when 'Contrato Fechado' {
                    setOpportunityAsWon(oppWithAccounts.get(opp.Id).Account.BR_Account_email__c, opp.MarcaFranquias__c);
                }
            }
        }
    }

    public static void leadNotQualified(Map<Id, Lead> oldLeads, Map<Id, Lead> newLeads){

        for(Id leadId: newLeads.keySet()){

            Lead lead = newLeads.get(leadId);

            if(String.isBlank(lead.Marca_RD_Station__c)){
                continue;
            }

            Boolean resultIsChanging = oldLeads.get(leadId).Resultado__c != lead.Resultado__c;

            if(resultIsChanging && lead.Resultado__c == 'Não Qualificado'){
                setOpportunityAsLost(lead.Email, lead.MotivoNaoQualificacao__c, lead.Marca_RD_Station__c);
            }
        }

    }

    @future(callout=true)
    private static void setOpportunityAsLost(String email, String motivoRecusa, String nomeConta){
        RDStationApi api = new RDStationApi(nomeConta);
        
        if(Test.isRunningTest()){
            return;
        }

        api.setOpportunityAsLost(email, motivoRecusa);
    }
	
    @future(callout=true)
    private static void setOpportunityAsWon(String email, String nomeConta){
        RDStationApi api = new RDStationApi(nomeConta);
        
        if(Test.isRunningTest()){
            return;
        }

        api.setOpportunityAsWon(email);
    }
    
}