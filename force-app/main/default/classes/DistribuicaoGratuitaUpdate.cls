public class DistribuicaoGratuitaUpdate {
    public static void updateDistribuicaoURL(List<BR_DistribuicaoGratuita__c> newDistribuicao) {
        Set<Id> lDisGratOpp = new Set<Id>();
		for (BR_DistribuicaoGratuita__c disGrat : newDistribuicao){
			lDisGratOpp.add(disGrat.BR_Oportunidade__c);
		}
		if(!lDisGratOpp.isEmpty()){
            Id tipoRegistro = RecordTypeMemory.getRecType('Opportunity', 'Sample_Order_University');

	        Map<String, Opportunity> mapOpp = new Map<String, Opportunity>();

			for (Opportunity opp : OpportunityDAO.BuscarOportunidades(lDisGratOpp)){
				  mapOpp.put(opp.Id, opp);
			}

			for (BR_DistribuicaoGratuita__c disGrat : newDistribuicao){
				Opportunity mOpp;
				mOpp = mapOpp.get(disGrat.BR_Oportunidade__c);
				if(mOpp != null){
					if(mOpp.RecordTypeId == tipoRegistro){
						disGrat.BR_URL__c = 'http://pearsonlatam-br.force.com/ConfirmaAdocao?RespEmail=' + disGrat.BR_Oportunidade__c + '&disGrat=' + disGrat.Id;
					}
				}
			}
		}
    }
}