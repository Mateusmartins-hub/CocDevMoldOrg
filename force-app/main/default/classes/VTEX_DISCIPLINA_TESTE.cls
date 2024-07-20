/*
*
* Teste da Class VTEX_DISCIPLINA() - 21/11/2016
*
*/
@isTest
// @isTest(SeeAllData=true)
public class VTEX_DISCIPLINA_TESTE {
    @isTest
    static void Disciplina() {
        
        Test.startTest();
        Course_Structure_Discipline__c csd = new Course_Structure_Discipline__c();
        csd.Type__c  = 'DISCIPLINA';
        csd.BR_Tipo__c   = '9';
        csd.Name = 'Química';
        insert csd;        
        
        apexpages.currentpage().getparameters().put('keyID' ,'698dc19d489c4e4db73e28a713eab07b');
        apexpages.currentpage().getparameters().put('fragmento' ,'Química');
        VTEX_DISCIPLINA.gerar_json_Disciplina();
        
        VTEX_DISCIPLINA vtxDisciplina = new VTEX_DISCIPLINA();
    	VTEX_DISCIPLINA.DisciplinaAtualizado vtxDiscAtual = new VTEX_DISCIPLINA.DisciplinaAtualizado();
        vtxDiscAtual.ID = '00002';
        vtxDiscAtual.ID = 'Nome';
        Test.stopTest();
    }

}