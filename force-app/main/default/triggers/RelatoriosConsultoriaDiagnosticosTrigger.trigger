trigger RelatoriosConsultoriaDiagnosticosTrigger on BR_Procedimento_Visita__c (before insert, before update) 
{ 
	RelatoriosConsultoriaDiagnosticosTrigger.getInstance().executar();
}