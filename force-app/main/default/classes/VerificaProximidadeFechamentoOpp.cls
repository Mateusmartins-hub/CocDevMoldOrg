public class VerificaProximidadeFechamentoOpp implements Schedulable {
	private String createCron() {
		return '0 0 1 * * ? ';
	}
	public static void scheduleIt() {
		string jobName = 'Verifica_Proximidade_Fechamento - ' + System.now();
		VerificaProximidadeFechamentoOpp SC = new VerificaProximidadeFechamentoOpp();
		System.schedule(jobName, SC.createCron(), SC);
	}

	public void execute(SchedulableContext ctx) {
		try{
			OrgWideEmailAddress owa = [select id, Address, DisplayName from OrgWideEmailAddress where Address = 'nao-responda@pearson.com'];
			EnviarEmailFechamentoOportunidade batch = new EnviarEmailFechamentoOportunidade(owa);
			Database.executebatch(batch, 10);
		} catch(Exception e) {
			System.debug(e.getStackTraceString());
			System.debug(e.getMessage());
			System.debug(e.getLineNumber());
		}
	}


}