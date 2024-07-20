public class AgendamentoVisitaConsultorController {

    public class Objeto {
        @AuraEnabled
        public Id idObjeto {get;set;}
        @AuraEnabled
        public String Prefixo {get;set;}
        @AuraEnabled
        public String Email {get;set;}
        @AuraEnabled
        public String Erro {get;set;}
        @AuraEnabled
        public Date dataSug1 {get;set;}
        @AuraEnabled
        public Date dataSug2 {get;set;}
        @AuraEnabled
        public Date dataSug3 {get;set;}
        @AuraEnabled
        public String EnviadoPor {get;set;}
        @AuraEnabled
        public String horaInicial {get;set;}
        @AuraEnabled
        public String horaFinal {get;set;}
        @AuraEnabled
        public String tempoApresentacao {get;set;}
        @AuraEnabled
        public Date DataConfirmada {get;set;}
        @AuraEnabled
        public string TipoSistemaDeEnsino{get;set;}
    }

    @AuraEnabled
    public static Objeto getObject(String id) {
        BusinessDays bd = new BusinessDays();
        Objeto obj = new Objeto();
        try {
            Lead ld = LeadDAO.BuscaLead(id);
            obj.IdObjeto = ld.Id;
            obj.Prefixo = 'ld';
            obj.Email = ld.Email;
            obj.TipoSistemaDeEnsino = ld.SistemaEnsino__c;

            if(!ld.SugestoesVisitas__r.isEmpty()) {
                obj.dataSug1 = ld.SugestoesVisitas__r[0].Data1__c;
                obj.dataSug2 = ld.SugestoesVisitas__r[0].Data2__c;
                obj.dataSug3 = ld.SugestoesVisitas__r[0].Data3__c;
                obj.horaInicial = ld.SugestoesVisitas__r[0].HoraInicialSugerida__c.hour() + 'h' + ld.SugestoesVisitas__r[0].HoraInicialSugerida__c.minute();
                obj.horaFinal = ld.SugestoesVisitas__r[0].HoraFinalSugerida__c.hour() + 'h' + ld.SugestoesVisitas__r[0].HoraFinalSugerida__c.minute();
                obj.tempoApresentacao = String.valueOf(Decimal.ValueOf(obj.horaFinal).SetScale(2) - Decimal.ValueOf(obj.horaInicial).SetScale(2)).replace('.3', '.5');
                obj.EnviadoPor = ld.SugestoesVisitas__r[0].EnviadoPor__c;
                obj.DataConfirmada = ld.SugestoesVisitas__r[0].DataConfirmada__c;
            }

        } catch (Exception e) {
            System.debug(e.getMessage());
            System.debug(e.getStackTraceString());
        }
        try {
            Opportunity op = OpportunityDAO.buscaOportunidade(id);
            Account ac = AccountDAO.buscaConta(op.AccountId);
            obj.IdObjeto = op.Id;
            obj.Prefixo = 'op';
            obj.TipoSistemaDeEnsino = ac.SistemaEnsino__c;
            
            if(ac.Contacts.size() > 0)
                obj.Email = ac.Contacts[0].Email;
            else
                obj.Email = op.Account.BR_Account_email__c;

            
            if(!op.SugestoesVisitas__r.isEmpty()) {
                obj.dataSug1 = op.SugestoesVisitas__r[0].Data1__c;
                obj.dataSug2 = op.SugestoesVisitas__r[0].Data2__c;
                obj.dataSug3 = op.SugestoesVisitas__r[0].Data3__c;
                obj.horaInicial = op.SugestoesVisitas__r[0].HoraInicialSugerida__c.hour() + 'h' + op.SugestoesVisitas__r[0].HoraInicialSugerida__c.minute();
                obj.horaFinal = op.SugestoesVisitas__r[0].HoraFinalSugerida__c.hour() + 'h' + op.SugestoesVisitas__r[0].HoraFinalSugerida__c.minute();
                obj.tempoApresentacao = String.valueOf(Decimal.ValueOf(obj.horaFinal).SetScale(2) - Decimal.ValueOf(obj.horaInicial).SetScale(2));
                obj.EnviadoPor = op.SugestoesVisitas__r[0].EnviadoPor__c;
                obj.DataConfirmada = op.SugestoesVisitas__r[0].DataConfirmada__c;
            }
        } catch (Exception e) {
            System.debug(e.getMessage());
        }

        List<Formulario__c> forms = [SELECT Id, CreatedDate
                                                       FROM Formulario__c
                                                       WHERE (Oportunidade__c =: id OR Lead__c =: id) AND RecordType.DeveloperName = 'Resposta'
                                                       ORDER BY CreatedDate DESC LIMIT 1];

        if(!forms.isEmpty()) {
            if (obj.dataSug1 == null)
                obj.dataSug1 = DateUtil.dateTimeToDate(bd.addDays(forms[0].createdDate, 7));
            if (obj.dataSug2 == null)
                obj.dataSug2 = DateUtil.dateTimeToDate(bd.addDays(forms[0].createdDate, 8));
            if (obj.dataSug3 == null)
                obj.dataSug3 = DateUtil.dateTimeToDate(bd.addDays(forms[0].createdDate, 9));
        }else{
            if (obj.dataSug1 == null)
                obj.dataSug1 = DateUtil.dateTimeToDate(bd.addDays(System.today(), 7));
            if (obj.dataSug2 == null)
                obj.dataSug2 = DateUtil.dateTimeToDate(bd.addDays(System.today(), 8));
            if (obj.dataSug3 == null)
                obj.dataSug3 = DateUtil.dateTimeToDate(bd.addDays(System.today(), 9));
        }

        if (String.isBlank(obj.Email))
            obj.Erro = 'Preencha o e-mail para agendar a visita';

        return obj;
    }

    @AuraEnabled
    public static String saveSugestionsAndSendEmail(Objeto objeto, String tipoVisita)  {
        if(objeto.dataSug1 <= System.today() || objeto.dataSug2 <= System.today() || objeto.dataSug3 <= System.today()){
            return 'As datas não podem ser menores ou iguais à hoje';
        }

        Integer maxDias = 180;
        if(objeto.dataSug1 > System.today().addDays(maxDias) || objeto.dataSug2 > System.today().addDays(maxDias) || objeto.dataSug3 > System.today().addDays(maxDias)){
            return 'As datas não podem ser maiores que ' + maxDias + ' dias';
        }

        try{
            SugestaoVisita__c sug = new SugestaoVisita__c();

            if(objeto.Prefixo == 'op') {
                sug.Oportunidade__c = objeto.IdObjeto;

                Opportunity op = OpportunityDAO.buscaOportunidade(objeto.IdObjeto);
                op.OwnerId = UserInfo.getUserId();
                update op;

            } else if(objeto.Prefixo == 'ld') {
                sug.Lead__c = objeto.IdObjeto;

                Lead ld  = LeadDAO.BuscaLead(objeto.IdObjeto);
                ld.OwnerId = UserInfo.getUserId();
                update ld;
                
            }

            sug.Data1__c = objeto.dataSug1;
            sug.Data2__c = objeto.dataSug2;
            sug.Data3__c = objeto.dataSug3;

            Integer horaInicial = Integer.valueOf(objeto.horaInicial.replace('h', ''));
            Integer horaFinal = Integer.valueOf(objeto.horaFinal.replace('h', '').replace(':30', ''));
            Integer minutosHoraFinal = Integer.valueOf(objeto.horaFinal.contains(':30') ? 30 : 0);

            
            sug.HoraInicialSugerida__c = Time.newInstance(horaInicial, 0, 0, 0);
            sug.HoraFinalSugerida__c = Time.newInstance(horaFinal, minutosHoraFinal, 0, 0);
            sug.EnviadoPor__c = 'Consultor';
            sug.TipoVisita__c = tipoVisita == 'VisitaExpansao' ? 'Visita de Expansão' : 'Visita Pedagógica';
            insert sug;
        }catch(Exception e) {
            return e.getMessage() + ' ' + e.getLineNumber();
        }

        try{
            Site externalSite = [SELECT Id FROM Site WHERE Name = 'AgendamentoVisita'];
            SiteDetail siteDetail = [SELECT SecureURL FROM SiteDetail WHERE DurableId = :externalSite.Id];

            String url = siteDetail.SecureURL + '?' + objeto.Prefixo + '=' + objeto.IdObjeto + '&amp;tpV=' + tipoVisita;
            String urlData1 = siteDetail.SecureURL + '?' + objeto.Prefixo + '=' + objeto.IdObjeto + '&amp;dtCnf=' + DateUtil.formatDate(objeto.dataSug1).replace('/', '-');
            String urlData2 = siteDetail.SecureURL + '?' + objeto.Prefixo + '=' + objeto.IdObjeto + '&amp;dtCnf=' + DateUtil.formatDate(objeto.dataSug2).replace('/', '-');
            String urlData3 = siteDetail.SecureURL + '?' + objeto.Prefixo + '=' + objeto.IdObjeto + '&amp;dtCnf=' + DateUtil.formatDate(objeto.dataSug3).replace('/', '-');

            EmailTemplate template;

            List<VisitaEmailTemplates__mdt> templateType = [SELECT emailDeveloperName__c FROM VisitaEmailTemplates__mdt WHERE tipoVisita__c = :tipoVisita AND sistemaDeEnsino__c = :objeto.TipoSistemaDeEnsino];

            if (templateType.size() > 0) {
                String emailDeveloperName = templateType[0].emailDeveloperName__c;
                template = EmailTemplateDAO.getEmailTemplateByDeveloperName(emailDeveloperName);
            }
            else
                template = getDefaultVisitaTemplate(tipoVisita);

            Time horaInicial = formatHour(objeto.horaInicial);
            Time horaFinal =  formatHour(objeto.horaFinal);
    
            String body = template.HtmlValue
                                            .replace('{URL}', url)
                                            .replace('{dataSug1}', DateUtil.formatDate(objeto.dataSug1))
                                            .replace('{dataSug2}', DateUtil.formatDate(objeto.dataSug2))
                                            .replace('{dataSug3}', DateUtil.formatDate(objeto.dataSug3))
                                            .replace('{linkDatSug1}', urlData1)
                                            .replace('{linkDatSug2}', urlData2)
                                            .replace('{linkDatSug3}', urlData3)
                                            .replace('{horaInicial}', horaInicial.hour() + 'h' + horaInicial.minute())
                                            .replace('{horaFinal}', horaFinal.hour() + 'h'+ horaFinal.minute());
            
            List<String> userId = new List<String>{ UserInfo.getUserId() };
            User user = UserDAO.getListUserByIdsUsers(userId)[0];
            System.debug(user);

            Messaging.SingleEmailMessage message = new Messaging.SingleEmailMessage();
            message.toAddresses = new String[] { objeto.Email };
            message.subject = template.Subject;
            message.htmlbody = body;            
            message.setReplyTo(user.Email);
            message.setSenderDisplayName(user.FirstName + ' ' + user.LastName);
            Messaging.SingleEmailMessage[] messages =   new List<Messaging.SingleEmailMessage> {message};
            Messaging.SendEmailResult[] results = Messaging.sendEmail(messages);

            return 'SUCESSO';
        }catch(Exception e) {
            return e.getMessage() + ' ' + e.getLineNumber();
        }
    }

    private static Time formatHour(String horario) {
        if(String.isNotBlank(horario)) {
            Integer horasHorario = Integer.valueOf(horario.replace(':30', '').replace('h', '').replace('.30', '').replace('.50', ''));
            Integer minutosHorario = Integer.valueOf(horario.contains(':30') ? 30 : 0);
            return Time.newInstance(horasHorario, minutosHorario, 0, 0);
        }
        
        return Time.newInstance(0, 0, 0, 0);
    }

    public static EmailTemplate getDefaultVisitaTemplate(String tipoDaVisita) {
        if(tipoDaVisita == 'VisitaExpansao')
            return [SELECT id, HtmlValue, Subject FROM EmailTemplate WHERE DeveloperName = 'VisitaExpansaoLead'];
        else
            return [SELECT id, HtmlValue, Subject FROM EmailTemplate WHERE DeveloperName = 'VisitaPedagogicaLead'];
    }
}