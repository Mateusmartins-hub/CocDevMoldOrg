@isTest
public class VisualizarSaldoAmostrasControllerTest {

    @isTest
    static void testOne() {

        User userToRun = [
            SELECT Id FROM User WHERE Profile.Name LIKE '%admin%' AND ManagerId != null AND isActive = true LIMIT 1
        ];

        System.runAs(userToRun){
                
            Opportunity op = TestHelper.createOpportunity();
            insert op;
            
            AmostraFisica__c amostra = new AmostraFisica__c();
            amostra.TipoFrete__c = 'Normal';
            amostra.Oportunidade__c = op.Id;
            insert amostra;
            
            VisualizarSaldoAmostrasController.getUsuarioOwner(amostra.Id);
            VisualizarSaldoAmostrasController.getUsuarioLogado(amostra.Id);
        }
    }
}