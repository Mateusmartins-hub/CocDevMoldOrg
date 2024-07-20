public class LeadBO {
    public static void setLeadData(List<Lead> leads) {  
        // Para cada Lead...
        for(Lead l : leads) {
            // Se o registro for originado no HubSpot e estiver com a Origem Inbound preenchida,
        	// o Salesforce preencherá a respectiva Origem Inbound com o valor informado.
            if(l.OrigemInboundHubspot__c != NULL){
                l.Origem_Inbound__c = l.OrigemInboundHubspot__c;
            }
        }
    }
}