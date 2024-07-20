public without sharing class LeadConverted {
    
    public static void shareFormToOpp(List<Lead> newLeads) {
         Map<Id, Lead> filteredLeads = new Map<Id, Lead>();
        
        for (Lead ld : newLeads) {
            if (ld.IsConverted) 
                filteredLeads.put(ld.Id, ld);                    
        }            
        
        List<Formulario__c> forms = FormularioParaExemplaresDAO.getFormsRelatedToLeads(filteredLeads.keySet());
        List<Formulario__c> formsToUpdate = new List<Formulario__c>();
        
        for (Formulario__c fm : forms){
            Id leadId = fm.Lead__c;
            if (filteredLeads.containsKey(leadId)) {
                if (filteredLeads.get(leadId).ConvertedOpportunityId != null)
                    fm.Oportunidade__c = filteredLeads.get(leadId).ConvertedOpportunityId;

                if (filteredLeads.get(leadId).ConvertedAccountId != null)
                    fm.Conta__c = filteredLeads.get(leadId).ConvertedAccountId;

                fm.Lead__c = null; 
                
                formsToUpdate.add(fm);
            }
        }

        update formsToUpdate;
    }

    public static void validate(List<Lead> newLeads, Map<Id, Lead> oldMap) {
        Set<Id> idsContas = new Set<Id>();
        
        for (Lead ld : newLeads) {
            if(!String.isEmpty(ld.ConvertedAccountId))
                idsContas.add(ld.ConvertedAccountId);
        }
        
        Map<Id, Account> mapAcc = new Map<Id, Account>([SELECT Id FROM Account WHERE Id IN: idsContas]);
        List<Account> accsUpdate = new List<Account>();
        
        for (Lead ld : newLeads) {
            if (ld.IsConverted && !oldMap.get(ld.Id).IsConverted) {
                if (!string.isBlank(ld.ConvertedAccountId)) {
                    Account acc = mapAcc.get(ld.ConvertedAccountId);
                    acc.BR_Status__c = 'PROSPECT';
                    
                    accsUpdate.add(acc);
                }
            }
        }
        
        if(!accsUpdate.isEmpty())
            update accsUpdate;
    }
}