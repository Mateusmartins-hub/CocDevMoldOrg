@IsTest
public with sharing class PesquisaSatisfacaoLivroControllerTest {
    
    @IsTest
    static void shouldTestController(){
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
            opp.StageName = 'Fase inicial';
            opp.CloseDate = System.Today().addDays(30);
            opp.AccountId = account.Id;
            opp.BR_Account_Contact__c = accountContact.Id;
            insert opp;
            
            RespostaEmail__c respEmail = new RespostaEmail__c();
            respEmail.BR_IdOportunidade__c = opp.Id;
            respEmail.Livro__c = 'Livro test';
            insert respEmail;

            Test.startTest();
            
            PageReference pageRef = Page.PesquisaSatisfacaoLivro;
            Test.setCurrentPage(pageRef);
            ApexPages.currentPage().getParameters().put('RespEmail', respEmail.Id);

            PesquisaSatisfacaoLivroController controller = new PesquisaSatisfacaoLivroController();

            controller.AvaliaLivro = '-';
            controller.adotaLivro = '-';
            controller.salaVirtual = '-';
            controller.seNao = '-';
            controller.salaVirtual = '-';
            controller.seSim = '-';
            controller.salaVirtual = '-';
            controller.recomenda = '-';

            controller.validaCampos();
            controller.AvaliaLivro = '10';
            controller.validaCampos();
            controller.adotaLivro = 'Sim';
            controller.validaCampos();
            controller.salaVirtual = 'Sim';
            controller.validaCampos();
            controller.seSim = '1';
            controller.validaCampos();
            controller.salaVirtual = 'Não';
            controller.validaCampos();
            controller.seNao = '1';
            controller.validaCampos();
            controller.recomenda = 'Sim';
            controller.validaCampos();

            controller.confirmarSalvar();


            


        }
    }

}