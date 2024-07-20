public with sharing class AccountBO
{
	public AccountBO() {}
    
    public static final AccountBO instance = new AccountBO();

	public static AccountBO getInstance()
		{
			return instance;
		}

	public void preencherTipoRegistro(List<Account> contas)
		{
			Id idPessoaFisica = RecordTypeUtil.getInstance().getRecordTypePorNome('Account', 'Pessoa Física').getRecordTypeId();
			Id idPessoaJuridica = RecordTypeUtil.getInstance().getRecordTypePorNome('Account', 'Pessoa Jurídica').getRecordTypeId();

			for(Account conta : contas)
				{
					if(conta.TipoRegistroAuxiliar__c != '')
					{
						if(conta.TipoRegistroAuxiliar__c == 'PessoaFisica')
						{
							conta.RecordTypeId = idPessoaFisica;
						}
						else if(conta.TipoRegistroAuxiliar__c == 'PessoaJuridica')
						{
							conta.RecordTypeId = idPessoaJuridica;
						}
					}
				}
		}

	public void preencherCodigoIBGEConta(List<Account> contas)
		{
			// Sets to store the fields UF and City from the Account
			Set<String> lstUF = new Set<String>();
			Set<String> lstCity = new Set<String>();

			List<IBGE_Code__c> lstIBGECode = null;

			// Map to store the IBGE Code, referred by a string formed by the concatenation of the fields UF_acronym__c and City_name__c
			Map<String, IBGE_Code__c> mapIBGE = new Map<String, IBGE_Code__c>();

			// Loops through the triggered itens, getting the UF and City names
			for(Account conta : contas)
				{
					lstUF.add(conta.BillingState);
					lstCity.add(conta.BillingCity);
				}
			// Retrieves the IBGE Code from the object IBGE_Code__c, using the UF and City lists
			lstIBGECode = [SELECT Id, UF_acronym__c, City_name__c, Name
					FROM IBGE_Code__c
					WHERE UF_acronym__c = :lstUF
			AND City_name__c = :lstCity];

			// For each IBGE Code on the list, record on the map the object, with the concatenation of the fields
			// UF_acronym__c and City_name__c as key
			for(IBGE_Code__c ibgeCode : lstIBGECode)
				{
					if(ibgeCode.UF_acronym__c != null && ibgeCode.City_name__c != null )
					{
						mapIBGE.put(ibgeCode.UF_acronym__c.toUpperCase() + ibgeCode.City_name__c.toUpperCase(), ibgeCode);
					}
				}
			// Retrieves the IBGE Code from the map and put it on the Account's IBGE_Code__c field
			for(Account acc : contas)
				{
					IBGE_Code__c ibgeCode;
					if(acc.BillingState != null && acc.BillingCity != null )
					{
						ibgeCode = mapIBGE.get( acc.BillingState.toUpperCase() + acc.BillingCity.toUpperCase());
					}
					if(ibgeCode != null )
					{
						acc.IBGE_Code__c = ibgeCode.Id;
					}
				}
		}
	public Database.QueryLocator ExcluirConta(String query){
		return AccountDAO.listarContaExcluir(query);
	}

    /*
	public void criarContaSAP(List<SObject> lstContasAtuais, Map<Id, SObject> mapContasAnteriores)
		{
			Account contaAnterior = null;
			Set<Id> idsContas = new Set<Id>();

			for(Account contaAtual : (List<Account>)lstContasAtuais)
				{
					contaAnterior = (Account)mapContasAnteriores.get(contaAtual.Id);

					if(contaAtual.BR_Integrar__c && !contaAnterior.BR_Integrar__c)
					{
						idsContas.add(contaAtual.Id);
					}
				}
			if(!idsContas.isEmpty())
			{
				integrar(idsContas);
			}
		}
    
	@future(callout = true)
	public static void integrar(Set<Id> idsContas)
		{
			//List<Account> contasIntegrar = AccountDAO.getInstance().buscarContas(idsContas);
			//AccountBO.getInstance().integrar(contasIntegrar);
		}

	

	public void integrar(List<Account> contas)
		{
			
			List<Account> contasAtualizar = new List<Account>();
			IntegracaoConta integracao = IntegracaoContaFactory.getIntegracaoConta();
			for(Account conta : contas)
				{
					IntegracaoContaTO registros = new IntegracaoContaTO(conta);
					IntegracaoRetornoTO retorno = integracao.criar(registros);
					System.debug('RETORNO: ' + retorno);

					if(retorno.status == 'OK')
					{
						conta.BR_Account_Id_SAP__c = retorno.retorno;
						conta.BR_ErroIntegracao__c = false;
						conta.BR_LogIntegracao__c  = '';
						contasAtualizar.add(conta);
					}
					else
					{
						conta.BR_LogIntegracao__c  = retorno.retorno;
						conta.BR_ErroIntegracao__c = true;
						contasAtualizar.add(conta);
					}
				}
			Database.update(contasAtualizar);
			
		}


	public void enviaAprovacao(List<Account> contas)
		{

			for (Account a : contas) {
				Approval.ProcessSubmitRequest req1 = new Approval.ProcessSubmitRequest();
				req1.setObjectId(a.id);
				Approval.ProcessResult result = Approval.process(req1);

			}

		}
*/

//	public Database.QueryLocator buscarContasErroIntegracao()
//		{
//			return AccountDAO.getInstance().buscarContasErroIntegracao();
//		}

	public FR_Procedimento_Franquias__c criaVinculoConsultoria(String contasId, String recTypeName)
		{
			FR_Procedimento_Franquias__c consultoria = new FR_Procedimento_Franquias__c();
			System.debug('Entrou aqui');
			System.debug('recTypeName ' + recTypeName);

			//consultoria.RecordTypeId = RecordTypeMemory.getRecType('FR_Procedimento_Franquias__c', recTypeName);
			consultoria.RecordTypeId = RecordTypeUtil.getInstance().getRecordTypePorNome('FR_Procedimento_Franquias__c', recTypeName).getRecordTypeId();
			System.debug('RecordTypeId - ' + consultoria.RecordTypeId);
			consultoria.BR_Conta__c = contasId;
			upsert consultoria;
			return consultoria;
		}

}