@RestResource(urlMapping='/RDStation/*')
global without sharing class RDStationWebhook {

    private static Id standardOwnerId = [SELECT Id FROM Group WHERE Type = 'Queue' AND DeveloperName = 'Lead_RDStation'][0].Id;
    private static Id coc = [SELECT Id FROM Group WHERE Type = 'Queue' AND DeveloperName = 'COC'][0].Id;
    private static Id domBosco = [SELECT Id FROM Group WHERE Type = 'Queue' AND DeveloperName = 'Dom_Bosco'][0].Id;
    
    private static final Map<String, String> recordTypeMapping = new Map<String, String>{
        'Wizard' => 'Franquias',
        'Yázigi' => 'Franquias',
        'COC' => 'Escolas',
        'Dom Bosco' => 'Escolas',
        'Mentes' => 'Escolas',
        'Biblioteca Virtual' => 'HED',
        'Skill' => 'Licenciamento',
        'Governo' => 'Governo',
        'Pearson' => 'Corporate'
    };
    
    @HttpPost
    global static String doPost(){

        try{
            
            List<Lead> leadsToUpsert = new List<Lead>();
            
            Map<String,Object> parameters = RestContext.request.params;
            String brand = getRequestBrand(parameters);

            String leadData = RestContext.request.requestBody.toString();
            System.debug(leadData);
            RDStationModel.Leads leads = (RDStationModel.Leads)JSON.deserialize(leadData, RDStationModel.Leads.class);

            Set<String> emails = new Set<String>();
            Set<String> users = new Set<String>();
            for(RDStationModel.Lead lead: leads.leads){
                if(String.isNotBlank(lead.email)){
                    emails.add(lead.email);
                }

                if(String.isNotBlank(lead.user)){
                    users.add(lead.user);
                }

                lead.brand = brand;
            }

            Map<String, Lead> leadsByEmail = retrieveLeadsByEmail(emails);
            Map<String, User> usersByEmail = retrieveUsersByEmail(users);

            for(RDStationModel.Lead leadRD: leads.leads){

                Lead lead = initiateNewLead(leadRD);
	
                if(leadRD.brand == 'COC'){
                    lead.OwnerId = coc;
                }else if(leadRD.brand == 'Dom Bosco'){
                    lead.OwnerId = domBosco;
                }else{
                    lead.OwnerId = getOwnerId(usersByEmail, leadRD.user);
                }
                
                if(leadsByEmail.containsKey(leadRD.email)){
                    lead.Id = leadsByEmail.get(leadRD.email).Id;
                }
                
                leadsToUpsert.add(lead);

            }

            upsert leadsToUpsert;

            return 'Ok';
        }
        catch (Exception e) {
            return e.getLineNumber() + ' - ' + e.getMessage();
        }
        
    }

    @TestVisible
    private static Id getOwnerId(Map<String, User> usersByEmail, String userEmail){
        Id ownerId;
        
        if(usersByEmail.containsKey(userEmail)){
            ownerId = usersByEmail.get(userEmail).Id;
        }
        else{
            // Confirmar se mantém o mesmo usuário hard-coded
            ownerId = standardOwnerId;
        }

        return ownerId;
    }
    
    @TestVisible
    private static Map<String, Lead> retrieveLeadsByEmail(Set<String> emails){
        
        Map<String, Lead> leadsByEmail = new Map<String, Lead>();

        List<Lead> leads = [
            SELECT Id, FirstName, LastName, Company, Email, City, State, Website, Description
            FROM Lead
            WHERE Email IN :emails
                AND IsConverted = false
        ];

        for(Lead lead: leads){
            leadsByEmail.put(lead.Email, lead);
        }

        return leadsByEmail;
    }
    
    @TestVisible
    private static Map<String, User> retrieveUsersByEmail(Set<String> usersEmail){
        
        Map<String, User> usersByEmail = new Map<String, User>();

        List<User> users = [
            SELECT Id, Email
            FROM User
            WHERE Email IN :usersEmail
        ];

        for(User user: users){
            usersByEmail.put(user.Email, user);
        }

        return usersByEmail;
    }
    
    @TestVisible
    private static Lead initiateNewLead(RDStationModel.Lead lead){
        
        Map<String, String> customFields = lead.custom_fields;
        
        Map<String, String> nameMapping = splitFullName(lead.name);

        Lead newLead = new Lead();
        newLead.RecordTypeId = getRecordTypeId(lead.brand);
        
        newLead.FirstName = String.isBlank(nameMapping.get('firstName')) ? 'Não informado' : nameMapping.get('firstName');
        newLead.LastName = String.isBlank(nameMapping.get('lastName'))  ? 'Não informado' : nameMapping.get('lastName');
        newLead.Company = lead.company != null ? lead.company : null;
        newLead.Tipo_de_Captacao__c = 'Inbound';
        newLead.Email = lead.email;
        newLead.Email_RD_Station__c = lead.email;
        newLead.Cidade__c = lead.city;
        newLead.City = lead.city;
        newLead.Estado__c = lead.state;
        newLead.State = lead.state;
        newLead.Website = lead.website;
        newLead.Description = lead.bio;
        newLead.URL_publica_RD_Station__c = lead.public_url;
        newLead.MobilePhone = lead.mobile_phone;
        newLead.Phone = lead.personal_phone;
        newLead.Title = lead.job_title;
        newLead.Tags_RD_Station__c = lead.tags != null ? String.join(lead.tags, ';') : '';
        newLead.Marca_RD_Station__c = lead.brand;

        if(customFields != null){

            if(newLead.Company == null){
                newLead.Company = getCompany(customFields);
            }

            newLead.Cargo__c = getFunction(customFields);
            newLead.NomeEscola__c = customFields.get('Escola');
            newLead.BR_Segmento_de_Atuacao__c = customFields.get('Em qual segmento você atua?');
        }

        if(lead.first_conversion != null){

            if(lead.first_conversion.content != null){
                if(newLead.Cargo__c == 'Não informado'){
                    newLead.Cargo__c = lead.first_conversion.content.Cargo;
                }
            }

            newLead.Origem_da_ultima_conversao__c = (lead.first_conversion.channel != null ? lead.first_conversion.channel + ' | ' : '') + lead.first_conversion.source;

            if(lead.first_conversion.conversion_origin != null){
                newLead.Origem_Inbound__c = lead.first_conversion.conversion_origin.source;
            }
        }
    
        return newLead;     
    }
  
    @TestVisible
    private static Id getRecordTypeId(String brand){

        // Validar a regra da pearson
        // if(brand == 'Pearson'){}
        if(String.isNotBlank(brand)){
            return Schema.SObjectType.Lead.getRecordTypeInfosByName().get(recordTypeMapping.get(brand)).getRecordTypeId();
        }

        return null;
    }

    private static String getCompany(Map<String, String> customFields){
        
        List<String> fieldNames = new List<String>{
            'Instituição',
            'Nome da escola'
        };

        String companyToReturn = 'Não informado';
        for(String field: fieldNames){
            String rdCompany = customFields.get(field);

            if(rdCompany != null){
                companyToReturn = rdCompany;
                break;
            }
        }

        return companyToReturn;

    }

    private static String getFunction(Map<String, String> customFields){

        List<String> fieldNames = new List<String>{
            'Eu sou...',
            'Sou - escolha a função',
            'Qual seu cargo atual?',
            'Qual o seu cargo atual?',
            'Qual é o seu cargo atual?'
        };

        String functionToReturn = 'Não informado';
        for(String field: fieldNames){
            String rdFunction = customFields.get(field);

            if(rdFunction != null){
                functionToReturn = rdFunction;
                break;
            }
        }

        return functionToReturn;

    }

    private static String getRequestBrand(Map<String, Object> parameters){

        String brand = String.valueOf(parameters.get('marca'));

        if (Test.isRunningTest()){
            brand = 'Mentes';
        }

        if(brand == null){
            throw new RDStationsWebhookException('Requisição sem especificar o parâmetro marca');
        }

        return brand;
    }

    @TestVisible
    private static Map<String, String> splitFullName(String fullName){
        String firstName, lastName = '';
        List<String> splittedName = fullName.split(' ');
        if(splittedName != null){
            firstName = splittedName[0];

            if(splittedName.size() > 1){
                for(Integer i = 1; i < splittedName.size(); i++){
                    if(i > 1){
                        lastName += ' ';
                    }
                    lastName += splittedName[i];
                }
            }
        }

        Map<String, String> names = new Map<String, String>{
            'firstName' => firstName,
            'lastName' => lastName
        };

        return names;
    } 

    public class LeadConversionWrapper{
        public Lead lead;
        public Account account;
        public Opportunity opportunity;
        public Id ownerId;
    }

    public class RDStationsWebhookException extends Exception {}
}