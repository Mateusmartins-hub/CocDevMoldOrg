@IsTest
public class ProductsStockResourceTest {
    @IsTest
    static void insertProductStocksTest() {
        Product2 pdrt = TestHelper.createProduct();
        insert pdrt;

        ProductsStockResource.ProductStockInfo ps = new ProductsStockResource.ProductStockInfo();
        ps.idProduto = pdrt.Id;
        ps.quantidade  = 10;

        List<ProductsStockResource.ProductStockInfo> listStocks = new List<ProductsStockResource.ProductStockInfo>();
        listStocks.add(ps);

        String result = ProductsStockResource.insertProductStocks(listStocks);

        System.assertEquals('OK', result);
    }
}