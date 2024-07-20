@isTest
public class LayoutTelaCasoControllerTest {

    @isTest static void testGetCamposCaso() {
        LayoutTelaCasoController.getCamposCaso();
    }
    
    @isTest static void testSalvarLayout() {
    	LayoutCaso__c layoutPadrao = new LayoutCaso__c();
        layoutPadrao.CamposLayout__c = 'AccountId;Subject;Description';
        layoutPadrao.GruposSolucionadores__c = null;
        
        LayoutTelaCasoController.salvarLayout(layoutPadrao);
    }
    
    @isTest static void testClonarLayout() {
    	LayoutCaso__c layoutPadrao = new LayoutCaso__c();
        layoutPadrao.CamposLayout__c = 'AccountId;Subject;Description';
        layoutPadrao.GruposSolucionadores__c = null;
        insert layoutPadrao;
        
        LayoutTelaCasoController.clonarLayout(layoutPadrao);
    }
    
    @isTest static void testPopularMapCampos() {
        LayoutTelaCasoController.popularMapCampos(new List<String> { '==Detalhes do Caso==', 'AccountId', '==Teste==', 'Subject' });
        LayoutTelaCasoController.popularMapCampos(new List<String> { 'AccountId', '==Teste==', 'Subject' });
    }
    
    @isTest static void testGetLayoutCaso() {
        LayoutTelaCasoController.getLayoutCaso(null);
    }
    
    @isTest static void testGetGruposSolucionadores() {
        LayoutTelaCasoController.getGruposSolucionadores();
    }
}