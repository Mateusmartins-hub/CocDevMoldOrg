@IsTest
public class FormularioDAOTest {

    @TestSetup
    static void makeData(){

        Id formPerguntaRecordType = Schema.SObjectType.Formulario__c.getRecordTypeInfosByDeveloperName().get('Pergunta').getRecordTypeId();

        Formulario__c fmPerguntaExpansao = new Formulario__c();
        fmPerguntaExpansao.Destinatario__c = 'Consultor';
        fmPerguntaExpansao.RecordTypeId = formPerguntaRecordType;
        fmPerguntaExpansao.Tipo__c = 'Visita de expansão';
        insert fmPerguntaExpansao;


        Account acc = TestHelper.createAccount();
        insert acc;
        Product2 prdt = TestHelper.createProduct();
        insert prdt;
        Id formRespostaRecordType = Schema.SObjectType.Formulario__c.getRecordTypeInfosByDeveloperName().get('Resposta').getRecordTypeId();
        Formulario__c fmResposta = new Formulario__c();
        fmResposta.RecordTypeId = formRespostaRecordType;
        fmResposta.SistemaEnsino__c = 'COC';
        fmResposta.Tipo__c = 'Amostra Virtual';
        fmResposta.Conta__c = acc.Id;
        fmResposta.Produto__c = prdt.Id;
        insert fmResposta;

    }

    @IsTest
    static void BuscaFormularioPerguntaVisitaTest() {
        String destinatario = 'Consultor';

        Formulario__c resultVisitaExpansao = FormularioDAO.BuscaFormularioPerguntaVisitaExpansaoPedagogica('Visita de expansão', destinatario, '');
        System.assertEquals(destinatario, resultVisitaExpansao.Destinatario__c);  
    }

    @IsTest
    static void  buscaFormPorIdTest() {
        Formulario__c form = [SELECT Id FROM Formulario__c LIMIT 1];
        Formulario__c resultForm = FormularioDAO.BuscaFormularioPorId(form.Id);
        System.assertEquals(form.Id, resultForm.Id);
    }

    @IsTest
    static void BuscarRespostasVisitaTest() {
        Id formRespostaRecordType = Schema.SObjectType.Formulario__c.getRecordTypeInfosByDeveloperName().get('Resposta').getRecordTypeId();

        Formulario__c form = [SELECT Id, SistemaEnsino__c, Tipo__c, Destinatario__c, Conta__C  FROM Formulario__c WHERE RecordTypeId = :formRespostaRecordType];

        List<Formulario__c> resultFormList = FormularioDAO.BuscarRespostasVisita(form.SistemaEnsino__c, form.Tipo__c, form.Destinatario__c,  form.Conta__c);
        Formulario__c resultForm = resultFormList[0];

        System.assertEquals(form.Id, resultForm.Id);
    }

    @IsTest
    static void BuscarRespostasAmostraVirtualTest() {
        Id formRespostaRecordType = Schema.SObjectType.Formulario__c.getRecordTypeInfosByDeveloperName().get('Resposta').getRecordTypeId();
        Formulario__c form = [SELECT Id, SistemaEnsino__c, Produto__c,  Conta__C  FROM Formulario__c WHERE RecordTypeId = :formRespostaRecordType];

        List<Formulario__c> resultFormList = FormularioDAO.BuscarRespostasAmostraVirtual(form.SistemaEnsino__c, form.Conta__c, form.Produto__c);
        Formulario__c resultForm = resultFormList[0];

        System.assertEquals(form.Id, resultForm.Id);
    }

    @IsTest
    static void BuscarPerguntasPorFormularioTest() {
        Id formPerguntaRecordType = Schema.SObjectType.Formulario__c.getRecordTypeInfosByDeveloperName().get('Pergunta').getRecordTypeId();

        Formulario__c form = [SELECT Id FROM Formulario__c WHERE RecordTypeId = :formPerguntaRecordType];
        PerguntaFormulario__c perguntas = new PerguntaFormulario__c();
        perguntas.Formulario__c = form.Id;
        perguntas.Pergunta__c = 'Is this a test?';
        perguntas.TipoResposta__c = 'Texto livre';
        insert perguntas;

        List<PerguntaFormulario__c> resultPerguntaList = FormularioDAO.BuscarPerguntasPorFormulario(form.Id);
        PerguntaFormulario__c resultPergunta = resultPerguntaList[0];

        System.assertEquals(perguntas.Id, resultPergunta.Id);
    }
}