public class RDStationModel {
    
    public class Evento{
        public final String event_family = 'CDP';
        public String event_type;
        public EventoPayload payload = new EventoPayload();

        public Boolean isValid(){
            return (
                String.isNotBlank(this.event_type) &&        
                String.isNotBlank(this.event_family) &&    
                String.isNotBlank(this.payload.email)
            );
        }

        public String toJson(){
            return (String)JSON.serialize(this);
        }
    }

    public class EventoPayload{
        public String email;
        public String funnel_name = 'default';
        public String reason;
        public Decimal value; 
    }

    public class Contato{

        public String uuid;
        public String email;
        public String name;
        public String bio;
        public String job_title;
        public String linkedin;
        public String facebook;
        public String city;
        public String state;
        public String country;
        public String twitter;
        public String personal_phone;
        public String mobile_phone;
        public String website;
        public List<String> tags;
        public List<Object> legal_bases;
        public String cf_motivo_de_perda;

        public Boolean isValid(){
            return (String.isNotBlank(this.email));
        }

        public String toJson(Boolean isUpdate){
            this.email = null;
            return toJson();
        }
        
        public String toJson(){
            return (String)JSON.serialize(this, true);
        }
    }

    // Webhook Lead
    public class Leads{
        public List<Lead> leads;
    }

    public class Lead{
        public String id;
        public String email;
        public String name;
        public String company;
        public String job_title;
        public String bio;
        public String public_url;
        public DateTime created_at; 
        public String opportunity;
        public String number_conversions;
        public String user;
        public String website; 
        public String personal_phone;
        public String mobile_phone;
        public String city; 
        public String state;
        public List<String> tags;
        public String lead_stage;
        public DateTime last_marked_opportunity_date;
        public String uuid;
        public String fit_score;
        public Integer interest;
        public Conversao first_conversion;
        public Conversao last_conversion;
        public Map<String,String> custom_fields;
        public String brand;
    }

    public class Conversao{
        public ConteudoConversao content;
        public DateTime created_at;
        public String cumulative_sum;
        public String source;
        public ConversaoOrigem conversion_origin;
        public String channel;
    }

    public class ConversaoOrigem{
        public String source;
        public String medium;
        public String value;
        public String campaign;
        public String channel;
    }

    public class ConteudoConversao{
        public String bio;
        public String user_id;
        public AtributosLead lead_info_attributes;
        public AtributosEmpresa company_attributes;
        public String email_lead;
        public String Nome;
        public String Cargo;
        public String UF;
        public String opportunity_origin;
        
    }

    public class AtributosLead{
        public String mobile_phone;
        public String personal_phone;
        public String twitter;
        public String facebook;
        public String linkedin;
        public String website;
    }

    public class AtributosEmpresa{
        public String name;
        public String site;
        public String twitter;
        public String facebook;
        public String phone;
        public String address;
        public String email;
        public String size;
        public String company_sector_id;
    }

}