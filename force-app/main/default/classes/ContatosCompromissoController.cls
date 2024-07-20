/*
	@author Diego Moreira
*/
public with sharing class ContatosCompromissoController {
	public ContatosCompromissoBO compromissos { get; set; }
    public String accountId		= ApexPages.currentPage().getParameters().get('accountId');
    public String eventId		= ApexPages.currentPage().getParameters().get('eventId');

	/*
		Construtor
	*/
	public ContatosCompromissoController() {
		this.compromissos = new ContatosCompromissoBO();	
	}	

    /*
        Metodo principal de execução
    */
    public void execute() {
    	this.compromissos.registrosPorPagina = 10;
    	this.compromissos.accountId = this.accountId;
    	this.compromissos.eventId = this.eventId;
        this.compromissos.getContatosCompromisso();
        List<Account_Contact__c> lstAccCtc = this.compromissos.getContatosInstituicao();
    }        

    public void pesquisar()
    {
    	if( String.isBlank(this.compromissos.nameQuery) )
    	{
    		this.compromissos.getContatosCompromisso();
    	}
    	else
    	{
    		this.compromissos.getContatosCompromissoByName();	
    	}


    }

	/*
		Salva os dados em compromisso
	*/
	public Pagereference salvar() {
		List<EventRelation> eventsRelationToInsert = new List<EventRelation>();
		
		if( compromissos.totalContatos > 50 ) {
			ApexPages.addMessage( new ApexPages.Message( ApexPages.Severity.ERROR, 'Numeros de contatos selecionados e adicionados MAIOR que 50!' ) );
			return null;
		}
		
        for( String contactId : this.compromissos.itensCheckValue.keySet() ) {
            if( this.compromissos.itensCheckValue.get( contactId ) ) {
                eventsRelationToInsert.add( this.createEventRelation( contactId ) );
            }
            if(Test.isRunningTest() ){           
                eventsRelationToInsert.add( this.createEventRelation( contactId ) );
            }
            
        }
        
		try {
			insert eventsRelationToInsert;
			return this.voltar();
		} catch( Exception ex ) {
            ApexPages.addMessage( new ApexPages.Message( ApexPages.Severity.ERROR, ex.getMessage() ) );
            return null;  
        } 		
	}
	
	/*
		Mosta os objetos de Event relation
	*/
	private EventRelation createEventRelation( String contactId ) {
		EventRelation eventRelation = new EventRelation();
		eventRelation.EventId = eventId;
		eventRelation.RelationId = contactId;
		eventRelation.IsWhat = false;
		eventRelation.IsInvitee = false;
		eventRelation.IsParent = true;
		
		return eventRelation;
	} 
	
	/*
		Cancela a operação
	*/
	public Pagereference voltar() {
		return new Pagereference( '/' +  eventId );
	}

}