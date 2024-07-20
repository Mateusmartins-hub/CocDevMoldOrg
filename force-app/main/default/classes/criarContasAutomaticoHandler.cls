public class criarContasAutomaticoHandler implements TriggerHandlerInterface {
	private static final criarContasAutomaticoHandler instance = new criarContasAutomaticoHandler();
    /* Private constructor to prevent the creation of instances of this class.*/
    
    private criarContasAutomaticoHandler(){
    /*
    @description Method responsible for providing the instance of this class.
    @return GeneralSourceTriggerHandler instance.
    */
    }
    public static criarContasAutomaticoHandler getInstance() {
        return instance;
    }
	/*
    Method to handle trigger before update operations. 
    */
	public void beforeUpdate(){
        criarContasAutomaticoUtil.Arti((List<SolicitacaoCadastroCliente__c>)trigger.new);
    	if(criarContasAutomaticoUtil.Mudanca((List<SolicitacaoCadastroCliente__c>)trigger.new,(Map<id,SolicitacaoCadastroCliente__c>) trigger.oldMap)){
        	if(criarContasAutomaticoUtil.UpContas((List<SolicitacaoCadastroCliente__c>)trigger.new)){
                criarContasAutomaticoUtil.AtualizarContas((List<SolicitacaoCadastroCliente__c>)trigger.new);
            }else{
                criarContasAutomaticoUtil.CriarContas((List<SolicitacaoCadastroCliente__c>)trigger.new); 
            }
    	}
    }
    
    /**
    * Method to handle trigger before insert operations. 
    */ 
    public void beforeInsert() {

        }
    
    /**
    * Method to handle trigger before delete operations. 
    */
    public void beforeDelete() {
  		
    }
    
    /**
    * Method to handle trigger after update operations. 
    */
    public void afterUpdate() {
       
    }
    
    /**
    * Method to handle trigger after insert operations. 
    */
    public void afterInsert()  {
        
    }
    /**
    * Method to handle trigger after delete operations. 
    */
    public void afterDelete() {

    }
}