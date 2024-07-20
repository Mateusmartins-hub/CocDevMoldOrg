public class Product2DAO {

	public static Product2 getProduct2ById(string productId){
		return [SELECT
					Id,
					Name,
					BR_Product_Code__c,
					BR_PrecoCusto__c
				From Product2
				Where Id =: productId limit 1];
	}

	public static list<Product2> listaProduto(list<string> lProductId){
	return [SELECT
				Id,
				Name,
				BR_Product_Code__c,
				BR_PrecoCusto__c,
				BR_ISBN__c
			From Product2
			Where Id IN :lProductId];
	}

	public static List<Product2> getProductsByISBN(Set<String> ISBNS) {
		return [SELECT Id, BR_ISBN__c FROM Product2 WHERE BR_ISBN__c IN :ISBNS];
	}
}