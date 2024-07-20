@isTest
public class ReenviarOportunidadeIntegracaoTest {

    @isTest
    public static void Executar()
    {   

        User userToRun = [
            SELECT Id FROM User WHERE Profile.Name LIKE '%admin%' AND ManagerId != null AND isActive = true LIMIT 1
        ];

        System.runAs(userToRun){

            Opportunity op = TestHelper.CreateOpportunity();

            op.BR_Aprovado__c = true;
            op.StageName = 'Erro ERP';
            insert op;
            
            String retornoReenviado = ReenviarOportunidadeIntegracaoController.ReenviaIntegracao(op.Id);

            System.assert(retornoReenviado == ReenviarOportunidadeIntegracaoController.RETORNO_REENVIADO_INTEGRACAO);

            String retornoNadaAFazer = ReenviarOportunidadeIntegracaoController.ReenviaIntegracao(op.Id);
            
            System.assert(retornoNadaAFazer == ReenviarOportunidadeIntegracaoController.RETORNO_FASE_DIFERENTE_ERRO_ERP);

        }
    }
}