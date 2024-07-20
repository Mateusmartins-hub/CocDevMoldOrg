@isTest
public with sharing class ConsultoriaBloqueioDeAcessosTest {
    
    @isTest
    static void deveriaCriarCasosParaAsConsultorias(){

        Account conta = new Account(
            Name = 'Teste'
        );
        insert conta;

        FR_Procedimento_Franquias__c consultoria1 = new FR_Procedimento_Franquias__c(
            RecordTypeId = Schema.SObjectType.FR_Procedimento_Franquias__c.getRecordTypeInfosByDeveloperName().get('Retencao_Escolas').getRecordTypeId(),
            BR_Conta__c = conta.Id,
            Fase__c = 'Bloqueio de Acessos'
        );
        insert consultoria1;
        Test.setCreatedDate(consultoria1.Id, System.Now().addYears(-1));

        FR_Procedimento_Franquias__c consultoria2 = consultoria1.clone();
        consultoria2.Fase__c = 'Preparação';
        insert consultoria2;
        Test.setCreatedDate(consultoria2.Id, System.Now().addYears(-1));

        List<Case> casosExistentesAntes = [SELECT Id FROM Case];
        System.assertEquals(0, casosExistentesAntes.size());

        Test.startTest();
        Database.executeBatch(new ConsultoriaBloqueioDeAcessos());
        Test.stopTest();

        List<Case> casosExistentesApos = [SELECT Id FROM Case];
        System.assertEquals(1, casosExistentesApos.size());



    }
}