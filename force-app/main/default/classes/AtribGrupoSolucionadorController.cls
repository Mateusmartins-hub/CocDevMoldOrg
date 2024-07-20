/**
 * Created by re035946 on 23/02/2018.
 */
public class AtribGrupoSolucionadorController {
    
    public static String testString = 'Test';
        
    /*
	public String idCaso{get;set;}
	public Case caso{get;set;}
	public Boolean primeiraSecao{get;set;}
	public Boolean segundaSecao{get;set;}
	public Boolean showDetalhamentoDois{get;set;}
	public Boolean enabledTipo{get;set;}
	public Boolean enabledSubtipo{get;set;}
	public Boolean enabledDetalhamento{get;set;}
	public Boolean enabledDetalhamentoDois{get;set;}
	public Boolean enabledBotaoSalvar{get;set;}
	public Boolean enabledBotaoSalvarDois{get;set;}
	public List<String> lstTipo{get;set;}
	public List<String> lstSubtipo{get;set;}
	public List<String> lstDetalhamento{get;set;}
	public List<String> lstDetalhamentoDois{get;set;}
	public Map<String, Boolean> mapCamposObrigatorios{get;set;}
	public Boolean isNew{get;set;}
	public Boolean isProdutosDigitais{get;set;}
	public Set<String> setTodosCampos{get;set;}
	public Set<String> setCamposObrigatorios{get;set;}
	private Boolean continuarGrupo{get;set;}
	private String paramId{get;set;}
	private String paramAreaDona{get;set;}
	private static Boolean atualizaPagina{get;set;}
	private Decimal slaTotalHoras{get;set;}
	private String slaTotalEmail{get;set;}
	private String proximoGrupo{get;set;}
	private String grupoAtual{get;set;}

	public AtribGrupoSolucionadorController(ApexPages.StandardController stdController) {
		isProdutosDigitais = false;
		enabledTipo = true;
		enabledSubtipo = false;
		enabledDetalhamento = false;
		enabledDetalhamentoDois = false;
		enabledBotaoSalvar = true;
		segundaSecao = false;
		enabledBotaoSalvarDois = false;
		mapCamposObrigatorios = new Map<String, Boolean>();
		atualizaPagina = true;
		grupoAtual = '';
		proximoGrupo = '';
		init(stdController);
	}

	public void init(ApexPages.StandardController stdController){
		System.debug('Id: ' + stdController.getId());
		if((stdController.getId()!= null && stdController.getId()!='')){
			this.idCaso = stdController.getId();
			this.caso = CaseDAO.getInstance().buscaTodosCamposCaseById(idCaso);
			isNew = false;
			System.debug('isNew: FALSE');
//			List<Controle_SLA__c> listaSLA = ControleSlaDAO.getInstance().getListControleSLAByCasoId(caso.Id);
//			if(listaSLA.isEmpty()){
//				isNew = true;
//			}
		} else {
			System.debug('Novo caso');
			isNew = true;
			System.debug('isNew: TRUE');
			caso = new Case();
		}
		if(!'5 - Fechado'.Equals(caso.Status) && !'6 - Encerrado'.Equals(caso.Status) && !'7 - Cancelado'.Equals(caso.Status)){
			System.debug('Inicio');
			enabledTipo = true;
			primeiraSecao = true;
		} else{
			enabledTipo = false;
			primeiraSecao = true;
		}
		setTodosCampos = Case.sObjectType.getDescribe().fields.getMap().keySet();
		System.debug('Todos campos Caso: ' + JSON.serialize(setTodosCampos));
		//setTodosCampos = CamposObrigatoriosDAO.getInstance().getAllCamposObrigatorios();
		//popularCamposObrigatorios(setTodosCampos, null);
		if(isNew && caso.Type!=null){
			onSave();
		}
	}

//	public void onChangeTipo(){
//		if (caso.Type != null && caso.Type != '') {
//			enabledSubtipo = true;
//
//			if('Produtos Digitais'.Equals(caso.Type)){
//				isProdutosDigitais = true;
//			}
//
//		} else {
//			enabledSubtipo = false;
//		}
//		verificarCampos();
//	}
//
//	public void onChangeSubtipo(){
//		if (caso.Subtipo__c!= null && caso.Subtipo__c!= '') {
//			enabledDetalhamento = true;
//		}
//		else {
//			enabledDetalhamento = false;
//		}
//		verificarCampos();
//	}
//
//	public void onChangeDetalhamento(){
//		if (caso.Detalhamento_del__c!= null && caso.Detalhamento_del__c!= '') {
//			enabledDetalhamentoDois = true;
//		}
//		verificarCampos();
//	}
//
//	public void onChangeDetalhamentoDois(){
//		verificarCampos();
//	}

//	public void verificarCampos(){
//		if (caso.Type != null && caso.Type != '' &&
//						caso.Subtipo__c != null && caso.Subtipo__c != '' &&
//						caso.Detalhamento_del__c != null && caso.Detalhamento_del__c != ''){
//			if(isProdutosDigitais){
//				if(caso.BR_Detalhamento2__c != null && caso.BR_Detalhamento2__c != ''){
//					enabledBotaoSalvar = false;
//				}
//			} else{
//				enabledBotaoSalvar = false;
//			}
//		}
//	}

	public void onSave(){
//		Database.upsert(caso);

		String chave = caso.Type + caso.Subtipo__c;

	}

	public void onSaveSecaoDois(){
		atualizaPagina = true;
	}

	public void atualizarControleSLA(){

	}



	public Boolean getAtualizaPagina(){
		return atualizaPagina;
	}

	public String getProximoGrupo(){
		return proximoGrupo;
	}

	public String getGrupoAtual(){
		return grupoAtual;
	}

	public  Boolean getExibirProximoGrupo(){
		if(proximoGrupo == ''){
			return false;
		}
		return true;
	}

	public Boolean getExibirGrupoAtual(){
		if(grupoAtual == ''){
			return false;
		}
		return true;
	} */
}