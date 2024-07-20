@IsTest
public class CriarCasoAPartirAtividadeControllerTest {
    
    @IsTest
    static void shouldTest(){

        Account account = new Account(
            Name = 'Test',
            Marca__c = 'Wizard'
        );
        insert account;

        Task task = new Task(
            WhatId = account.Id,
            Description = 'Task test',
            Status = 'Open'
        );
        insert task;

        Case cs = new Case(
            Subject = 'Test',
            AccountId = account.Id
        );
        insert cs;
        
        Test.startTest();

        ApexPages.StandardController sc = new ApexPages.StandardController(cs);
        PageReference pageRef = Page.CriarCasoAPartirAtividade;
        Test.setCurrentPage(pageRef);
        ApexPages.currentPage().getParameters().put('tarefaId', task.Id);

        CriarCasoAPartirAtividadeController controller = new CriarCasoAPartirAtividadeController(sc);

        List<SelectOption> options = controller.getRecordTypes();
        controller.selected = options[0].getValue();
        controller.abrirPagina();

        Test.stopTest();
        
        
        
    }
}