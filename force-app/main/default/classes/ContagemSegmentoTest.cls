@isTest
private class ContagemSegmentoTest {
    @TestSetup
    static void criarDados(){
        
        User userToRun = [
    		SELECT Id FROM User WHERE Profile.Name LIKE '%admin%' AND ManagerId != null AND isActive = true LIMIT 1
		];

        System.runAs(userToRun){
            List<Opportunity> opps = new List<Opportunity>();
            for(Integer i = 0; i < 9; i++){
                Opportunity opp = new Opportunity(
                    Name      = 'Teste ' + i,
                    CloseDate = Date.today().addDays(30),
                    StageName = 'Coletando informações'
                );

                opps.add(opp);
            }

            insert opps;
        

            List<Contagem_de_alunos_por_segmento__c> segmentos = new List<Contagem_de_alunos_por_segmento__c>();
            for(Opportunity opp : opps){
                Contagem_de_alunos_por_segmento__c segmento = new Contagem_de_alunos_por_segmento__c(
                    Oportunidade__c = opp.Id,
                    Segmento__c     = 'Ensino Fundamental 1'
                );

                segmentos.add(segmento);
            }

            insert segmentos;
        }
    }
    
    @isTest
    private static void validarSegmentoTest(){
        List<Opportunity> opps = [SELECT Id FROM Opportunity];
        System.assertEquals(9, opps.size(), 'Verifica se as oportunidades foram criadas corretamente');
        
        List<Contagem_de_alunos_por_segmento__c> segmentos = new List<Contagem_de_alunos_por_segmento__c>();
        for(Opportunity opp : opps){
            Contagem_de_alunos_por_segmento__c segmento = new Contagem_de_alunos_por_segmento__c(
                Oportunidade__c = opp.Id,
                Segmento__c     = 'Ensino Fundamental 1'
            );

            segmentos.add(segmento);
        }

        List<Database.SaveResult> resultados = Database.insert(segmentos, false);
        for(Database.SaveResult result : resultados){
            System.assertEquals('Esse segmento já existe para essa oportunidade', result.getErrors()[0].getMessage(), 'Verifica erro em cada segmento');
        }

        System.assertEquals(9, [SELECT COUNT() FROM Contagem_de_alunos_por_segmento__c], 'Verifica se os segmentos não foram duplicados');
    }
}