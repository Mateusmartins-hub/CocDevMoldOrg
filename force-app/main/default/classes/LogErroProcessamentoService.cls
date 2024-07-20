public class LogErroProcessamentoService {
	private static final LogErroProcessamentoService instance = new LogErroProcessamentoService();
	private List<BR_LogSistema__c> lstCacheParaCommitDeUmaVez;

	private LogErroProcessamentoService() {
		lstCacheParaCommitDeUmaVez = new List<BR_LogSistema__c>();
	}

	public static LogErroProcessamentoService getInstance(){
		return instance;
	}

	public void criarNovoLogErroParaCaso(String idCaso, String acaoUsuario, String erroProcessamento){
		BR_LogSistema__c logSistema = new BR_LogSistema__c();
		logSistema.BR_AcaoUsuario__c = acaoUsuario;
		logSistema.BR_CasoRelacionado__c = idCaso;
		if(erroProcessamento.length() > 250 ){
			logSistema.BR_ErroProcessamento__c = erroProcessamento.substring(0,250);
		}else{
			logSistema.BR_ErroProcessamento__c = erroProcessamento;
		}
		
		insert logSistema;
	}

	public void criarNovoLogErroParaOportunidadeAdocao(String idOportunidade, String acaoUsuario, String erroProcessamento){
		getInstance().registrarNovaInstanciaLogErroParaOportunidadeAdocao(idOportunidade, acaoUsuario, erroProcessamento);
		getInstance().comitarRegistrosDBLogErro();
	}

	public void comitarRegistrosDBLogErro(){
		insert lstCacheParaCommitDeUmaVez;
	}

	public void registrarNovaInstanciaLogErroParaOportunidadeAdocao(String idOportunidade, String acaoUsuario, String erroProcessamento){
		BR_LogSistema__c logSistema = new BR_LogSistema__c();
		logSistema.BR_AcaoUsuario__c = acaoUsuario;
		logSistema.BR_OportunidadeRelacionada__c = idOportunidade;
		if(erroProcessamento.length() > 250 ){
			logSistema.BR_ErroProcessamento__c = erroProcessamento.substring(0,250);
		}else{
			logSistema.BR_ErroProcessamento__c = erroProcessamento;
		}
		lstCacheParaCommitDeUmaVez.add(logSistema);
	}
}