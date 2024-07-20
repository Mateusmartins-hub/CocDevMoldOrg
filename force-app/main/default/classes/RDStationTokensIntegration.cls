public class RDStationTokensIntegration {
    public class Response {
        public string access_token;
        public string refresh_token;
        public string expires_in;
    }
    
    public static RDStationSkill__c getTokenAndGetCustomSettingsSkill() {
        RDStationSkill__c rd = RDStationSkill__c.getOrgDefaults();
        
        Map<String, String> params = new Map<String, String>();
        
        params.put('client_id', rd.ClientId__c);
        params.put('client_secret', rd.ClientSecret__c);
        params.put('code', rd.Code__c);
        
        String r = getBodyFromCallout('/auth/token', 'POST', params, rd.BaseDomain__c);
        Response response = (Response) System.JSON.deserialize(r, Response.class);
        
        rd.AccessTokenPart1__c = response.access_token.substring(0, 255); 
        rd.AccessTokenPart2__c = response.access_token.substring(255, 510); 
        if(response.access_token.length() <= 765)
            rd.AccessTokenPart3__c = response.access_token.substring(510, response.access_token.length());
        else {
            rd.AccessTokenPart3__c = response.access_token.substring(510, 765);
            rd.AccessTokenPart4__c = response.access_token.substring(765, response.access_token.length());
        }
        
        rd.RefreshToken__c = response.refresh_token;
        
        return rd;
    }
    
    public static RDStationWizard__c getTokenAndGetCustomSettingsWizard() {
        RDStationWizard__c rd = RDStationWizard__c.getOrgDefaults();
        
        Map<String, String> params = new Map<String, String>();
        
        params.put('client_id', rd.ClientId__c);
        params.put('client_secret', rd.ClientSecret__c);
        params.put('code', rd.Code__c);
        
        String r = getBodyFromCallout('/auth/token', 'POST', params, rd.BaseDomain__c);
        Response response = (Response) System.JSON.deserialize(r, Response.class);
        
        rd.AccessTokenPart1__c = response.access_token.substring(0, 255); 
        rd.AccessTokenPart2__c = response.access_token.substring(255, 510); 
        if(response.access_token.length() <= 765)
            rd.AccessTokenPart3__c = response.access_token.substring(510, response.access_token.length());
        else {
            rd.AccessTokenPart3__c = response.access_token.substring(510, 765);
            rd.AccessTokenPart4__c = response.access_token.substring(765, response.access_token.length());
        }
        
        rd.RefreshToken__c = response.refresh_token;
        
        return rd;
    }
    
    public static RDStationYazigi__c getTokenAndGetCustomSettingsYazigi() {
        RDStationYazigi__c rd = RDStationYazigi__c.getOrgDefaults();
        
        Map<String, String> params = new Map<String, String>();
        
        params.put('client_id', rd.ClientId__c);
        params.put('client_secret', rd.ClientSecret__c);
        params.put('code', rd.Code__c);
        
        String r = getBodyFromCallout('/auth/token', 'POST', params, rd.BaseDomain__c);
        Response response = (Response) System.JSON.deserialize(r, Response.class);
        
        rd.AccessTokenPart1__c = response.access_token.substring(0, 255); 
        rd.AccessTokenPart2__c = response.access_token.substring(255, 510); 
        if(response.access_token.length() <= 765)
            rd.AccessTokenPart3__c = response.access_token.substring(510, response.access_token.length());
        else {
            rd.AccessTokenPart3__c = response.access_token.substring(510, 765);
            rd.AccessTokenPart4__c = response.access_token.substring(765, response.access_token.length());
        }
        
        rd.RefreshToken__c = response.refresh_token;
        
        return rd;
    }
    
    public static RDStationSkill__c refreshTokenAndGetCustomSettingsSkill() {
        RDStationSkill__c rd = RDStationSkill__c.getOrgDefaults();
        
        Map<String, String> params = new Map<String, String>();
        
        params.put('client_id', rd.ClientId__c);
        params.put('client_secret', rd.ClientSecret__c);
        params.put('refresh_token', rd.RefreshToken__c);
        
        String r = getBodyFromCallout('/auth/token', 'POST', params, rd.BaseDomain__c);
        Response response = (Response) System.JSON.deserialize(r, Response.class);
        
        rd.AccessTokenPart1__c = response.access_token.substring(0, 255); 
        rd.AccessTokenPart2__c = response.access_token.substring(255, 510); 
        if(response.access_token.length() <= 765)
            rd.AccessTokenPart3__c = response.access_token.substring(510, response.access_token.length());
        else {
            rd.AccessTokenPart3__c = response.access_token.substring(510, 765);
            rd.AccessTokenPart4__c = response.access_token.substring(765, response.access_token.length());
        }
        
        rd.RefreshToken__c = response.refresh_token;
        
        return rd;
    }
    
    public static RDStationWizard__c refreshTokenAndGetCustomSettingsWizard() {
        RDStationWizard__c rd = RDStationWizard__c.getOrgDefaults();
        
        Map<String, String> params = new Map<String, String>();
        
        params.put('client_id', rd.ClientId__c);
        params.put('client_secret', rd.ClientSecret__c);
        params.put('refresh_token', rd.RefreshToken__c);
        
        String r = getBodyFromCallout('/auth/token', 'POST', params, rd.BaseDomain__c);
        Response response = (Response) System.JSON.deserialize(r, Response.class);
        
        rd.AccessTokenPart1__c = response.access_token.substring(0, 255); 
        rd.AccessTokenPart2__c = response.access_token.substring(255, 510); 
        if(response.access_token.length() <= 765)
            rd.AccessTokenPart3__c = response.access_token.substring(510, response.access_token.length());
        else {
            rd.AccessTokenPart3__c = response.access_token.substring(510, 765);
            rd.AccessTokenPart4__c = response.access_token.substring(765, response.access_token.length());
        }
        
        rd.RefreshToken__c = response.refresh_token;
        
        return rd;
    }
    
    public static RDStationYazigi__c refreshTokenAndGetCustomSettingsYazigi() {
        RDStationYazigi__c rd = RDStationYazigi__c.getOrgDefaults();
        
        Map<String, String> params = new Map<String, String>();
        
        params.put('client_id', rd.ClientId__c);
        params.put('client_secret', rd.ClientSecret__c);
        params.put('refresh_token', rd.RefreshToken__c);
        
        String r = getBodyFromCallout('/auth/token', 'POST', params, rd.BaseDomain__c);
        Response response = (Response) System.JSON.deserialize(r, Response.class);
        
        rd.AccessTokenPart1__c = response.access_token.substring(0, 255); 
        rd.AccessTokenPart2__c = response.access_token.substring(255, 510); 
        if(response.access_token.length() <= 765)
            rd.AccessTokenPart3__c = response.access_token.substring(510, response.access_token.length());
        else {
            rd.AccessTokenPart3__c = response.access_token.substring(510, 765);
            rd.AccessTokenPart4__c = response.access_token.substring(765, response.access_token.length());
        }
        
        rd.RefreshToken__c = response.refresh_token;
        
        return rd;
    }
    
    public static String getBodyFromCallout(String endpoint, String method, Map<String, String> mapParams, String baseDomain) {
        Http h = new Http();
        
        HttpRequest req = new HttpRequest();
        req.setTimeout(30000);
        req.setMethod(method);
        
        String params = '';
        if(mapParams.size() > 0) {
            params = '?';
            for(String param : mapParams.keySet()) {
                params += param + '=' + mapParams.get(param) + '&';
            }
        }
        
        req.setEndpoint(baseDomain + endpoint + params);
        req.setHeader('Content-Length', '0');
        
        HttpResponse res = h.send(req);
        return res.getBody();
    }
}