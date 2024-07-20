public class EventCheckOutController {

	private static final Id VISITA_EXPANSAO_RECORD_TYPE_ID = Schema.SObjectType.Event.getRecordTypeInfosByDeveloperName().get('VisitaExpansao').getRecordTypeId();
	private static final Id VISITA_PEDAGOGICA_RECORD_TYPE_ID = Schema.SObjectType.Event.getRecordTypeInfosByDeveloperName().get('Visita_Pedagogica').getRecordTypeId();

	@AuraEnabled
	public static Formulario BuscarFormulario(string idEvent) {
		Event event = EventDAO.getEventById(idEvent);		

		if(string.isBlank(event.Description))
			throw new AuraHandledException('Preencha o campo de descrição');

		if(event.RecordTypeId != VISITA_EXPANSAO_RECORD_TYPE_ID && event.RecordTypeId != VISITA_PEDAGOGICA_RECORD_TYPE_ID) {			
			return null;
		}

		string tipo = event.RecordTypeId == VISITA_EXPANSAO_RECORD_TYPE_ID ? 'Visita de expansão' :'Visita pedagógica';

		Formulario__c formConsultor = FormularioDAO.BuscaFormularioPerguntaVisitaExpansaoPedagogica(tipo, 'Consultor', event.ObjetivoVisita__c);
		if(formConsultor == null) {			
			return null;
		}

		Formulario formulario = new Formulario();
		formulario.IdFormulario = formConsultor.Id;
		formulario.Titulo = formConsultor.Titulo__c;

		List<PerguntaFormulario__c> perguntas = FormularioDAO.BuscarPerguntasPorFormulario(formConsultor.Id);

		formulario.Perguntas = new List<PerguntaResposta>();

		for (PerguntaFormulario__c pergunta :perguntas) {
			formulario.Perguntas.add(new PerguntaResposta(pergunta));
		}

		return formulario;
	}


	@AuraEnabled
	public static String EnviarChecklistCliente(string idEvent) {
		try {
			Event event = EventDAO.getEventById(idEvent);
			List<Account> account = AccountDAO.BuscaContas(new Set<Id>{ event.WhatId });
			List<Lead> ld = LeadDAO.BuscarLeads(new Set<Id>{ event.WhoId });
			List<Opportunity> op = OpportunityDAO.BuscarOportunidades(new Set<Id>{ event.WhatId });

			Account conta = !account.isEmpty() ? account [0] :null;
			Lead lead = !ld.isEmpty() ? ld [0] :null;
			Opportunity oportunidade = !op.isEmpty() ? op [0] :null;
			string emailCliente;
			string nomeCliente;
			string prefixo;
			string parentId;
			if(string.IsNotBlank(event.WhatId)) {
				parentId = event.WhatId;

				if(conta != null) {
					emailCliente = conta.BR_Account_email__c;
					nomeCliente = conta.Name;
					prefixo = 'ac';
				} 
				else if(oportunidade != null) {
					emailCliente = oportunidade.Account.BR_Account_email__c;
					nomeCliente = oportunidade.Account.Name;
					prefixo = 'op';
				}
			} 
			else if(string.IsNotBlank(event.WhoId)) {
				parentId = event.WhoId;

				if(lead != null) {
					emailCliente = lead.Email;
					nomeCliente = lead.Name;
					prefixo = 'ld';
				}
			}

			string tipo = event.RecordTypeId == VISITA_EXPANSAO_RECORD_TYPE_ID ? 'Visita de expansão' :'Visita pedagógica';


			Formulario__c formConsultor = FormularioDAO.BuscaFormularioPerguntaVisitaExpansaoPedagogica(tipo, 'Consultor', event.ObjetivoVisita__c);
			Formulario__c formCliente = FormularioDAO.BuscaFormularioPerguntaVisitaExpansaoPedagogica(tipo, 'Cliente', event.ObjetivoVisita__c);

			User consultor = [SELECT Id, Email, FirstName, LastName FROM User WHERE Id = :event.OwnerId];

			Map<string, string> mapReplacement = new Map<string, string>();
			mapReplacement.put('{DATA_VISITA}', DateUtil.formatDateTime(Event.StartDateTime));
			mapReplacement.put('{CLIENTE}', nomeCliente);

			if(string.isNotBlank(prefixo) && formConsultor != null) {
				Map<string, string> mapUrlParams = new Map<string, string>();
				mapUrlParams.put('id', formConsultor.Id);
				mapUrlParams.put(prefixo, parentId);
				Formulario_FormularioDigital.EnviarFormulario(consultor.Email, 'Encerramento_Visita_Expans_o_1575382377791', mapUrlParams, mapReplacement, null, null);
			}

			if(string.isNotBlank(emailCliente) && formCliente != null) {
				Map<string, string> mapUrlParams = new Map<string, string>();
				mapUrlParams.put('id', formCliente.Id);
				mapUrlParams.put(prefixo, parentId);
				Formulario_FormularioDigital.EnviarFormulario(emailCliente, 'Boas_Vindas_Lead_1575661695434', mapUrlParams, mapReplacement, consultor.Email, consultor.FirstName + ' ' + consultor.LastName);
			}
			return null;
		} catch(Exception e) {
			System.debug(e.getMessage());
			System.debug(e.getLineNumber());
			System.debug(e.getStackTraceString());
		}

		return 'erro';
	}


	@AuraEnabled
	public static Formulario SalvarRespostas(string idEvent, object form) {
		Formulario formulario;
		try {
			string j = JSON.serialize(form);

			Event event = EventDAO.getEventById(idEvent);
			formulario = (Formulario) JSON.deserialize(j, Formulario.class);

			Formulario__c formularioPergunta = FormularioDAO.BuscaFormularioPorId(formulario.IdFormulario);

			if(Formulario_FormularioDigital.ValidaFormulario(formulario.Perguntas)) {
				List<Account> account = AccountDAO.BuscaContas(new Set<Id>{ event.WhatId });
				List<Lead> ld = LeadDAO.BuscarLeads(new Set<Id>{ event.WhoId });
				List<Opportunity> op = OpportunityDAO.BuscarOportunidades(new Set<Id>{ event.WhatId });

				Account conta = !account.isEmpty() ? account [0] :null;
				Lead lead = !ld.isEmpty() ? ld [0] :null;
				Opportunity oportunidade = !op.isEmpty() ? op [0] :null;

				Formulario_FormularioDigital.SalvaRespostas(formulario.Perguntas, formularioPergunta, conta != null ? conta.Id :null, oportunidade != null ? oportunidade.Id :null, lead != null ? lead.Id :null);

				return null;

			}
		} catch(Exception e) {
			System.debug(e.getMessage());
			System.debug(e.getLineNumber());
			system.debug(e.getStackTraceString());
		}

		return formulario;
	}
}