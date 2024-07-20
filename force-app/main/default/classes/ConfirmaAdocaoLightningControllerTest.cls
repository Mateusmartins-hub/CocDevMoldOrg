@isTest
public class ConfirmaAdocaoLightningControllerTest {
    @isTest
    public static void Executar()
    {
        Test.setMock(HttpCalloutMock.class, new MockCapturaSAP());

        User userToRun = [
    		SELECT Id FROM User WHERE Profile.Name LIKE '%admin%' AND ManagerId != null AND isActive = true LIMIT 1
		];

		System.runAs(userToRun){
        
            OpportunityLineItem item = TestHelper.createOpportunityLineItem();
            insert item;

            ConfirmaAdocaoLightningController.ConfirmaAdocao(item.OpportunityId);
            ConfirmaAdocaoLightningController.BuscaOportunidade(item.OpportunityId);
            ConfirmaAdocaoLightningController.BuscaProdutos(item.OpportunityId);
        }
    }
}