public with sharing class IntegracaoDistribuicaoOrdemVendaTO {

	public String AUART	{ get; set; }		//Tipo de documento de vendas	- CHAR 4
	public String BSTKD	{ get; set; }		//Numero do pedido do cliente	- CHAR 35
	public String KOSTL	{ get; set; }		//Centro de custo				- CHAR 10
	public String KUNNR	{ get; set; }		//Numero Cliente				- CHAR 10
	public String SPART { get; set; } 		//Setor de atividade			- CHAR 2
	public List<IntegracaoOrdemVenda> T_ITEMS	{ get; set; }
	public String VKORG { get; set; } 		//Organizacao de vendas			- CHAR 4
	public String VTWEG	{ get; set; }		//Canal de distribuicao			- CHAR 2

	public class IntegracaoOrdemVenda{
		public String MATNR		{ get; set; } 		//Numero do Material	- CHAR 18
		public String DZMENG  	{ get; set; } 		//Quantidade			- DECIMAL 14
		public String KWERT		{ get; set; } 		//verificar qual informação deve ser mandado
		public String WERKS		{ get; set; }		//Centro
	}


	public IntegracaoDistribuicaoOrdemVendaTO(BR_DistribuicaoGratuita__c distribuicaoGratuita)
		{
			List<IntegracaoOrdemVenda> listaOV = new List<IntegracaoOrdemVenda>();

			AUART = String.valueOf(distribuicaoGratuita.BR_TipoOrdemVenda__c);
			VKORG = String.valueOf(distribuicaoGratuita.BR_CodigoOrganizacaoVenda__c);
			VTWEG = String.valueOf(distribuicaoGratuita.BR_CodigoCanalDistribuicao__c);
			SPART = String.valueOf(distribuicaoGratuita.BR_CodigoSetorAtividade__c);
			BSTKD = String.valueOf(distribuicaoGratuita.Name);
			KUNNR = String.valueOf(distribuicaoGratuita.BR_Aos_Cuidados_de_Account_Contact__r.Account__r.BR_Account_Id_SAP__c);
			//KUNNR = '0000128334';
			KOSTL = String.valueOf(distribuicaoGratuita.BR_CentroCusto__c);

			for(BR_ProdutoDistribuicaoGratuita__c item : distribuicaoGratuita.ProdutosDistribuicaoGratuita__r)
				{
					IntegracaoOrdemVenda integracaoOrdemVenda = new IntegracaoOrdemVenda();
					integracaoOrdemVenda.MATNR = String.valueOf(item.BR_ISBN__c);
					integracaoOrdemVenda.DZMENG = String.valueOf(item.BR_Quantidade__c);
					integracaoOrdemVenda.KWERT = String.valueOf(item.BR_PrecoCusto__c);
					integracaoOrdemVenda.WERKS = String.valueOf(distribuicaoGratuita.BR_Centro__c);

					listaOV.add(integracaoOrdemVenda);
				}
			this.T_ITEMS = listaOV;
		}
}