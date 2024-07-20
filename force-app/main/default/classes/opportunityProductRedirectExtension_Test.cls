@isTest (Seealldata = true)
public class opportunityProductRedirectExtension_Test {
    @isTest static void Test1(){
        User u1 = new User(
            Alias = 'standt1', 
            Email='standarduser1@pearson.br', 
            EmailEncodingKey='UTF-8', 
            LastName='Testing', 
            LanguageLocaleKey='pt_BR', 
            LocaleSidKey='pt_BR', 
            ProfileId = UserInfo.getProfileId(), 
            TimeZoneSidKey='America/Sao_Paulo', 
            UserName='standarduser1@pearson.br'
            
        );
        u1.ManagerId = UserInfo.getUserId();
        insert u1;
        
        
        Opportunity opp = new Opportunity(
            Name = 'Test Class Opp Name',
            StageName = 'Sem Interesse',
            CloseDate = System.Today(),
            Description = 'Teste',
            OwnerId = [SELECT Id FROM User WHERE UserName = 'standarduser1@pearson.br' LIMIT 1].Id
        );
        insert opp;
        
        Product2 p2 = new Product2();
        p2.Name = 'Teste';
        insert p2;
        
        Pricebook2 pb = [select id from Pricebook2 where isStandard=true];
        //pb.IsStandard = true;
        //pb.Name = 'Teste';
        //insert pb;
        
        PricebookEntry pbe = new PricebookEntry();
        pbe.UnitPrice = 10;
        pbe.Pricebook2Id = pb.Id;
        pbe.Product2Id = p2.Id;
        pbe.IsActive = true;
        insert pbe;
        
        OpportunityLineItem item = new OpportunityLineItem();
        item.OpportunityId = opp.Id;
        item.Quantity = 1.0;
        item.TotalPrice = 10;
        item.PricebookEntryId = pbe.Id;
        insert item;
        
        PageReference pageRef = Page.opportunityProductRedirect;
        
        Test.setCurrentPage(pageRef);
        ApexPages.currentPage().getParameters().put('id', opp.Id);
        ApexPages.StandardController sc = new ApexPages.standardController(item);
        opportunityProductRedirectExtension controller = new opportunityProductRedirectExtension(sc);
        controller.redirect();
        
    }
}