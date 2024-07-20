@IsTest
public class PesquisaSatisfacaoControllerTest {
    
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

            Test.startTest();
            
            PageReference pageRef = Page.PesquisaSatisfacao;
            Test.setCurrentPage(pageRef);
            ApexPages.currentPage().getParameters().put('RespEmail', opp.Id);

            PesquisaSatisfacaoController controller = new PesquisaSatisfacaoController();

            System.assert(controller.lstPerg1.size() > 0);
            System.assert(controller.lstPerg2.size() > 0);
            System.assert(controller.lstPerg3.size() > 0);
            System.assert(controller.lstPerg4.size() > 0);
            System.assert(controller.lstPerg5.size() > 0);
            System.assert(controller.lstPerg6.size() > 0);
            System.assert(controller.lstPerg7.size() > 0);
            System.assert(controller.lstPerg8.size() > 0);
            System.assert(controller.lstPerg9.size() > 0);

            controller.tela1 = true;
            
            controller.pesqSat.Resposta1 = '-';
            controller.pesqSat.Resposta2 = '-';
            controller.pesqSat.Resposta3 = '-';
            controller.pesqSat.Resposta4 = '-';
            controller.pesqSat.Resposta5 = '-';
            controller.pesqSat.Resposta6 = '-';
            controller.pesqSat.Resposta7 = '-';
            controller.pesqSat.Resposta8 = '-';
            controller.pesqSat.Resposta9 = '-';

            controller.ProximaFase();
            System.assert(controller.tela1 = true);
            controller.pesqSat.Resposta1 = '1';
            controller.ProximaFase();
            controller.pesqSat.Resposta2 = 'Site da Pearson';
            controller.ProximaFase();
            controller.pesqSat.Resposta3 = 'Indiferente';
            controller.ProximaFase();
            controller.pesqSat.Resposta4 = 'Sim';
            controller.ProximaFase();
            controller.pesqSat.Resposta5 = 'Sim';
            controller.ProximaFase();
            controller.pesqSat.Resposta6 = 'Sim';
            controller.ProximaFase();
            System.assert(controller.tela2 = true);


            controller.pesqSat.Resposta7 = 'Uso pessoal';
            controller.ProximaFase2();
            controller.pesqSat.Resposta8 = 'Sim';
            controller.ProximaFase2();
            controller.pesqSat.Resposta9 = 'Anualmente';
            controller.ProximaFase2();
            System.assert(controller.tela3 = true);

            controller.confirmarSalvar();

            Test.stopTest();

        }
    }
}