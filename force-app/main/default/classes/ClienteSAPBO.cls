public class ClienteSAPBO {

	static final String PROFILE_ENVIAR_EMAIL = 'Cadastro';
	static final String ROLE_ENVIAR_EMAIL = 'Financeiro';


	public static String atualizarClienteLocalAPartirDoSAP(List<Account> accounts) {

		String  CPF_CNPJ;
		String retorno = '';
		for (Account acc :accounts) {
			CPF_CNPJ = acc.BR_cnpj__c.replaceAll('[^\\d]', '');
			String retornoRaw = '';
			ClienteSAPPOJO A = new ClienteSAPPOJO();
			Map<String, String> retornos = A.buscarClienteSAP(CPF_CNPJ);
			List<String> ovsExistentes = new List<String>();
			Map<String, ClienteSAPPOJO.RootObject> B = new Map<String, ClienteSAPPOJO.RootObject>();
			for (String key :retornos.keySet()) {
				retornoRaw = retornoRaw + '\n----------' + retornos.get(key);
				B.put(key, A.parse(retornos.get(key)));

				if(B.get(key).Data.Tables [0].Structures.size()
				   > 0) {
					ovsExistentes.add(key);
				}

			}

			acc.StatusConsultaCliente__c = retornoRaw;

			acc.Produtos__c = '';
			for (String ov :ovsExistentes) {
				acc.Produtos__c = acc.Produtos__c + ',' + ov;
			}
			if(acc.Produtos__c.length() > 0) {
				acc.Produtos__c.substring(1);
			}

			if(ovsExistentes.size() > 0) {
				String Nome = B.get(ovsExistentes.get(0)).Data.Tables [0].Structures [0].NAME1;
				String Estado = B.get(ovsExistentes.get(0)).Data.Tables [0].Structures [0].REGIO;
				Double LimiteCredito = Double.valueof(B.get(ovsExistentes.get(0)).Data.Tables [0].Structures [0].KLIMK.Replace(',', '.'));
				String Matriz = B.get(ovsExistentes.get(0)).Data.Tables [0].Structures [0].KNKLI;
				Double TotalDividaReceber = Double.valueof(B.get(ovsExistentes.get(0)).Data.Tables [0].Structures [0].SKFOR.replace(',', '.'));
				Double Saldo = Double.valueof(B.get(ovsExistentes.get(0)).Data.Tables [0].Structures [0].SALDO.replace(',', '.'));
				String CodCliente = B.get(ovsExistentes.get(0)).Data.Tables [0].Structures [0].KUNNR;



				acc.BR_Main_State__c = Estado;
				acc.BR_FI_Saldo_disponivel__c = Saldo;
				acc.BR_FI_Dividas_a_receber__c = TotalDividaReceber;
				acc.BR_FI_Limite_de_credito_do_cliente__c = LimiteCredito;
				acc.BR_Account_Id_SAP__c = CodCliente;
				acc.BR_Integrate_to_SAP__c = true;
				acc.BR_Integration_Status_SAP__c = 'Integrado ERP';
				update acc;
				retorno = B.get(ovsExistentes.get(0)).Status;
			} else {
				//Cliente não encontrado. Abrir caso
				string descricaoCaso = 'Conta: ' + CPF_CNPJ;
				CaseBO.criarCaso(descricaoCaso, acc.Id);

				// Procura os emails a serem enviados
				List<User> usuarios = [select id, Email, profile.name, UserRole.Name, IsActive FROM User where profile.name = :PROFILE_ENVIAR_EMAIL and UserRole.Name = :ROLE_ENVIAR_EMAIL and IsActive = true];

				EmailTemplate template = EmailTemplateDAO.getEmailTemplateByDeveloperName('Novo_Cliente_Cadastrar');

				String assunto = 'Cadastrar Cliente no ERP';

				Set<String> emailsEnviar = new Set<String>();
				String htmlBody = template.HtmlValue.replace('{URL}', URL.getSalesforceBaseUrl().toExternalForm() + '/' + acc.Id);

				for (User usuario :usuarios) {
					emailsEnviar.add(usuario.Email);
				}
				acc.BR_Integration_Status_SAP__c = 'Cliente não encontrado no ERP';
				update acc;

				EmailUtil.getInstance().sendMail(emailsEnviar, htmlBody, assunto);
				retorno = 'Cliente não encontrado';
			}

			Integration_log__c Log = New Integration_log__c(ERP__c = '', 
														    Account__c = acc.Id, 
														    Status__c = retorno, 
														    Message_Long__c = retornoRaw, 
														    Message__c = '', 
														    Oportunidade__c = null);
			insert(Log);


		}

		return retorno;
	}
	public static void buscarClientesInseridosUltimas24Horas() {

		List<Account> accs = [select CreatedDate, BR_cnpj__c, BR_Integrate_to_SAP__c from Account where CreatedDate = Yesterday and BR_Integrate_to_SAP__c = false and BR_cnpj__c != null];

		atualizarClienteLocalAPartirDoSAP(accs);

	}
}