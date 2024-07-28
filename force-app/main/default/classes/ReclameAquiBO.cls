public without sharing class ReclameAquiBO {

    static final String SKILL_BRASIL_FRANSHISING = 'Skill Brasil Franshising';
    static final String SKILL = 'Skill';
    static final String EDITORA_PEARSON_EDUCATION = 'Editora Pearson Education';
    static final String MEU_INGLES = 'Meu Inglês';
    static final String KOALA_TESTES = 'Koala Testes';
    static final String B2B = 'B2B';
    static final String COC_SISTEMA_DE_ENSINO = 'COC - Sistema de Ensino';
    static final String COC = 'COC';
    
    final static Integer TAM = 50;
    final static Integer ultimaPagina = (Integer)IntegracaoRA__c.getOrgDefaults().UltimaPagina__c;
    private static final IntegracaoRA__c settingsRA = IntegracaoRA__c.getOrgDefaults();
    
    public static Map<String, CaseVO> buscarReclamacoes() {
        try {
            Map<String, CaseVO> casos = new Map<String, CaseVO>();
            
            Integer lastPage = ultimaPagina;
            
            Decimal pagesNumber = ReclameAquiWS.count();
            pagesNumber = (pagesNumber/TAM).round(System.RoundingMode.UP);
            
            if(pagesNumber >= (lastPage + 5)) {
                pagesNumber = lastPage + 5;
                settingsRA.UltimaPagina__c = pagesNumber;
            }else{
                settingsRA.UltimaPagina__c = 0;
            }
            
            Integer pagina;
            Boolean erro = false;
            
            for(pagina = lastPage + 1; pagina <= pagesNumber; pagina++) {
                System.debug(pagina);
                String endpoint = settingsRA.EndpointAllTickets__c + '?ra_status.id[in]=' + settingsRA.StatusBuscar__c + '&creation_date[gte]=' + settingsRA.DataCorte__c + '&sort[creation_date]=DESC&page[number]=' + pagina + '&page[size]=' + String.valueOf(TAM);
                String response = ReclameAquiWS.requisicao(endpoint, 'GET', null);
                ReclameAquiVO ra = ReclameAquiVO.parse(response);
                
                if(ra.data != null && !ra.data.isEmpty()) {
                    System.debug(ra.data.size());
                    casos.putAll(converterToCase(ra.data));
                }else{
                    System.debug(ra.data);
                    erro = true;
                    throw new CustomException('Data vazio');
                }
                System.debug('===================');
            }

            Map<String, Contact> mapContatos = new Map<String, Contact>();
            Map<String, Contact> mapContatosInsert = new Map<String, Contact>();
            Set<String> setEmailsContactsAdded = new Set<String>();
            
            if(!casos.isEmpty()) {
                for(String idRA : casos.keySet()) {
                    if(casos.get(idRA).contato != null) {
                        mapContatos.put(idRA, casos.get(idRA).contato);
                        if(casos.get(idRA).contato.Id == null && !setEmailsContactsAdded.contains(casos.get(idRA).contato.Email)) {
                            mapContatosInsert.put(idRA, casos.get(idRA).contato);
                            setEmailsContactsAdded.add(casos.get(idRA).contato.Email);
                        }
                    }
                }
                
                if(mapContatosInsert.size() > 0)
                    insert mapContatosInsert.values();
                
                for(String idRA : casos.keySet()) {
                    if(casos.get(idRA).contato != null && casos.get(idRA).caso != null) 
                        casos.get(idRA).caso.ContactId = mapContatos.get(idRA).Id;
                }
            }
            
            if(!erro)
                update settingsRA;
            return casos;
        } catch (Exception ex) {
            settingsRA.Token__c = null;
            settingsRA.UltimaPagina__c = ultimaPagina;
            update settingsRA;
            
            System.debug('ERRO '+ex.getStackTraceString()+' '+ex.getMessage());
            return new Map<String, CaseVO>();
        }
        
    }
    
    public static Map<String, CaseVO> converterToCase(List<ReclameAquiVO.Data> reclamacoes) {
        Map<String, CaseVO> upsertCases = new Map<String, CaseVO>();
        List<Case> casosRA = new List<Case>();
        Map<String, ReclameAquiVO.Data> mapReclamacoes = new Map<String,ReclameAquiVO.Data>();
        Map<String, Case> mapCase = new Map<String,Case>();
        Map<String, Contact> mapContact = new Map<String,Contact>();
        Map<String, ReclameAquiVO.Data> mapContatoRA = new Map<String,ReclameAquiVO.Data>();
        
        for(ReclameAquiVO.Data ra : reclamacoes) {
            if(ra.customer.email.size() > 0) {
                ra.linksAnexos = anexarArquivosTexto(ra);
                mapReclamacoes.put(String.valueOf(ra.id), ra);
                mapContatoRA.put(ra.customer.email.get(0), ra);
            }
        }
        
        for(Contact contato : [SELECT Id, Email FROM Contact WHERE Email IN : mapContatoRA.keySet()]){
            mapContact.put(contato.Email,contato);
        }
        
        for(String email : mapContatoRA.keySet()){
            if(!mapContact.containsKey(email)){
                Contact contato = criarContato(mapContatoRA.get(email));
                mapContact.put(email, contato);
            }
        }
        
        for(Case caso : [SELECT Id, IdRA__c, Subject, VoltariaFazerNegocioRA__c, ConteudoReclamacaoRA__c,TituloReclamacaoRA__c,
                         StatusRA__c, StatusHugme__c, ProblemaResolvidoRA__c, Tipo__c, Subtipo__c, RespostaPublica__c,
                         MotivoModeracaoRA__c, DescricaoModeracaoRA__c, TreplicaPublica__c, StatusIntegracao__c, status, ErroIntegracaoRA__c,
                         Detalhamento__c, NotaRA__c FROM Case WHERE IdRA__c IN : mapReclamacoes.keySet()])
        {
            mapCase.put(caso.IdRA__c, caso);
        }
        
        QueueSObject fila = [Select Queue.Id, Queue.Name, Queue.Type from QueueSObject WHERE Queue.Name = 'Ouvidoria'];
        
        for(String idRA : mapReclamacoes.keySet()) {
            CaseVO casoAtt = new CaseVO();
            
            Case caso;
            if(!mapCase.containsKey(idRA) && (mapReclamacoes.get(idRA).ra_status.id == 5 || mapReclamacoes.get(idRA).ra_status.id == 7)){
                caso = novoCaso(mapReclamacoes.get(idRA));
                caso.ownerId = fila.Queue.Id;
                
                casoAtt.contato =  mapContact.get(mapReclamacoes.get(idRA).customer.email.get(0));
            } else if(mapCase.containsKey(idRA)) {
                if((mapReclamacoes.get(idRA).ra_status.id == 18 || mapReclamacoes.get(idRA).ra_status.id == 19) && 
                   mapReclamacoes.get(idRA).rating == String.valueOf(mapCase.get(idRA).notaRA__c)){                        
                       continue;
                   }
                
                caso = atualizarCaso(mapReclamacoes.get(idRA), mapCase.get(idRA));
                caso.ownerId = fila.Queue.Id;
            }
            
            if(caso != null) {
                casoAtt.caso = caso;
                
                upsertCases.put(idRA, casoAtt);
            }
        }
        
        return upsertCases;
    }
    
    public static Contact criarContato(ReclameAquiVO.Data contatoRA) {
        String fone = !contatoRA.customer.phone_numbers.isEmpty() ? contatoRA.customer.phone_numbers.get(0).replaceAll('[^\\d]','') : null;
        String cpf = !contatoRA.customer.cpf.isEmpty() ? contatoRA.customer.cpf.get(0).replaceAll('[^\\d]','') : null;
        
        Contact novo = new Contact();
        novo.FirstName = (contatoRA.customer.name).substringBefore(' ');
        novo.LastName = (contatoRA.customer.name).contains(' ') ? (contatoRA.customer.name).substringAfter(' ') : 'Não Informado';
        novo.Email = contatoRA.customer.email.get(0);
        novo.BR_Address_city__c = contatoRA.customer.city != null ? contatoRA.customer.city.get(0).name : null;
        novo.BR_Address_state__c = contatoRA.customer.state != null ?contatoRA.customer.state.get(0).fs : null;
       
        if(!contatoRA.customer.birthday.isEmpty()){
            Date birthdate = Date.valueOf(contatoRA.customer.birthday.get(0));
            novo.Birthdate = birthdate.year() >= 1700 ? birthdate : null;
        }

        if(cpf != null && cpf.length() == 11){
            novo.BR_CPF__c = cpf.substring(0,3)+'.'+cpf.substring(3,6)+'.'+cpf.substring(6,9)+'-'+cpf.substring(9,11); 
        }

        if(fone != null) {
            fone = fone.replace('(','').replace(')', '').replace('-', '');
            novo.MobilePhone = fone.length() == 11 ? fone.substring(2,7) + '-' + fone.substring(7, fone.length()) : (fone.length() == 10) ? fone.substring(2,6) + '-' + fone.substring(6,fone.length()) : '';
            novo.BR_Area_code_cel__c = Integer.valueOf(fone.substring(0,2));
        }
            
        return novo;
    }
    
    public static Case novoCaso(ReclameAquiVO.Data reclamacao) {
        Set<String> valores = new Set<String>{'Yázigi', 'Wizard', 'COC', 'Dom Bosco', 'Skill'};
            Case novo = new Case();
        novo.RecordTypeId = Schema.SObjectType.Case.getRecordTypeInfosByDeveloperName().get('ReclameAqui').getRecordTypeId();
        
        novo.IdRA__c = String.valueOf(reclamacao.id);
        novo.Status = 'Novo';
        novo.Origin = 'Reclame Aqui';
        novo.MarcaAtendimento__c = deParaMarcaAtendimento(reclamacao.company.name);
        novo.Id_anexos_RA__c = reclamacao.linksAnexos;
        novo.Description = reclamacao.complaint_content;
        novo.Subject = reclamacao.complaint_title;
        novo.VoltariaFazerNegocioRA__c = reclamacao.back_doing_business; 
        novo.ConteudoReclamacaoRA__c = reclamacao.complaint_content;
        novo.TituloReclamacaoRA__c = reclamacao.complaint_title;
        novo.StatusRA__c = reclamacao.ra_status.name;
        novo.StatusHugme__c = reclamacao.hugme_status.name;
        novo.ProblemaResolvidoRA__c = reclamacao.resolved_issue; 
        novo.Tipo__c = 'Fale Conosco';
        novo.Subtipo__c = 'Outros';
        novo.Detalhamento__c = 'Outros';
        novo.respostaPublica__c = null;
        novo = atualizarCaso(reclamacao, novo);
        return novo;
    }
    
    public static Case atualizarCaso(ReclameAquiVO.Data reclamacao, Case caso) {
        List<String> manifestacoes = new List<String>();
        List<String> respostas = new List<String>();
        
        if(reclamacao.ra_status.name == 'Réplica do consumidor'){
            for(ReclameAquiVO.Interactions interacao : reclamacao.interactions){
                if(interacao.ticket_interaction_name == 'Manifestação'){
                    manifestacoes.add(interacao.message);
                }
                
                if(interacao.ticket_interaction_name == 'Resposta'){
                    respostas.add(interacao.message);
                }
            }
            
            if(manifestacoes.size() > 1){
                caso.Status = 'Reaberto';
                caso.ReplicaCliente__c = manifestacoes.get(1);
            }
            
            if(!respostas.isEmpty() && caso.respostaPublica__c == null){
                caso.respostaPublica__c = respostas.get(0);
            }
            
            caso.StatusIntegracao__c = 'Não integrado';
        }
        
        caso.ProblemaResolvidoRA__c = reclamacao.resolved_issue;
        try{
            caso.NotaRA__c = Decimal.valueOf(reclamacao.rating) == -1? null : Decimal.valueOf(reclamacao.rating);
        }
        catch(Exception ex){
            caso.NotaRA__c = null;
        }
        
        return caso;
    }
    
    public static String anexarArquivosTexto(ReclameAquiVO.Data reclamacao) {
        String idsAttachments = '';
        
        for(ReclameAquiVO.Attached atta : reclamacao.attached) {
            if(atta.type_detail_id == 15) {
                idsAttachments = idsAttachments + atta.id + ';';
            }
        }
        
        return idsAttachments;
    }
    /*
    public static List<Attachment> anexarArquivos(ReclameAquiVO.Data reclamacao) {
        List<Attachment> anexos = new List<Attachment>();
        
        for(ReclameAquiVO.Attached atta : reclamacao.attached) {
            if(atta.type_detail_id == 15) {
                Attachment anexo = new Attachment();
                
                HttpRequest req = new HttpRequest();
                req.setEndpoint(atta.detail_description);
                req.setMethod('GET');
                Http binding = new Http();
                HttpResponse res = binding.send(req);
                Blob image = res.getBodyAsBlob();
                String b64 = 'data:'+res.getHeader('Content-Type')+';base64,'+EncodingUtil.base64Encode(image);
                
                Attachment a = new Attachment();
                a.Name = atta.detail_description.substringAfterLast('/');
                a.Body = image;
                
                anexos.add(anexo);
            }
        }
        
        return anexos;
    }*/
    
    public static String deParaMarcaAtendimento(String empresa) {
        if(empresa.equals(SKILL_BRASIL_FRANSHISING)) {
            return SKILL;
        }
        else if (empresa.equals(EDITORA_PEARSON_EDUCATION) || empresa.equals(MEU_INGLES) || empresa.equals(KOALA_TESTES)) {
            return B2B;
        }
        else if (empresa.equals(COC_SISTEMA_DE_ENSINO)) {
            return COC;
        }

        return empresa;
    }
    
    public static List<Case> enviarRespostas(List<Case> casos) {
        try{
            for(case caso : casos) {
                ReclameAquiVO.RespostaRA request = new ReclameAquiVO.RespostaRA();
                
                if(caso.MotivoModeracaoRA__c != null){
                    String form64 = '';
                    form64 += FormData.append('id', EncodingUtil.urlEncode(caso.IdRA__c, 'UTF-8'));
                    form64 += FormData.append('message', EncodingUtil.urlEncode(caso.DescricaoModeracaoRA__c, 'UTF-8'));
                    form64 += FormData.append('reason', EncodingUtil.urlEncode(caso.MotivoModeracaoRA__c, 'UTF-8'));
                    
                    Blob formBlob = FormData.makeBlob(form64);
                    
                    if (!Test.isRunningTest()) {
                        request.ResponseRespostaPublica = ReclameAquiVO.parseResponseRespostaPublica(ReclameAquiWS.requisicaoFormData(settingsRA.EndpointModeration__c, 'POST', formBlob));
                        caso = tratarResponseRespostaPublica(caso, request.ResponseRespostaPublica);
                    }
                }else {
                    request.message = caso.TreplicaPublica__c != null ? caso.TreplicaPublica__c : caso.RespostaPublica__c;
                    request.id = caso.IdRA__c;
                    
                    String body = JSON.serialize(request);
                    
                    if (!Test.isRunningTest()) {
                        request.ResponseRespostaPublica = ReclameAquiVO.parseResponseRespostaPublica(ReclameAquiWS.requisicao(settingsRA.EndpointPublicMessage__c, 'POST', body));
                        caso = tratarResponseRespostaPublica(caso, request.ResponseRespostaPublica);
                    }
                }
            }
            
            return casos;
        } catch (Exception ex) {
            settingsRA.Token__c = null;
            update settingsRA;
            
            System.debug('ERRO '+ex.getStackTraceString() + ' ' + ex.getMessage());
            return casos;
        }
    }
    
    public static case tratarResponseRespostaPublica(Case caso, ReclameAquiVO.ResponseRespostaPublica response) {
        if(response != null && (response.error == null || (response.success != null && response.success))) {
            caso.StatusIntegracao__c = 'Integrado';
            caso.status = 'Closed';
        } else {
            caso.StatusIntegracao__c = 'Não integrado';
            caso.ErroIntegracaoRA__c = response.message + ' -error: ' + response.error + ' -sucess: ' + response.success ;
        }
        
        return caso;
    }
    
    public class CaseVO {
        public Case caso;
        public Contact contato;
        /*public List<Attachment> anexos;
        
        public CaseVO() {
            this.anexos = new List<Attachment>();
        }*/
    }
    
    public class CustomException extends Exception{}
}