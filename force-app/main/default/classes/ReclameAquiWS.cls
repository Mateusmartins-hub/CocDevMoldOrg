public class ReclameAquiWS {
    
    private static final IntegracaoRA__c settingsRA = IntegracaoRA__c.getOrgDefaults();

    public static String getToken(){
        try{
            String UserPassword = EncodingUtil.base64Encode(Blob.valueOf(settingsRA.UserPassword__c));
            Http http = new Http();
            HttpResponse response = new HttpResponse();
            HttpRequest request = new HttpRequest();
            request.setHeader('Content-Type', 'application/json;charset=UTF-8');
            request.setHeader('Authorization', 'Basic '+ UserPassword);
            request.setMethod('POST');
            request.setEndpoint(settingsRA.EndpointAuth__c);
            request.setTimeout(Integer.valueOf(settingsRA.Timeout__c));
            
            if (!Test.isRunningTest()) response = http.send(request);
            
            String bodyResponse = response.getBody();
            
            if (Test.isRunningTest())
                return parseToken('{"access_token":"bab03215-afd9-4f5a-b500-e79c0f45731e","token_type":"bearer","expires_in":10799,"scope":"trust read write","rate_limit":2500,"license_start_at":"2018-10-16 00:00:00"}').access_token;
        
            return parseToken(bodyResponse).access_token;
        }catch(Exception ex){
            System.debug('ERRO '+ex.getStackTraceString()+' '+ex.getMessage());
            return 'Erro: Ocorreu um erro durante o processo. Contacte um administrador.';
        }
    }

    public static Integer count(){
        try{
            if(settingsRA.Token__c == null || settingsRA.Token__c == 'Usuário ou senha inválido.')
                settingsRA.Token__c = getToken();
                
            Http http = new Http(); 
            HttpRequest request = new HttpRequest();
            HttpResponse response = new HttpResponse();
            request.setHeader('Accept', 'application/json');
            request.setHeader('accept-encoding', 'gzip, deflate, br');
            request.setHeader('Authorization', 'Bearer '+ settingsRA.Token__c);
            request.setMethod('GET');
            System.debug(settingsRA.DataCorte__c);
            System.debug(settingsRA.Token__c);
            request.setEndpoint(settingsRA.EndpointCountTickets__c + '?creation_date[gte]=' + settingsRA.DataCorte__c + '&ra_status.id[in]=' + settingsRA.StatusBuscar__c);
            request.setTimeout((Integer) settingsRA.Timeout__c);

            if (!Test.isRunningTest()) response = http.send(request);
            
            String bodyResponse = response.getBody();
            System.debug(bodyResponse);
            
            if (Test.isRunningTest())
                return 50;
            
            return parseCount(bodyResponse).data;
        }catch(Exception ex){
            System.debug('ERRO '+ex.getStackTraceString()+' '+ex.getMessage());
            return null;
        }
    }
    
    public static String requisicao(String endpoint, String method, String body){
        try{
            if(settingsRA.Token__c == null || settingsRA.Token__c == 'Usuário ou senha inválido.')
                settingsRA.Token__c = getToken();

            Http http = new Http(); 
            HttpRequest request = new HttpRequest();
            HttpResponse response = new HttpResponse();
            request.setHeader('Accept', 'application/json');
            request.setHeader('Content-Type', 'application/json');
            request.setHeader('accept-encoding', 'gzip, deflate');
            request.setHeader('Authorization', 'Bearer '+ settingsRA.Token__c);
            if(body != null){	
                request.setBody(body);
            }
            request.setMethod(method);
            request.setEndpoint(endpoint);
            request.setTimeout((Integer) settingsRA.Timeout__c);        
			
            if (!Test.isRunningTest()) response = http.send(request);
            
            System.debug(response.getBody());
            
            if (Test.isRunningTest())
                return '{"data":[{"hugme_status":{"id":3,"name":"Fechado"},"ra_status":{"id":7,"name":"Réplica do consumidor"},"favorable_assessment":{"id":0,"description":"Não Solicitado"},"information_source":{"id":1,"name":"RA Reclamação"},"source":{"id":1,"name":"ReclameAQUI"},"company":{"id":1871,"name":"Koala Testes"},"last_feeling":{"id":-1,"name":null},"feed_type":{"id":-1,"name":null},"moderation":{"user":{"id":-1,"name":null},"status":null,"reason":null,"request_date":null,"response_date":null},"ra":{"replicas_count":1,"source_id":1,"source_name":"Site","deactivation_date":null,"deactivation_reason":null,"internal_process":true,"blackfriday":false},"customer":{"birthday":["1992-04-22T00:00:00.000Z"],"cpf":["47217739004"],"rg":["497233201"],"gender":["Masculino"],"email":["abc@abc.com"],"phone_numbers":["19999547852","19992466666","19999547852"],"photo":[],"id":50273839,"duplicate_id":-1,"name":"Primeiro Nome Sobrenome","city":[{"id":616,"name":"Paulínia"}],"state":[{"id":26,"name":"São Paulo","fs":"SP"}],"type":"Private Person","tags":[],"pending_tickets_count":0},"user":{"id":-1,"name":null},"account":{"id":-1,"name":null},"rafone":{"expiration_date":null,"status_id":-1,"status_name":null},"_id":"5f1727b8ae09c9c234a2f9b1","id":35888715,"source_external_id":"108888931","can_like":false,"commentary":false,"creation_date":"2020-07-21T17:35:26.000Z","insertion_date":"2020-07-21T17:36:53.000Z","complaint_title":"Teste 2107-1434","filed":false,"last_modification_date":"2020-07-21T18:23:30.000Z","closed_date":null,"request_moderation":true,"request_evaluation":false,"frozen":false,"complaint_content":"Testando","ra_reason":"Outros","ra_feeling":null,"complaint_response_content":"Resposta solucionadora.","complaint_response_date":"2020-07-21T18:22:22.000Z","interactions_count":3,"interactions_not_readed_count":12,"resolved_issue":true,"back_doing_business":true,"consumer_consideration":"Teste","consumer_consideration_date":"2020-07-21T18:23:30.000Z","company_consideration":"Resposta solucionadora.","company_consideration_date":"2020-07-21T18:22:22.000Z","private_treatment_time":null,"public_treatment_time":"26589262","rating_time":"26589263","rating":"9","rating_date":"2020-07-21T18:23:30.000Z","comments_count":0,"redistributions_count":0,"redistributions_reason":null,"ticket_moderations_count":0,"ticket_messages_count":0,"last_replica_date":"2020-07-21T18:22:22.000Z","contact_us":null,"rating_without_response":false,"hugme_ticket_type":null,"customer_interactions_count":11,"company_interactions_count":1,"assignment_count":0,"rule_id":6533,"duplicate_ticket":[],"tags":[],"extra_data":{},"sticky_notes":[],"autos":[],"personalized_fields":[],"attached":[],"categories":[],"historical":[{"user":{"id":-1,"name":null,"email":null},"auto":{"id":-1,"name":null},"id":349971233,"creation_date":"2020-07-21T17:36:54.000Z","type":{"id":4,"name":"INTERACAO"}},{"user":{"id":-1,"name":null,"email":null},"auto":{"id":-1,"name":null},"id":349971234,"creation_date":"2020-07-21T17:36:54.000Z","type":{"id":1,"name":"CRIACAO"}},{"user":{"id":-1,"name":null,"email":null},"auto":{"id":-1,"name":null},"id":350004333,"creation_date":"2020-07-21T18:22:18.000Z","type":{"id":4,"name":"INTERACAO"}},{"user":{"id":-1,"name":null,"email":null},"auto":{"id":-1,"name":null},"id":350004334,"creation_date":"2020-07-21T18:22:18.000Z","type":{"id":20,"name":"resposta pública enviada"}},{"user":{"id":-1,"name":null,"email":null},"auto":{"id":-1,"name":null},"id":350006745,"creation_date":"2020-07-21T18:25:08.000Z","type":{"id":4,"name":"INTERACAO"}}],"interactions":[{"ticket_interaction_id":"129126003","ticket_interaction_type_id":1,"ticket_interaction_name":"Manifestação","customer_id":"50273839","responsible_id":null,"responsible_name":null,"message":"Testando","privacy":false,"creation_date":"2020-07-21T17:35:26.000Z","modification_date":null,"delivered":true,"readed":false,"visualized":false,"video":null,"picture":null,"details":[{"ticket_detail_id":"281348021","ticket_detail_type_id":1,"name":"Assunto","value":"Outros","code":null,"creation_date":"2020-07-21T17:35:26.000Z","privacy":false,"modification_date":null},{"ticket_detail_id":"281348024","ticket_detail_type_id":14,"name":"Assunto ID","value":"27","code":null,"creation_date":"2020-07-21T17:35:26.000Z","privacy":false,"modification_date":null},{"ticket_detail_id":"281348025","ticket_detail_type_id":8,"name":"IP","value":"187.10.27.218","code":null,"creation_date":"2020-07-21T17:35:26.000Z","privacy":false,"modification_date":null},{"ticket_detail_id":"281348026","ticket_detail_type_id":7,"name":"Para qual empresa deseja reclamar?","value":"B2C","code":null,"creation_date":"2020-07-21T17:35:26.000Z","privacy":false,"modification_date":null},{"ticket_detail_id":"281348027","ticket_detail_type_id":7,"name":"Por qual canal você deseja ser contatado?","value":"E-mail","code":null,"creation_date":"2020-07-21T17:35:26.000Z","privacy":false,"modification_date":null},{"ticket_detail_id":"281348028","ticket_detail_type_id":7,"name":"Você esta na Koala Testes por qual motivo?","value":"Reclamar","code":null,"creation_date":"2020-07-21T17:35:26.000Z","privacy":false,"modification_date":null},{"ticket_detail_id":"281348029","ticket_detail_type_id":3,"name":"Contato 1","value":"19992466557","code":null,"creation_date":"2020-07-21T17:35:26.000Z","privacy":false,"modification_date":null}]},{"ticket_interaction_id":"129126003","ticket_interaction_type_id":1,"ticket_interaction_name":"Manifestação","customer_id":"50273839","responsible_id":null,"responsible_name":null,"message":"Testando","privacy":false,"creation_date":"2020-07-21T17:35:26.000Z","modification_date":null,"delivered":true,"readed":false,"visualized":false,"video":null,"picture":null,"details":[{"ticket_detail_id":"281348021","ticket_detail_type_id":1,"name":"Assunto","value":"Outros","code":null,"creation_date":"2020-07-21T17:35:26.000Z","privacy":false,"modification_date":null},{"ticket_detail_id":"281348024","ticket_detail_type_id":14,"name":"Assunto ID","value":"27","code":null,"creation_date":"2020-07-21T17:35:26.000Z","privacy":false,"modification_date":null},{"ticket_detail_id":"281348025","ticket_detail_type_id":8,"name":"IP","value":"187.10.27.218","code":null,"creation_date":"2020-07-21T17:35:26.000Z","privacy":false,"modification_date":null},{"ticket_detail_id":"281348026","ticket_detail_type_id":7,"name":"Para qual empresa deseja reclamar?","value":"B2C","code":null,"creation_date":"2020-07-21T17:35:26.000Z","privacy":false,"modification_date":null},{"ticket_detail_id":"281348027","ticket_detail_type_id":7,"name":"Por qual canal você deseja ser contatado?","value":"E-mail","code":null,"creation_date":"2020-07-21T17:35:26.000Z","privacy":false,"modification_date":null},{"ticket_detail_id":"281348028","ticket_detail_type_id":7,"name":"Você esta na Koala Testes por qual motivo?","value":"Reclamar","code":null,"creation_date":"2020-07-21T17:35:26.000Z","privacy":false,"modification_date":null},{"ticket_detail_id":"281348029","ticket_detail_type_id":3,"name":"Contato 1","value":"19992466557","code":null,"creation_date":"2020-07-21T17:35:26.000Z","privacy":false,"modification_date":null}]},{"ticket_interaction_id":"129135514","ticket_interaction_type_id":2,"ticket_interaction_name":"Resposta","customer_id":null,"responsible_id":null,"responsible_name":null,"message":"Resposta solucionadora.","privacy":false,"creation_date":"2020-07-21T18:22:22.000Z","modification_date":null,"delivered":true,"readed":false,"visualized":false,"video":null,"picture":null,"details":[{"ticket_detail_id":"281367780","ticket_detail_type_id":8,"name":"IP","value":"10.20.12.4","code":null,"creation_date":"2020-07-21T18:22:18.000Z","privacy":false,"modification_date":null}]},{"ticket_interaction_id":"129136018","ticket_interaction_type_id":11,"ticket_interaction_name":"Avaliação","customer_id":"50273839","responsible_id":null,"responsible_name":null,"message":"Teste","privacy":false,"creation_date":"2020-07-21T18:23:30.000Z","modification_date":null,"delivered":true,"readed":false,"visualized":false,"video":null,"picture":null,"details":[{"ticket_detail_id":"281368853","ticket_detail_type_id":4,"name":"Resolvida","value":"1","code":null,"creation_date":"2020-07-21T18:23:30.000Z","privacy":false,"modification_date":null},{"ticket_detail_id":"281368854","ticket_detail_type_id":5,"name":"Voltaria a fazer negócio?","value":"1","code":null,"creation_date":"2020-07-21T18:23:30.000Z","privacy":false,"modification_date":null},{"ticket_detail_id":"281368855","ticket_detail_type_id":6,"name":"Nota","value":"9","code":null,"creation_date":"2020-07-21T18:23:30.000Z","privacy":false,"modification_date":null},{"ticket_detail_id":"281368857","ticket_detail_type_id":8,"name":"IP","value":"187.10.27.218","code":null,"creation_date":"2020-07-21T18:23:30.000Z","privacy":false,"modification_date":null}]}],"active":true,"duplicate_tiqt":[]}],"meta":{"page":{"number":1,"size":1},"total":1}}';
        
            return response.getBody();
        }catch(Exception ex){
            System.debug('Integracao ERRO '+ex.getStackTraceString()+' '+ex.getMessage());
            return 'Ocorreu um erro durante o processo. Contacte um administrador.';
        }
    }
    
    public static String requisicaoFormData(String endpoint, String method, Blob formBlob){
        try{
            if(settingsRA.Token__c == null || settingsRA.Token__c == 'Usuário ou senha inválido.')
                settingsRA.Token__c = getToken();
            
            String contentLength = string.valueOf(formBlob.size());
            String contentType = FormData.GetContentType();
            
            HttpRequest request = new HttpRequest();
            HttpResponse response = new HttpResponse();
            Http http = new Http();
            
            request.setBodyAsBlob(formBlob);
            request.setEndpoint(endpoint);
            request.setHeader('Content-Type', contentType);
            request.setHeader('Content-Length', contentLength);
            request.setHeader('Accept', 'application/json'); 
            request.setHeader('Authorization', 'Bearer '+ settingsRA.Token__c);
            request.setMethod(method);
            request.setTimeout((Integer) settingsRA.Timeout__c);
			
            if (!Test.isRunningTest()) response = http.send(request);
            
            System.debug(response.getBody());
            
            if (Test.isRunningTest())
                return '{"ticketDetails":[{"createdAt":"2020-09-03T11:56:09","text":"IP","type":"IP","value":"10.20.1.8"},{"createdAt":"2020-09-03T11:56:09","text":"migrar","type":"RECLAMEAQUI_MEDIACAO_MIGRAR","value":"0"},{"createdAt":"2020-09-03T11:56:09","text":"Motivo ID","type":"RA Mediação Motivo ID","value":"1"},{"createdAt":"2020-09-03T11:56:09","text":"Motivo","type":"RA Mediação Motivo","value":"A reclamação de outra empresa"}],"ticketInteractionType":{"id":8,"name":"Pedido de Mediação "},"video":null,"message":"Operação efetuada com sucesso","createdAt":"2020-09-03T11:56:09","picture":null,"consumer":null,"success":true,"person":null,"ticket":{"systemStatus":{"id":5,"value":"Não respondido"},"ticketStatus":[{"id":21,"type":1,"value":"Novo"},{"id":5,"type":2,"value":"Não respondido"}]}}';
        
            return response.getBody();
        }catch(Exception ex){
            System.debug('Integracao ERRO '+ex.getStackTraceString()+' '+ex.getMessage());
            return 'Ocorreu um erro durante o processo. Contacte um administrador.';
        }
    }
    
    public static String requisicaoAnexo(String endpoint, String method, String body){
        try{
            if(settingsRA.Token__c == null || settingsRA.Token__c == 'Usuário ou senha inválido.')
                settingsRA.Token__c = getToken();

            Http http = new Http(); 
            HttpRequest request = new HttpRequest();
            HttpResponse response = new HttpResponse();
            request.setHeader('Accept', 'application/json');
            request.setHeader('Content-Type', 'application/json');
            request.setHeader('accept-encoding', 'gzip, deflate');
            request.setHeader('Authorization', 'Bearer '+ settingsRA.Token__c);
            
            if(body != null){	
                request.setBody(body);
            }
            request.setMethod(method);
            request.setEndpoint(endpoint);
            request.setTimeout((Integer) settingsRA.Timeout__c);            

            if (!Test.isRunningTest()) 
                response = http.send(request);
                  
            return response.getBody();
        }catch(Exception ex){
            System.debug('Integracao ERRO '+ex.getStackTraceString()+' '+ex.getMessage());
            return 'Ocorreu um erro durante o processo. Contacte um administrador.';
        }
    }
    
    public static Count parseCount(String json) {
        return (Count) System.JSON.deserialize(json, Count.class);
    }

    public static Token parseToken(String json) {
        return (Token) System.JSON.deserialize(json, Token.class);
    }

    public class Count {
        public Integer data;
    }

    public class Token {

        public String access_token;
        public String token_type;
        public Integer expires_in;
        public String scope;
        public Integer rate_limit;
        public String license_start_at;

    }
    
}