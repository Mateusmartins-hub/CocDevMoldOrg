public class AmostraFisica_Status {

    public static void validarAmostraEntregue(List<AmostraFisica__c> amostras) {
        for(AmostraFisica__c a : amostras) {
            if(a.Status__c == 'Entregue' || a.Status__c == 'Integrada')  a.addError('Amostra física entregue. Não poderá ser realizada alterações.');
        }
    }

    public static void blockChangesAfterIntegration(List<AmostraFisica__c> oldAmostras, Map<Id, AmostraFisica__c> newAmostras) {
        for (AmostraFisica__c amostra : oldAmostras) {
            if (amostra.Status__c == 'Integrada') {
                AmostraFisica__c newAmostra = newAmostras.get(amostra.Id);
                if (newAmostra.Status__c != 'Entregue')
                    newAmostra.addError('Amostra física integrada. Não poderá ser realizada alterações.');
            }
            else if (amostra.Status__c == 'Entregue' || amostra.Status__c == 'Integrada') {
                AmostraFisica__c newAmostra = newAmostras.get(amostra.Id);
                newAmostra.addError('Amostra física entregue. Não poderá ser realizada alterações.');
            }
        }
    }

    public static void enviarEmailConsultorAgendarVisita(List<AmostraFisica__c> amostras) {
        Set<Id> oppsIds = new Set<Id>();
        for (AmostraFisica__c amostra : amostras) {
            if (amostra.Status__c == 'Entregue')
                oppsIds.add(amostra.Oportunidade__c);
        }

        EmailTemplate template = EmailTemplateDAO.getEmailTemplateByDeveloperName('AgendarVisitaConsultor');
        List<Opportunity> opps = [SELECT Id, OwnerId, Owner.Email, Owner.Name, Account.Name FROM Opportunity WHERE ID IN :oppsIds];
        for (Opportunity opp : opps) {
            String body = template.HtmlValue.replace('{NOMECONSULTOR}', opp.Owner.Name).replace('{NOMECONTA}', opp.Account.Name);
            Messaging.SingleEmailMessage message = new Messaging.SingleEmailMessage();
            message.toAddresses = new String[] { opp.Owner.Email };
            message.subject = template.Subject;
            message.htmlbody = body;
            Messaging.SingleEmailMessage[] messages = new List<Messaging.SingleEmailMessage> {message};
            Messaging.SendEmailResult[] results = Messaging.sendEmail(messages);
        }
    }
}