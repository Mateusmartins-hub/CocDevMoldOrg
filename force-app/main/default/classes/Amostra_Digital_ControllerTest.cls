/*******************************************************************************
*                     Copyright (C) 2013 - Cloud2b
*-------------------------------------------------------------------------------
*
* Classe que faz o teste de cobertura da classe Amostra_Digital_Controller
* NAME: Amostra_Digital_ControllerTest.cls
* AUTHOR: ROGERIO ALVARENGA                         DATE: 03/07/2013
*
*******************************************************************************/

@isTest( seeAllData = false )
private class Amostra_Digital_ControllerTest {
  static testMethod void myUnitTest() {

    User userToRun = [
      SELECT Id FROM User WHERE Profile.Name LIKE '%admin%' AND ManagerId != null AND isActive = true LIMIT 1
    ];
    
    System.runAs(userToRun){
      Opportunity opp = new Opportunity(
            Name = 'Test Class Opp Name',
            StageName = 'Sem Interesse',
          CloseDate = System.Today()
      );
    opp.Description = 'Teste';
    insert opp;
        
    Product2 p2 = new Product2();
        p2.Name = 'Teste';
        insert p2;
        
        Pricebook2 pb = new Pricebook2();
        pb.Name = 'Teste';
        insert pb;
        
        PricebookEntry pbe = new PricebookEntry();
        pbe.UnitPrice = 10;
        pbe.Pricebook2Id = Test.getStandardPricebookId();
        pbe.Product2Id = p2.Id;
        pbe.IsActive = true;
        insert pbe;
        
        OpportunityLineItem item = new OpportunityLineItem();
        item.OpportunityId = opp.Id;
        item.Quantity = 1.0;
        item.TotalPrice = 10;
        item.PricebookEntryId = pbe.Id;
        insert item;

    Test.startTest();
      Amostra_Digital_Controller lController = new Amostra_Digital_Controller();
      lController.OpportID = Opp.Id;
      lController.getOpp();
      lController.getOppItems();
      Test.stopTest();
    }
  }
}