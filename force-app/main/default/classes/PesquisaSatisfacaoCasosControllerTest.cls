@isTest
private without sharing class PesquisaSatisfacaoCasosControllerTest {
    @isTest static void updateAvaliacaoTrue(){
        // Criar conta
        Account conta = TestPSCCFactory.criarConta();

        // Criar contato
        Contact contato = TestPSCCFactory.criarContato(conta);

        // Criar caso
        Case caso = TestPSCCFactory.criarCaso(conta, contato);

        // Criar avaliação
        Avalia_o__c avaliacao = TestPSCCFactory.criarAvaliacao(caso, true);

        // Atualizar avalição
        avaliacao.resolvido__c = 'Sim';
        avaliacao.aval_atendimento__c = 3; 
        Boolean result = PesquisaSatisfacaoCasosController.insertAval(avaliacao);
        System.assertEquals(true, result);

    }

    @isTest static void updateAvaliacaoFalse(){
        // Criar conta
        Account conta = TestPSCCFactory.criarConta();

        // Criar contato
        Contact contato = TestPSCCFactory.criarContato(conta);

        // Criar caso
        Case caso = TestPSCCFactory.criarCaso(conta, contato);

        // Criar avaliação
        Avalia_o__c avaliacao = TestPSCCFactory.criarAvaliacao(caso, false);

        // Atualizar avalição
        avaliacao.resolvido__c = 'Sim';
        avaliacao.aval_atendimento__c = 3; 
        Boolean result = PesquisaSatisfacaoCasosController.insertAval(avaliacao);
        System.assertEquals(false, result);
    }
}