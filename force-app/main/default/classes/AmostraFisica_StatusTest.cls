@isTest
public class AmostraFisica_StatusTest {

    @TestSetup
    static void makeData(){

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
        }
    }

    @isTest
    static void testOne() {
        AmostraFisica__c amostra = [SELECT Id FROM AmostraFisica__c LIMIT 1];        
        update amostra;        
        delete amostra;
    }

    @isTest
    static void testTipoFrete() {
        AmostraFisica__c amostra = [SELECT Id FROM AmostraFisica__c LIMIT 1];        
        try{
            amostra.TipoFrete__c = 'Emergencial';
            update amostra;
        }catch(Exception e){
            System.assert(e.getMessage().containsIgnoreCase('frete'));
        }        
    }

    @IsTest
    static void enviarEmailConsultorAgendarVisitaTest() {
        AmostraFisica__c amostra = [SELECT Id FROM AmostraFisica__c LIMIT 1];        
        amostra.Status__c = 'Entregue';
        

        Test.startTest();
            update amostra;
            Integer emailInvocations = Limits.getEmailInvocations();
        Test.stopTest();

        //System.assertEquals(1, emailInvocations, 'Email enviado para o consultor');
    }
}