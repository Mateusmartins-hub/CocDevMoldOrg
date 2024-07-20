public class RDStationContact {
    public String name;
    public String job_title;
    public String bio;
    public String website;
    public String linkedin;
    public String personal_phone;
    public String city;
    public String state;
    public String country;
    public List<String> tags;
    public String facebook;
    public String twitter;
    public String mobile_phone;
    public String cf_motivo_de_perda;
    
    public static RDStationContact parse(String json) {
        return (RDStationContact) System.JSON.deserialize(json, RDStationContact.class);
    }
    
    public static String unparse(RDStationContact con) {
        return (String)System.JSON.serialize(con);
    }
}