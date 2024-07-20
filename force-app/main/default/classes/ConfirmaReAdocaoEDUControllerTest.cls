@IsTest
public with sharing class ConfirmaReAdocaoEDUControllerTest {
    
    @IsTest
    static void shouldTestController() {

        User userToRun = [
            SELECT Id FROM User WHERE Profile.Name LIKE '%admin%' AND ManagerId != null AND isActive = true LIMIT 1
        ];

        System.runAs(userToRun){

            Account account = new Account();
            account.Name = 'Test';
            insert account;

            Contact contact = new Contact();
            contact.LastName = 'Test';
            contact.AccountId = account.Id;
            insert contact;

            Course_Structure_Discipline__c course = new Course_Structure_Discipline__c();
            course.Type__c = 'CURSO';
            course.BR_Discipline_code__c = '123';
            insert course;

            Account_Contact__c accountContact = new Account_Contact__c();
            accountContact.RecordTypeId = Schema.SObjectType.Account_Contact__c.getRecordTypeInfosByDeveloperName().get('Franquias').getRecordTypeId(); 
            accountContact.Name = '';
            accountContact.CPF__c = '11111111111';
            accountContact.Email__c = 'test@example.com';
            accountContact.Account__c = account.Id;
            accountContact.Contact__c = contact.Id;
            accountContact.Curso__c = course.Id; 
            insert accountContact;

            Opportunity opp = new Opportunity();
            opp.Name = 'Test';
            opp.StageName = 'Adotado';
            opp.CloseDate = System.Today().addDays(30);
            opp.AccountId = account.Id;
            opp.BR_Account_Contact__c = accountContact.Id;
            insert opp;

            PricebookEntry ent = TestHelper.createPricebookEntry();
            insert ent;
            
            OpportunityLineItem opL = new OpportunityLineItem();
            opL.PricebookEntryId = ent.Id;
            opL.OpportunityId = opp.Id;
            opL.Quantity = 10;
            opL.TotalPrice = 100;
            opL.BR_StatusProduto__c = true;
            insert opL;

            Test.startTest();
            
            PageReference pageRef = Page.PesquisaSatisfacao;
            Test.setCurrentPage(pageRef);
            ApexPages.currentPage().getParameters().put('RespEmail', opp.Id);

            ConfirmaReAdocaoEDUController controller = new ConfirmaReAdocaoEDUController();

            controller.confirmarSalvar();
            controller.naoConfirmaAdocao();

        }
    }

}