public class MeetimeParam {
	
	public String event {get;set;} 
	public Prospection prospection {get;set;} 
    
    public MeetimeParam(JSONParser parser) {
        while (parser.nextToken() != System.JSONToken.END_OBJECT) {
            if (parser.getCurrentToken() == System.JSONToken.FIELD_NAME) {
                String text = parser.getText();
                if (parser.nextToken() != System.JSONToken.VALUE_NULL) {
                    if (text == 'event') {
                        event = parser.getText();
                    } else if (text == 'prospection') {
                        prospection = new Prospection(parser);
                    } else {
                        System.debug(LoggingLevel.WARN, 'MeetimeParam consuming unrecognized property: '+text);
                        consumeObject(parser);
                    }
                }
            }
        }
    }

	public class Origin {
		public String campaign {get;set;} 
		public String source {get;set;} 
		public String conversion {get;set;} 
		public String channel {get;set;} 

		public Origin(JSONParser parser) {
			while (parser.nextToken() != System.JSONToken.END_OBJECT) {
				if (parser.getCurrentToken() == System.JSONToken.FIELD_NAME) {
					String text = parser.getText();
					if (parser.nextToken() != System.JSONToken.VALUE_NULL) {
						if (text == 'campaign') {
							campaign = parser.getText();
						} else if (text == 'source') {
							source = parser.getText();
						} else if (text == 'conversion') {
							conversion = parser.getText();
						} else if (text == 'channel') {
							channel = parser.getText();
						} else {
							System.debug(LoggingLevel.WARN, 'Origin consuming unrecognized property: '+text);
							consumeObject(parser);
						}
					}
				}
			}
		}
	}
	
	public class Prospection {
		public Integer id {get;set;} 
		public Lead lead {get;set;} 
		public Cadence cadence {get;set;} 
		public String originType {get;set;} 
		public Boolean inbound {get;set;} 
		public String startDate {get;set;} 
		public String endDate {get;set;} 
		public String status {get;set;} 
		public Cadence salesman {get;set;} 
		public List<Phones> activities {get;set;} 
		public List<Phones> extraActivities {get;set;} 
		public Origin origin {get;set;} 

		public Prospection(JSONParser parser) {
			while (parser.nextToken() != System.JSONToken.END_OBJECT) {
				if (parser.getCurrentToken() == System.JSONToken.FIELD_NAME) {
					String text = parser.getText();
					if (parser.nextToken() != System.JSONToken.VALUE_NULL) {
						if (text == 'id') {
							id = parser.getIntegerValue();
						} else if (text == 'lead') {
							lead = new Lead(parser);
						} else if (text == 'cadence') {
							cadence = new Cadence(parser);
						} else if (text == 'originType') {
							originType = parser.getText();
						} else if (text == 'inbound') {
							inbound = parser.getBooleanValue();
						} else if (text == 'startDate') {
							startDate = parser.getText();
						} else if (text == 'endDate') {
							endDate = parser.getText();
						} else if (text == 'status') {
							status = parser.getText();
						} else if (text == 'salesman') {
							salesman = new Cadence(parser);
						} else if (text == 'activities') {
							activities = arrayOfPhones(parser);
						} else if (text == 'extraActivities') {
							extraActivities = arrayOfPhones(parser);
						} else if (text == 'origin') {
							origin = new Origin(parser);
						} else {
							System.debug(LoggingLevel.WARN, 'Prospection consuming unrecognized property: '+text);
							consumeObject(parser);
						}
					}
				}
			}
		}
	}
	
	public class CustomFields {
		public String marcaSf {get;set;} 
		public String origemDoLead {get;set;} 

		public CustomFields(JSONParser parser) {
			while (parser.nextToken() != System.JSONToken.END_OBJECT) {
				if (parser.getCurrentToken() == System.JSONToken.FIELD_NAME) {
					String text = parser.getText();
					if (parser.nextToken() != System.JSONToken.VALUE_NULL) {
						if (text == 'marcaSf') {
							marcaSf = parser.getText();
						} else if (text == 'origemDoLead') {
							origemDoLead = parser.getText();
						} else {
							System.debug(LoggingLevel.WARN, 'CustomFields consuming unrecognized property: '+text);
							consumeObject(parser);
						}
					}
				}
			}
		}
	}
	
