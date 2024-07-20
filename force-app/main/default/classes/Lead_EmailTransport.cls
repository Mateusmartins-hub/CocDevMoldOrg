public class Lead_EmailTransport {
    
    public static void CopyEmailTransport(List<Lead> newLeads){
        
        for( Lead l: newLeads){
            l.BR_Email_Transporte__c = l.email;
        }
    }
}