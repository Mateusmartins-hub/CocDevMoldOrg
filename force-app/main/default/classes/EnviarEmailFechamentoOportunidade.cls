global class EnviarEmailFechamentoOportunidade implements Database.Batchable<sObject>{
    private OrgWideEmailAddress sender;
    
    global EnviarEmailFechamentoOportunidade(){
        
    }

    global EnviarEmailFechamentoOportunidade(OrgWideEmailAddress sender) {
        this.sender = sender;
    }

    // The batch job starts
    global Database.Querylocator start(Database.BatchableContext bc) {
        String query = 'select Id, OwnerId, CloseDate, CreatedDate, Owner.Name from Opportunity where stagename != \'Cancelada\' and  CloseDate <= next_n_days:' +30 + ' and CloseDate > today';
        return Database.getQuerylocator(query);
    }

    global void enviarEmail(List<Opportunity> opps, Map<Id, User> usuarios) {
        String emailTemplateName = 'Proximidade de visita';
        EmailTemplate emailTemplate = EmailTemplateDAO.getInstance().getEmailTemplateByName(emailTemplateName);
        System.debug(emailTemplate.Subject);
        String assunto = emailTemplate.Subject;



        List<String> destinatarios = new List<String>();
        Validate validate = Validate.getInstance();
        Date hoje = Date.today();
        for(Opportunity opp :opps) {
            
            if(validate.validateEmail(usuarios.get(opp.OwnerId).Email)) {
                Integer diasFaltantes = hoje.daysBetween(opp.CloseDate);
                Integer diasAberto = Test.isRunningTest() ? 1 : opp.CreatedDate.date().daysBetween(hoje);
                System.debug('DF ' + diasFaltantes);
                //Se faltar 30,15,3 ou 1 dia para fechar a oportunidade envia um email
                if(diasFaltantes == 30 || diasFaltantes == 15 || diasFaltantes == 3 || diasFaltantes == 1) {
                    list<Messaging.SingleEmailMessage> lEmail = new list<Messaging.SingleEmailMessage>();
                    Messaging.SingleEmailMessage email = new Messaging.SingleEmailMessage();
                    String htmlBody = emailTemplate.HtmlValue;
                    htmlBody = htmlBody.replace('{numeroDiasAberta}', String.valueOf(diasAberto));
                    htmlBody = htmlBody.replace('{numeroDiasFaltantes}', String.valueOf(diasFaltantes));
                    String url = URL.getSalesforceBaseUrl().toExternalForm() + '/' + opp.Id;
                    htmlBody = htmlBody.replace('{URL}', url);
                    system.debug('Enviado ' + usuarios.get(opp.OwnerId).Email);
                    email.setToAddresses(new List<String>{ usuarios.get(opp.OwnerId).Email });
                    email.setOrgWideEmailAddressId(sender.Id);
                    email.setSubject(assunto);
                    email.setHtmlBody(htmlBody);
                    lEmail.add(email);
                    System.debug(Messaging.sendEmail(lEmail));
                }
            }

        }

    }

    // The batch job executes and operates on one batch of records
    global void execute(Database.BatchableContext bc, List<sObject> scope) {
        try{
            Date startDate = Date.today();
            Map<Id, User> usuarios = new Map<Id, User>([select Id, email from User]);
            enviarEmail(scope, usuarios);
        } catch(Exception e) {
            System.debug(e.getStackTraceString());
            System.debug(e.getMessage());
            System.debug(e.getLineNumber());
        }



    }

    global void finish(Database.BatchableContext BC) {
    }
}