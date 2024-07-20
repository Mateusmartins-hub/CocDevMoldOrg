public with sharing class PesquisasSegmento {
public static void validateQuantidadeAluno(List<BR_Pesquisa__c> pesquisas) {

        for(BR_Pesquisa__c p : pesquisas) {

            if(String.isNotBlank(p.NumeroDeAlunosPorSegmento__c)) {
                String[] segmentos = p.NumeroDeAlunosPorSegmento__c.split(';');
                
               for(String segmento : segmentos) {
                    if(segmento.equals('EI')) {
                        if(p.QuantidadeAlunosEnsinoInfantil__c == null || p.QuantidadeAlunosEnsinoInfantil__c == 0 ) {
                            p.QuantidadeAlunosEnsinoInfantil__c.addError('Preencha o valor do campo \'Quantidade de Alunos Ensino Infantil\' ou remova o valor \'EI\' do campo Segmento ');
                            
                        }
                    }
                    if(segmento.equals('EF1')) {
                        if(p.QuantidadeAlunosEnsinoFundamental1__c == null || p.QuantidadeAlunosEnsinoFundamental1__c == 0) {
                            p.QuantidadeAlunosEnsinoFundamental1__c.addError('Preencha o valor do campo \'Quantidade de Alunos Ensino Fundamental I\' ou remova o valor \'EF1\' do campo Segmento ');
                        }
                    }
                    if(segmento.equals('EF2')) {
                        if(p.QuantidadeAlunosEnsinoFundamental2__c == null || p.QuantidadeAlunosEnsinoFundamental2__c == 0 ) {
                            p.QuantidadeAlunosEnsinoFundamental2__c.addError('Preencha o valor do campo \'Quantidade de Alunos Ensino Fundamental II\' ou remova o valor \'EF2\' do campo Segmento ');
                        }
                    }
                    if(segmento.equals('EM')) {
                        if(p.QuantidadeAlunosEnsinoMedio__c == null || p.QuantidadeAlunosEnsinoMedio__c == 0) {
                            p.QuantidadeAlunosEnsinoMedio__c.addError('Preencha o valor do campo \'Quantidade de Alunos Ensino Médio\' ou remova o valor \'EM\' do campo Segmento ');
                        }
                    }
                    if(segmento.equals('PV')) {
                        if(p.QuantidadeAlunosPreVestibular__c == null || p.QuantidadeAlunosPreVestibular__c == 0) {
                            p.QuantidadeAlunosPreVestibular__c.addError('Preencha o valor do campo \'Quantidade de Alunos Pré Vestibular\' ou remova o valor \'PV\' do campo Segmento ');
                        }
                    }
                }
                
            }

        }
    }
    
    public static void validateAccountAndOpp(List<Br_Pesquisa__c> pesquisas) {
        Map<Id, Br_Pesquisa__c> pesquisasWithOpp = new Map<Id, Br_Pesquisa__c>();
        for (Br_Pesquisa__c pesquisa : pesquisas) {
            if (pesquisa.Opportunity__c != null)
                pesquisasWithOpp.put(pesquisa.Opportunity__c, pesquisa);
        }
        
		List<Opportunity> opps = [SELECT Id, AccountId FROM Opportunity WHERE Id IN :pesquisasWithOpp.keySet()];

		for (Opportunity opp : opps) {
            Br_Pesquisa__c pesquisa = pesquisasWithOpp.get(opp.Id);
            
          /*Trecho de código comentado, autorizado por Bruno Bezerra, para atender as necessidades da INC6022087
           *   if (pesquisa.BR_Conta__c != opp.AccountId)                 
                pesquisa.addError('Conta e oportunidade precisam ser relacionados.'); */           
        }		        
    }

}