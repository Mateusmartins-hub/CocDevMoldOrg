global class ClienteSAPJob implements Schedulable  {

    public static String CRON_EXP = '0 0 5 * * ?';
    /*
    global String scheduleIt() { 
       ProximidadeVisitaJob proximidadeVisitaJob = new ProximidadeVisitaJob();
       
       string jobName = 'Consulta_Proximidade_Visita'; 
        
       return System.schedule(jobName, CRON_EXP, proximidadeVisitaJob);
    }  */
     
    global static void execute(SchedulableContext ctx){
        ClienteSAPBO.buscarClientesInseridosUltimas24Horas();
    } 
}