global class ScheduledBuscarReclamacoes implements Schedulable {

    public static final String JOB_NAME = 'Integração Reclame Aqui - Buscar reclamações';

    private static final String CRON_FORMAT = '{0} {1} {2} {3} {4} {5}';
    private static final Integer QUEUE_LIMIT = 1;
    private static final Integer INTERVAL_MINS = Integer.valueOf(IntegracaoRA__c.getOrgDefaults().tempoBuscarReclamacoes__c);


    global void execute(SchedulableContext sc) {
            
        BatchBuscarReclamacoes batch = new BatchBuscarReclamacoes();
        Database.executeBatch(batch);
        scheduleNextExecution();
        System.abortJob(sc.getTriggerId());
    }

    private void scheduleNextExecution() {
        DateTime nextExecution = DateTime.now().addMinutes(INTERVAL_MINS);
        List<String> args = new List<String>{
            '0',
            String.valueOf(nextExecution.minute()),
            String.valueOf(nextExecution.hour()),
            String.valueOf(nextExecution.day()),
            String.valueOf(nextExecution.month()),
            '?'
        };
        String jobName = JOB_NAME + ' - ' + nextExecution.format('yyyy-MM-dd HH:mm:ss');
        String expression = String.format(CRON_FORMAT, args);
        System.schedule(jobName, expression, this);
    }

    public void scheduleNowExecution() {
        DateTime nextExecution = DateTime.now().addMinutes(1);
        List<String> args = new List<String>{
            '0',
            String.valueOf(nextExecution.minute()),
            String.valueOf(nextExecution.hour()),
            String.valueOf(nextExecution.day()),
            String.valueOf(nextExecution.month()),
            '?'
        };
        String jobName = JOB_NAME + ' - ' + nextExecution.format('yyyy-MM-dd HH:mm:ss');
        String expression = String.format(CRON_FORMAT, args);
        System.schedule(jobName, expression, this);
    }

}