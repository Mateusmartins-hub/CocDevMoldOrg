public class ReenviarOportunidadeIntegracaoController {

    public static final string RETORNO_REENVIADO_INTEGRACAO = 'Reenviado para integração';
    public static final string RETORNO_FASE_DIFERENTE_ERRO_ERP = 'Pedido não está com a fase Erro ERP';
    @AuraEnabled
    public static string ReenviaIntegracao(Id idOportunidade)
    {
        Opportunity op = [SELECT Id, BR_Aprovado__c, StageName FROM Opportunity WHERE Id =: idOportunidade LIMIT 1];

        if (op.BR_Aprovado__c && op.StageName == 'Erro ERP') 
        {
            op.StageName = 'Enviado para Integração';

            update op;

            return RETORNO_REENVIADO_INTEGRACAO;
        }

        return RETORNO_FASE_DIFERENTE_ERRO_ERP;
    }
}