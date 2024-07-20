@RestResource(urlMapping='/MeetimeApi/*')
global without sharing class RestMeetime {
    @HttpPost
    global static String doPost() {
        String jsonString = RestContext.request.requestBody.toString();
        System.debug(jsonString);
        MeetimeParam p = MeetimeParam.parse(jsonString);
        
        String nomeVendedor = p.prospection.salesman.name;
        
        List<User> user = new List<User>();
        Id ownerId;
        
        if(nomeVendedor.split(' ').size() > 1)
            user = [SELECT Id FROM User WHERE FirstName =: nomeVendedor.split(' ')[0] AND LastName =: nomeVendedor.split(' ')[1]];
        
        if(user.size() > 0)
            ownerId = user[0].Id;
        else
            ownerId = [SELECT Id FROM User WHERE FirstName = 'teste' AND LastName = 'segregacao'][0].Id;
        
        Lead l = paramToLead(p.prospection);
        l.OwnerId = ownerId;
        l.Resultado__c = 'Qualificado';
        insert l;
        
        Account a = paramToAccount(p.prospection);
        a.OwnerId = ownerId;
        List<Account> accounts = [SELECT Id FROM Account WHERE BR_Account_email__c = :a.BR_Account_email__c];
        if (accounts.size() == 0)
        	insert a;
        else
            a = accounts[0];

        MeetimeParam.Prospection params = p.prospection;        
        Opportunity o = paramToOpportunity(p.prospection);
        o.AccountId = a.Id;
        o.OwnerId = ownerId;
        o.URLPublicaMeetime__c = params.Lead.publicUrl; 
        insert o;
        
        Database.LeadConvert lc = new database.LeadConvert();
        lc.setLeadId(l.id);
        lc.setConvertedStatus('Finalizado');
        lc.setOwnerId(ownerId);
        lc.setAccountId(a.Id);
        lc.setOpportunityId(o.Id);
        
        Database.LeadConvertResult lcr = Database.convertLead(lc);
        
        //Id contactId = lcr.getContactId();        
        //Contact ctc = [SELECT Id From Contact WHERE ID = :contactId];
        //delete ctc;
        
        return 'OK';
    }
    
    private static Lead paramToLead(MeetimeParam.Prospection p) {
        Lead l = new Lead();
        
        l.FirstName = p.lead.firstName == null ? 'Não informado' : buildFirstName(p.lead.name);
        l.LastName = p.lead.name == null ? 'Não informado' : buildLastName(p.lead.name);
        l.Company = p.lead.company == null ? 'Não informado' : p.lead.company;
        l.Email = p.lead.email;
        l.City = p.lead.city;
        l.State = p.lead.state;
        l.Website = p.lead.site;
        l.Description = p.lead.annotations;
        
        l.LigacaoRealizada__c = true;
        
        return l;
    }
    
    private static Account paramToAccount(MeetimeParam.Prospection p) {
        Account a = new Account();
        
        a.Name = buildFirstName(p.lead.name) + ' ' + buildLastName(p.lead.name);
        a.RecordTypeId =  Schema.SObjectType.Account.getRecordTypeInfosByDeveloperName().get('Pessoa_F_sica').getRecordTypeId();
        a.BR_Account_email__c = p.lead.email;
        a.BR_Main_City__c = p.lead.city;
        a.BR_Main_State__c = p.lead.state;
        a.Website = p.lead.site;
        a.Description = p.lead.annotations;
        
        if(p.lead.customFields.marcaSf == '181ec979-9736-4f50-a3a9-e4a3c60abf4b')
            a.Marca__c = 'Yázigi';
        else if(p.lead.customFields.marcaSf == '001793dc-e2c7-409e-8ea1-fe1b673f793d')
            a.Marca__c = 'Wizard';
        else if(p.lead.customFields.marcaSf == 'ad7e95ba-0408-446f-b9ad-19a361183521')
            a.Marca__c = 'Skill';  
        
        return a;
    }
    
    private static Opportunity paramToOpportunity(MeetimeParam.Prospection p) {
        Opportunity o = new Opportunity();
        
        o.Name = 'Oportunidade de Franquias ' + buildFirstName(p.lead.name) + ' ' + buildLastName(p.lead.name);
        o.RecordTypeId = Schema.SObjectType.Opportunity.getRecordTypeInfosByDeveloperName().get('ExpansaoFranquias').getRecordTypeId();
        o.StageName = 'Interesse Inicial - Franquias';
        o.LeadSource = 'Meetime';
        o.CloseDate = System.today().addDays(120);
        
        return o;
    }
    
    private static String buildFirstName(String nome) {
        if(nome.contains(' ')) {
            return nome.substringBefore(' ');
        }else{
            return nome;
        }
    }
    
    private static String buildLastName(String nome) {
        if(nome.contains(' ')) {
            return nome.substringAfter(' ');
        }else{
            return nome;
        }
    }
}