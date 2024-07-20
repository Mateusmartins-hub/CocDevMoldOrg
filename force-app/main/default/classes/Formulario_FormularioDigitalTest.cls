@IsTest
public class Formulario_FormularioDigitalTest {
    @IsTest
    static void EnviarFormularioTest(){
        String email = 'test@pearson.com';
        String emailTemplate = 'VisitaPedagogicaLead';
        Map<String, String> mapParamsUrl = new Map<String, String>();
        mapParamsUrl.put('test', 'test123');

        Map<String, String> mapReplacementBody = new Map<String, String> ();
        mapReplacementBody.put('test', 'test123');

        Formulario_FormularioDigital.EnviarFormulario(email, emailTemplate, mapParamsUrl, mapReplacementBody, null, null);
    }

    @IsTest
    static void ValidaFormularioTest() {
        List<String> tiposResposta = new List<String>{'Lista de opções única', 'Texto livre', 'Numérico', 'Lista de opções múltipla'};

        for (String tipoResposta : tiposResposta) {
            PerguntaResposta pr = new PerguntaResposta();
            pr.Respostas = new List<String>();
            pr.TipoResposta = tipoResposta;
            pr.Obrigatorio = true;        

            List<PerguntaResposta> listPrs = new List<PerguntaResposta>();
            listPrs.add(pr);

            Boolean result = Formulario_FormularioDigital.ValidaFormulario(listPrs);
            System.assert(!result);
        }
    }

    @IsTest
    static void SalvaRespostasTest() {

        User userToRun = [
    		SELECT Id FROM User WHERE Profile.Name LIKE '%admin%' AND ManagerId != null AND isActive = true LIMIT 1
		];

		System.runAs(userToRun){
            
            Account acc = TestHelper.createAccount();        
            insert acc;
            
            Lead ld = TestHelper.createLead();
            insert ld;

            Opportunity opp = TestHelper.createOpportunity();
            insert opp;

            Product2 prdt = TestHelper.createProduct();
            insert prdt;

            Formulario__c frm = new Formulario__c();
            //frm.SistemaEnsino__c = 'COC';
            frm.Titulo__c = 'test';
            frm.Produto__c = prdt.Id;
            frm.Tipo__c = 'Visita pedagógica';
            frm.Destinatario__c  = 'Consultor';
            insert frm;

            PerguntaResposta pr = new PerguntaResposta();        
            pr.TipoResposta = 'Texto livre';
            pr.Resposta = 'test';
            pr.Obrigatorio = true;

            List<PerguntaResposta> listPrs = new List<PerguntaResposta>();
            listPrs.add(pr);

            Formulario_FormularioDigital.SalvaRespostas(listPrs, frm, acc.id, opp.id, ld.Id);

            List<RespostaFormulario__c> prResult = [SELECT Id FROM RespostaFormulario__c];
            System.assertEquals(1, prResult.size());

            List<Formulario__c> formResult = [SELECT Id FROM Formulario__c];
            System.assertEquals(2, formResult.size());
        }
    }
}