	public class Phones {
		public Phones(JSONParser parser) {
			while (parser.nextToken() != System.JSONToken.END_OBJECT) {
				if (parser.getCurrentToken() == System.JSONToken.FIELD_NAME) {
					String text = parser.getText();
					if (parser.nextToken() != System.JSONToken.VALUE_NULL) {
						{
							System.debug(LoggingLevel.WARN, 'Phones consuming unrecognized property: '+text);
							consumeObject(parser);
						}
					}
				}
			}
		}
	}
	
	public class Lead {
		public Integer id {get;set;} 
		public String email {get;set;} 
		public String firstName {get;set;} 
		public String name {get;set;} 
		public String company {get;set;} 
		public List<Phones> phones {get;set;} 
		public String position {get;set;} 
		public String site {get;set;} 
		public String state {get;set;} 
		public String city {get;set;} 
		public String twitter {get;set;} 
		public String facebook {get;set;} 
		public String linkedIn {get;set;} 
		public String annotations {get;set;} 
		public CustomFields customFields {get;set;} 
		public String publicUrl {get;set;} 

		public Lead(JSONParser parser) {
			while (parser.nextToken() != System.JSONToken.END_OBJECT) {
				if (parser.getCurrentToken() == System.JSONToken.FIELD_NAME) {
					String text = parser.getText();
					if (parser.nextToken() != System.JSONToken.VALUE_NULL) {
						if (text == 'id') {
							id = parser.getIntegerValue();
						} else if (text == 'email') {
							email = parser.getText();
						} else if (text == 'firstName') {
							firstName = parser.getText();
						} else if (text == 'name') {
							name = parser.getText();
						} else if (text == 'company') {
							company = parser.getText();
						} else if (text == 'phones') {
							phones = arrayOfPhones(parser);
						} else if (text == 'position') {
							position = parser.getText();
						} else if (text == 'site') {
							site = parser.getText();
						} else if (text == 'state') {
							state = parser.getText();
						} else if (text == 'city') {
							city = parser.getText();
						} else if (text == 'twitter') {
							twitter = parser.getText();
						} else if (text == 'facebook') {
							facebook = parser.getText();
						} else if (text == 'linkedIn') {
							linkedIn = parser.getText();
						} else if (text == 'annotations') {
							annotations = parser.getText();
						} else if (text == 'customFields') {
							customFields = new CustomFields(parser);
						} else if (text == 'publicUrl') {
							publicUrl = parser.getText();
						} else {
							System.debug(LoggingLevel.WARN, 'Lead consuming unrecognized property: '+text);
							consumeObject(parser);
						}
					}
				}
			}
		}
	}
	
	public class Cadence {
		public Integer id {get;set;} 
		public String name {get;set;} 

		public Cadence(JSONParser parser) {
			while (parser.nextToken() != System.JSONToken.END_OBJECT) {
				if (parser.getCurrentToken() == System.JSONToken.FIELD_NAME) {
					String text = parser.getText();
					if (parser.nextToken() != System.JSONToken.VALUE_NULL) {
						if (text == 'id') {
							id = parser.getIntegerValue();
						} else if (text == 'name') {
							name = parser.getText();
						} else {
							System.debug(LoggingLevel.WARN, 'Cadence consuming unrecognized property: '+text);
							consumeObject(parser);
						}
					}
				}
			}
		}
	}
	
	public static MeetimeParam parse(String json) {
		System.JSONParser parser = System.JSON.createParser(json);
		return new MeetimeParam(parser);
	}
	
	public static void consumeObject(System.JSONParser parser) {
		Integer depth = 0;
		do {
			System.JSONToken curr = parser.getCurrentToken();
			if (curr == System.JSONToken.START_OBJECT || 
				curr == System.JSONToken.START_ARRAY) {
				depth++;
			} else if (curr == System.JSONToken.END_OBJECT ||
				curr == System.JSONToken.END_ARRAY) {
				depth--;
			}
		} while (depth > 0 && parser.nextToken() != null);
	}
    
    private static List<Phones> arrayOfPhones(System.JSONParser p) {
        List<Phones> res = new List<Phones>();
        if (p.getCurrentToken() == null) p.nextToken();
        while (p.nextToken() != System.JSONToken.END_ARRAY) {
            res.add(new Phones(p));
        }
        return res;
    }
}