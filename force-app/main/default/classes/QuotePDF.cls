public class QuotePDF {
	public static Blob qtPDF { get; set; }
	public static String quoteId { get; set; }

	private class CotacaoException extends Exception { 
	}


	public QuotePDF(ApexPages.StandardController controller) {
		quoteId = controller.getRecord().Id;
	}

	public static void updatePDF() {
		PageReference pr = Page.CotacaoPDF;
		pr.getParameters().put('id', quoteId);

		if(Test.isRunningTest()) {
			qtPDF = blob.valueOf('Unit.Test');
		} else {
			qtPDF = pr.getContentAsPDF();
		}
	}

	@AuraEnabled
	public static String getPDFURL(String idQuote) {
		return URL.getOrgDomainUrl().toExternalForm() + Page.CotacaoPDF.getUrl();
	}

	public static Blob getQuotePDF {
		get {
			updatePDF();
			return qtPDF;
		}
	}

	@future(callout = true)@ AuraEnabled
	public static void sendQuoteToContact(List<String> quoteIds) {
		Site externalSite = [SELECT Id FROM Site WHERE Name = 'AprovacaoCotacao'];
		SiteDetail siteDetail = [SELECT SecureURL FROM SiteDetail WHERE DurableId = :externalSite.Id];

		List<Quote> quotes = QuoteDAO.getQuoteByIds(quoteIds);
		Set<Id> accountIds = new Set<Id>();
		Set<Id> setIds = new Set<Id>();
		for (Quote qt :quotes) {
			setIds.add(qt.Id);
			accountIds.add(qt.AccountId);
		}

		List<ProcessInstance> listprocess = ProcessInstanceDAO.getApprovedProcessById(setIds);
		if(listprocess.size() < 1 && !Test.isRunningTest())
			throw new CotacaoException('É necessário que o processo de aprovação interno seja finalizado antes do envio');

		List<Account_Contact__c> accountContacts = ContactDAO.getAccountContacts(accountIds);
		Map<Id, Account_Contact__c> mapAccountContacts = new Map<Id, Account_Contact__c>();
		for (Account_Contact__c ctc :accountContacts) {
			mapAccountContacts.put(ctc.Account__c, ctc);
		}

		for (Quote qt :quotes) {
			quoteId = qt.Id;
			updatePDF();
			String url;
			if(Test.isRunningTest())
				url = 'TestURL';
			else {
				url = siteDetail.SecureURL + '?ObjectId=' + quoteId + '&AprovacaoResposta=';
			}

			EmailTemplate et = EmailTemplateDAO.getEmailTemplateByDeveloperName('AprovacaoCotacao');
			String templateBody = et.HtmlValue.replace('{URLAPROVAR}', url + 'aceitar').replace('{URLRECUSAR}', url + 'recusar');

			List<Messaging.SingleEmailMessage> emailsList = new List<Messaging.SingleEmailMessage>();
			List<Messaging.EmailFileAttachment> attachmentsList = new List<Messaging.EmailFileAttachment>();

			Messaging.EmailFileAttachment att = createAttachment(qtPDF);
			attachmentsList.add(att);

			Messaging.SingleEmailMessage email = new Messaging.SingleEmailMessage();

			String sendEmail = mapAccountContacts.get(qt.AccountId).Email__c;
			if(String.isBlank(sendEmail)) {
				sendEmail = mapAccountContacts.get(qt.AccountId).Contact__r.Email;
			}

			if(String.isBlank(sendEmail)) {
				throw new CotacaoException('E-mail não cadastrado. Favor solicitar o cadastro e tentar novamente!');
			}

			email.toAddresses = new String [] { 
				sendEmail};
			email.subject = et.Subject;
			email.htmlbody = templateBody;
			email.setReplyTo(qt.Owner.Email);
			email.setSenderDisplayName(qt.Owner.Name);
			email.setFileAttachments(attachmentsList);

			emailsList.add(email);

			Messaging.sendEmail(emailsList);
		}
	}

	public static Messaging.EmailFileAttachment createAttachment(Blob body) {
		Messaging.EmailFileAttachment attach = new Messaging.EmailFileAttachment();
		attach.setContentType('application/pdf');
		attach.setFileName('Cotação.pdf');
		attach.setInline(false);
		attach.setBody(body);
		return attach;
	}
}