@IsTest
public class SolicitacaoDocumentosControllerTest {
    @TestSetup
    static void makeData(){

        User userToRun = [
            SELECT Id FROM User WHERE Profile.Name LIKE '%admin%' AND ManagerId != null AND isActive = true LIMIT 1
        ];

        System.runAs(userToRun){
            Account_Contact__c ctc = TestHelper.createAccountContact();
            ctc.Email__c = 'test@test.com';
            ctc.Name = 'Test';
            insert ctc;
            Opportunity opp = TestHelper.createOpportunity();
            opp.AccountId = ctc.Account__c;
            insert opp;
        }
    }

    @IsTest
    static void getNameAndEmailTest() {
        
        Opportunity opp = [SELECT Id FROM Opportunity LIMIT 1];
        Contact expectedCTC = [SELECT Name, Email FROM Contact LIMIT 1];
        SolicitacaoDocumentosController.ContactLink ctc = SolicitacaoDocumentosController.getNameAndEmail(opp.Id);
        System.assertEquals(expectedCTC.Name, ctc.nome);
        System.assertEquals(expectedCTC.Email, ctc.email);
    }

    @IsTest
    static void sendMissingDocumentsRequestTest() {
        Opportunity opp = [SELECT Id, AccountId FROM Opportunity LIMIT 1];
        Account acc = [SELECT BR_Main_State__c FROM Account LIMIT 1];
        Contact ctc = [SELECT Name, Email FROM Contact LIMIT 1];
        acc.BR_Main_State__c = 'SP'; 
        update acc;

        SolicitacaoDocumentosController.sendMissingDocumentsRequest(ctc.Email, new List<String> {'document'}, opp.Id);       
    }
}