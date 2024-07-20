public class IntegrarAmostraController {

	@AuraEnabled
	public static Boolean integrarAmostraFisica(String idAmostra) {
		AmostraFisica__c amostra = AmostraFisicaDAO.getAmostraFisicaById(idAmostra);

		if(amostra.Oportunidade__r.BR_Shipping_Address__c != 'Instituição')
			throw new AuraHandledException('O valor do campo "Endereço da entrega" tem que ser "Instituição"');
        
		if(amostra.Oportunidade__r.Probability < 20)
			throw new AuraHandledException('Oportunidade não passou pelo status de Amostra Física.');

		if(amostra.ItensAmostraFisica__r.isEmpty())
			throw new AuraHandledException('Amostra não contém nenhum produto.');

		validarEstoque(amostra.ItensAmostraFisica__r);
        
		/*String retorno = '';
		try{
			retorno = ClienteSAPController.BuscarClienteSAP(amostra.Oportunidade__r.Id);
		} catch(AuraHandledException e) {
			if(!e.getMessage().containsIgnoreCase('Conta já integrada com o SAP')) {
				throw e;
			}
		}
		if(retorno.equals('Cliente não encontrado')) {
			return retorno;
		}*/
        
        Boolean temErro = AmostraFisicaSAPIntegration.doIntegration(amostra);
		return temErro;
	}

	private static void validarEstoque(List<ItemAmostraFisica__c> itensAmostra) {
		Map<Id, ItemAmostraFisica__c> productAmostra = new Map<Id, ItemAmostraFisica__c>();
		for (ItemAmostraFisica__c itemAmostra :itensAmostra) {
			productAmostra.put(itemAmostra.Produto__c, itemAmostra);
		}

		List<EstoqueProdutos__c> estoques = EstoqueProdutosDAO.getEstoqueFromProductsId(productAmostra.keySet());

		Map<Id, EstoqueProdutos__c> estoquesMap = new Map<Id, EstoqueProdutos__c>();
		for (EstoqueProdutos__c estoque :estoques) {
			estoquesMap.put(estoque.Produto__c, estoque);
		}

		for (ItemAmostraFisica__c itemAmostra :itensAmostra) {
			if(!estoquesMap.containsKey(itemAmostra.Produto__c))
				throw new AuraHandledException('Não existe estoque para o produto ' + itemAmostra.Produto__r.Name);

			EstoqueProdutos__c estoque = estoquesMap.get(itemAmostra.Produto__c);
			if(itemAmostra.Quantidade__c > estoque.Quantidade__c) {
				throw new AuraHandledException('Não existem produtos suficientes no estoque do produto ' + estoque.Produto__r.Name);
			}
		}

	}

	public static void atualizarEstoque(AmostraFisica__c amostra) {
		Map<Id, ItemAmostraFisica__c> productAmostra = new Map<Id, ItemAmostraFisica__c>();
		for (ItemAmostraFisica__c itemAmostra :amostra.ItensAmostraFisica__r) {
			productAmostra.put(itemAmostra.Produto__c, itemAmostra);
		}

		List<EstoqueProdutos__c> estoques = EstoqueProdutosDAO.getEstoqueFromProductsId(productAmostra.keySet());

		for (EstoqueProdutos__c estoque :estoques) {
			ItemAmostraFisica__c itemAmostra = productAmostra.get(estoque.Produto__c);
			if(itemAmostra.Quantidade__c > estoque.Quantidade__c)
				throw new AuraHandledException('Não existem produtos suficientes no estoque ' + estoque.Produto__r.Name);

			estoque.Quantidade__c = estoque.Quantidade__c - itemAmostra.Quantidade__c;

		}

		update estoques;
	}

	public class CustomException extends Exception {}
}