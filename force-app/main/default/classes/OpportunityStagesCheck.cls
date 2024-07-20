public class OpportunityStagesCheck {
	public static final Id RECORD_TYPE_OPORTUNIDADE_SETOR_PRIVADO = Schema.SObjectType.Opportunity.getRecordTypeInfosByDeveloperName().get('OportunidadeDeVendasSetorPrivado').getRecordTypeId();
	public static final Id RECORD_TYPE_OPORTUNIDADE_SETOR_PUBLICO = Schema.SObjectType.Opportunity.getRecordTypeInfosByDeveloperName().get('OportunidadeDeVendasSetorPublico').getRecordTypeId();
	public static final Id RECORD_TYPE_OPORTUNIDADE_INSTITUTO_LINGUAS = Schema.SObjectType.Opportunity.getRecordTypeInfosByDeveloperName().get('OportunidadeDeVendasInstitutoDeLinguas').getRecordTypeId();
	public static final Id RECORD_TYPE_OPORTUNIDADE_VENDAS_COC = Schema.SObjectType.Opportunity.getRecordTypeInfosByDeveloperName().get('Sales_Opportunities_COC').getRecordTypeId();
	public static final Id RECORD_TYPE_OPORTUNIDADE_VENDAS_DOM_BOSCO = Schema.SObjectType.Opportunity.getRecordTypeInfosByDeveloperName().get('Sales_Opportunities_Dom_Bosco').getRecordTypeId();
	public static final Id RECORD_TYPE_OPORTUNIDADE_VENDAS_ATITUDE = Schema.SObjectType.Opportunity.getRecordTypeInfosByDeveloperName().get('Sales_Opportunities_Atitude').getRecordTypeId();
	public static final Id RECORD_TYPE_OPORTUNIDADE_FRANQUIA_SKILL_ED = Schema.SObjectType.Opportunity.getRecordTypeInfosByDeveloperName().get('ExpansaoSkillEd').getRecordTypeId();
	public static final Id RECORD_TYPE_OPORTUNIDADE_FRANQUIAS = Schema.SObjectType.Opportunity.getRecordTypeInfosByDeveloperName().get('Franquias').getRecordTypeId();
	public static final Id RECORD_TYPE_OPORTUNIDADE_ELT = Schema.SObjectType.Opportunity.getRecordTypeInfosByDeveloperName().get('ELT_Distribuidor').getRecordTypeId();

	public static Set<Id> opportunitiesWithPesquisa;

	public static void setInitialStage(List<Opportunity> lstOpps) {
		for(Opportunity opp :(List<Opportunity>) trigger.new) {
			if(opp.RecordTypeId == RECORD_TYPE_OPORTUNIDADE_SETOR_PRIVADO || opp.RecordTypeId == RECORD_TYPE_OPORTUNIDADE_SETOR_PUBLICO || opp.RecordTypeId == RECORD_TYPE_OPORTUNIDADE_INSTITUTO_LINGUAS)
				opp.StageName = 'Validação da conta';
		}
	}

	public static void stagesCheck(List<Opportunity> lstOpps) {
        
        Set<Id> quoteIds = new Set<Id>();
        for(Opportunity opt : lstOpps) {
            quoteIds.add(opt.SyncedQuoteId);
        }
        List<Quote> lstQuote = new List<Quote>([SELECT Id, Status FROM Quote WHERE Id IN: quoteIds]);
		

		buildOpportunitiesWithPesquisaMap(lstOpps);

		for(Opportunity opp :lstOpps) {
			if(opp.RecordTypeId == RECORD_TYPE_OPORTUNIDADE_SETOR_PRIVADO) {
				if(opp.StageName == 'Visita Inicial') {
					validarConta(opp);
				} else if(opp.StageName == 'Aprofundamento Pedagógico') {
					validarConta(opp);
					setorPrivadoValidarVisitaInicial(opp);
				} else if(opp.StageName == 'Negociação') {
					validarConta(opp);
					setorPrivadoValidarVisitaInicial(opp);
				} else if(opp.StageName == 'Elaborando Contrato') {
					validarConta(opp);
					setorPrivadoValidarVisitaInicial(opp);
					setorPrivadoNegociacao(opp);
					criarProcessoNursery(opp);
				} else if(opp.StageName == 'Coletando assinatura') {
					validarConta(opp);
					setorPrivadoValidarVisitaInicial(opp);
					setorPrivadoNegociacao(opp);
				} else if(opp.StageName == 'Contrato Finalizado') {
					validarConta(opp);
					setorPrivadoValidarVisitaInicial(opp);
					setorPrivadoNegociacao(opp);					
					criarProcessoNursery(opp);
				} else if(opp.StageName == 'Pedido Gerado') {
					validarConta(opp);
					setorPrivadoValidarVisitaInicial(opp);
					setorPrivadoNegociacao(opp);					
					setorPrivadoContratoFinalizado(opp);
                    checkIfPesquisaDeMercadoExists(opp);
				}		  		
			} else if(opp.RecordTypeId == RECORD_TYPE_OPORTUNIDADE_INSTITUTO_LINGUAS) {
				if(opp.StageName == 'Visita Inicial') {
					validarConta(opp);
				} else if(opp.StageName == 'Amostras Físicas') {
					validarConta(opp);
					validarVisitaDeExpansao(opp);
				} else if(opp.StageName == 'Aprofundamento Pedagógico') {
					validarConta(opp);
					validarVisitaDeExpansao(opp);
					setorPrivadoValidarVisitaInicial(opp);
				} else if(opp.StageName == 'Registro de Adoção') {
					validarConta(opp);
					validarVisitaDeExpansao(opp);
					setorPrivadoValidarVisitaInicial(opp);
				} else if(opp.StageName == 'Confirmação de Adoção') {
					validarConta(opp);
					setorPrivadoValidarVisitaInicial(opp);
					setorPrivadoNegociacao(opp);
				} else if(opp.StageName == 'Adoção') {
					validarConta(opp);
					setorPrivadoValidarVisitaInicial(opp);
					setorPrivadoNegociacao(opp);
				}
			} else if(opp.RecordTypeId == RECORD_TYPE_OPORTUNIDADE_VENDAS_COC) {
				if(opp.StageName == 'Contrato Finalizado') {
					criarProcessoNursery(opp);
				}
			} else if(opp.RecordTypeId == RECORD_TYPE_OPORTUNIDADE_VENDAS_DOM_BOSCO) {
				if(opp.StageName == 'Contrato Finalizado') {
					criarProcessoNursery(opp);
				}
			} else if(opp.RecordTypeId == RECORD_TYPE_OPORTUNIDADE_VENDAS_ATITUDE) {
				if(opp.StageName == 'Contrato Finalizado') {
					criarProcessoNursery(opp);
				}
			} else if(opp.RecordTypeId == RECORD_TYPE_OPORTUNIDADE_FRANQUIAS) {
				System.debug('opportunities stage check - ' + opp.SyncedQuoteId);
				for(Quote qt :lstQuote) {

					if(opp.IsClosed && !opp.IsWon) continue; //Caso a oportunidade seja perdida

                    if(opp.SyncedQuoteId == qt.Id && qt.Status != 'Aprovada'){
                    	opp.addError('A Cotação ainda não foi aprovada e não pode ser Sincronizada com a Oportunidade.');  
                    }
                }             
			
				if(opp.StageName == 'Análise da Proposta') {
					checkIfOpportunityHasPesquisaRecord(opp);
				}
			}
		}
	}

	public static void ELTStagesCheck(List<Opportunity> lstOpps) {
		List<Opportunity> opportunitiesELT = new List<Opportunity>();

		for(Opportunity opportunity : lstOpps) {
			if(opportunity.RecordTypeId == RECORD_TYPE_OPORTUNIDADE_ELT) {
				opportunitiesELT.add(opportunity);
			}
		}

		if(opportunitiesELT.size() > 0) {
			Id recordTypePesquisaELT = Schema.SObjectType.BR_Pesquisa__c.getRecordTypeInfosByDeveloperName().get('ELT_Distribuidor').getRecordTypeId();
			
			List<BR_Pesquisa__c> ELTPesquisas = [
				SELECT Id, RecordTypeId, Opportunity__c
				FROM BR_Pesquisa__c
				WHERE Opportunity__c IN :opportunitiesELT
				AND RecordTypeId = :recordTypePesquisaELT
			];
	
			Set<Id> ELTOpportunitiesWithPesquisa = new Set<Id>();
	
			for(BR_Pesquisa__c pesquisa : ELTPesquisas){
				ELTOpportunitiesWithPesquisa.add(pesquisa.Opportunity__c);
			}
	
			Id recordTypeBeneficioELT = Schema.SObjectType.Beneficio__c.getRecordTypeInfosByDeveloperName().get('ELT_Distribuidor').getRecordTypeId();
			
			List<Beneficio__c> ELTBeneficios = [
				SELECT Id, RecordTypeId, Nome_da_Oportunidade__c
				FROM Beneficio__c
				WHERE Nome_da_Oportunidade__c IN :opportunitiesELT
				AND RecordTypeId = :recordTypeBeneficioELT
			];
	
			Set<Id> ELTOpportunitiesWithBeneficio = new Set<Id>();
			
			for(Beneficio__c beneficio : ELTBeneficios){
				ELTOpportunitiesWithBeneficio.add(beneficio.Nome_da_Oportunidade__c);
			}
	
			for(Opportunity opp :opportunitiesELT) {
				if(opp.RecordTypeId == RECORD_TYPE_OPORTUNIDADE_ELT){
					if(opp.StageName == 'Análise do material' &&
					  (opp.Tipo_de_contrato__c == 'Expansão' ||
					   opp.Tipo_de_contrato__c == 'Upsell') &&
					  !ELTOpportunitiesWithPesquisa.contains(opp.Id)) {
						  opp.addError('É necessária a criação de um registro de Pesquisa do tipo ELT');
					} else if(opp.StageName == 'Adotado' &&
								opp.Beneficio_confirmado__c == 'Foi necessário' &&
							   !ELTOpportunitiesWithBeneficio.contains(opp.Id)) {
						  opp.addError('É necessária a criação de um registro de Benefício do tipo ELT');
					}
				}
			}
		}

	}

	public static void criarProcessoNursery(Opportunity opp) {
		Set<Id> idOpp = new Set<Id>{ opp.Id };
		List<Processo__c> listProcess = ProcessoDAO.getProcessosByOppsIds(idOpp);

		if(listProcess.size() == 0) {
			Processo__c proc = new Processo__c();
			proc.Conta__c = opp.AccountId;
			proc.Oportunidade__c = opp.id;
			proc.RecordTypeId = Schema.SObjectType.Processo__c.getRecordTypeInfosByDeveloperName().get('Nursery').getRecordTypeId();

			insert proc;
		}
	}

	public static void validarModalidadeLicitacao(Opportunity opp) {
		if(opp.BR_Modalidade_licitacao__c == null)
			opp.addError('É necessário preencher o campo \'Modalidade Processo Contratação\' antes de atualizar a oportunidade');
	}

	public static void validarVisitaDeExpansao(Opportunity opp) {
		if(!opp.VisitaDeExpansaoRealizada__c)
			opp.addError('É necessário realizar a visita de expansão antes de atualizar a oportunidade');
	}

	public static void validarAprovacaoGerencial(Opportunity opp) {
		if(!opp.AprovacaoGerencial__c)
			opp.addError('É necessário aprovação gerencial antes de atualizar a oportunidade');
	}

	public static void validarConta(Opportunity opp) {
		List<string> errors = new List<string>();
		if(opp.Phone__c == null)
			errors.add('Telefone');

		if(!errors.isEmpty() && !Test.isRunningTest())
			opp.addError('Para mudar de fase, preencha os seguintes campos: "' + string.join(errors, '", "') + '"');
	}

	public static void setorPrivadoValidarVisitaInicial(Opportunity opp) {
		if(!opp.AmostraFisicaEnviada__c)
			opp.addError('É necessário enviar a amostra física antes de atualizar a oportunidade');
	}

	public static void setorPrivadoNegociacao(Opportunity opp) {
		if(!opp.CotacaoGerada__c)
			opp.addError('É necessário gerar a cotação antes de atualizar a oportunidade');
	}

	public static void setorPrivadoContratoFinalizado(Opportunity opp) {
		if(!opp.ContratoAnexado__c)
			opp.addError('É necessário anexar o contrato no Salesforce antes de atualizar a oportunidade');
	}
    
    public static void checkIfPesquisaDeMercadoExists(Opportunity opp) {
        List<BR_Pesquisa__c> pesquisas = [SELECT Id, RecordTypeId FROM BR_Pesquisa__c WHERE Opportunity__c = :opp.Id];
        Id PESQUISA_MERCADO_RECORD_TYPE =  Schema.SObjectType.BR_Pesquisa__c.getRecordTypeInfosByDeveloperName().get('PesquisaMercadoEscola').getRecordTypeId();
        if (pesquisas.isEmpty())
            opp.addError('É necessário fazer pelo menos uma pesquisa de mercado antes de fechar a oportunidade');
        
        Boolean foundPesquisa = false;
        for (BR_Pesquisa__c pesquisa : pesquisas) {
            if (pesquisa.RecordTypeId == PESQUISA_MERCADO_RECORD_TYPE)
                foundPesquisa = true;
        }
        
        if (!foundPesquisa)
            opp.addError('É necessário fazer pelo menos uma pesquisa de mercado antes de fechar a oportunidade');            
	}

	private static void buildOpportunitiesWithPesquisaMap(List<Opportunity> opportunities){

		if(opportunitiesWithPesquisa != null) return;

		Id recordTypePesquisaFranquias = Schema.SObjectType.BR_Pesquisa__c.getRecordTypeInfosByDeveloperName().get('BR_Expansao_Franquias').getRecordTypeId();
		
		List<BR_Pesquisa__c> pesquisasFranquias = [
			SELECT Id, RecordTypeId, Opportunity__c
			FROM BR_Pesquisa__c
			WHERE Opportunity__c IN :opportunities
			AND RecordTypeId = :recordTypePesquisaFranquias
		];

		opportunitiesWithPesquisa = new Set<Id>();
		for(BR_Pesquisa__c pesquisa : pesquisasFranquias){
			opportunitiesWithPesquisa.add(pesquisa.Opportunity__c);
		}
	}
	
	public static void checkIfOpportunityHasPesquisaRecord(Opportunity opp){
		if(!opportunitiesWithPesquisa.contains(opp.Id)){
			opp.addError('Para avançar de fase, você deve criar um registro de pesquisa expansão franquias');  
		}
	}
}