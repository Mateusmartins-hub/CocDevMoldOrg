@isTest
public class EnviarAmostraControllerTest {
    
    @isTest
    static void testOne() {
        Product2 prod = InstanceToClassCoverage.createProduct2();
        prod.BR_ISBN__c = '123321';
        prod.BR_Digital_Product__c = true;
        insert prod;
        
        PricebookEntry pricEntry = InstanceToClassCoverage.createPricebookEntry();
        pricEntry.Product2Id 	= prod.Id;
        pricEntry.Pricebook2Id 	= Test.getStandardPricebookId();
        insert pricEntry;
        
        Contact individuo = InstanceToClassCoverage.createIndividuo();
        insert individuo;
        
        Amostra_Virtual__c amostraVirtual = new Amostra_Virtual__c();
        amostraVirtual.Amostra__c = prod.Id;
        amostraVirtual.Individuo__c = individuo.Id;
        
        insert amostraVirtual;
        
        EnviarAmostraController.salvar(amostraVirtual.Id);
    } 
}