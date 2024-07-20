public class RDStationApi {

    private String endpoint;

    public RDStationApi(String nomeConta){

        if(String.isBlank(nomeConta)){
            throw new RDStationsApiException('Não foi informado a marca para a integração.');
        }

        this.endpoint = 'callout:RDStation_' + nomeConta.replace('á', 'a').remove(' ');
    }

    public HttpResponse retrieveContact(String email){
        HttpRequest req = new HttpRequest();
        req.setEndpoint(this.endpoint + '/platform/contacts/email:' + email);
        req.setMethod('GET');
        req.setHeader('Content-Type', 'application/json');

        Http http = new Http();
        return http.send(req);
    }

    public HttpResponse updateContact(RDStationModel.Contato contato){
        if(!contato.isValid()){
            throw new RDStationsApiException('A conta não possui e-mail!');
        }

        HttpRequest req = new HttpRequest();
        req.setEndpoint(this.endpoint + '/platform/contacts/email:' + contato.email);
        req.setMethod('POST');
        req.setHeader('X-HTTP-Method-Override','PATCH');
        req.setHeader('Content-Type', 'application/json');
        req.setBody(contato.toJson(true));

        Http http = new Http();
        return http.send(req);
    }

    public HttpResponse sendEvent(RDStationModel.Evento evento){

        if(!evento.isValid()){
            throw new RDStationsApiException('A conta não possui e-mail!');
        }

        HttpRequest req = new HttpRequest();
        req.setEndpoint(this.endpoint + '/platform/events');
        req.setMethod('POST');
        req.setHeader('Content-Type', 'application/json');
        req.setBody(evento.toJson());

        Http http = new Http();
        return http.send(req);
    }

    public HttpResponse setContactAsOpportunity(String email){
        return setContactAsOpportunity(email, null);
    }

    public HttpResponse setContactAsOpportunity(String email, String nomeFunil){

        RDStationModel.Evento evento = new RDStationModel.Evento();
        evento.event_type = 'OPPORTUNITY';
        evento.payload.email = email;
        
        if(String.isNotBlank(nomeFunil)){
            evento.payload.funnel_name = nomeFunil;
        }

        return sendEvent(evento);
    }

    public HttpResponse setOpportunityAsWon(String email){
        return setOpportunityAsWon(email, null, null);
    }

    public HttpResponse setOpportunityAsWon(String email, Decimal valorVenda){
        return setOpportunityAsWon(email, null, valorVenda);
    }
    
    public HttpResponse setOpportunityAsWon(String email, String nomeFunil, Decimal valorVenda){

        RDStationModel.Evento evento = new RDStationModel.Evento();
        evento.event_type = 'SALE';
        evento.payload.email = email;

        if(valorVenda != null){
            evento.payload.value = valorVenda;
        }

        if(String.isNotBlank(nomeFunil)){
            evento.payload.funnel_name = nomeFunil;
        }
        else{
            evento.payload.funnel_name = 'Cliente';
        }

        return sendEvent(evento);
    }

    public HttpResponse setOpportunityAsLost(String email, String motivoDaPerda){
        return setOpportunityAsLost(email, null, motivoDaPerda);
    }
    
    public HttpResponse setOpportunityAsLost(String email, String nomeFunil, String motivoDaPerda){

        RDStationModel.Evento evento = new RDStationModel.Evento();
        evento.event_type = 'OPPORTUNITY_LOST';
        evento.payload.email = email;
        
        if(motivoDaPerda != null){
            evento.payload.reason = motivoDaPerda;
        }
        
        if(String.isNotBlank(nomeFunil)){
            evento.payload.funnel_name = nomeFunil;
        }
        else{
            evento.payload.funnel_name = 'Lead';
        }

        return sendEvent(evento);
    }

    public class RDStationsApiException extends Exception {}

}