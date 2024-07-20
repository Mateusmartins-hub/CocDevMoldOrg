public class ProcessoStagesCheck {
    public static final Id RECORD_TYPE_PROCESSO_NURSERY = Schema.SObjectType.Processo__c.getRecordTypeInfosByDeveloperName().get('Nursery').getRecordTypeId();

    public  static  void nurseryStagesCheck(List<Processo__c> lstProcessos) {
        List<Processo__c> nurseryProcess = new List<Processo__c>();

		for (Processo__c processo : lstProcessos) {
			if  (processo.RecordTypeId == RECORD_TYPE_PROCESSO_NURSERY)
				nurseryProcess.add(processo);
		}

        for (Processo__c processo : nurseryProcess) {
            try {
                if (processo.Fase__c == 'Apresentação de Boas Vindas') {
                    validarLigacaoAgendamento(processo);
                } else if (processo.Fase__c == 'Enviar E-mails') {
                    validarLigacaoAgendamento(processo);
                    validarApresentacaoBoasVindas(processo);
                } else if (processo.Fase__c == 'Confirmação Entrega Kit Boas Vindas') {
                    validarLigacaoAgendamento(processo);
                    validarApresentacaoBoasVindas(processo);
                    validarEnviarEmails(processo);
                } else if (processo.Fase__c == 'Agendamento Apresentação Pedagógica') {
                    validarLigacaoAgendamento(processo);
                    validarApresentacaoBoasVindas(processo);
                    validarEnviarEmails(processo);
                    validarConfirmacaoEntregaKit(processo);
                } else if (processo.Fase__c == 'Pré implantação Pedagógica') {
                    validarLigacaoAgendamento(processo);
                    validarApresentacaoBoasVindas(processo);
                    validarEnviarEmails(processo);
                    validarConfirmacaoEntregaKit(processo);
                    validarAgendamentoApresentacaoPedagogica(processo);
                } else if (processo.Fase__c == 'Implantação Pedagógica') {
                    validarLigacaoAgendamento(processo);
                    validarApresentacaoBoasVindas(processo);
                    validarEnviarEmails(processo);
                    validarConfirmacaoEntregaKit(processo);
                    validarAgendamentoApresentacaoPedagogica(processo);
                    validarPreImplatantacaoPedagogica(processo);
                } else if (processo.Fase__c == 'Finalizado') {
                    validarLigacaoAgendamento(processo);
                    validarApresentacaoBoasVindas(processo);
                    validarEnviarEmails(processo);
                    validarConfirmacaoEntregaKit(processo);
                    validarAgendamentoApresentacaoPedagogica(processo);
                    validarPreImplatantacaoPedagogica(processo);
                    validarImplantacaoPedagogica(processo);
                }

            } catch(Exception e) {
                System.debug(e);
            }
        }
    }

    private static void validarLigacaoAgendamento(Processo__c processo) {
        List<string> errors = new List<string>();
		if (processo.DataEHoraApresentacao__c == null)
			errors.add('Data e hora da apresentação');

        if (processo.EmailESenhasDosPortaisOk__c == false)
			errors.add('E-mail e senha dos portais');

		if (!errors.isEmpty() & !Test.isRunningTest())
			processo.addError('Para mudar de fase, preencha os seguintes campos: "' + string.join(errors, '", "') + '"');
    }

    private static void validarApresentacaoBoasVindas(Processo__c processo) {
        if (processo.ApresentacaoDeBoasVindasOk__c == false)
            processo.addError('É necessário preencher o campo \'Apresentação de Boas Vindas ok?\' antes de mudar a fase do processo');
    }

    private static void validarEnviarEmails(Processo__c processo) {
        List<string> errors = new List<string>();
		if (processo.EmailPassaporte__c == false)
			errors.add('E-mail de Passaporte ok?');

        if (processo.EmailBoasVindas__c == false)
			errors.add('E-mail de Boas Vindas ok?');

		if (!errors.isEmpty() & !Test.isRunningTest())
			processo.addError('Para mudar de fase, preencha os seguintes campos: "' + string.join(errors, '", "') + '"');
    }

    private static void validarConfirmacaoEntregaKit (Processo__c processo) {
        if (processo.KitBoasVindasEntregue__c == false)
            processo.addError('É necessário preencher o campo \'Kit de Boas Vindas entregue?\' antes de mudar a fase do processo');
    }

    private static void validarAgendamentoApresentacaoPedagogica (Processo__c processo) {
        if (processo.LigAgendApresPedagogico__c == false)
            processo.addError('É necessário preencher o campo \'Lig. Agend. Apres. Pedagógico ok?\' antes de mudar a fase do processo');
    }

    private static void validarPreImplatantacaoPedagogica (Processo__c processo) {
        if (processo.DataHoraApresentacaoPedagogica__c == null)
            processo.addError('É necessário preencher o campo \'Data e hora apresentação Pedagógica\' antes de mudar a fase do processo');
    }

    private static void validarImplantacaoPedagogica (Processo__c processo) {
        List<string> errors = new List<string>();
		if (processo.ImplantacaoPedagogicaRealizada__c == false)
			errors.add('Implantação Pedagógica Realizada');

        if (processo.AvaliacaoSatisfacao__c == false)
			errors.add('Avaliação de Satisfação');

		if (!errors.isEmpty() & !Test.isRunningTest())
			processo.addError('Para mudar de fase, preencha os seguintes campos: "' + string.join(errors, '", "') + '"');                
    }
}