/**
 * Created by re035946 on 28/02/2018.
 */
public class EmailMessageDAO {
	private static final EmailMessageDAO instance = new EmailMessageDAO();

	public EmailMessageDAO() {
	}

	public static EmailMessageDAO getInstance(){
		return instance;
	}

	public List<EmailMessage> getEmailMessageByParentId(Id id){
		return [SELECT Id,
				Status,
				Subject
				FROM EmailMessage
				Where ParentId =: id];
	}

	public List<EmailMessage> getEmailMessageByParentIdAndStatus(Id id, String status){
		return [SELECT Id,
				Status,
				Subject
				FROM EmailMessage
				Where ParentId =: id
				AND Status =: status];
	}
}