@IsTest
public class DistribuicaoGratuitaStageUpdateTest {
    @TestSetup
    static void makeData(){

        User userToRun = [
    		SELECT Id FROM User WHERE Profile.Name LIKE '%admin%' AND ManagerId != null AND isActive = true LIMIT 1
		];

		System.runAs(userToRun){
            
            List<Opportunity> lstOpps = new List<Opportunity>();
            for (Integer i = 0; i < 3; i++){
                Opportunity opp = TestHelper.createOpportunity();
                lstOpps.add(opp);
            }

            insert lstOpps;
            
            List<BR_DistribuicaoGratuita__c> lstDistribuicoes = new List<BR_DistribuicaoGratuita__c>();
            for (Opportunity opp : lstOpps){
                BR_DistribuicaoGratuita__c distribuicao = new BR_DistribuicaoGratuita__c();
                distribuicao.BR_Oportunidade__c = opp.Id;
                lstDistribuicoes.add(distribuicao);
            }
            
            insert lstDistribuicoes;
        }
    }

    @IsTest
    static void updateAmostraStageTest() {
        List<BR_DistribuicaoGratuita__c> distribuicoes = [SELECT Id, BR_Oportunidade__c FROM BR_DistribuicaoGratuita__c];

        distribuicoes[0].BR_StatusProcessoAprovacao__c = 'APROVADO';
        distribuicoes[1].BR_StatusProcessoAprovacao__c = 'Aguardando aprovação';
        distribuicoes[2].BR_StatusProcessoAprovacao__c = 'Reprovado';

        update distribuicoes;


        List<Opportunity> lstOpps = [SELECT Id, StageName FROM Opportunity];
        Map<Id, Opportunity> mapOpps = new Map<Id, Opportunity>();

        for (Opportunity opp : lstOpps){
            mapOpps.put(opp.Id, opp);
        }

        for (BR_DistribuicaoGratuita__c distribuicao: distribuicoes) {
            Opportunity opp = mapOpps.get(distribuicao.BR_Oportunidade__c);
			/*
            switch on distribuicao.BR_StatusProcessoAprovacao__c {
                when 'APROVADO' {
                    System.assertEquals('Amostra Autorizada', opp.StageName);
                }
                when 'Aguardando aprovação' {
                    System.assertEquals('Envio de Amostra', opp.StageName);
                }
                when 'Reprovado' {
                    System.assertEquals('Amostra não autorizada', opp.StageName);
                }
                when else {
                    System.assert(false);
                }
            }
            */
        }
    }
}