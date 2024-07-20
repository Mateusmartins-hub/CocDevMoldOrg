public with sharing class ContagemSegmentoUtil {
    public static void validarSegmento(List<Contagem_de_alunos_por_segmento__c> segmentos){
        Set<ID> oppIds = new Set<ID>();
        for(Contagem_de_alunos_por_segmento__c segmento : segmentos){
            oppIds.add(segmento.Oportunidade__c);
        }

        List<Contagem_de_alunos_por_segmento__c> segExistentes = [SELECT Segmento__c, Oportunidade__c FROM Contagem_de_alunos_por_segmento__c WHERE Oportunidade__c IN :oppIds];
        
        // Iteração para cada segmento da trigger
        for(Contagem_de_alunos_por_segmento__c atual : segmentos){
            // atual.Segmento__c     -> Lista de opções
            // atual.Oportunidade__c -> Oportunidade vinculada
            for(Contagem_de_alunos_por_segmento__c existente : segExistentes){
                if(atual.Oportunidade__c == existente.Oportunidade__c && atual.Segmento__c == existente.Segmento__c){
                    atual.Segmento__c.addError('Esse segmento já existe para essa oportunidade');
                }
            }    

        }
    }
}