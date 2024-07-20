@IsTest
public class EnvioDocumentosControllerTest {
    @TestSetup
    static void makeData(){

        User userToRun = [
    		SELECT Id FROM User WHERE Profile.Name LIKE '%admin%' AND ManagerId != null AND isActive = true LIMIT 1
		];

		System.runAs(userToRun){
            Opportunity opp = TestHelper.createOpportunity();        
            insert opp;
        }
    }

    @IsTest
    static void getDocumentsURLTest() {
        List<String> fields = new List<String> {'CartaoCNPJ__c'};
        List<EnvioDocumentosController.DocumentLink> dl = EnvioDocumentosController.getDocumentsURL(fields, 'SP');        
    }

    @IsTest
    static void saveTheFileTest() {
        Opportunity opp = [SELECT Id FROM Opportunity LIMIT 1];
        EnvioDocumentosController.saveTheFile(opp.Id, 'CartaoCNPJ__c', 'random', 'test', 'image/png');
    }
    
    @IsTest
    static void acceptTermsTest() {
        Opportunity opp = [SELECT Id, TermosCondicoesAceitos__c FROM Opportunity LIMIT 1];
        EnvioDocumentosController.acceptTerms(opp.Id);
    }
}