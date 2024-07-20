global class bacthSetRelatedToIdEmail implements Database.Batchable<sObject>,Database.AllowsCallouts {
    
    global Database.QueryLocator start(Database.BatchableContext BC){        
        return Database.getQueryLocator('SELECT Id, ParentId, ActivityId, CreatedById, IdSegregacao__c, CreatedDate, LastModifiedDate, LastModifiedById, SystemModstamp, TextBody, HtmlBody, Headers, Subject, FromName, FromAddress, ValidatedFromAddress, ToAddress, CcAddress, BccAddress, Incoming, HasAttachment, Status, MessageDate, IsDeleted, ReplyToEmailMessageId, IsPrivateDraft, IsExternallyVisible, MessageIdentifier, ThreadIdentifier, IsClientManaged, RelatedToId, IsTracked, IsOpened, FirstOpenedDate, LastOpenedDate, IsBounced, EmailTemplateId, RelatedToId__c FROM EmailMessage  where RelatedToId__c != null');
    }
    
    global void execute(Database.BatchableContext BC, List<EmailMessage> scope){
        List<EmailMessage> deleteEm = new List<EmailMessage>();
        List<EmailMessage> insertEm = new List<EmailMessage>();
        for(EmailMessage em:scope){
            EmailMessage emClone = new EmailMessage();
            emClone = em.clone(false, false, false, false);
            emClone.ValidatedFromAddress = null;
            emClone.ActivityId = null;
            emClone.EmailTemplateId = null;
            emClone.ReplyToEmailMessageId = null;
            emClone.RelatedToId = emClone.RelatedToId__c;
            emClone.MessageDate = null;
            insertEm.add(emClone);
            deleteEm.add(em);
        }
        
        Database.SaveResult[] srList = Database.insert(insertEm, false);
        
        // Iterate through each returned result
        for (Database.SaveResult sr : srList) {
            if (sr.isSuccess()) {
                // Operation was successful, so get the ID of the record that was processed
                System.debug('Successfully inserted account. Account ID: ' + sr.getId());
            }
            else {
                // Operation failed, so get all errors                
                for(Database.Error err : sr.getErrors()) {
                    System.debug('The following error has occurred.');                    
                    System.debug(err.getStatusCode() + ': ' + err.getMessage());
                    System.debug('Account fields that affected this error: ' + err.getFields());
                }
            }
        }
        
		delete deleteEm;
    }
    
    global void finish(Database.BatchableContext BC){
        
    }
    
}