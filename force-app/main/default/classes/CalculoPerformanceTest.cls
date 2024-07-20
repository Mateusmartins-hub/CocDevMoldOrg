@isTest
private class CalculoPerformanceTest
{
    @testSetup 
    static void setup()
    {
        BR_ConfiguracaoRelConsult__c config = new BR_ConfiguracaoRelConsult__c();
        config.BR_APIPerformance__c = 'BR_PerformAtualRecrutamentoSelecao__c';
        config.BR_Campo__c = 'BR_ExisteProcessoSeletivoNaEscola__c';
        config.BR_PesoQuestao__c = 3;
        config.BR_TipoRegistro__c = 'Especializada G&G FR';
        Database.insert(config);

        BR_ConfiguracaoRelConsult__c config2 = new BR_ConfiguracaoRelConsult__c();
        config2.BR_APIPerformance__c = 'BR_PerformAtualRecrutamentoSelecao__c';
        config2.BR_Campo__c = 'BR_PessoaResponsavelPeloReS__c';
        config2.BR_PesoQuestao__c = 2;
        config2.BR_TipoRegistro__c = 'Especializada G&G FR';
        Database.insert(config2);

        BR_ConfiguracaoRelConsult__c config3 = new BR_ConfiguracaoRelConsult__c();
        config3.BR_APIPerformance__c = 'BR_PerformAtualRecrutamentoSelecao__c';
        config3.BR_Campo__c = 'BR_DivulgacaoVagas__c';
        config3.BR_PesoQuestao__c = 4;
        config3.BR_TipoRegistro__c = 'Especializada G&G FR';
        Database.insert(config3);
        
        Id idPessoaFisica = RecordTypeUtil.getInstance().getRecordTypePorNome('Account', 'Pessoa Física').getRecordTypeId();
        Account conta = new Account();
        conta.RecordTypeId = idPessoaFisica;
        conta.Name = 'ANHEMBI MORUMBI - CENTRO';
        conta.BR_Approval_status__c = 'Em elaboração';
        conta.BR_cnpj__c = '64.645.655/0001-08';
        conta.BR_Account_Id_SAP__c = '000000';
        conta.Phone = '96736-3333';
        conta.BR_Account_email__c = 'email@email.com.br';
        Database.insert(conta);

        FR_Procedimento_Franquias__c consultoria = new FR_Procedimento_Franquias__c();
        consultoria.BR_Conta__c = conta.Id;
        consultoria.BR_StatusConsultoria__c = 'Aberta';
        consultoria.BR_TipoConsultoria__c = 'Auditoria FR';
        Database.insert(consultoria);



    }
        
    @isTest
    static void itShould()
    {
        FR_Procedimento_Franquias__c consultoria = [SELECT Id FROM FR_Procedimento_Franquias__c LIMIT 1];

        Id idEspecializadaGFFR = RecordTypeUtil.getInstance().getRecordTypePorNome('BR_Procedimento_Visita__c', 'Consultoria Pedagógica').getRecordTypeId();
        BR_Procedimento_Visita__c relatorio = new BR_Procedimento_Visita__c();
        relatorio.RecordTypeId = idEspecializadaGFFR;
        relatorio.BR_FR_Procedimento_Franquias_Visita__c = consultoria.Id;
        //relatorio.BR_SequenciaConsultoria__c = 'Dia 1 - 1ª semana (diagnóstico)';

        relatorio.BR_ExisteProcessoSeletivoNaEscola__c = 'Conforme';
        relatorio.BR_EntrevistaIndividualComCandidatos__c = 'Conforme';
        relatorio.BR_PessoaResponsavelPeloReS__c = 'Não-Conforme';
        relatorio.DescricaoPrincipaisCargos__c = 'Conforme';
        relatorio.BR_DivulgacaoVagas__c = 'Inexistente';
        relatorio.BR_SaoAplicadasDinamicasParaSelecao__c = 'Não-Conforme';
        relatorio.BR_ExisteProcessoRecrutamentoInterno__c = 'Não-Conforme';
        relatorio.ProvasConhecimentoEspecifico__c = 'Não-Conforme';
        Database.insert(relatorio);

        relatorio.ProvasConhecimentoEspecifico__c = 'Conforme';
        Database.update(relatorio);
    }
}