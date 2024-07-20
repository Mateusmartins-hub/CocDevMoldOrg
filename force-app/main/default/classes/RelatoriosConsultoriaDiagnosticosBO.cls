public with sharing class RelatoriosConsultoriaDiagnosticosBO 
{
	private static final RelatoriosConsultoriaDiagnosticosBO instance = new RelatoriosConsultoriaDiagnosticosBO();

	private RelatoriosConsultoriaDiagnosticosBO() 
	{	
	}

	public static RelatoriosConsultoriaDiagnosticosBO getInstance()
	{
		return instance;
	}

	public Map<String, List<BR_ConfiguracaoRelConsult__c>> buscarConfiguracao()
	{
		Map<String, List<BR_ConfiguracaoRelConsult__c>> mapConfiguracoes = new Map<String, List<BR_ConfiguracaoRelConsult__c>>();
		for(BR_ConfiguracaoRelConsult__c config : RelatoriosConsultoriaDiagnosticosDAO.getInstance().buscarConfiguracao())
		{
			List<BR_ConfiguracaoRelConsult__c> lst = mapConfiguracoes.get(config.BR_APIPerformance__c);
			if(lst == null)
			{
				lst = new List<BR_ConfiguracaoRelConsult__c>();
				mapConfiguracoes.put(config.BR_APIPerformance__c, lst);
			}

			lst.add(config);
		}
		return mapConfiguracoes; 
	}

	public void calcularPerformance(List<BR_Procedimento_Visita__c> relatorios)
	{
		Map<String, List<BR_ConfiguracaoRelConsult__c>> mapConfiguracoes = RelatoriosConsultoriaDiagnosticosBO.getInstance().buscarConfiguracao();
		Id idConsultoriaSkill = RecordTypeUtil.getInstance().getRecordTypePorNome('BR_Procedimento_Visita__c', 'Consultoria Especializada - Comercial Skill').getRecordTypeId();
		Id idConsultoriaWizard = RecordTypeUtil.getInstance().getRecordTypePorNome('BR_Procedimento_Visita__c', 'Consultoria Especializada - Comercial Wizard').getRecordTypeId();
		Id idConsultoriaYazigi = RecordTypeUtil.getInstance().getRecordTypePorNome('BR_Procedimento_Visita__c', 'Consultoria Especializada - Comercial Yázigi').getRecordTypeId();
		Id idEspecializadaGFFR = RecordTypeUtil.getInstance().getRecordTypePorNome('BR_Procedimento_Visita__c', 'Especializada G&G FR').getRecordTypeId();
		Id idEspecializadaFinanceira = RecordTypeUtil.getInstance().getRecordTypePorNome('BR_Procedimento_Visita__c', 'Especializada Financeiro FR').getRecordTypeId();

		if(!mapConfiguracoes.isEmpty())
		{
			for(BR_Procedimento_Visita__c relatorio : relatorios)
			{
				/*
                if((relatorio.RecordTypeId == idConsultoriaSkill) ||
				   (relatorio.RecordTypeId == idConsultoriaWizard) ||
				   (relatorio.RecordTypeId == idConsultoriaYazigi) ||
				   (relatorio.RecordTypeId == idEspecializadaGFFR) ||
				   (relatorio.RecordTypeId == idEspecializadaFinanceira))
				{
					Decimal camposInexistente = 0.0;
					Decimal camposNaoConforme = 0.0;
					Decimal camposConforme    = 0.0;
					for(String key : mapConfiguracoes.keySet())
					{
                        Decimal performaneceAtual = 0.0;
						Decimal notaCompostaSecao = 0.0;
						Decimal notaDesejadaSecao = 0.0;
						for(BR_ConfiguracaoRelConsult__c config : mapConfiguracoes.get(key))
						{
							Id idTipoRegistro = RecordTypeUtil.getInstance().getRecordTypePorNome('BR_Procedimento_Visita__c', config.BR_TipoRegistro__c).getRecordTypeId();
							if(idTipoRegistro == relatorio.RecordTypeId)
							{
								String resposta = String.valueOf(relatorio.get(config.BR_Campo__c));
								Decimal notaIndividual = 0.0;
								if(resposta == 'Conforme')
								{
									camposConforme ++;
									notaIndividual = 10.0;
								}
								else if(resposta == 'Não-Conforme')
								{
									camposNaoConforme ++;
									notaIndividual = 5.0;
								}
								else
								{
									camposInexistente ++;
									notaIndividual = 0.0;
								}

								Decimal notaComposta = notaIndividual * config.BR_PesoQuestao__c;
								Decimal notaDesejada = 10.0 * config.BR_PesoQuestao__c;
								notaCompostaSecao = notaCompostaSecao + notaComposta;
								notaDesejadaSecao = notaDesejadaSecao + notaDesejada;
							}	
						}
						if(notaDesejadaSecao != 0.0)
						{
							performaneceAtual = (notaCompostaSecao / notaDesejadaSecao) * 100;
						}	

						relatorio.put(key, performaneceAtual);
					}
					relatorio.BR_QuestoesInexistentes__c = camposInexistente;
					relatorio.BR_QuestoesNaoConforme__c = camposNaoConforme;
					relatorio.BR_QuestoesConforme__c = camposConforme;
				}	
                */
			}
		}	
			
	}

	
}