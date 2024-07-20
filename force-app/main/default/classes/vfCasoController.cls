public without sharing class vfCasoController {
    public Case caso { get; private set; }

    public vfCasoController (ApexPages.StandardController controller) {
        Id id = ApexPages.currentPage().getParameters().get('id');
        caso = (id == null) ? new Case() : [SELECT Id, Novo__c FROM Case WHERE Id = :id];
	}
}