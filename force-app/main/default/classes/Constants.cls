public with sharing class Constants {
	// URL e Chaves para acesso ao ESB

	//
	// Amostra - RFC ZSD_ORDEM_VENDA_BR
	//
	// Homologação
	/*
	 public static final String AMOSTRA_ESB_URL = 'http://integrationdev.pearson.com.br/rfc';
	 public static final String AMOSTRA_ESB_KEY = '42963.83939217776';
	 public static final String AMOSTRA_ESB_USER = 'umiosro';
	 public static final String AMOSTRA_ESB_CONNECTIONNAME = 'SAP_QAS';
	 public static final String AMOSTRA_ESB_APPLICATION = 'SAP';
	 public static final String AMOSTRA_ESB_RFC = 'ZSD_ORDEM_VENDA_BR';
	 */
	// Produção

	public static final String AMOSTRA_ESB_URL = 'https://integration.pearson.com.br/rfc';
	public static final String AMOSTRA_ESB_KEY = '59796.65995109826';
	public static final String AMOSTRA_ESB_USER = 'umiosro';
	public static final String AMOSTRA_ESB_CONNECTIONNAME = 'SAP_PRD';
	public static final String AMOSTRA_ESB_APPLICATION = 'SAP';
	public static final String AMOSTRA_ESB_RFC = 'ZSD_ORDEM_VENDA_BR';
    
    //
    // Cadastro de cliente - RFC ZBRFSD_CRM_CREATECUSTOMER
    // Homologação
    /*
    public static final String CADCLI_ESB_URL = 'http://integrationdev.pearson.com.br/rfc';
    public static final String CADCLI_ESB_KEY = '42963.83939217776';
    public static final String CADCLI_ESB_USER = 'umiosro';
    public static final String CADCLI_ESB_CONNECTIONNAME = 'SAP_QAS';
    public static final String CADCLI_ESB_APPLICATION = 'SAP';
    public static final String CADCLI_ESB_RFC = 'ZBRFSD_CRM_CREATECUSTOMER';
    */
    // Produção
    public static final String CADCLI_ESB_URL = 'https://integration.pearson.com.br/rfc';
    public static final String CADCLI_ESB_KEY = '42963.83939217776';
    public static final String CADCLI_ESB_USER = 'umiosro';
    public static final String CADCLI_ESB_CONNECTIONNAME = 'SAP_PRD';
    public static final String CADCLI_ESB_APPLICATION = 'SAP';
    public static final String CADCLI_ESB_RFC = 'ZBRFSD_CRM_CREATECUSTOMER';

	//
	// Amostra - ZSD_RETORNA_STATUS_ITENS_OV
	//
	// Homologação
	/*
	 public static final String AMOSTRA_ESB_STATUS_URL = 'http://integrationdev.pearson.com.br/rfc';
	 public static final String AMOSTRA_ESB_STATUS_KEY = '42963.83939217776';
	 public static final String AMOSTRA_ESB_STATUS_USER = 'umiosro';
	 public static final String AMOSTRA_ESB_STATUS_CONNECTIONNAME = 'SAP_QAS';
	 public static final String AMOSTRA_ESB_STATUS_APPLICATION = 'SAP';
	 public static final String AMOSTRA_ESB_STATUS_RFC = 'ZSD_RETORNA_STATUS_ITENS_OV';
	 */
	// Produção

	public static final String AMOSTRA_ESB_STATUS_URL = 'https://integration.pearson.com.br/rfc';
	public static final String AMOSTRA_ESB_STATUS_KEY = '59796.65995109826';
	public static final String AMOSTRA_ESB_STATUS_USER = 'umiosro';
	public static final String AMOSTRA_ESB_STATUS_CONNECTIONNAME = 'SAP_PRD';
	public static final String AMOSTRA_ESB_STATUS_APPLICATION = 'SAP';
	public static final String AMOSTRA_ESB_STATUS_RFC = 'ZSD_RETORNA_STATUS_ITENS_OV';

	//
	// ESTOQUE - ZSD_RETORNA_ESTOQUE_DISPONIVEL
	//
	// Homologação
	/*
	 public static final String ESTOQUE_ESB_URL = 'http://integrationdev.pearson.com.br/rfc';
	 public static final String ESTOQUE_ESB_KEY = '42963.83939217776';
	 public static final String ESTOQUE_ESB_USER = 'umiosro';
	 public static final String ESTOQUE_ESB_CONNECTIONNAME = 'SAP_QAS';
	 public static final String ESTOQUE_ESB_APPLICATION = 'SAP';
	 public static final String ESTOQUE_ESB_RFC = 'ZSD_ESTOQUE_DISPONIVEL_SF';
	 */

	// Produção

	public static final String ESTOQUE_ESB_URL = 'https://integration.pearson.com.br/rfc';
	public static final String ESTOQUE_ESB_KEY = '59796.65995109826';
	public static final String ESTOQUE_ESB_USER = 'umiosro';
	public static final String ESTOQUE_ESB_CONNECTIONNAME = 'SAP_PRD';
	public static final String ESTOQUE_ESB_APPLICATION = 'SAP';
	public static final String ESTOQUE_ESB_RFC = 'ZSD_ESTOQUE_DISPONIVEL_SF';


	//Clientes
    //QAS

	//public static final String CLIENTE_ESB_URL = 'http://integrationdev.pearson.com.br/rfc';
    //public static final String CLIENTE_ESB_KEY = '42963.83939217776';
    //public static final String CLIENTE_ESB_USER = 'umiosro';
    //public static final String CLIENTE_ESB_CONNECTIONNAME = 'SAP_QAS';
    //public static final String CLIENTE_ESB_APPLICATION = 'SAP';
    //public static final String CLIENTE_ESB_RFC = 'ZSD_VTEX_DADOS_CLIENTES';
    
    public static final String CLIENTE_ESB_URL = 'http://integration.pearson.com.br/rfc';
    public static final String CLIENTE_ESB_KEY = '42963.83939217776';
    public static final String CLIENTE_ESB_USER = 'umiosro';
    public static final String CLIENTE_ESB_CONNECTIONNAME = 'SAP_PRD';
    public static final String CLIENTE_ESB_APPLICATION = 'SAP';
    public static final String CLIENTE_ESB_RFC = 'ZSD_VTEX_DADOS_CLIENTES';

	//
	// VENDA ESPECIAL - DIRETO COM ESCOMMERCE
	//

	// Homologação
	//    public static final String VENDAESPECIAL_ESB_URL = 'https://ecollege.pearson.com.br/ws/vendaEspecial.asmx';
	// Produção

	public static final String VENDAESPECIAL_ESB_URL = 'https://ecollege.pearson.com.br/ws/vendaEspecial_producao.asmx';

	public static final String ORGANIZER_EMAIL = 'Pearson@pearson.com';
	//FILE UPLOAD CUSTOM
	public static final String VISIBILITY_ALLUSERS = 'AllUsers';
	public static final String SHRARED_TYPE = 'V';
	public static final String STATUS_PUBLICADO = 'Publicado';
	public static final String STATUS_ARQUIVADO = 'Arquivado';



}