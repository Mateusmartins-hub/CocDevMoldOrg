public with sharing class TesteSetup 
{ 
    @TestVisible
    private static final TesteSetup instance = new TesteSetup();

    private TesteSetup(){}

    public static TesteSetup getInstance()
    {
        return instance;
    }

    public Account criarConta()
    {
        Account conta = new Account();
        conta.RecordTypeId = RecordTypeUtil.getInstance().getRecordTypePorNome('Account', 'Pessoa Física').getRecordTypeId();
        conta.Name = 'Teste Validação';
        conta.BR_Approval_status__c = 'Em elaboração';
        conta.BR_CPF__c = '433.354.278-23';
        conta.BR_Funcao__c = 'Professor';
        conta.BR_Gender__c = 'MASCULINO';
        conta.BR_Birthdate__c = '11/01/1988';
        conta.BR_LinhaDeNegocio__c = 'Educação Básica';
        conta.Phone = '5943-0222';
        conta.BR_Account_email__c = 'teste@validacao.com';
        conta.BR_Bairro__c = 'Teste';
        conta.BR_ShippingAddressComplement__c = 'N/A';
        conta.BR_Account_Id_SAP__c = '012345';
        conta.BillingStreet = 'Teste Rua 2';
        conta.BillingPostalCode = '00000-010';
        conta.BillingCountry = 'Brasil';
        return conta;
    }

    public Contact criarContato(Account conta)
    {
        Contact contato = new Contact();
        contato.FirstName = 'Primeiro nome contato';
        contato.LastName = 'Contato Teste';
        contato.BR_CPF__c = '433.354.278-23';
        contato.Phone = '99787-7788';
        contato.Email = 'teste@validacao.com';
        contato.Fun_o__c = 'Coordenador Pedagógico';
        contato.AccountId = conta.Id;
        return contato;
    }

    public ParametrizacaoCasos__c criarParametrizacao()
    {
        ParametrizacaoCasos__c param = new ParametrizacaoCasos__c();
        param.Tipo__c = 'Comercial';
        param.Subtipo__c = 'Processo';
        //param.Detalhamento__c = 'Juizado Especial Civil';
        param.Detalhamento2__c = '';
        //param.SLATotal__c = '100';
        //param.Chave__c = 'ComercialProcessoJuizado Especial Civil';
        return param;
    }

    public CamposObrigatorios__c criarCamposObrigatorios(ParametrizacaoCasos__c param)
    {
        CamposObrigatorios__c campo = new CamposObrigatorios__c();
        campo.CampoObrigatorio__c = 'BR_InformacaoASerAlteradaIncorreta__c';
        campo.Chave__c = '1Cadastro / Gestão de ContratosBR_InformacaoASerAlteradaIncorreta__c';
        campo.GrupoSolucionador__c = 'Cadastro / Gestão de Contratos';
        campo.ParametrizacaoCasos__c = param.Id;
        campo.Sequencia__c = '1';
        campo.MensagemErro__c = '"Informação a ser Alterada/Incorreta".';
        return campo;
    }
	/*
    public Grupos_Solucionadores__c criarGruposSolucionadores(ParametrizacaoCasos__c param){
        Grupos_Solucionadores__c grupo = new Grupos_Solucionadores__c();
        grupo.BR_Parametrizacao_Casos__c = param.Id;
        grupo.BR_Chave_Grupo_Solucionador__c = param.Chave__c;
        grupo.BR_Sequencia__c = 1;
        grupo.BR_SLA_em_minutos__c = 900;
        grupo.Name = 'Cadastro / Gestão de Contratos';
        return grupo;
    }
    */

    public Case criarCaso(Account conta, Contact contato)
    {
        Case caso = new Case();
        caso.RecordTypeId = RecordTypeUtil.getInstance().getRecordTypePorNome('Case', 'Demanda Interna').getRecordTypeId();
        caso.AccountId = conta.Id;
        caso.ContactId = contato.Id;
        //caso.Resumo__c = 'Teste';
        caso.BR_Grupo_Solucionador__c = 'Customer Care';
        caso.BR_MarcaSegmentoNegocio__c = 'COC';
        caso.BR_NumeroMarco__c = '1';
        caso.SLATotal__c = '100';
        caso.Status = ' 1 - Aguardando Cliente';
        caso.Reason = 'Solicitação';
        caso.Origin = 'Telefone';
        caso.Priority = 'Média';
        caso.Type = 'Cadastro';
        //caso.Subtipo__c = 'Novo Cadastro';
        caso.Detalhamento_del__c = 'Novo Cliente';
        caso.BR_Detalhamento2__c = '';
        caso.Subject = 'Teste';
        caso.Description = 'Teste';
        caso.BR_Rua__c = 'Avenida Teste de classe';
        caso.BR_Numero__c = '666';
        caso.BR_CEP__c = '00000000';
        caso.BR_Bairro__c = 'Vale do Teste';
        caso.BR_CidadeConta__c = 'Teste de sucesso';
        caso.BR_EstadoConta__c = 'XX';
        caso.BR_InformacaoASerAlteradaIncorreta__c = 'teste';
        return caso;
    }

    public Entitlement criaDireito(Account conta)
    {
        Entitlement direito = new Entitlement();
        direito.Name = 'Direito Teste marco';
        direito.AccountId = conta.Id;
        direito.Chave__c = 'ComercialProcessoJuizado Especial Civil';
        return direito;
    }

//    public InstanciaIntegracao__c criaParametrizacaoIntegracaoConta()
//    {
//      InstanciaIntegracao__c param = new InstanciaIntegracao__c();
//      param.Name = 'IntegracaoConta';
//      param.EndPoint__c = 'Teste';
//      param.ESBApplication__c = 'Teste';
//      param.ESBConnectionName__c = 'Teste';
//      param.ESBKey__c = 'Teste';
//      param.ESBRFC__c = 'Teste';
//      param.ESBUser__c = 'Teste';
//      param.Metodo__c = 'Teste';
//      param.NomeClasse__c = 'IntegracaoContaImpl';
//      param.TimeOut__c = 12000;
//      return param;
//    }
    
//    public InstanciaIntegracao__c criaParametrizacaoIntegracaoContaEndereco(){
//      InstanciaIntegracao__c param = TesteSetup.getInstance().criaParametrizacaoIntegracaoConta();
//      param.Name = 'IntegracaoContaEndereco';
//      param.NomeClasse__c = ' IntegracaoContaEnderecoImpl';
//      return param;
//    }

//    public IntegracaoCondPag__c criaParametrizacaoIntegracaoCondPag()
//    {
//      IntegracaoCondPag__c param = new IntegracaoCondPag__c();
//      param.Name = 'IntegracaoCondPag';
//      param.EndPoint__c = 'Teste';
//      param.ESBApplication__c = 'Teste';
//      param.ESBConnectionName__c = 'Teste';
//      param.ESBKey__c = 'Teste';
//      param.ESBRFC__c = 'Teste';
//      param.ESBUser__c = 'Teste';
//      param.Metodo__c = 'Teste';
//      param.TimeOut__c = 12000;
//      return param;
//    }

    public static List<Account> ObterContaContatoTest(Integer qtdeConta, Integer qtdeContatoDaConta) {
        List<Account> listaConta = new List<Account>();
        for(Integer i=0; i < qtdeConta; i++) {
            Account account = new Account(Name='TestAccount' + i, BR_Account_email__c = 'teste@teste.com',
                    BR_CPF__c = '507.124.836-08', BR_RG__c = '10.123.234-2', Phone = '9090-9090',
                    RecordTypeID =  RecordTypeMemory.getRecType( 'Account', 'Academic_Account'));
            listaConta.add(account);
        }
        insert listaConta;

        List<Contact> listaContato = new List<Contact>();
        for (Integer j=0; j < qtdeConta; j++) {
            Account contaCriada = listaConta[j];

            // Adiciona contato para cada conta
            for (Integer x=qtdeContatoDaConta; x < qtdeContatoDaConta + 1; x++) {
                listaContato.add(new Contact(firstname='Test',
                        lastname='Contact' + x, Phone = '9090-9090', Email = 'contato@teste.com',
                        AccountId = contaCriada.Id));
            }
        }
        insert listaContato;

        return listaConta;
    }

    public Opportunity ObterOportunidadeTest()
    {
        Account[] account = ObterContaContatoTest(1,1);

        Opportunity Opp = new Opportunity(Name = 'Oportunidade Test', StageName  = 'Elaboração',
                AccountID =  account[0].Id, CloseDate = System.today(), BR_shipping_type__c = 'Retira',
                RecordTypeId = RecordTypeMemory.getRecType('Opportunity', 'Indication'),
                Description = 'Opp Test');

        return Opp;
    }

    public BR_DistribuicaoGratuita__c obterDistribuicaoGratuita()
    {
        BR_DistribuicaoGratuita__c distribuicao = new BR_DistribuicaoGratuita__c(BR_AprovadorNivel1__c = '0051D000000H1XRQA0', BR_AprovadorNivel2__c = '0051D000000GhL6QAK',
                BR_CentroCusto__c = '1120102', BR_CodigoCanalDistribuicao__c = '01', BR_CodigoOrganizacaoVenda__c = 'OVE0', BR_CodigoSetorAtividade__c = '05',
                BR_Email__c = 'teste@teste.com.br', BR_IntegradoSucesso__c = false, BR_Integrar__c = false, BR_TipoOrdemVenda__c = 'ZMAP');

        return distribuicao;
    } 
    
}