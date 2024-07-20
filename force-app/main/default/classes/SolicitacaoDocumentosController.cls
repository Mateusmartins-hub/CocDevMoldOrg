public class SolicitacaoDocumentosController {
    public class ContactLink{
        @AuraEnabled
        public String nome {get; set;}
        
        @AuraEnabled
        public String email {get; set;}
        
        @AuraEnabled
        public Boolean isPJ {get; set;}
    }
    
    @AuraEnabled
    public static ContactLink getNameAndEmail(String id){
        try {
            Opportunity opp = [SELECT AccountId FROM Opportunity WHERE Id = :id];
            
            //Account_Contact__c accountContact = [SELECT Name, Email__c FROM Account_Contact__c WHERE Account__c = :opp.AccountId LIMIT 1];
            Contact accountContact = [SELECT Name, Email FROM Contact WHERE AccountId = :opp.AccountId LIMIT 1];
            ACcount acc = [SELECT RecordType.DeveloperName FROM Account WHERE id = :opp.AccountId LIMIT 1];
            
            ContactLink aContact = new ContactLink();
            aContact.nome = accountContact.Name;
            aContact.email = accountContact.Email;
            if (acc.RecordType.DeveloperName == 'PessoaJuridica')
                aContact.isPJ = true;
            else
                aContact.isPJ = false;
            
            return aContact;
        } catch(Exception err) {
            throw new AuraHandledException('É necessário que a conta possua pelo menos um Contact/Indivíduo para o envio da solicitação');
        }
    }
    
    public static void cleanTerms(String recordId) {
        Opportunity opp = [SELECT Id, TermosCondicoesAceitos__c FROM Opportunity WHERE Id = :recordId LIMIT 1];
        opp.TermosCondicoesAceitos__c = false;
        update opp;
    }
    
    @AuraEnabled
    public static void sendMissingDocumentsRequest(String email, String[] documentsToRequest, String recordId) {
        try {            
            
            Opportunity opp = [SELECT AccountId FROM Opportunity WHERE Id = :recordId];
            Account acc = [SELECT BR_Main_State__c FROM Account WHERE Id = :opp.AccountId LIMIT 1];
            
            EmailTemplate template = EmailTemplateDAO.getEmailTemplateByDeveloperName('SolicitacaoDocumentos');
            EmailUtil et = EmailUtil.getInstance();
            
            String separator = ',';
            String fieldsToQuery = String.join(documentsToRequest, separator);
            
            Site externalSite = [SELECT Id FROM Site WHERE Name = 'EnvioDocumentosCadastrais'];
            SiteDetail siteDetail = [SELECT SecureURL FROM SiteDetail WHERE DurableId = :externalSite.Id];
            
            String accountState;
            if(acc.BR_Main_State__c == null)
                accountState = 'SP';
            else
                accountState = acc.BR_Main_State__c;
            
            String url = siteDetail.SecureURL + '?documentsToSend=' + fieldsToQuery + '&state=' + accountState + '&recordId='+recordId;
            String body = template.HtmlValue.replace('{URL}', url);
            
            Set<String> receiverEmails = new Set<String> {email};
                
                et.sendMail(receiverEmails, body, template.subject);
            
            cleanTerms(recordId);
        } catch(Exception err) {
            System.debug(err);
            throw new AuraHandledException(err.getMessage());
        }
    }
}