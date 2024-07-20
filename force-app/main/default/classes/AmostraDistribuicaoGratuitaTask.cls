/**
 * Created by re035946 on 13/06/2018.
 */
global class AmostraDistribuicaoGratuitaTask implements Schedulable{
    
    global static String scheduleIt() { 
        
    	return System.schedule('Process Amostra - Idiomas at 10m - ' + System.now(),'0 10 * * * ?',new AmostraDistribuicaoGratuitaTask());    
    }
    
	global void execute(SchedulableContext SC) {
		AmostraDistribuicaoGratuitaJob.integrar();
	}
}