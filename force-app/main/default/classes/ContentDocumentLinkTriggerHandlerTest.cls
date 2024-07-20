@isTest
public class ContentDocumentLinkTriggerHandlerTest {
            
    @isTest
    static void testBeforeInsertUpdate(){
        Account acct					= new Account();
        acct.Name						= 'Test Account';
        insert acct;
        
        ContentVersion contentVersion	= new ContentVersion();
        contentVersion.Title 			= 'New Attachment';
       	contentVersion.PathOnClient 	= 'Attachment.jpg';
        contentVersion.VersionData 		= Blob.valueOf('Test Attachment');
        contentVersion.IsMajorVersion 	= true;        
        insert contentVersion;    
        
        List<ContentDocument> documents = [SELECT Id, Title, LatestPublishedVersionId FROM ContentDocument];
       
        ContentDocumentLink cdl 		= New ContentDocumentLink();
        cdl.LinkedEntityId 				= acct.id;
        cdl.ContentDocumentId 			= documents[0].Id;
        cdl.shareType 					= 'V';
        insert cdl;
        
        update cdl;
    }

}