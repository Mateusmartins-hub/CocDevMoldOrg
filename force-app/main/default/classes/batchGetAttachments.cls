global class batchGetAttachments implements Database.Batchable<sObject>,Database.AllowsCallouts {
    global GetAttachmentsEndPoint__c endPoint = GetAttachmentsEndPoint__c.getOrgDefaults();
    global string urlPrefix 	= endPoint.URLPrefix__c;
    global string authToken 	= endPoint.Auth_Token__c;
    global string parentType	= endPoint.Parent_Type__c;
    
    global Database.QueryLocator start(Database.BatchableContext BC){        
        return Database.getQueryLocator('SELECT Id,Name__c,IDSegregacao__c,ParentIdReal__c,Processado__c,ParentType__c FROM Anexo__c WHERE Processado__c!=true AND ParentIdReal__c!=null AND ParentIdReal__c!=\'\' AND ParentIdReal__c!=\'#N/D\' AND ParentType__c=\''+parentType+'\' ');
    }
    
    global void execute(Database.BatchableContext BC, List<Anexo__c> scope){
        List<Anexo__c> lstUpdAnexos = new List<Anexo__c>();
        List<Attachment> lstAttach = new List<Attachment>();
        
        for(Anexo__c ax : scope){
            
            HttpRequest req = new HttpRequest();
            req.setEndpoint(urlPrefix + '/services/data/v53.0/sobjects/Attachment/'+ax.IDSegregacao__c+'/body');
            req.setMethod('GET');
            req.setHeader('Authorization', authToken); 
            
            Http http = new Http();
            HTTPResponse response = http.send(req);
            
            if(response.getStatusCode() == 200){    
                //System.debug('arquivo: '+ax.Name__c);
                Blob arquivo 	= response.getBodyAsBlob();
                Attachment att	= new Attachment();
                att.Body		= arquivo;
                att.Name		= ax.Name__c;
                att.parentId	= ax.ParentIdReal__c;
                lstAttach.add(att);
                
                ax.Processado__c = true;
                lstUpdAnexos.add(ax);
            }  
            
        }
        if(!lstAttach.isEmpty()){
            insert lstAttach;
        }
        
        if(!lstUpdAnexos.isEmpty()){
            update lstUpdAnexos;
        }
    }
    
    global void finish(Database.BatchableContext BC){
        
    }
    
}