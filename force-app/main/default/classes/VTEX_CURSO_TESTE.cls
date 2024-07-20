/*
*
* Teste da Class VTEX_CURSO() - 21/11/2016
*
*/
@isTest
// @isTest(SeeAllData=true)
public class VTEX_CURSO_TESTE {
    static testMethod void Curso() {
        Course_Structure_Discipline__c csd = new Course_Structure_Discipline__c();
        csd.Type__c  = 'CURSO';
        csd.BR_Tipo__c   = '9';
        csd.Name = 'Química';
        insert csd;
        
        apexpages.currentpage().getparameters().put('keyID' ,'120f029fef154dcec18489c4e3d4db38');
        apexpages.currentpage().getparameters().put('fragmento' ,'Química');
        VTEX_CURSO vtex = new VTEX_CURSO();
    }    
    
    static testMethod void Curso2() {
        
        apexpages.currentpage().getparameters().put('keyID' ,'120f029fef154dcec18489c4e3d4db38');
        apexpages.currentpage().getparameters().put('fragmento' ,'Química');
        VTEX_CURSO vtex = new VTEX_CURSO();
    } 
    
        static testMethod void Curso3() {
        
        apexpages.currentpage().getparameters().put('keyID' ,'120f029fef154dcec18489c4e3d4db39');
        apexpages.currentpage().getparameters().put('fragmento' ,'Química');
        VTEX_CURSO vtex = new VTEX_CURSO();
    } 
    
}