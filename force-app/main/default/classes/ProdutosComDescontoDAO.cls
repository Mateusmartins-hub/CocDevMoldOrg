public class ProdutosComDescontoDAO 
{
	private static ProdutosComDescontoDAO instance = new ProdutosComDescontoDAO();

	private ProdutosComDescontoDAO(){ }

	public static ProdutosComDescontoDAO getInstance()
	{
		return instance;
	}

	public List<Produtos_com_desconto__c> getProdutos(List<String> lstContactsIds)  
	{
		return[ Select 
					Id,
					Autor__c,
					Data_do_pedido__c,
					Desconto__c,
					ISBN__c,
					Pedido_Site__c,
					Produto_Adquirido__c,
					Professor__c,
					Titulo__c,
					Titulo__r.Name
				From
					Produtos_com_desconto__c
				Where 
					Professor__c IN: lstContactsIds		
		];
	}
}