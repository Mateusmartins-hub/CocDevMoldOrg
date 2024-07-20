global class LeadTarefasAutomaticas implements Schedulable, Database.Batchable<sObject> {
    
    public Database.Querylocator start(Database.BatchableContext BC) {   
        String query = 'SELECT Id, CreatedDate, OwnerId, RecordTypeId from Lead where Contato_Futuro__c = FALSE and CreatedDate >= LAST_N_DAYS:9 AND IsConverted = FALSE';
        return Database.getQueryLocator(query);
    }

    public void execute(Database.BatchableContext BC, List<Lead> leads){
        
        Map<String, Object> inputs = new Map<String, Object>();
        inputs.put('Leads', leads);
        
        if(!Test.isRunningTest()){
            Flow.Interview.Tarefas_Automaticas_do_Lead flowTarefas = new Flow.Interview.Tarefas_Automaticas_do_Lead(inputs);
            flowTarefas.start();
        }
    }

    public void finish(Database.BatchableContext BC){}
    
    public void execute(SchedulableContext SC) {
        Database.executeBatch(new LeadTarefasAutomaticas(), 10);
    }
    
    global class Request {
        @InvocableVariable(label='Business Hours Id' required = true)
        global String businessHoursId;
        
        @InvocableVariable(label='Lead' required = true)
        global Lead leadToProcess;
    }

    global class Response {

        @InvocableVariable (label='Lead')
        global Lead lead;
        
        @InvocableVariable (label='Day')
        global Integer day;

        @InvocableVariable (label='Date')
        global Datetime dueDate;

        @InvocableVariable (label='Created on weekend?')
        global Boolean createdOnWeekend;

        @InvocableVariable (label='Next Business Day')
        global Datetime nextBusinessDay;

        @InvocableVariable (label='Is Business Day?')
        global Boolean isBusinessDay;

    }

    @InvocableMethod(label='Split the leads per business day' description='Split the leads per business day using the created date of lead')
    global static List<Response> splitLeads(List<Request> requestList) {
        
        List<Response> returnList = new List<Response>();
        
        if(requestList != null && requestList.size() > 0){
            
            for(Request request: requestList){
                Response response = calculate(request);
                returnList.add(response);        
            }
        }

        return returnList;
    }

    public static Response calculate(Request request){

        Date createdDate = request.leadToProcess.CreatedDate.dateGmt();
        Datetime datetimeToProcessing = Datetime.newInstance(
            createdDate.year(),
            createdDate.month(),
            createdDate.day(),
            12, 0, 0
        );

        Datetime noon = Datetime.newInstance(
            System.Today().year(),
            System.Today().month(),
            System.Today().day(),
            12, 0, 0
        );

        Decimal diff = BusinessHours.diff(
            request.businessHoursId, 
            datetimeToProcessing,
            noon
        );

        Datetime nextBusinessDay = BusinessHours.add(
            request.businessHoursId,
            noon,
            36000000
        );

        Integer day = Integer.valueOf((diff / 36000000).round(System.RoundingMode.CEILING));

        Boolean createdOnWeekend = dayOfWeekNumberIsWeekend(createdDate);
        
        Boolean isBusinessDay = BusinessHours.isWithin(
            request.businessHoursId, 
            noon
        );

        Response response = new Response();

        response.createdOnWeekend = createdOnWeekend;
        response.day = createdOnWeekend ? day + 1 : day;
        response.lead = request.leadToProcess;
        response.dueDate = System.Today();
        response.nextBusinessDay = nextBusinessDay;
        response.isBusinessDay = isBusinessDay;

        return response;
        
    }

    public static Boolean dayOfWeekNumberIsWeekend(Date aDate) {
        Integer dayNumber = Math.mod(Date.newInstance(1900, 1, 7).daysBetween(aDate),7);

        if(dayNumber == 0 || dayNumber == 6){
            return true;
        }

        return false;
    }
}