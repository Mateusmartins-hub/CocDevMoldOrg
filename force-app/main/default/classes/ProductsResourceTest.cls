@isTest
public class ProductsResourceTest {
    
    @isTest
    static void testOne() {
        ProductsResource.ProductInfo prd = new ProductsResource.ProductInfo();
        prd.name = 'Test';
        prd.code = 'Test';
        
        System.debug(ProductsResource.insertProducts(new List<ProductsResource.ProductInfo> {prd}));
    }
}