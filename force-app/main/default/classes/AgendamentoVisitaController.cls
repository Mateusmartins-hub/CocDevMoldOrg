public class AgendamentoVisitaController {

    public String leadId {get;set;}
    public String oppId {get;set;}

    public Opportunity op {get;set;}
    public Lead ld {get;set;}

    public Objeto objeto {get;set;}

    public String sugData1 {get;set;}
    public String sugData2 {get;set;}
    public String sugData3 {get;set;}
    
    public List<String> horarios {get;set;}
    public String horarioSetado {get;set;}
    
    public Boolean datasEnviadas {get;set;}
    public Boolean dataConfirmada {get;set;}

    public String dataConf {get;set;}

    public String msgErro {get;set;}

    public class CurrentStyle {
        public String imageUrl {get;set;}
        public String logoUrl {get;set;} 
        public String currentClass {get;set;}         
    }

    public CurrentStyle currentStyleObj {get; set;}

    public class Objeto {
        public Id idObjeto {get;set;}
        public String Prefixo {get;set;}
        public String Email {get;set;}
        public String EmailConsultor {get;set;}
        public DateTime dataSug1 {get;set;}
        public DateTime dataSug2 {get;set;}
        public DateTime dataSug3 {get;set;}
        public String horaInicial {get;set;}
        public String horaFinal {get;set;}
        public String tempoApresentacao {get;set;}
        public Date dataConfirmadaVisita {get;set;}
        public String EnviadoPor {get;set;}
        public String TipoVisita {get;set;}
        public String TipoSistemaDeEnsino {get;set;}
        public Id OwnerId {get;set;}
    }

    public AgendamentoVisitaController() {
        dataConfirmada = false;
        leadId = Apexpages.currentPage().getParameters().get('ld');
        oppId = Apexpages.currentPage().getParameters().get('op');
                
        objeto = new Objeto();
        if(!String.IsBlank(oppId)) {
            op = OpportunityDAO.buscaOportunidade(oppId);
            Account ac = AccountDAO.buscaConta(op.AccountId);            
            currentStyleObj = updatePageStyle(op.Account.SistemaEnsino__c);

            objeto.IdObjeto = op.Id;
            if(ac.Contacts.size() > 0)
                objeto.Email = ac.Contacts[0].Email;
            else
                objeto.Email = op.Account.BR_Account_email__c;
            objeto.EmailConsultor = op.Owner.Email;
            objeto.TipoSistemaDeEnsino = op.Account.SistemaEnsino__c;


            objeto.dataSug1 = op.SugestoesVisitas__r[0].Data1__c;
            objeto.dataSug2 = op.SugestoesVisitas__r[0].Data2__c;
            objeto.dataSug3 = op.SugestoesVisitas__r[0].Data3__c;
            if(op.SugestoesVisitas__r[0].HoraInicialSugerida__c != null)
                objeto.horaInicial = op.SugestoesVisitas__r[0].HoraInicialSugerida__c.hour() + 'h';
            if(op.SugestoesVisitas__r[0].HoraFinalSugerida__c != null)
                objeto.horaFinal = op.SugestoesVisitas__r[0].HoraFinalSugerida__c.hour() + 'h' + op.SugestoesVisitas__r[0].HoraFinalSugerida__c.minute();
            if(objeto.horaFinal != null && objeto.horaInicial != null)
                objeto.tempoApresentacao = String.valueOf(Decimal.ValueOf(formatHour(objeto.horaFinal).hour()).SetScale(2) - Decimal.ValueOf(formatHour(objeto.horaInicial).hour()).SetScale(2)).replace('.3', '.5');
            
            objeto.TipoVisita = op.SugestoesVisitas__r[0].TipoVisita__c;
            objeto.EnviadoPor = op.SugestoesVisitas__r[0].EnviadoPor__c;
            objeto.OwnerId = op.OwnerId;
            objeto.Prefixo = 'op';

            if(op.SugestoesVisitas__r[0].DataConfirmada__c != null) {
                objeto.dataConfirmadaVisita = dateTimeToDate(op.SugestoesVisitas__r[0].DataConfirmada__c);
                dataConfirmada = true;
            }


        }else if(!String.IsBlank(leadId)) {
            ld = LeadDAO.BuscaLead(leadId);            

            objeto.IdObjeto = ld.Id;
            objeto.Email = ld.Email;
            objeto.EmailConsultor = ld.Owner.Email;
            
            objeto.dataSug1 = ld.SugestoesVisitas__r[0].Data1__c;
            objeto.dataSug2 = ld.SugestoesVisitas__r[0].Data2__c;
            objeto.dataSug3 = ld.SugestoesVisitas__r[0].Data3__c;
            objeto.TipoVisita = ld.SugestoesVisitas__r[0].TipoVisita__c;
            if(ld.SugestoesVisitas__r[0].HoraInicialSugerida__c != null)
                objeto.horaInicial = ld.SugestoesVisitas__r[0].HoraInicialSugerida__c.hour() + 'h';
            if(ld.SugestoesVisitas__r[0].HoraFinalSugerida__c != null)
                objeto.horaFinal = ld.SugestoesVisitas__r[0].HoraFinalSugerida__c.hour() + '.' + ld.SugestoesVisitas__r[0].HoraFinalSugerida__c.minute();
            if(objeto.horaFinal != null && objeto.horaInicial != null)
                objeto.tempoApresentacao = String.valueOf(Decimal.ValueOf(formatHour(objeto.horaFinal).hour()).SetScale(2) - Decimal.ValueOf(formatHour(objeto.horaInicial).hour()).SetScale(2)).replace('.3', '.5');
            
            objeto.TipoVisita = ld.SugestoesVisitas__r[0].TipoVisita__c;
            objeto.EnviadoPor = ld.SugestoesVisitas__r[0].EnviadoPor__c;
            objeto.OwnerId = ld.OwnerId;
            objeto.Prefixo = 'ld';
             
            currentStyleObj = updatePageStyle(ld.SistemaEnsino__c);
            objeto.TipoSistemaDeEnsino = ld.SistemaEnsino__c;

            if(ld.SugestoesVisitas__r[0].DataConfirmada__c != null) {
                objeto.dataConfirmadaVisita = dateTimeToDate(ld.SugestoesVisitas__r[0].DataConfirmada__c);
                dataConfirmada = true;
            }
        }

        if(String.IsBlank(oppId) && String.IsBlank(leadId)) {
            throw new CustomException('Erro, contate o seu consultor.');
        }else{
            sugData1 = String.valueOf(DateTime.newInstance(objeto.dataSug1.year(), objeto.dataSug1.month(), objeto.dataSug1.day()).format('dd/MM/yyyy'));
            sugData2 = String.valueOf(DateTime.newInstance(objeto.dataSug2.year(), objeto.dataSug2.month(), objeto.dataSug2.day()).format('dd/MM/yyyy'));
            sugData3 = String.valueOf(DateTime.newInstance(objeto.dataSug3.year(), objeto.dataSug3.month(), objeto.dataSug3.day()).format('dd/MM/yyyy'));
            
            horarios = new List<String>();
            Decimal tempoLimite = 18 - Decimal.valueOf(objeto.tempoApresentacao == null ? '1' : objeto.tempoApresentacao);
            
            for (Integer i = 8; i < 18; i++) {                
                if(tempoLimite >= i)
                    horarios.add(String.valueOf(i)+'h');
            }
            
            if(objeto.EnviadoPor == 'Parceiro')
                datasEnviadas = true;
        }
    }

    public void confirmarData() {
        String[] emails = new String[]{};
        dataConf = Apexpages.currentPage().getParameters().get('dtCnf');

        if(String.isNotBlank(dataConf)) {
            dataConf = dataConf.replace('-', '/');
            if(!dataConfirmada) {
                if((dataConf == sugData1 || dataConf == sugData2 || dataConf == sugData3)) {
                    Date diaConfirmado = Date.newInstance(Integer.ValueOf(dataConf.substring(6, 10)), Integer.ValueOf(dataConf.substring(3, 5)), Integer.ValueOf(dataConf.substring(0, 2)));
                    String tipoVisita;
                    Event e = new Event();
                    if(!String.IsBlank(oppId)) {
                        e.WhatId = oppId;
                        op.SugestoesVisitas__r[0].DataConfirmada__c = diaConfirmado;
                        op.SugestoesVisitas__r[0].HoraInicialSugerida__c = formatHour(objeto.horaInicial);
                        op.SugestoesVisitas__r[0].HoraFinalSugerida__c = formatHour(objeto.horaFinal);
                        update op.SugestoesVisitas__r[0];
                        
                        tipoVisita = op.SugestoesVisitas__r[0].TipoVisita__c;
                    }else if(!String.IsBlank(leadId)) {
                        e.WhoId = leadId;
                        ld.SugestoesVisitas__r[0].DataConfirmada__c = diaConfirmado;
                        ld.SugestoesVisitas__r[0].HoraInicialSugerida__c = formatHour(objeto.horaInicial);
                        ld.SugestoesVisitas__r[0].HoraFinalSugerida__c = formatHour(objeto.horaFinal);
                        update ld.SugestoesVisitas__r[0];
                        
                        tipoVisita = ld.SugestoesVisitas__r[0].TipoVisita__c;
                    }
                    Id rEventId;
                    if(tipoVisita == 'Visita de Expansão')
                        rEventId = Schema.SObjectType.Event.getRecordTypeInfosByDeveloperName().get('VisitaExpansao').getRecordTypeId();
                    else if(tipoVisita == 'Visita Pedagógica')
                        rEventId = Schema.SObjectType.Event.getRecordTypeInfosByDeveloperName().get('Visita_Pedagogica').getRecordTypeId();
                    
                    e.RecordTypeId = rEventId;
                    e.subject = tipoVisita;
                    e.StartDateTime = DateTime.newInstance(diaConfirmado,formatHour(objeto.horaInicial));
                    System.debug(e.StartDateTime);
                    //e.StartDateTime = e.StartDateTime.addHours(formatHour(objeto.horaInicial).hour());
                    e.DurationInMinutes = 60;
                    e.OwnerId = objeto.ownerId;
                    insert e;

                    String link = URL.getOrgDomainUrl().toExternalForm() + '/' + e.Id;

                    List<Messaging.SingleEmailMessage> listaEmails = new List<Messaging.SingleEmailMessage>();

                    EmailTemplate templateConsultor;
                    EmailTemplate templateParceiro;
                    if (objeto.TipoSistemaDeEnsino == 'COC') {
                        templateConsultor = [SELECT id, HtmlValue, Subject FROM EmailTemplate WHERE DeveloperName = 'VisitaConfirmadaCOCConsultor'];
                        templateParceiro = [SELECT id, HtmlValue, Subject FROM EmailTemplate WHERE DeveloperName = 'VisitaConfirmadaCOCLead'];
                    } else {
                        templateConsultor = [SELECT id, HtmlValue, Subject FROM EmailTemplate WHERE DeveloperName = 'VisitaConfirmadaConsultor'];
                        templateParceiro = [SELECT id, HtmlValue, Subject FROM EmailTemplate WHERE DeveloperName = 'VisitaConfirmadaLead'];
                    }

                    Time horaInicial = formatHour(objeto.horaInicial);
                    Time horaFinal = formatHour(objeto.horaFinal);

                    String horaInicialStr = horaInicial.hour() + 'h' + horaInicial.minute();
                    String horaFinalStr = horaFinal.hour() + 'h' + horaFinal.minute();

                    if (horaFinal.minute() == 0){
                        horaFinalStr = horaFinalStr + '0';
                    }
                    if (horaInicial.minute() == 0){
                        horaInicialStr = horaInicialStr + '0';
                    }

                    String bodyConsultor = templateConsultor.HtmlValue
                        .replace('{dataVisita}', dataConf)
                        .replace('{URL}', link)
                        .replace('{horaInicial}', horaInicialStr)
                        .replace('{horaFinal}', horaFinalStr); 
                    String bodyParceiro = templateParceiro.HtmlValue
                        .replace('{dataVisita}', dataConf)
                        .replace('{horaInicial}', horaInicialStr)
                        .replace('{horaFinal}', horaFinalStr);

                    List<String> userId = new List<String>{ objeto.OwnerId };
                    User user = UserDAO.getListUserByIdsUsers(userId)[0];
                    OrgWideEmailAddress owea = [SELECT Id FROM OrgWideEmailAddress WHERE Address = 'p2d.educacao@yopmail.com' LIMIT 1];
                    
                    Messaging.SingleEmailMessage msg = new Messaging.SingleEmailMessage();
                    msg.toAddresses = new String[]{objeto.EmailConsultor};
                    msg.subject = templateConsultor.Subject;
                    msg.htmlbody = bodyConsultor;
                    msg.setReplyTo(user.Email);
                    msg.setOrgWideEmailAddressId(owea.Id);
                    listaEmails.add(msg);

                    Messaging.SingleEmailMessage msg2 = new Messaging.SingleEmailMessage();
                    msg2.toAddresses = new String[]{objeto.Email};
                    msg2.subject = templateParceiro.Subject;
                    msg2.htmlbody = bodyParceiro;
                    msg2.setReplyTo(user.Email);
                    msg2.setOrgWideEmailAddressId(owea.Id);
                    listaEmails.add(msg2);

                    Messaging.sendEmail(listaEmails);

                    dataConfirmada = true;
                }else{
                    datasEnviadas = false;
                }
            }else{
                dataConf = formatDate(objeto.dataConfirmadaVisita);
            }
        }
    }

    public void enviarDatas() {
        
        this.objeto.horaInicial = ApexPages.currentpage().getparameters().get('horarioSetado'); 
        
        msgErro = '';
        SugestaoVisita__c sug = new SugestaoVisita__c();

        if(sugData1.length() != 10) {
            msgErro = 'Primeira data inválida.';
        }else if(sugData2.length() != 10) {
            msgErro = 'Segunda data inválida.';
        }else if(sugData3.length() != 10) {
            msgErro = 'Terceira data inválida.';
        }
        
        if(String.isBlank(objeto.horaInicial)) {
            msgErro = 'Selecione um horário para a visita.';
        }
        
        Integer yearData1 = Integer.ValueOf(sugData1.substring(6, 10));
        Integer yearData2 = Integer.ValueOf(sugData2.substring(6, 10));
        Integer yearData3 = Integer.ValueOf(sugData3.substring(6, 10));

        Integer monthData1 = Integer.ValueOf(sugData1.substring(3, 5));
        Integer monthData2 = Integer.ValueOf(sugData2.substring(3, 5));
        Integer monthData3 = Integer.ValueOf(sugData3.substring(3, 5));

        Integer dayData1 = Integer.ValueOf(sugData1.substring(0, 2));
        Integer dayData2 = Integer.ValueOf(sugData2.substring(0, 2));
        Integer dayData3 = Integer.ValueOf(sugData3.substring(0, 2));

        Date data1 = Date.newInstance(yearData1, monthData1, dayData1);
        Date data2 = Date.newInstance(yearData2, monthData2, dayData2);
        Date data3 = Date.newInstance(yearData3, monthData3, dayData3);

        if(data1.month() != monthData1 || data2.month() != monthData2 || data3.month() != monthData3) {
            msgErro = 'Data inválida.';
        }

        if(data1 == data2 || data1 == data3 || data2 == data3) {
            msgErro = 'As datas não podem ser repetidas.';
        }

        if(data1 <= System.today() || data2 <= System.today() || data3 <= System.today()){
            msgErro = 'As datas não podem ser menores ou iguais à hoje';
        }

        Integer maxDias = 180;
        if(data1 > System.today().addDays(maxDias) || data2 > System.today().addDays(maxDias) || data3 > System.today().addDays(maxDias)){
            msgErro = 'As datas não podem ser maiores que ' + maxDias + ' dias';
        }
        if(String.isBlank(msgErro)) {
            try{
                objeto.horaFinal = String.valueOf(Integer.valueOf(objeto.horaInicial.replace('h', '')) + Decimal.ValueOf(objeto.tempoApresentacao).SetScale(2)).replace('.50', ':30').replace('.00', 'h');
                if(!String.IsBlank(oppId))
                    sug.Oportunidade__c = oppId;
                else if(!String.IsBlank(leadId))
                    sug.Lead__c = leadId;
                
                sug.Data1__c = data1;
                sug.Data2__c = data2;
                sug.Data3__c = data3;
                sug.EnviadoPor__c = 'Parceiro';
                sug.TipoVisita__c = objeto.TipoVisita;
                
                sug.HoraInicialSugerida__c = formatHour(objeto.horaInicial);
                sug.HoraFinalSugerida__c = formatHour(objeto.horaFinal);
            }catch(Exception e) {
                System.debug(e.getMessage());
                System.debug(e.getLineNumber());
                msgErro = 'Erro ao converter datas, contate o seu consultor.';
            }
        }
        
        if(String.isBlank(msgErro)) {
            Savepoint sp = Database.setSavepoint();
            try{
                insert sug;
                String link = URL.getOrgDomainUrl().toExternalForm() + '/' + objeto.IdObjeto;
                
                Site externalSite = [SELECT Id FROM Site WHERE Name = 'AgendamentoVisita'];
                SiteDetail siteDetail = [SELECT SecureURL FROM SiteDetail WHERE DurableId = :externalSite.Id];
                
                String urlData1 = siteDetail.SecureURL + '?' + objeto.Prefixo + '=' + objeto.IdObjeto + '&amp;dtCnf=' + formatDate(data1).replace('/', '-') + '&amp';
                String urlData2 = siteDetail.SecureURL + '?' + objeto.Prefixo + '=' + objeto.IdObjeto + '&amp;dtCnf=' + formatDate(data2).replace('/', '-') + '&amp';
                String urlData3 = siteDetail.SecureURL + '?' + objeto.Prefixo + '=' + objeto.IdObjeto + '&amp;dtCnf=' + formatDate(data3).replace('/', '-') + '&amp';
                
                EmailTemplate template;
                
                if(objeto.TipoVisita == 'Visita de Expansão') {
                    if (objeto.TipoSistemaDeEnsino == 'COC'){
                        template = [SELECT id, HtmlValue, Subject FROM EmailTemplate WHERE DeveloperName = 'VisitaExpansaoCOCConsultor'];
                    } else {
                        template = [SELECT id, HtmlValue, Subject FROM EmailTemplate WHERE DeveloperName = 'VisitaExpansaoConsultor'];
                    }
                }else if(objeto.TipoVisita == 'Visita Pedagógica') {
                    if (objeto.TipoSistemaDeEnsino == 'COC'){
                        template = [SELECT id, HtmlValue, Subject FROM EmailTemplate WHERE DeveloperName = 'VisitaPedagogicaCOCConsultor'];
                    } else {
                        template = [SELECT id, HtmlValue, Subject FROM EmailTemplate WHERE DeveloperName = 'VisitaPedagogicaConsultor'];
                    }
                }
                
                Time horaFinal = formatHour(objeto.horaFinal);
                Time horaInicial = formatHour(objeto.horaInicial);

                String horaInicialStr = horaInicial.hour() + 'h' + horaInicial.minute();
                String horaFinalStr = horaFinal.hour() + 'h' + horaFinal.minute();

                if (horaFinal.minute() == 0){
                    horaFinalStr = horaFinalStr + '0';
                }
                if (horaInicial.minute() == 0){
                    horaInicialStr = horaInicialStr + '0';
                }

                
                String body = template.HtmlValue
                    .replace('{URL}', link)
                    .replace('{dataSug1}', formatDate(data1))
                    .replace('{dataSug2}', formatDate(data2))
                    .replace('{dataSug3}', formatDate(data3))
                    .replace('{linkDatSug1}', urlData1)
                    .replace('{linkDatSug2}', urlData2)
                    .replace('{linkDatSug3}', urlData3)
                    .replace('{horaInicial}', horaInicialStr)
                    .replace('{horaFinal}', horaFinalStr);
                
                Messaging.SingleEmailMessage message = new Messaging.SingleEmailMessage();
                message.toAddresses = new String[] { objeto.EmailConsultor };
                    message.subject = template.Subject;
                message.htmlbody = body;
                Messaging.sendEmail(new List<Messaging.SingleEmailMessage> {message});
                
                datasEnviadas = true;
            } catch(Exception e) {
                Database.rollback( sp );
 
                System.debug(e.getMessage());
                System.debug(e.getLineNumber());
                msgErro = e.getMessage() + e.getLineNumber();
            }
        }
    }

    private static String formatDate(Date data) {
        String dia = String.valueOf(data.day());
        dia = data.day() >= 10 ? dia : '0' + dia;

        String mes = String.valueOf(data.month());
        mes = data.month() >= 10 ? mes : '0' + mes;

        return dia + '/' + mes + '/' + String.valueOf(data.year());
    }

    private static Time formatHour(String horario) {
        if(String.isNotBlank(horario)) {
            Integer horasHorario = Integer.valueOf(horario.replace(':30', '').replace('h', '').replace('.30', '').replace('.50', ''));
            Integer minutosHorario = Integer.valueOf(horario.contains(':30') ? 30 : 0);
            return Time.newInstance(horasHorario, minutosHorario, 0, 0);
        }
        
        return Time.newInstance(0, 0, 0, 0);
    }

    private static Date dateTimeToDate(DateTime dt) {
        return Date.newInstance(dt.year(), dt.month(), dt.day());
    }

    public CurrentStyle updatePageStyle(String sistemaDeEnsino) {
        CurrentStyle cs = new CurrentStyle();        
        switch on sistemaDeEnsino{
            when 'COC'{
                cs.imageUrl = 'COCAgendamento'; 
                cs.logoUrl = 'COCLogo';
                cs.currentClass = 'coc';                
            }            
            when else {                
                cs.imageUrl = 'AgendamentoVisita';
                cs.logoUrl = 'PearsonLogo2';
                cs.currentClass = 'defaultClass';
            }
        }
        
        return cs;
    }    

    public class CustomException extends Exception {}
}