global class AttachmentToContentDocument implements Database.Batchable<Solution> {
    
    global List<Solution> start(Database.BatchableContext BC){
         
        return [SELECT Id FROM Solution]; 
    }
     
    global void execute(Database.BatchableContext BC, List<Solution> sols) {
        
        List<Id> solIds = new List<Id>();
        for (Solution s : sols)
            solIds.add(s.Id);
        
        List<Attachment> anexos = [SELECT Id, ParentId, Name, Body, Description FROM Attachment WHERE ParentId IN :solIds];
        
        if (anexos.isempty())
            return;
        
        List<string> refs = new List<string>();
        for (Attachment att : anexos)
        {
            refs.add(att.ParentId);
        }
        
        List<Solucoes__kav> knowledges = [SELECT Id, SolutionRef__c FROM Solucoes__kav WHERE PublishStatus = 'Draft' AND SolutionRef__c IN :refs];
        
        
        Map<Id, Id> mapSolToKnow = new Map<Id, Id>();
        for (Solucoes__kav kav : knowledges)
        {
            mapSolToKnow.put(kav.SolutionRef__c, kav.Id);
        }
        
        List<ContentVersion> versions = new List<ContentVersion>();
        for (Attachment att : anexos)
        {
            ContentVersion cv = new ContentVersion();
            cv.ContentLocation = 'S';
            cv.VersionData = att.Body;
            cv.Title = att.Name;
            cv.PathOnClient = att.ParentId;
            
            versions.add(cv);
        } 
        
        insert versions;
        
        List<Id> idsCV = new List<Id>();
        for (ContentVersion cv : versions)
        {
            idsCV.add(cv.Id);
        } 
        
        List<ContentDocumentLink> links = new List<ContentDocumentLink>();
        for (ContentVersion cv : [SELECT Id, ContentDocumentId, PathOnClient FROM ContentVersion WHERE Id IN: idsCV])
        {
            if (!mapSolToKnow.containsKey(cv.PathOnClient))
                continue;
            
            ContentDocumentLink cdl = new ContentDocumentLink();
            cdl.ContentDocumentId = cv.ContentDocumentId;
            cdl.LinkedEntityId = mapSolToKnow.get(cv.PathOnClient);
            cdl.ShareType = 'V';
            
            links.add(cdl);
        }
        
        insert links;  
    }
    
    global void finish(Database.BatchableContext BC){
        
    }
}