global without sharing class BotaoJavaScript {
	public BotaoJavaScript() {

	}
    
	webservice static String novaConsultoria(String contaId)
		{

			try {
                AccountBO aBO = new AccountBO();
				System.debug('começou');
				FR_Procedimento_Franquias__c consultoria;// = AccountBO.getInstance().criaVinculoConsultoria(contaId);

				User usuarioAtual = UserDAO.getProfileIdByUserId(UserInfo.getUserId());
				Profile perfilAtual = ProfileDAO.getProfileNameByProfileId(usuarioAtual.ProfileId);
                System.debug('Profile: ' + PerfilAtual.Name);
				String RecordTypeId;
				String link;
				if ('Comercial Franquias'.Equals(perfilAtual.Name) || 'Pedagógico Franquias'.Equals(perfilAtual.Name) ||
						'Especializada FR'.Equals(perfilAtual.Name) || 'Backoffice FR'.Equals(perfilAtual.Name) ||
						'Gerência Comercial FR'.Equals(perfilAtual.Name) || 'Operacional FR'.Equals(perfilAtual.Name) ||
						'Planejamento FR'.Equals(perfilAtual.Name) || 'ADM Franquias'.Equals(perfilAtual.Name) ||
						'Retenção FR'.Equals(perfilAtual.Name) || 'Auditoria FR'.Equals(perfilAtual.Name)) {
					Account contaAtual = AccountDAO.buscaConta(contaId);

					link = '/a0e/e?retURL=%2Fa0e%2Fo&CF00Nd00000093BoU=' + contaAtual.Name;
				} else {
					if('Consultoria Pedagógica ELT'.Equals(perfilAtual.Name)) {
						consultoria = aBO.criaVinculoConsultoria(contaId, 'Pedagógico');
						RecordTypeId = RecordTypeUtil.getInstance().getRecordTypePorNome('Event','EDU Pearson English Pedagógico').getRecordTypeId();
						link = '/00U/e?what_id=' + consultoria.Id + '&retURL=%2F' + consultoria.Id + '&RecordType=' +
								RecordTypeId + '&ent=Event' ;
						
					}else {
						consultoria = aBO.criaVinculoConsultoria(contaId, 'Pedagógico');
						RecordTypeId = RecordTypeUtil.getInstance().getRecordTypePorNome('Event','K12 - Compromisso Pedagógico').getRecordTypeId();
						link = '/00U/e?what_id=' + consultoria.Id + '&retURL=%2F' + consultoria.Id + '&RecordType=' +
								RecordTypeId + '&ent=Event' ;
					}
				}

				System.debug('RecordTypeId' + RecordTypeId);

				//String link = 'https://pearsonlatam--resource1.cs68.my.salesforce.com/00U/e?what_id=' + consultoria.Id + '&retURL=%2F' + consultoria.Id + '&RecordType=' + RecordTypeId + '&ent=Event' ;
				System.debug('link ' + link);
				return link;

			} catch (System.DmlException ex) {

				String qualBotao = 'Ocorreu um erro no botão Nova Consultoria ' + ex.getMessage();
				String mensagem = montaErro2(qualBotao, ex);

				return mensagem;
			}
		}


	webservice static String enviarEmail(String id) {
		System.debug('Id ' + id);
		try {
			EnvioEmailConsultoriaController envioEmailConsultoriaController = new EnvioEmailConsultoriaController();
			String mensagem = envioEmailConsultoriaController.init(id);
			return ''.equals(mensagem) ? 'sucesso' : mensagem;
		} catch (Exception ex) {
			return ex.getMessage();
		}
	}

	public static String montaErro2(String qualBotao, System.DmlException ex)
	{
		String mensagem;
		String erroMensagem;
       
        mensagem = qualBotao + ' ' + ex.getCause();
       
        /*
		if (StatusCode.FIELD_CUSTOM_VALIDATION_EXCEPTION == ex.getDmlType(0)) {
			erroMensagem = ex.getDmlMessage(0);
			String[] textoErro = erroMensagem.split(',,');
			if (textoErro != null && !textoErro.isEmpty()) {
				mensagem = textoErro[1];
			} else {
				mensagem = qualBotao;
			}
		} else {
			mensagem = qualBotao;
		}
		*/

		return mensagem;
	}

}