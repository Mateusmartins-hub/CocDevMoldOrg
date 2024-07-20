/**
 * Created by re035946 on 09/02/2018.
 */
public class EmailUtil {
	private static final EmailUtil instance = new EmailUtil();
	private EmailUtil() {
	}

	public static EmailUtil getInstance(){
		return instance;
	}
	
	public void sendMail(Set<string> toMail, String htmlBody, String subject){
		Messaging.SingleEmailMessage email = new Messaging.SingleEmailMessage();
		string[] to = new string[toMail.size()];
		Integer i = 0;
		for(String mail:toMail){
			to[i] = mail;
			i++;
		}
		email.setToAddresses(to);

		email.setSubject(subject);

		email.setHtmlBody(htmlBody);
		try{
			Messaging.sendEmail(new Messaging.SingleEmailMessage[] { email });
			System.debug('Email enviado!');
		}catch(exception e){
			System.debug('Erro ao enviar email: ' + e);
			//apexpages.addmessage(new apexpages.message(apexpages.severity.error,e.getMessage()));
		}
	}

    /*
	public Blob invite(String organizerEmail, String summary, String UID, DateTime startDT, DateTime endDT, String description) {
        String startdatetime= DateUtil.formatDate(startDT);
        String endDatetime= DateUtil.formatDate(endDT);
        String txtInvite = ''; 
        txtInvite += 'BEGIN:VCALENDAR\r\n';        
        txtInvite += 'PRODID:-//ical.pearson.com//iCal Event Maker\r\n';
        txtInvite += 'VERSION:2.0\r\n';
        txtInvite += 'CALSCALE:GREGORIAN\r\n';
        txtInvite += 'METHOD:PUBLISH\r\n';
        txtInvite += 'BEGIN:VEVENT\r\n';
        txtInvite += 'ORGANIZER:mailto:' + organizerEmail+'r\n';			
        txtInvite += 'DTSTART:'+startdatetime+'\r\n'; 
        txtInvite += 'DTEND:'+endDatetime+'\r\n';
        txtInvite += 'DTSTAMP:'+startdatetime+'\r\n';
        txtInvite += 'SUMMARY:' + summary+'\r\n';
        txtInvite += 'UID:'+UID+'\r\n';
        txtInvite += 'CREATED:'+startdatetime+'\r\n';
        txtInvite += 'LAST-MODIFIED:'+startdatetime+'\r\n';
        txtInvite += 'DESCRIPTION:'+ description +'\r\n';
        txtInvite += 'SEQUENCE:0\r\n';
        txtInvite += 'STATUS:CONFIRMED\r\n';
        txtInvite += 'TRANSP:OPAQUE\r\n';
        txtInvite += 'END:VEVENT\r\n';
        txtInvite += 'END:VCALENDAR\r\n';
        return Blob.valueOf(txtInvite);
    }
	*/
	
}