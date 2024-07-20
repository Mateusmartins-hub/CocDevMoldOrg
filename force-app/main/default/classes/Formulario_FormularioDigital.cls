public class Formulario_FormularioDigital {

    private static string SecureURL { get; set; }
    private static Map<string, EmailTemplate> MapTemplate { get; set; }
    
    public static void EnviarFormulario(string email, string emailTemplate, Map<string, string> mapParamsUrl, Map<string, string> mapReplacementBody, String senderEmail, String senderName)
    {
        if(MapTemplate == null)
            MapTemplate = new Map<String, EmailTemplate>();
        
        if (string.isBlank(SecureURL))
        {
            Site externalSite = [SELECT Id FROM Site WHERE Name = 'Pearson'];
            SiteDetail siteDetail = [SELECT SecureURL FROM SiteDetail WHERE DurableId = :externalSite.Id];

            SecureURL = siteDetail.SecureURL;
        }
        
        if (!MapTemplate.containsKey(emailTemplate))
        {
            EmailTemplate template = [SELECT id, HtmlValue, Subject FROM EmailTemplate WHERE DeveloperName =: emailTemplate];

            MapTemplate.put(emailTemplate, template);
        }

        string url = SecureURL;
        
        if (mapParamsUrl != null && !mapParamsUrl.isEmpty())
        {
            url += '?';
            
            for (string key : mapParamsUrl.keySet())
            {
                url += key + '=' + mapParamsUrl.get(key) + '&';
            }
            
            url = url.substring(0, (url.length() - 1));
        }
        
        string body = MapTemplate.get(emailTemplate).HtmlValue;
                
        if (mapReplacementBody != null) 
        {
            for (string key : mapReplacementBody.keySet())
            {
                body = body.replace(key, mapReplacementBody.get(key));
            }
        }

        Messaging.SingleEmailMessage message = new Messaging.SingleEmailMessage();
        message.toAddresses = new String[] { email };
        message.subject = MapTemplate.get(emailTemplate).subject; 
        message.htmlbody = body.replace('{URL}', url);
        if (senderEmail != null && senderName != null) {
            message.setReplyTo(senderEmail);
            message.setSenderDisplayName(senderName);
        }
        Messaging.SingleEmailMessage[] messages =   new List<Messaging.SingleEmailMessage> { message };
        Messaging.SendEmailResult[] results = Messaging.sendEmail(messages);

    }

    public static boolean ValidaFormulario(List<PerguntaResposta> perguntas)
    {
        boolean erro = false;
        for (PerguntaResposta pr : perguntas)
        {
            pr.Erro = null;
            
            if (pr.TipoResposta == 'Texto livre')
            {
                if (pr.Obrigatorio && string.isBlank(pr.Resposta))
                    pr.Erro = 'Campo obrigatório';
            }
            else if (pr.TipoResposta == 'Numérico')
            {
                if (pr.Obrigatorio && string.isBlank(pr.Resposta))
                {
                    pr.Erro = 'Campo obrigatório';
                }
                else {
                    try {
                        Decimal.valueOf(pr.Resposta);
                    } catch (Exception e) {
                        pr.Erro = 'Campo deve conter valor numérico';
                    }
                }
            }
            else if (pr.TipoResposta == 'Lista de opções única')
            {
                if (pr.Obrigatorio && string.isBlank(pr.Resposta))
                    pr.Erro = 'Campo obrigatório';
            }
            else if (pr.TipoResposta == 'Lista de opções múltipla')
            {
                if (pr.Obrigatorio && pr.Respostas.isEmpty())
                    pr.Erro = 'Campo obrigatório';
            }
            
            if (string.isNotBlank(pr.Erro))
                erro = true;
        }

        return !erro;
    }

    public static void SalvaRespostas(List<PerguntaResposta> perguntaRespostas, Formulario__c formularioPergunta, string contaId, string oportunidadeId, string leadId)
    {
        Id recordTypeId = Schema.SObjectType.Formulario__c.getRecordTypeInfosByDeveloperName().get('Resposta').getRecordTypeId();
        
        system.debug(formularioPergunta.SistemaEnsino__c);
        system.debug(formularioPergunta);

        Formulario__c formularioResposta = new Formulario__c();
        formularioResposta.RecordTypeId = recordTypeId;
        formularioResposta.SistemaEnsino__c = formularioPergunta.SistemaEnsino__c;
        formularioResposta.Titulo__c = formularioPergunta.Titulo__c;
        formularioResposta.Produto__c = formularioPergunta.Produto__c;
        formularioResposta.Tipo__c = formularioPergunta.Tipo__c;
        formularioResposta.Destinatario__c = formularioPergunta.Destinatario__c;
        formularioResposta.ObjetivoVisita__c = formularioPergunta.ObjetivoVisita__c;
        
        if (!string.IsBlank(contaId))
            formularioResposta.Conta__c = contaId;
        else if (!string.IsBlank(oportunidadeId))
            formularioResposta.Oportunidade__c = oportunidadeId;
        else if (!string.IsBlank(leadId))
            formularioResposta.Lead__c = leadId;
        
        insert formularioResposta;
        
        List<RespostaFormulario__c> respostas = new List<RespostaFormulario__c>();
        for (PerguntaResposta pr : perguntaRespostas)
        {
            RespostaFormulario__c resposta = new RespostaFormulario__c();
            resposta.Pergunta__c = pr.Pergunta;
            resposta.Formulario__c = formularioResposta.Id;
            
            if (pr.TipoResposta != 'Lista de opções múltipla')
                resposta.Resposta__c = pr.Resposta;
            else  
                resposta.Resposta__c = string.join(pr.Respostas, ';');
            
            respostas.add(resposta);
        }
        
        insert respostas;

    }
}