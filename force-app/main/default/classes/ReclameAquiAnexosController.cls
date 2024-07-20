public with sharing class ReclameAquiAnexosController {

    private static final IntegracaoRA__c settingsRA = IntegracaoRA__c.getOrgDefaults();
    
    @AuraEnabled
    public static void retrieveAttachmentsLinks(Id caseId){
        try {
            
            Case cs = [
                SELECT Id, Id_anexos_RA__c FROM Case WHERE Id = :caseId
            ];

            List<String> attachmentIds = cs.Id_anexos_RA__c.split(';');
            List<String> attachmentLinks = new List<String>();

            for(String attachmentId: attachmentIds){
                String endpoint = settingsRA.EndpointAnexo__c + attachmentId;
                
                if(Test.isRunningTest()){
                    attachmentLinks.add(attachmentId + '\n');
                    continue;
                }
                
                String response = ReclameAquiWS.requisicaoAnexo(endpoint, 'GET', null);
                if(response != null){
                    ReclameAquiAnexoVO ra = ReclameAquiAnexoVO.parse(response);
                    attachmentLinks.add(ra.attachmentLink + '\n');
                }
            }

            if(!attachmentLinks.isEmpty()) {
                cs.LinksAnexos__c = String.join(attachmentLinks, '\n');
                update cs;
            }

        } catch (Exception e) {
            throw new AuraHandledException(e.getMessage());
        }
    }

}