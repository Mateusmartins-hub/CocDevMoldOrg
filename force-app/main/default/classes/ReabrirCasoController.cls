public without sharing class ReabrirCasoController {

    public Case caso {get; set;}
    
    public ReabrirCasoController() {
        try 
        {
            Id id = ApexPages.currentPage().getParameters().get('id');
            
            caso = [SELECT Id, CaseNumber, Subject, Status FROM Case WHERE Id =: id];
        }
        catch(Exception ex)
        {
            System.debug('Erro: ' + ex.getMessage() + ' - ' + ex.getLineNumber());
        }
    }
    
    public void reabrirCaso() 
    {
        caso.Status = 'Reaberto';
        caso.ReabertoEmail__c = true;
        update caso;
    }
}