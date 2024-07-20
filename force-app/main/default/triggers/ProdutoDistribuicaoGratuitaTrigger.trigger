trigger ProdutoDistribuicaoGratuitaTrigger on BR_ProdutoDistribuicaoGratuita__c (after insert, after update, after delete, before insert, before update) {
	if(Trigger.isAfter) {
		DistribuicaoGratuitaBO.getInstance().processaDadosDistribuicaoGratuitaRelacionada(Trigger.new, Trigger.oldMap, Trigger.isDelete);
		if(Trigger.isUpdate){
			DistribuicaoGratuitaBO.getInstance().alterarFaseDG(Trigger.new,Trigger.oldMap);
		}
	}else{
		DistribuicaoGratuitaBO.getInstance().montaURLPesquisaAdocao(Trigger.new);
	}
}