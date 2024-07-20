@isTest
public class EnvioAmostraDigitalControllerTest {
    @isTest
    public static void Executar()
    {
        User userToRun = [
    		SELECT Id FROM User WHERE Profile.Name LIKE '%admin%' AND ManagerId != null AND isActive = true LIMIT 1
		];

		System.runAs(userToRun){
                
            Opportunity op = TestHelper.CreateOpportunity();
            insert op;
            
            Lead ld = TestHelper.CreateLead();
            insert ld;
    
            Formulario__c form = new Formulario__c();
            form.Tipo__c = 'Amostra Virtual';
            form.SistemaEnsino__c = 'COC';
            insert form;

            EnvioAmostraDigitalController.AmostraLink al = EnvioAmostraDigitalController.GetObject(op.AccountId);
            EnvioAmostraDigitalController.GetObject(op.Id);
            EnvioAmostraDigitalController.GetObject(ld.Id);
            EnvioAmostraDigitalController.GetFormulario('COC');
            EnvioAmostraDigitalController.ValidaEnvioPosterior(null, null, null);
            EnvioAmostraDigitalController.SendEmail(al, form.Id, 'teste');
        }
    }
}