global without sharing class EmailPublisherHandler implements QuickAction.QuickActionDefaultsHandler {
  // Empty constructor
  global EmailPublisherHandler() {}

  // The main interface method
  global void onInitDefaults(QuickAction.QuickActionDefaults[] defaults) {
    QuickAction.SendEmailQuickActionDefaults sendEmailDefaults = (QuickAction.SendEmailQuickActionDefaults)defaults.get(0);
     
    if (sendEmailDefaults != null) {
		List<Case> cases = [SELECT Account.Consultor_Escolar__r.Email FROM Case WHERE Id=:sendEmailDefaults.getContextId()];
        
        if(!cases.isEmpty()) {
            Case c = cases.get(0);
            if(!String.isBlank(c.Account.Consultor_Escolar__r.Email)) {
                EmailMessage emailMessage = (EmailMessage)sendEmailDefaults.getTargetSObject(); 
            	emailMessage.CcAddress = c.Account.Consultor_Escolar__r.Email;   
            }
        }
    }
  }
}