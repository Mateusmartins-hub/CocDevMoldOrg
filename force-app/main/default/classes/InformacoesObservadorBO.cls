public class InformacoesObservadorBO {
    public static void enviarEmailObservadores(List<InformacoesObservador__c> infos) {
        List<Id> observadores = new List<Id>();
        List<Id> casosIds = new List<Id>();
        List<Id> infosIds = new List<Id>();
        
        for(InformacoesObservador__c info : infos) {
            infosIds.add(info.Id);
            
            if(info.Observador__c != null)
                observadores.add(info.Observador__c);
            if(info.Caso__c != null)
                casosIds.add(info.Caso__c);
        }
        
        EmailTemplate et = [SELECT Id, Body, HtmlValue FROM EmailTemplate WHERE DeveloperName = 'ObservadorDoCasoTemplate' LIMIT 1];
        Messaging.SingleEmailmessage[] emails = new Messaging.SingleEmailmessage[]{};
        Map<Id, Case> mapCaso = new Map<Id, Case>([SELECT Id, CaseNumber FROM Case WHERE Id IN: casosIds]);
        Map<Id, User> mapUsers = new Map<Id, User>([SELECT Id, Name FROM User WHERE Id IN: observadores]);
        
        for(InformacoesObservador__c info : infos) {
            String textoCorpo = et.HtmlValue;
            textoCorpo = textoCorpo.replace('{!NomeObservador}', mapUsers.get(info.Observador__c).Name);
            textoCorpo = textoCorpo.replace('{!NumeroCaso}', mapCaso.get(info.Caso__c).CaseNumber);
            textoCorpo = textoCorpo.replace('{!NomeAdicionadoPor}', UserInfo.getFirstName() + ' ' + UserInfo.getLastName());
            textoCorpo = textoCorpo.replace('{!InformacaoAoObservador}', info.Informacao__c);
            textoCorpo = textoCorpo.replace('{!LinkCaso}', URL.getSalesforceBaseUrl().toExternalForm() + '/' + mapCaso.get(info.Caso__c).Id);
            
            Messaging.Singleemailmessage email = new Messaging.Singleemailmessage();
            email.setSubject('Observador do caso');
            email.setWhatId(info.Id);
            email.setTargetObjectId(info.Observador__c);
            email.setSaveAsActivity(false);
            email.setHtmlBody(textoCorpo);
            
            emails.add(email);
        }
        
        Messaging.sendEmail(emails);
    }
    
    @future
    public static void compartilharCaso(Set<Id> infosId) { /*
        List<CaseShare> newCazeList = new List<CaseShare>();
        List<InformacoesObservador__c> infos = [SELECT Id, Caso__c, Observador__c FROM InformacoesObservador__c WHERE Id IN: infosId];
        
        for(InformacoesObservador__c i : infos){
            CaseShare newCaze = new CaseShare();
            newCaze.CaseId = i.Caso__c;
            newCaze.UserOrGroupId = i.Observador__c;
            newCaze.CaseAccessLevel = 'Read';
            newCaze.RowCause = 'Manual';
            newCazeList.add(newCaze);
        }
        
        insert newCazeList; */
    }
}