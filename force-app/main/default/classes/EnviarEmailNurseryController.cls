public class EnviarEmailNurseryController {

	@AuraEnabled
	public static List<EmailTemplate> getEmails() {
		return [SELECT Id, Name FROM EmailTemplate where Folder.DeveloperName = 'Processos' ORDER BY Name];
	}

	@AuraEnabled
	public static void enviarEmail(String idProcesso, String idTemplate) {
		List<String> emailsToAddress = new List<String>();
		Processo__c p = [SELECT Id, Oportunidade__c, Conta__c, DataHoraVisita__c FROM Processo__c WHERE Id = :idProcesso] [0];
		//try{
			if(p.Oportunidade__c != null) {
				Opportunity op = OpportunityDAO.buscaOportunidade(p.Oportunidade__c);
				Account ac = AccountDAO.buscaConta(op.AccountId);

				if(ac.Contacts.size() > 0)
					emailsToAddress.add(ac.Contacts [0].Email);
				else 
					emailsToAddress.add(ac.BR_Account_email__c);
			} else if(p.Conta__c != null) {
				Account ac = AccountDAO.buscaConta(p.Conta__c);

				if(ac.Contacts.size() > 0)
					emailsToAddress.add(ac.Contacts [0].Email);
				else 
					emailsToAddress.add(ac.BR_Account_email__c);
			}
		//} catch(Exception e) {
		//	throw new AuraHandledException(e.getMessage());
		//}

		EmailTemplate et = [SELECT Id, Name, Subject, HtmlValue FROM EmailTemplate WHERE Id = :idTemplate] [0];

		if(emailsToAddress.isEmpty())
			throw new AuraHandledException('Não foi encontrado nenhum e-mail de destinatário.');

		validar(et, p);
        
        //try{
            Messaging.SingleEmailMessage message = new Messaging.SingleEmailMessage();
            message.toAddresses = emailsToAddress;
            message.subject = et.Subject;
            //message.htmlbody = et.HtmlValue.replace('{dataHorarioVisita}', (p.DataHoraVisita__c  == null ?  ''  :  p.DataHoraVisita__c.format('dd/MM/yyyy\' às \'HH:mm')));
            message.htmlbody = '';
        	Messaging.SingleEmailMessage [] messages = new List<Messaging.SingleEmailMessage>{ message };
            Messaging.SendEmailResult [] results = Messaging.sendEmail(messages);
        //} catch(Exception e) {
        //   throw new AuraHandledException(e.getMessage());
        //}
	}

	public static void validar(EmailTemplate et, Processo__c p) {
		if((et.Name == 'Avisar ao cliente sobre agendamento da visita' || et.Name == 'Avisar ao cliente sobre a proximidade da visita') && p.DataHoraVisita__c == null)
			throw new AuraHandledException('Preencha a data e horário agendado antes de enviar esse e-mail.');
	}
}