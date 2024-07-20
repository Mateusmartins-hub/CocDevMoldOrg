public class Event_CheckinCheckOut {
	
    public static void AtualizarCheckOut(List<Event> eventos)
    {
        for (Event e : eventos)
        {
            if (e.BR_FinalCheckinDate__c != null)
                e.BR_Visita_Realizada__c = true;
        }
    }
}