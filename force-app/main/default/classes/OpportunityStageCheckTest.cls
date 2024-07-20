@IsTest
public class OpportunityStageCheckTest {
    @TestSetup
    static void makeData(){

        User userToRun = [
            SELECT Id FROM User WHERE Profile.Name LIKE '%admin%' AND ManagerId != null AND isActive = true LIMIT 1
        ];

        System.runAs(userToRun){
                
            Opportunity opp = TestHelper.createOpportunity();
            opp.StageName = 'Validação da Conta';        
            opp.BR_Modalidade_licitacao__c = 'Carta Convite';
            opp.VisitaDeExpansaoRealizada__c = true;
            opp.AprovadoCompliance__c = true;
            opp.AprovacaoGerencial__c = true;
            opp.AmostraFisicaEnviada__c = true;
            opp.VisitaPedagogicaRealizada__c = true;        
            opp.CotacaoGerada__c = true;
            opp.CasoFechado__c = true;
            opp.ContratoAnexado__c = true; 
            insert opp;
        }
    }

    @IsTest
    static void setorPrivadoStagesCheckTest() {

        User userToRun = [
            SELECT Id FROM User WHERE Profile.Name LIKE '%admin%' AND ManagerId != null AND isActive = true LIMIT 1
        ];

        System.runAs(userToRun){
                
            Opportunity opp = [SELECT Id, StageName, RecordTypeId FROM Opportunity LIMIT 1];
            opp.RecordTypeId = OpportunityStagesCheck.RECORD_TYPE_OPORTUNIDADE_SETOR_PRIVADO;
            
            List<String> stageNames = new List<String>{'Visita Inicial', 'Negociação', 'Elaborando Contrato', 'Coletando assinatura', 'Contrato Finalizado'};
            List<Opportunity> opps = new List<Opportunity>();
            List<OpportunityLineItem> listOli = new List<OpportunityLineItem>();
            for (String stage : stageNames) {
                Opportunity oppClone = opp.clone(false, true);
                oppClone.StageName = stage;
                oppClone.Name = stage;
                oppClone.CloseDate = System.today();
                oppClone.BR_Modalidade_licitacao__c = 'Carta Convite';
                oppClone.VisitaDeExpansaoRealizada__c = true;
                oppClone.AprovadoCompliance__c = true;
                oppClone.AprovacaoGerencial__c = true;
                oppClone.AmostraFisicaEnviada__c = true;
                oppClone.VisitaPedagogicaRealizada__c = true;        
                oppClone.CotacaoGerada__c = true;
                oppClone.CasoFechado__c = true;
                oppClone.ContratoAnexado__c = true; 
                opps.add(oppClone);
                
            }
            
            insert opps;  
        }      
    }

    @IsTest
    static void setorPublicoStagesCheckTest() {

        User userToRun = [
            SELECT Id FROM User WHERE Profile.Name LIKE '%admin%' AND ManagerId != null AND isActive = true LIMIT 1
        ];

        System.runAs(userToRun){
                
            Opportunity opp = [SELECT Id, StageName, RecordTypeId FROM Opportunity LIMIT 1];
            opp.RecordTypeId = OpportunityStagesCheck.RECORD_TYPE_OPORTUNIDADE_SETOR_PUBLICO;

            List<String> stageNames = new List<String>{'Aprovação Compliance', 'Visita Inicial', 'Degustação Pedagógica', 'Aguardando Edital', 'Contrato Finalizado', 'Contrato Anexado'};
            List<Opportunity> opps = new List<Opportunity>();
            List<OpportunityLineItem> listOli = new List<OpportunityLineItem>();
            for (String stage : stageNames) {
                Opportunity oppClone = opp.clone(false, true);
                oppClone.StageName = stage;            
                oppClone.Name = stage;
                oppClone.CloseDate = System.today();            
                oppClone.BR_Modalidade_licitacao__c = 'Carta Convite';
                oppClone.VisitaDeExpansaoRealizada__c = true;
                oppClone.AprovadoCompliance__c = true;
                oppClone.AprovacaoGerencial__c = true;
                oppClone.AmostraFisicaEnviada__c = true;
                oppClone.VisitaPedagogicaRealizada__c = true;        
                oppClone.CotacaoGerada__c = true;
                oppClone.CasoFechado__c = true;
                oppClone.ContratoAnexado__c = true; 
                opps.add(oppClone);
            }
            
            insert opps;        
        }
    }

    @IsTest
    static void institutoLinguasStagesCheckTest() {
        User userToRun = [
            SELECT Id FROM User WHERE Profile.Name LIKE '%admin%' AND ManagerId != null AND isActive = true LIMIT 1
        ];

        System.runAs(userToRun){
                
            Opportunity opp = [SELECT Id, StageName, RecordTypeId FROM Opportunity LIMIT 1];
            opp.RecordTypeId = OpportunityStagesCheck.RECORD_TYPE_OPORTUNIDADE_INSTITUTO_LINGUAS;

            List<String> stageNames = new List<String>{'Visita Inicial', 'Amostras Físicas', 'Aprofundamento Pedagógico', 'Registro de Adoção', 'Confirmação de Adoção', 'Adoção'};
            List<Opportunity> opps = new List<Opportunity>();
            List<OpportunityLineItem> listOli = new List<OpportunityLineItem>();
            for (String stage : stageNames) {
                Opportunity oppClone = opp.clone(false, true);
                oppClone.StageName = stage;            
                oppClone.Name = stage;
                oppClone.CloseDate = System.today();            
                oppClone.BR_Modalidade_licitacao__c = 'Carta Convite';
                oppClone.VisitaDeExpansaoRealizada__c = true;
                oppClone.AprovadoCompliance__c = true;
                oppClone.AprovacaoGerencial__c = true;
                oppClone.AmostraFisicaEnviada__c = true;
                oppClone.VisitaPedagogicaRealizada__c = true;        
                oppClone.CotacaoGerada__c = true;
                oppClone.CasoFechado__c = true;
                oppClone.ContratoAnexado__c = true; 
                opps.add(oppClone);

            }
            
            insert opps;        
        }
    }
}