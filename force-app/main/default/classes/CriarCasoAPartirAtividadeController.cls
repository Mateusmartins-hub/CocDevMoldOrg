/**
 * Created by re035946 on 06/03/2018.
 */
public class CriarCasoAPartirAtividadeController {
	private String tarefaId;
	private Task tarefa;
	//public List<Schema.RecordtypeInfo> listRecType;
	public Schema.RecordtypeInfo recType;
	public String selected { get; set; }
	//public Map<String, Id> mapRecType;
	//public Set<String> listRecTypeName;

	public CriarCasoAPartirAtividadeController(ApexPages.StandardController controller) {
		tarefaId = ApexPages.currentPage().getParameters().get('tarefaId');
		tarefa = TaskDAO.getInstance().getTaskById(tarefaId);
	}

	public pageReference abrirPagina(){
		System.Debug('Selecionado: ' + selected);
		
		Case caso = new Case();
		String url = '/500/e?retURL=%2F500%2Fo&RecordType='+selected+'&ent=Case';
		url+= '&cas4=' + tarefa.Account.Name;
		url+= '&cas7=2 - Em aberto';
		url+= '&' + this.getFieldId() + '=' + tarefa.Account.Marca__c;
		url+= '&cas3=' + tarefa.Who.Name;
		url+= '&cas6=Solicitação';
		url+= '&cas11=Telefone';
		url+= '&cas15='+tarefa.Description;
		
		System.Debug('URL:' + url);
		PageReference newPage = new PageReference(url);
		newPage.setRedirect(true);
		return newPage;
		
	}
	
    public List<SelectOption> getRecordTypes() {
        List<SelectOption> options = new List<SelectOption>();
        List<String> lstObj = new List<String>();
        /*
        for(Schema.RecordtypeInfo recType : RecordTypeUtil.getInstance().getTodosRecordTypes('Case')){
        	options.add(new SelectOption(recType.getRecordTypeId(),recType.getName()));	
        }
        */
        lstObj.add('Case');
        for(RecordType recType : RecordTypeDAO.getInstance().getRecordTypeByObject(lstObj)){
        	options.add(new SelectOption(recType.Id,recType.Name));	
        }
        return options;
    }
    
    private String getFieldId(){
    	String retorno ='';
    	String orgId = UserInfo.getOrganizationId();
    	
    	//Propulsão
    	if(orgId == '00D3D000000CzGIUA0'){
    		retorno = '00N3D000001Utbn';
    	}
    	//QALatam
    	if(orgId == '00D1k0000004e3AEAQ'){
    		retorno = '00N1k000000KIBW';
    	}
    	
    	//Produção
    	if(orgId == '00Dd0000000fkBh'){
    		retorno = '';
    	}
    	return retorno;
    }
}