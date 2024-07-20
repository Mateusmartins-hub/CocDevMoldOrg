/**
 * Created by re035946 on 09/02/2018.
 */
public class EmailTemplateDAO {
	private static final EmailTemplateDAO instance = new EmailTemplateDAO();
	private EmailTemplateDAO() {
	}

	public static EmailTemplateDAO getInstance(){
		return instance;
	}
	
	public EmailTemplate getEmailTemplateByName(string name){
		return [SELECT Id,
				HTMLValue,
				Subject,
				Name
				FROM EmailTemplate
				WHERE Name =: name];
	}

	public static EmailTemplate getEmailTemplateByDeveloperName(String developerName) {
		return [SELECT Id,
				HTMLValue,
				Subject
				FROM EmailTemplate
				WHERE DeveloperName =: developerName];
	}
}