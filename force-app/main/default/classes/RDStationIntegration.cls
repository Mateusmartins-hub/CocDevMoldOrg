public class RDStationIntegration {
    
    public static void returnOppToLead(Opportunity opp) {
        try {
            Account acc = AccountDAO.buscaConta(opp.AccountId);
            
            integrate(opp, acc);
        } catch(Exception ex) {
            System.debug(ex.getMessage());
            System.debug(ex.getStackTraceString());
            throw new CustomException(ex.getMessage());
        }
    }
    
    public static void integrate(Opportunity opp, Account acc) {
        RDStationSettingsParams rd = new RDStationSettingsParams();
        
        if(String.isEmpty(acc.BR_Account_email__c)) {
            throw new CustomException('Email na conta vazio.');
        }else if(opp.MarcaFranquias__c == 'Skill') {
            rd = settingsToParam(RDStationTokensIntegration.refreshTokenAndGetCustomSettingsSkill());
        } else if(opp.MarcaFranquias__c == 'Yázigi') {
            rd = settingsToParam(RDStationTokensIntegration.refreshTokenAndGetCustomSettingsYazigi());
        }else if(opp.MarcaFranquias__c == 'Wizard') {
            rd = settingsToParam(RDStationTokensIntegration.refreshTokenAndGetCustomSettingsWizard());
        }else if(String.isBlank(opp.MarcaFranquias__c)) {
            throw new CustomException('Marca na oportunidade vazia.');
        }else{
            throw new CustomException('Marca não permitida para integração ao RD Station.');
        }
        
        String json = RDStationContact.unparse(accountToRDContact(acc, opp));
        HttpResponse response = getBodyFromCallout('/platform/contacts/email:' + acc.BR_Account_email__c, 'PATCH', new Map<String, String>(), json, rd);
        System.debug(response.getBody());
        updateParamToSettings(rd);
        
        if(response.getStatus() != 'OK') {
            System.debug(response.getStatus());
            System.debug(response.getBody());
            throw new CustomException('Erro ao integrar com a RD Station. Contate o Tech.');
        }
    }
    
    public static HttpResponse getBodyFromCallout(String endpoint, String method, Map<String, String> mapParams, String body, RDStationSettingsParams rd) {        
        Http h = new Http();
        
        HttpRequest req = new HttpRequest();
        
        if(method == 'PATCH'){
            req.setMethod('POST');
            req.setHeader('X-HTTP-Method-Override','PATCH');
        }else{
            req.setMethod(method);
        }
        
        req.setHeader('Content-Type', 'application/json');
        String accesstoken = 
            (rd.AccessTokenPart1 == null ? '' : rd.AccessTokenPart1) +
            (rd.AccessTokenPart2 == null ? '' : rd.AccessTokenPart2) +
            (rd.AccessTokenPart3 == null ? '' : rd.AccessTokenPart3) +
            (rd.AccessTokenPart4 == null ? '' : rd.AccessTokenPart4);
        req.setHeader('Authorization', 'Bearer ' + accesstoken);
        
        String params = '';
        if(mapParams.size() > 0) {
            params = '?';
            for(String param : mapParams.keySet()) {
                params += param + '=' + mapParams.get(param) + '&';
            }
        }
        
        if(!String.isBlank(body))
            req.setBody(body);
        
        req.setEndpoint(rd.BaseDomain + endpoint + params);
        
        return h.send(req);
    }
    
    private static RDStationContact accountToRDContact(Account acc, Opportunity opp) {
        RDStationContact con = new RDStationContact();
        
        con.name = acc.Name; 
        con.bio = acc.Description; 
        con.city = acc.BR_Main_City__c; 
        con.state = acc.BR_Main_State__c; 
        con.country = acc.BR_Main_Country__c; 
        con.personal_phone = acc.Phone; 
        con.mobile_phone = acc.BR_Telefone2__c; 
        con.website = acc.Website; 
        con.cf_motivo_de_perda = opp.BR_MotivoRecusa__c;
        con.tags = new List<String>{'salesforce', 'oportunidade fechada'};
            
        /* CHG0286544 - efetuado rollback porque as credenciais do RD Station estavam expiradas
        if (opp.BR_MotivoRecusa__c == null || opp.BR_MotivoRecusa__c == '' ) {
            con.tags = new List<String>{'salesforce', 'oportunidade fechada'};
        } else {
        	con.tags = new List<String>{'salesforce', 'cancelada'};
        }
		*/
        
        return con;
    }
    
    public class RDStationSettingsParams {
        public String Marca;
        public String AccessTokenPart1;
        public String AccessTokenPart2;
        public String AccessTokenPart3;
        public String AccessTokenPart4;
        public String BaseDomain;
        public String ClientId;
        public String ClientSecret;
        public String Code;
        public String RefreshToken;
    }
    
    public static RDStationSettingsParams settingsToParam(RDStationWizard__c rd) {
        RDStationSettingsParams r = new RDStationSettingsParams();
        
        r.Marca = 'Wizard';
        
        r.AccessTokenPart1 = rd.AccessTokenPart1__c;
        r.AccessTokenPart2 = rd.AccessTokenPart2__c;
        r.AccessTokenPart3 = rd.AccessTokenPart3__c;
        r.AccessTokenPart4 = rd.AccessTokenPart4__c;
        r.BaseDomain = rd.BaseDomain__c;
        r.ClientId = rd.ClientId__c;
        r.ClientSecret = rd.ClientSecret__c;
        r.Code = rd.Code__c;
        r.RefreshToken = rd.RefreshToken__c;
        
        return r;
    }
    
    public static RDStationSettingsParams settingsToParam(RDStationYazigi__c rd) {
        RDStationSettingsParams r = new RDStationSettingsParams();
        
        r.Marca = 'Yázigi';
        
        r.AccessTokenPart1 = rd.AccessTokenPart1__c;
        r.AccessTokenPart2 = rd.AccessTokenPart2__c;
        r.AccessTokenPart3 = rd.AccessTokenPart3__c;
        r.AccessTokenPart4 = rd.AccessTokenPart4__c;
        r.BaseDomain = rd.BaseDomain__c;
        r.ClientId = rd.ClientId__c;
        r.ClientSecret = rd.ClientSecret__c;
        r.Code = rd.Code__c;
        r.RefreshToken = rd.RefreshToken__c;
        
        return r;
    }
    
    public static RDStationSettingsParams settingsToParam(RDStationSkill__c rd) {
        RDStationSettingsParams r = new RDStationSettingsParams();
        
        r.Marca = 'Skill';
        
        r.AccessTokenPart1 = rd.AccessTokenPart1__c;
        r.AccessTokenPart2 = rd.AccessTokenPart2__c;
        r.AccessTokenPart3 = rd.AccessTokenPart3__c;
        r.AccessTokenPart4 = rd.AccessTokenPart4__c;
        r.BaseDomain = rd.BaseDomain__c;
        r.ClientId = rd.ClientId__c;
        r.ClientSecret = rd.ClientSecret__c;
        r.Code = rd.Code__c;
        r.RefreshToken = rd.RefreshToken__c;
        
        return r;
    }
    
    public static void updateParamToSettings(RDStationSettingsParams rd) {
        if(rd.Marca == 'Skill') {
            RDStationSkill__c r = RDStationSkill__c.getOrgDefaults();
            
            r.AccessTokenPart1__c = rd.AccessTokenPart1;
            r.AccessTokenPart2__c = rd.AccessTokenPart2;
            r.AccessTokenPart3__c = rd.AccessTokenPart3;
            r.AccessTokenPart4__c = rd.AccessTokenPart4;
            r.BaseDomain__c = rd.BaseDomain;
            r.ClientId__c = rd.ClientId;
            r.ClientSecret__c = rd.ClientSecret;
            r.Code__c = rd.Code;
            r.RefreshToken__c = rd.RefreshToken;
            
            update r;
        } else if(rd.Marca == 'Yázigi') {
            RDStationYazigi__c r = RDStationYazigi__c.getOrgDefaults();
            
            r.AccessTokenPart1__c = rd.AccessTokenPart1;
            r.AccessTokenPart2__c = rd.AccessTokenPart2;
            r.AccessTokenPart3__c = rd.AccessTokenPart3;
            r.AccessTokenPart4__c = rd.AccessTokenPart4;
            r.BaseDomain__c = rd.BaseDomain;
            r.ClientId__c = rd.ClientId;
            r.ClientSecret__c = rd.ClientSecret;
            r.Code__c = rd.Code;
            r.RefreshToken__c = rd.RefreshToken;
            
            update r;
        }else if(rd.Marca == 'Wizard') {
            RDStationWizard__c r = RDStationWizard__c.getOrgDefaults();
            
            r.AccessTokenPart1__c = rd.AccessTokenPart1;
            r.AccessTokenPart2__c = rd.AccessTokenPart2;
            r.AccessTokenPart3__c = rd.AccessTokenPart3;
            r.AccessTokenPart4__c = rd.AccessTokenPart4;
            r.BaseDomain__c = rd.BaseDomain;
            r.ClientId__c = rd.ClientId;
            r.ClientSecret__c = rd.ClientSecret;
            r.Code__c = rd.Code;
            r.RefreshToken__c = rd.RefreshToken;
            
            update r;
        }    
    }
    
    public class CustomException extends Exception {}
}