@isTest
public class LayoutCasoTriggerTest {
	
    public static testMethod void Testar()
    {
        LayoutCaso__c layoutPadrao = new LayoutCaso__c();
        layoutPadrao.CamposLayout__c = 'AccountId;Subject;Description';
        layoutPadrao.GruposSolucionadores__c = null;
        insert layoutPadrao;
        
        update layoutPadrao;
        
        LayoutCaso__c layout1 = new LayoutCaso__c();
        layout1.CamposLayout__c = 'AccountId;Subject;Description';
        layout1.GruposSolucionadores__c = 'Eventos';
        insert layout1;
        
        update layout1;
        
        LayoutCasoDAO.BuscaLayoutTelaCaso(layout1.Id);
        LayoutCasoDAO.BuscarLayoutsPorGrupoSolucionador('Eventos 2');
        
        delete layout1;
    }
}