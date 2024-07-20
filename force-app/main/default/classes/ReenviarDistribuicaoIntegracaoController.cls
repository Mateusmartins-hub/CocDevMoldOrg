public without sharing class ReenviarDistribuicaoIntegracaoController {
    
    @AuraEnabled
    public static String ReenviaIntegracao(Id idDist) {
        
        BR_DistribuicaoGratuita__c dist = [SELECT BR_ErroIntegracao__c FROM BR_DistribuicaoGratuita__c WHERE Id =: idDist];
        
        system.debug('STATUS da INTEGRACAO ' + dist.BR_ErroIntegracao__c);
        
        if (dist.BR_ErroIntegracao__c == true) {
            
            AmostraDistribuicaoGratuitaJob.reenviar_amostra_com_erro_button(idDist);
            
            return 'Reenviado para integração';
        }
        
        return 'Distribuição não está com o Status de Erro ERP';
    }
}