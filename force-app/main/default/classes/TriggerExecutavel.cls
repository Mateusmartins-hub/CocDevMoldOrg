/**
* Classe abstrata que controla as ações disparadas por triggers.
* Cada objeto deverá ter somente uma Trigger e, portanto, ter uma classe 
* que implemente os métodos definidos nessa classe. 
* A única chamada que deve ter nas triggers é a do método executar, nada mais.
*/
public abstract class TriggerExecutavel
{				
	protected TriggerExecutavel()
	{
	}
			
	/**
	* Método principal da classe que deve ser chamado pelas triggers.
	* Este método identifica o momento e a ação que está sendo executada pela trigger 
	* e se encarrega de chamar o método correto. Por exemplo, se a trigger estiver sendo
	* executada no before insert, o método executarAntesInserir será chamado. 
	*/
	public void executar()
	{
		//verifica se está no contexto de execução de uma trigger
		if(Trigger.isExecuting)
		{			
			if(Trigger.isBefore)
			{
				if(Trigger.isInsert)
				{				
					this.executarAntesInserir(Trigger.new);	
				}	
				
                else if(Trigger.isUpdate)
				{
					this.executarAntesAlterar(Trigger.new, Trigger.oldMap);		
				}	
				/*
				else
				{
					this.executarAntesExcluir(Trigger.old);			
				}
                */
			}	
			/*
            else
			{
				if(Trigger.isInsert)
				{
					this.executarDepoisInserir(Trigger.new);
				}	
				else if(Trigger.isUpdate)
				{
					this.executarDepoisAlterar(Trigger.new, Trigger.oldMap);	
				}
				else if(Trigger.isDelete)
				{
					this.executarDepoisExcluir(Trigger.old);	
				}
				else if(Trigger.isUndelete)
				{
					this.executarDepoisRecuperarLixeira(Trigger.new);	
				}
			}
            */
		}		
	}
		
	virtual
    protected void executarAntesInserir(List<SObject> lstDadosAtuais)
    {
    }
	
    virtual
	protected void executarAntesAlterar(List<SObject> lstDadosAtuais, Map<Id, SObject> mapDadosAnteriores)
    {
    }
	/*
    virtual
	protected void executarAntesExcluir(List<SObject> lstDadosAnteriores)
    {
    }
	
    virtual
	protected void executarDepoisInserir(List<SObject> lstDadosAtuais)
    {     
    }
	
    virtual
	protected void executarDepoisAlterar(List<SObject> lstDadosAtuais, Map<Id, SObject> mapDadosAnteriores)
    {
    }
	
    virtual
	protected void executarDepoisExcluir(List<SObject> lstDadosAnteriores)
    {     
    }
	
    virtual
	protected void executarDepoisRecuperarLixeira(List<SObject> lstDadosAtuais)
    {     
    }
	*/
}