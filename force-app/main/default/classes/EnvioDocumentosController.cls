public class EnvioDocumentosController {
    public class DocumentLink{
        @AuraEnabled
        public String documentName {get; set;}
        
        @AuraEnabled
        public String documentURL {get; set;}
        
        @AuraEnabled
        public String documentFieldName {get; set;}
    }      
    @AuraEnabled
    public static DocumentLink[] getDocumentsURL(String[] documentsToSend, String accountState){
        String separator = ', ';
        String fieldsToQuery = String.join(documentsToSend, separator);
        OrientacoesDocumentosCadastrais__mdt orientacoes = Database.query('SELECT ' +fieldsToQuery+ ' FROM OrientacoesDocumentosCadastrais__mdt WHERE Estado__c = :accountState LIMIT 1');
        
        List<DocumentLink> documents = new List<DocumentLink>();
        
        Map<String, Schema.SObjectType> schemaMap = Schema.getGlobalDescribe();
        Schema.SObjectType orientacoesSchema = schemaMap.get('OrientacoesDocumentosCadastrais__mdt');
        Map<String, Schema.SObjectField> fieldMap = orientacoesSchema.getDescribe().fields.getMap();
        
        for (String document : documentsToSend) {
            DocumentLink dl = new DocumentLink();
            dl.documentURL = (String) orientacoes.get(document);
            
            String fieldLabel = fieldMap.get(document).getDescribe().getLabel();            
            dl.documentName = fieldLabel;
            
            dl.documentFieldName = document;
            
            if (dl.documentName != null || dl.documentURL != null)
                documents.add(dl);
        }
        
        return documents;
    }
    
    @AuraEnabled
    public static void saveTheFile(Id parentId, String fieldName, String base64Data, String fileName, String contentType) {
        base64Data = EncodingUtil.urlDecode(base64Data, 'UTF-8');        
       DocumentosCadastrais__c dc;
        try {
            dc = [SELECT Id FROM DocumentosCadastrais__c WHERE Opportunity__c = :parentId];
        } catch(Exception err) {
            Opportunity opp = [SELECT AccountId, Name FROM Opportunity WHERE Id = :parentId];
            dc = new DocumentosCadastrais__c();
            dc.Name = opp.Name + ' docs';
            dc.Opportunity__c = parentId;
			dc.Account__c = opp.AccountId;
            insert dc;
        }

        Attachment a = new Attachment();
        a.parentId = dc.Id;
        a.Body = EncodingUtil.base64Decode(base64Data);
        a.Name = fileName;
        a.ContentType = contentType;
        
        insert a;        
    }
    
    @AuraEnabled
    public static void acceptTerms(Id recordId) {
        Opportunity opp = [SELECT Id, TermosCondicoesAceitos__c FROM Opportunity WHERE Id = :recordId LIMIT 1];
        opp.TermosCondicoesAceitos__c = true;
        update opp;
    }
}