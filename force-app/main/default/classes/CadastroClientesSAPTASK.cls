global class CadastroClientesSAPTASK implements Schedulable{
    
    global static String scheduleIt() { 
        
    	return System.schedule('Cadastro de Clientes SAP at 10m - ' + System.now(),'0 10 * * * ?',new CadastroClientesSAPTASK()); 
    }
    
	global void execute(SchedulableContext SC) {
		CadastroClienteIntegracaoSAPJob.getInstance().Integra();
	}

}