public class DistribuicaoGratuitaStageUpdate {
    public static void updateAmostraStage(List<BR_DistribuicaoGratuita__c> newDistribuicao, List<BR_DistribuicaoGratuita__c> oldDistribuicao) {
        Id idAmostraFisica = RecordTypeUtil.getInstance().getRecordTypePorNome('BR_DistribuicaoGratuita__c', 'Amostra Física').getRecordTypeId();

		List<Opportunity> opps = new List<Opportunity>();
		List<String> idOpps = null;
		List<Opportunity> oppsDistGrat = new List<Opportunity>();
		Integer c = 0;
		BR_DistribuicaoGratuita__c disGratOld = null;
		for (BR_DistribuicaoGratuita__c disGrat : newDistribuicao){
			disGratOld = oldDistribuicao.get(c);
			c++;
			idOpps = new List<String>();
			idOpps.add(disGrat.BR_Oportunidade__c);
			oppsDistGrat = OpportunityDAO.getListOppById(idOpps);
			if(disGratOld.BR_StatusProcessoAprovacao__c != 'APROVADO' && disGrat.BR_StatusProcessoAprovacao__c == 'APROVADO'){
				for(Opportunity op : oppsDistGrat){
					if(op.RecordType.DeveloperName == 'Oportunidade_de_Negocio_Pearson_English_EDU' || op.RecordType.DeveloperName == 'Sample_Order_University'){
						if(disGrat.RecordTypeId == idAmostraFisica){
							op.BR_DataRecebimentoNotificacao__c = disGrat.BR_DataAprovacao__c;
						}
						op.StageName = 'Amostra Autorizada';
						opps.add(op);
					}
				}
			}
			else if(disGratOld.BR_StatusProcessoAprovacao__c != 'Aguardando aprovação' && disGrat.BR_StatusProcessoAprovacao__c == 'Aguardando aprovação'){
				for(Opportunity op : oppsDistGrat){
					if(op.RecordType.DeveloperName == 'Oportunidade_de_Negocio_Pearson_English_EDU' || op.RecordType.DeveloperName == 'Sample_Order_University'){
						op.StageName = 'Envio de Amostra';
						opps.add(op);
					}
				}
			}
			else if(disGratOld.BR_StatusProcessoAprovacao__c != 'Reprovado' && disGrat.BR_StatusProcessoAprovacao__c == 'Reprovado'){
				for(Opportunity op : oppsDistGrat){
					if(op.RecordType.DeveloperName == 'Oportunidade_de_Negocio_Pearson_English_EDU' || op.RecordType.DeveloperName == 'Sample_Order_University'){
						op.StageName = 'Amostra não autorizada';
						opps.add(op);
					}
				}
			}
		}

        Update opps;
    }
}