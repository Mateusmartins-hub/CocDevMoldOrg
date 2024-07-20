global class UpdateEventsBatch implements Database.Batchable<Event> {
    
    private integer Days {get;set;}
    
    public UpdateEventsBatch(integer days)
    {
        this.Days = days;
    }
    
    global List<Event> start(Database.BatchableContext BC) {
        return (List<Event>)Database.query('SELECT Id, Subject from Event where startDateTime >= LAST_N_DAYS:' + Days);
    }
    
    global void execute(Database.BatchableContext BC, List<Event> scope) {
        
        database.update(scope, false);
    }
    
    global void finish(Database.BatchableContext BC){
        
    }
}