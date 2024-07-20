public with sharing class VerificaProximidadeVisita {

    public static void estaProxima(){
        List<SugestaoVisita__c> visitas = [select Id,DataConfirmada__c,Lead__c,EnviadoPor__c from SugestaoVisita__c where 	DataConfirmada__c = NEXT_N_DAYS:2 ];

        System.debug(visitas.size());
        for (SugestaoVisita__c v:visitas){
            enviarEmailCliente(v);
            //enviarEmailConsultor(v);

        }

    }

    private static void enviarEmailCliente(SugestaoVisita__c visita){
        String emailTemplateName = 'Proximidade de Visita';
        EmailTemplate emailTemplate = EmailTemplateDAO.getInstance().getEmailTemplateByName(emailTemplateName);
        String assunto = emailTemplate.Subject;

        list<Messaging.SingleEmailMessage> lEmail = new list<Messaging.SingleEmailMessage>();

            Messaging.SingleEmailMessage email = new Messaging.SingleEmailMessage();
            String htmlBody = emailTemplate.HtmlValue;	
            htmlBody = htmlBody.replace('{dataSug1}', visita.DataConfirmada__c.format());
            Lead lead = LeadDAO.BuscaApenasLeadPorId(visita.Lead__c);

            if (lead.email != null){
                email.setToAddresses(new List<String>{lead.Email});
                email.setSubject(assunto);
                email.setHtmlBody(htmlBody);
                lEmail.add(email);
            }
        
            Messaging.sendEmail(lEmail);
        }

    // private static void enviarEmailConsultor(SugestaoVisita__c visita){
    //     String emailTemplateName = 'Proximidade Visita Consultor';
    //     EmailTemplate emailTemplate = EmailTemplateDAO.getInstance().getEmailTemplateByName(emailTemplateName);
    //     String assunto = emailTemplate.Subject;

    //     list<Messaging.SingleEmailMessage> lEmail = new list<Messaging.SingleEmailMessage>();

    //         Messaging.SingleEmailMessage email = new Messaging.SingleEmailMessage();
    //         String htmlBody = emailTemplate.HtmlValue;	
    //         htmlBody = htmlBody.replace('{nomeConsultor}', visita.DataConfirmada__c.format());
    //         Lead lead = LeadDAO.BuscaApenasLeadPorId(visita.Lead__c);
    //         if (lead.OwnerId != null){
    //             User ownerLead = [select Email from User where Id = :lead.OwnerId];
    //             email.setToAddresses(new List<String>{ownerLead.Email});
    //             email.setSubject(assunto);
    //             email.setHtmlBody(htmlBody);
    //             lEmail.add(email);
    //         }
        
    //         Messaging.sendEmail(lEmail);
    //     }

}