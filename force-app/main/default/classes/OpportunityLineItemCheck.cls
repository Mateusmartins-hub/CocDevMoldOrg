public class OpportunityLineItemCheck {
    public static void checkForAmostraAutorizada(List<OpportunityLineItem> lstItems) {
        Id oppRecordType = OpportunityStagesCheck.RECORD_TYPE_OPORTUNIDADE_SETOR_PRIVADO;
		Set<Id> setOppIds = new Set<Id>();

		for (OpportunityLineItem item : lstitems)
			setOppIds.add(item.OpportunityId);

        List<Opportunity> lstOpps =  OpportunityDAO.BuscarOportunidades(setOppIds);
        Set<Id> filteredOpps = new Set<Id>();

        for (Opportunity opp : lstOpps) {
            if (opp.RecordTypeId == oppRecordType && opp.Probability <= 5)
                filteredOpps.add(opp.Id);
        }

        for (OpportunityLineItem item : lstItems) {
            if (filteredOpps.contains(item.OpportunityId)){
                item.addError('Não é possível adicionar itens na oportunidade antes da visita inicial');
            }
        }

    }
}