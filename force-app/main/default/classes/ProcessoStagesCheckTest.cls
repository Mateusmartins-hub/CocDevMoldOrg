@IsTest
public class ProcessoStagesCheckTest {
    @TestSetup
    static void makeData(){

        User userToRun = [
            SELECT Id FROM User WHERE Profile.Name LIKE '%admin%' AND ManagerId != null AND isActive = true LIMIT 1
        ];

        System.runAs(userToRun){
            Opportunity opp = TestHelper.createOpportunity();
            insert opp;        
        }
    }

    @IsTest
    static void testNurseryProcess() {
        Account acc = [SELECT Id FROM account];
        Opportunity opp = [SELECT Id FROM Opportunity];

        Processo__c processo = new Processo__c();
        processo.RecordTypeId = Schema.SObjectType.Processo__c.getRecordTypeInfosByDeveloperName().get('Nursery').getRecordTypeId();
        processo.DataEHoraApresentacao__c =  System.today();
        processo.EmailESenhasDosPortaisOk__c = true;
        processo.ApresentacaoDeBoasVindasOk__c = true;        
        processo.EmailPassaporte__c = true;
        processo.EmailBoasVindas__c = true;
        processo.KitBoasVindasEntregue__c = true;
        processo.LigAgendApresPedagogico__c = true;
        processo.DataHoraApresentacaoPedagogica__c = System.today();
        processo.ImplantacaoPedagogicaRealizada__c = true;
        processo.AvaliacaoSatisfacao__c = true;
        processo.Fase__c  = 'Ligação de Agendamento';
        processo.Conta__c = acc.Id;
        processo.Oportunidade__c = opp.id;
        insert processo;

        List<String> stageNames = new List<String>{'Apresentação de Boas Vindas', 'Enviar E-mails',
        'Confirmação Entrega Kit Boas Vindas', 'Agendamento Apresentação Pedagógica', 'Pré implantação Pedagógica', 'Implantação Pedagógica'};
        List<Processo__c> processos = new List<Processo__c>();
        for (String stage : stageNames) {
            Processo__c processoClone = processo.clone(false, true);
            processoClone.Fase__c = stage;
            processos.add(processoClone);
        }

        insert processos;

        processo = [SELECT Id, Fase__c FROM Processo__c WHERE Fase__c = 'Implantação Pedagógica'];
        processo.Fase__c = 'Finalizado';
        update processo;
    }
}