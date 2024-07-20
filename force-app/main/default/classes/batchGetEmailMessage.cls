global class batchGetEmailMessage implements Database.Batchable<sObject>,Database.AllowsCallouts {
    global GetAttachmentsEndPoint__c endPoint = GetAttachmentsEndPoint__c.getOrgDefaults();
    global string urlPrefix 	= endPoint.URLPrefix__c;
    global string authToken 	= endPoint.Auth_Token__c;
    
    global Database.QueryLocator start(Database.BatchableContext BC){        
        return Database.getQueryLocator('SELECT Id, IDSegregacao__c, Processado__c FROM GetEmail__c WHERE Processado__c = false');
    }
    
    global void execute(Database.BatchableContext BC, List<GetEmail__c> scope){
        List<GetEmail__c> lstGetEmail = new List<GetEmail__c>();
        List<EmailMessage> lstEmail = new List<EmailMessage>();
        
        for(GetEmail__c ax : scope){
            
            HttpRequest req = new HttpRequest();
            req.setEndpoint(urlPrefix + '/services/data/v53.0/sobjects/EmailMessage/' + ax.IDSegregacao__c);
            req.setMethod('GET');
            req.setHeader('Authorization', authToken); 
            
            Http http = new Http();
            HTTPResponse response = http.send(req);
            if(response.getStatusCode() == 200){
                
                EmailMessage em = (EmailMessage)JSON.deserialize(response.getBody(), EmailMessage.class);
                em.IdSegregacao__c = em.Id;
                em.Id = null;
                em.ValidatedFromAddress = null;
                em.ParentId = null;
                em.ActivityId = null;
                em.EmailTemplateId = null;
                em.ReplyToEmailMessageId = null;
                em.RelatedToId = null;
                em.MessageDate = null;
                lstEmail.add(em);
                
                ax.Processado__c = true;
                lstGetEmail.add(ax);
            }  
            
        }
        if(!lstEmail.isEmpty()){
            Database.SaveResult[] lsr = Database.insert(lstEmail, false);
            for(Database.SaveResult res:lsr){
                System.debug('lstEmail('+res.getId()+'): '+res);
            }
            
        }
        
        if(!lstGetEmail.isEmpty()){
            Database.SaveResult[] lsr = Database.update(lstGetEmail);
             for(Database.SaveResult res:lsr){
                System.debug('lstGetEmail('+res.getId()+'): '+res);
            }
        }
    }
    
    global void finish(Database.BatchableContext BC){
        
    }
    
}