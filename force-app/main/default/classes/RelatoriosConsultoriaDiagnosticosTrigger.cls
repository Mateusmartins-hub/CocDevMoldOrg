public with sharing class RelatoriosConsultoriaDiagnosticosTrigger extends TriggerExecutavel
{
	private static final RelatoriosConsultoriaDiagnosticosTrigger instance = new RelatoriosConsultoriaDiagnosticosTrigger();

	private RelatoriosConsultoriaDiagnosticosTrigger() 
	{	
	}

	public static RelatoriosConsultoriaDiagnosticosTrigger getInstance()
	{
		return instance;
	}

	
    override
    protected void executarAntesInserir(List<SObject> lstDadosAtuais)
    {
    	List<BR_Procedimento_Visita__c> lst = (List<BR_Procedimento_Visita__c>)lstDadosAtuais;
    	RelatoriosConsultoriaDiagnosticosBO.getInstance().calcularPerformance(lst);
    }

    override
    protected void executarAntesAlterar(List<SObject> lstDadosAtuais, Map<Id, SObject> mapDadosAnteriores)
    {
    	List<BR_Procedimento_Visita__c> lst = (List<BR_Procedimento_Visita__c>)lstDadosAtuais;
    	RelatoriosConsultoriaDiagnosticosBO.getInstance().calcularPerformance(lst);
    }

}