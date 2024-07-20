/*
	@author Diego Moreira
*/
public with sharing class ContatosCompromissoBO { 
    public Integer noOfRecords 							{ get; set; }
    public Integer registrosPorPagina					{ get; set; }
    public List<AccountContactTO> accountContactListTO 	{ get; set; }
    public ApexPages.StandardSetController setCon 		{ get; set; }
    public map<String, Boolean> itensCheckValue;
    
    public String accountId								{ get; set; }
    public String eventId								{ get; set; }
    
    public String nameQuery                               { get; set; }

    public Boolean checkValue							{ get; set; }
	public String contatoId								{ get; set; }
	
	public Integer totalContatos						{ get; set; }

    public List<Account_Contact__c> getContatosInstituicao() {

        List<Account_Contact__c> accountContact = new List<Account_Contact__c>();
        accountContact = AccountContactDAO.getInstance().getContatosIstituicao( this.accountId );
        return accountContact;
    }
	
    /*
    	Busca os dados de contatos
    */
    public void getContatosCompromisso() {
    	List<String> contactToRemove = new List<String>();
        List<Account_Contact__c> accountContact = new List<Account_Contact__c>();
        
        for( EventRelation event : EventRelationDAO.getInstance().getEventsRelationsByEventId( this.eventId ) )
        	contactToRemove.add( event.RelationId );
        
        this.totalContatos = contactToRemove.size();
        	
        if( contactToRemove.size() > 0 ) {
        	accountContact = AccountContactDAO.getInstance().getListAccountContactByAccountIdRemoveContact( this.accountId, contactToRemove );
        } else {
        	accountContact = AccountContactDAO.getInstance().getListAccountContactByAccountId( this.accountId );
        }            
        
        this.doInicializaValoresSelecao( accountContact );
        
        this.setCon = new ApexPages.StandardSetController( accountContact );
        this.setCon.setPageSize( this.registrosPorPagina );
        this.noOfRecords = this.setCon.getResultSize();
        
        this.doRecords();     
    }

    /*
        Busca os dados de contatos
    */
    public void getContatosCompromissoByName() {
        List<String> contactToRemove = new List<String>();
        List<Account_Contact__c> accountContact = new List<Account_Contact__c>();
        
        for( EventRelation event : EventRelationDAO.getInstance().getEventsRelationsByEventId( this.eventId ) )
            contactToRemove.add( event.RelationId );
        
        this.totalContatos = contactToRemove.size();
            
        if( contactToRemove.size() > 0 ) {
            accountContact = AccountContactDAO.getInstance().getListAccountContactByAccountIdAndContactNameRemoveContact( this.accountId, '%' + this.nameQuery + '%', contactToRemove );
        } else {
            accountContact = AccountContactDAO.getInstance().getListAccountContactByAccountIdAndContactName( this.accountId, '%' + this.nameQuery + '%' );
        }            
        
        this.doInicializaValoresSelecao( accountContact );
        
        this.setCon = new ApexPages.StandardSetController( accountContact );
        this.setCon.setPageSize( this.registrosPorPagina );
        this.noOfRecords = this.setCon.getResultSize();
        
        this.doRecords();     
    }
    
    /*
    	Monta o objeto de exibição
    */ 
    private void doRecords() {
        this.accountContactListTO = new List<AccountContactTO>();
        
        for(Account_Contact__c record : ( List<Account_Contact__c> ) this.setCon.getRecords() ) {
        	AccountContactTO contatoTO = new AccountContactTO();
        	contatoTO.check = this.itensCheckValue.get( record.Contact__c );
        	contatoTO.id = record.Contact__c;
        	contatoTO.nome = record.Contact__r.Name;
            contatoTO.cpf = record.Contact__r.BR_CPF__c;
        	
        	this.accountContactListTO.add( contatoTO );
        }
    }
    
    /*
    	Inicializa as os registros de seleção
    */
    private void doInicializaValoresSelecao( List<Account_Contact__c> recordsToInitialize ) {
    	this.itensCheckValue = new map<String, Boolean>();
    	
    	for( Account_Contact__c record : recordsToInitialize )
    		this.itensCheckValue.put( record.Contact__c, false );
    }
    
	/*
    	Atualiza valor de seleção
    */
    public void doSelectOrDeselectItem() {
 		this.itensCheckValue.put( this.contatoId, this.checkValue );
 		this.doCalculaTotalContatos(); 
    }
    
    /*
    	Soma o total de contatos do compromisso
    */
    private void doCalculaTotalContatos() {
    	if( this.checkValue )
    		this.totalContatos = this.totalContatos + 1;
    	else
    		this.totalContatos = this.totalContatos - 1;	
    } 
    
    /*
    	Metodos de controle de paginação
    */ 
    public Boolean hasNext {
        get {   return this.setCon.getHasNext();
        }
        set;
    }
    
    public Boolean hasPrevious {
        get {  return this.setCon.getHasPrevious();
        }
        set;
    }
  	
    public Integer pageNumber {
        get {  return this.setCon.getPageNumber();
        }
        set;
    }
  	
    public void first() {
        this.setCon.first();
        doRecords();
    }
  
    public void last() {
        this.setCon.last();
        doRecords();
    }
  
    public void previous() {
        this.setCon.previous();
        doRecords();
    }
  
    public void next() {
        this.setCon.next();
        doRecords();
    }

}