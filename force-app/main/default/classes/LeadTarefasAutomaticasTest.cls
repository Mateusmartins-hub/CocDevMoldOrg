@isTest
public class LeadTarefasAutomaticasTest {
    
    @isTest
    static void shouldSplitLeadPerCreatedDate(){

        Date weekStart = System.Today().toStartofWeek();

        for(Integer i = 0; i < 7; i++){
            Lead lead = new Lead();
            lead.FirstName = 'FirstName ' + i;
            lead.LastName = 'LastName' + i;
            lead.Company = 'Company' + i;
            lead.Email = 'test' + i + '@test.com';
            insert lead;
            Test.setCreatedDate(lead.Id, weekStart.addDays(-i));
        }

        BusinessHours bh = [SELECT Id FROM BusinessHours WHERE Name = 'Brazil'];
        
        List<Lead> leads = [SELECT Id, CreatedDate FROM Lead];
        
        List<LeadTarefasAutomaticas.Request> requests = new List<LeadTarefasAutomaticas.Request>();
        for(Lead lead: leads){
            LeadTarefasAutomaticas.Request request = new LeadTarefasAutomaticas.Request();
            request.leadToProcess = lead;
            request.businessHoursId = bh.Id;

            requests.add(request);
        }
        
        Test.startTest();
        List<LeadTarefasAutomaticas.Response> responses = LeadTarefasAutomaticas.splitLeads(requests);
        Test.stopTest();

        

    }

    @isTest
    static void shouldReturnTrueWhenIsAWeekendDay(){

        Date weekStart = System.Today().toStartofWeek();

        Boolean isWeekendDay = LeadTarefasAutomaticas.dayOfWeekNumberIsWeekend(weekStart.addDays(-1));

        System.assertEquals(true, isWeekendDay);
    }

    @isTest
    static void shouldTestBatch(){

        Date weekStart = date.today().toStartofWeek();
        DateTime dtWeekStart = datetime.newInstance(weekStart, Time.newInstance(23,59,59,59));

        for(Integer i = 0; i < 7; i++){
            Lead lead = new Lead();
            lead.FirstName = 'FirstName ' + i;
            lead.LastName = 'LastName' + i;
            lead.Company = 'Company' + i;
            lead.Email = 'test' + i + '@test.com';
            insert lead;
            Test.setCreatedDate(lead.Id, dtWeekStart.addDays(-i).addHours(5));
        }

        BusinessHours bh = [SELECT Id FROM BusinessHours WHERE Name = 'Brazil'];
        
        List<Lead> leads = [SELECT Id, CreatedDate FROM Lead];
        
        List<LeadTarefasAutomaticas.Request> requests = new List<LeadTarefasAutomaticas.Request>();
        for(Lead lead: leads){
            LeadTarefasAutomaticas.Request request = new LeadTarefasAutomaticas.Request();
            request.leadToProcess = lead;
            request.businessHoursId = bh.Id;

            requests.add(request);
        }
        
        Test.startTest();
        Database.executeBatch(new LeadTarefasAutomaticas());
        Test.stopTest();

    }

    
}