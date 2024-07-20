@isTest
private class AmostraVirtualBOTest {

    static testMethod void myUnitTest() {
            Test.startTest();
    		//Pricebook2 pric2 = [SELECT Id from Pricebook2 where IsStandard = true limit 1];
			
			Product2 prod = InstanceToClassCoverage.createProduct2();
			prod.BR_ISBN__c = '123321';
			prod.BR_Digital_Product__c = true;
			insert prod;
			 
			PricebookEntry pricEntry = new PricebookEntry(); //InstanceToClassCoverage.createPricebookEntry();
			pricEntry.Product2Id 	= prod.Id;
			pricEntry.Pricebook2Id 	= Test.getStandardPricebookId(); //pric2.Id;
        	pricEntry.UnitPrice		= 23;
			pricEntry.IsActive		= true; 
			insert pricEntry;
				
			Contact individuo = InstanceToClassCoverage.createIndividuo();
			insert individuo;
			
			Amostra_Virtual__c amostraVirtual = new Amostra_Virtual__c();
			amostraVirtual.Amostra__c = prod.Id;
			amostraVirtual.Individuo__c = individuo.Id;
			
			insert amostraVirtual;
			
			amostraVirtual.Enviado__c = true;
			update amostraVirtual;
        	Test.stopTest();
    }
}