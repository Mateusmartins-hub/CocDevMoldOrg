public with sharing class EventCheck {
    public static final Id RECORD_TYPE_VISITA_PEDAGOGICA = Schema.SObjectType.Event.getRecordTypeInfosByDeveloperName().get('Visita_Pedagogica').getRecordTypeId();
    
    public static void checkOpportunityBeforeDelete(List<Event> lstEvents) {
        List<Id> oppIds = new  List<Id>();
        for (Event evt : lstEvents){
            if (evt.RecordTypeId == RECORD_TYPE_VISITA_PEDAGOGICA)
                oppIds.add(evt.WhatId);
        } 

        List<Opportunity> relatedOpportunities = OpportunityDAO.getOpportunitiesByEventIdAndRecordType(oppIds, OpportunityStagesCheck.RECORD_TYPE_OPORTUNIDADE_SETOR_PRIVADO);

        Set<Id> relatedIds = new Set<Id>();
        for (Opportunity opp : relatedOpportunities)
            relatedIds.add(opp.Id);
        
        for (Event evt : lstEvents){
            if (relatedIds.contains(evt.WhatId))
                evt.addError('Não é possível apagar o compromisso pois o mesmo já está relacionado a uma oportunidade');
        }
    }
}