public class ReclameAquiVO {

	public class Meta {
		public Integer total;
	}

	public List<Data> data;
	public Meta meta;

	public class Moderation {
		public Last_feeling user;
	}

	public class Customer {
		public List<String> birthday;
		public List<String> cpf;
		public List<String> rg;
		public List<String> gender;
		public List<String> email;
		public List<String> phone_numbers;
		public Integer id;
		public Integer duplicate_id;
		public String name;
		public List<Hugme_status> city;
		public List<State> state;
		public Integer pending_tickets_count;
	}

	public class Data {
        public String linksAnexos;
		public Hugme_status hugme_status;
		public Hugme_status ra_status;
		public Favorable_assessment favorable_assessment;
		public Hugme_status information_source;
		public Hugme_status source;
		public Hugme_status company;
		public Last_feeling last_feeling;
		public Last_feeling feed_type;
		public Moderation moderation;
		public Ra ra;
		public Customer customer;
		public Last_feeling user;
		public Last_feeling account;
		public Rafone rafone;
		public Integer id;
		public String source_external_id;
		public Boolean can_like;
		public Boolean commentary;
		public String creation_date;
		public String insertion_date;
		public String complaint_title;
		public Boolean filed;
		public String last_modification_date;
		public Boolean request_moderation;
		public Boolean request_evaluation;
		public Boolean frozen;
		public String complaint_content;
		public String ra_reason;
		public Integer interactions_count;
		public Integer interactions_not_readed_count;
		public Boolean resolved_issue;
		public Boolean back_doing_business;
		public String rating;
		public Integer comments_count;
		public Integer redistributions_count;
		public Integer ticket_moderations_count;
		public Integer ticket_messages_count;
		public Boolean rating_without_response;
		public Integer customer_interactions_count;
		public Integer company_interactions_count;
		public Integer assignment_count;
		public Integer rule_id;
		public List<String> duplicate_ticket;
		public List<Attached> attached;
		public List<Historical> historical;
		public List<Interactions> interactions;
		public Boolean active;
	}

	public class Favorable_assessment {
		public Integer id;
		public String description;
	}

	public class Ra {
		public Integer replicas_count;
		public Integer source_id;
		public String source_name;
		public Boolean internal_process;
		public Boolean blackfriday;
	}

	public class Attached {
		public String id;
		public Integer type_detail_id;
		public String name;
		public String detail_description;
		public String creation_date;
		public Boolean privacy;
	}

	public class Details {
		public String ticket_detail_id;
		public Integer ticket_detail_type_id;
		public String name;
		public String value;
		public String creation_date;
		public Boolean privacy;
	}

	public class State {
		public Integer id;
		public String name;
		public String fs;
	}

	public class Last_feeling {
		public Integer id;
	}

	public class Rafone {
		public Integer status_id;
	}

	public class Interactions {
		public String ticket_interaction_id;
		public Integer ticket_interaction_type_id;
		public String ticket_interaction_name;
		public String customer_id;
		public String message;
		public Boolean privacy;
		public String creation_date;
		public Boolean delivered;
		public Boolean readed;
		public Boolean visualized;
		public List<Details> details;
	}

	public class Historical {
		public Last_feeling user;
		public Last_feeling auto;
		public Integer id;
		public String creation_date;
	}

	public class Hugme_status {
		public Integer id;
		public String name;
	} 
    
	public static ReclameAquiVO parse(String json) {
		return (ReclameAquiVO) System.JSON.deserialize(json, ReclameAquiVO.class);
	}
    
    public class ResponseRespostaPublica{
        public String message;	//Operação efetuada com sucesso
        public boolean success;
        public String error;
    }
    
    public static ResponseRespostaPublica parseResponseRespostaPublica(String json) {
        return (ResponseRespostaPublica) System.JSON.deserialize(json, ResponseRespostaPublica.class);
    }
    
    public class RespostaRA {
        public Id idSalesforce {get;set;}
        public String id {get;set;} 
        public String message {get;set;}
        public String reason {get;set;}
        public ResponseRespostaPublica ResponseRespostaPublica {get;set;}
    }
}