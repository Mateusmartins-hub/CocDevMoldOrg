public class ContarVisitasHandler implements TriggerHandlerInterface {
	private static final ContarVisitasHandler instance = new ContarVisitasHandler();
    /* Private constructor to prevent the creation of instances of this class.*/
    
    private ContarVisitasHandler(){
    /*
    @description Method responsible for providing the instance of this class.
    @return GeneralSourceTriggerHandler instance.
    */
    }
    public static ContarVisitasHandler getInstance() {
        return instance;
    }
	/*
    Method to handle trigger before update operations. 
    */
	public void beforeUpdate(){
    		ContarVisitasUtil.ContageMultipla(Trigger.new);    
    }
    
    /**
    * Method to handle trigger before insert operations. 
    */ 
    public void beforeInsert() {
        if(trigger.new.size() == 1){
            ContarVisitasUtil.ContagemUnica(Trigger.new);
        }else{
			ContarVisitasUtil.ContageMultipla(Trigger.new);
        }
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