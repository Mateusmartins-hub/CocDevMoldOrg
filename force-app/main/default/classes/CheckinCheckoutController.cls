public class CheckinCheckoutController {
   public class EventObj {
        @AuraEnabled
        public String Id;
        @AuraEnabled
        public Datetime StartDateTime;
        @AuraEnabled
        public String WhoId;
        @AuraEnabled
        public String WhoName;
        @AuraEnabled
        public String Subject;
        @AuraEnabled
        public Boolean VisitaRealizada;
    }

    private class ResponseObj {
        public String action;
        public Boolean hasResearch;
    }

    @AuraEnabled
    public static List<EventObj> getUserEvents(){
        Date todaysDate = date.today();
        Date WeekFrom = todaysDate.toStartofWeek();
        Date WeekTo = WeekFrom.adddays(7);
        TimeZone tz = UserInfo.getTimeZone();

        List<Event> events = [SELECT Id, WhoId, Who.Name, Subject, BR_Visita_Realizada__c, StartDateTime FROM Event WHERE OwnerId =: userInfo.getUserId() AND StartDateTime > :WeekFrom AND StartDateTime < :WeekTo];

        List<EventObj> eventsObjs = new List<EventObj>();
        for (Event evt : events) {
            EventObj evtObj = new EventObj();
            evtObj.iD = evt.Id;
            //Visto que a hora esta sendo salva com o timezone errado aqui é feita a conversão para o timezone do usuário
            //evtObj.StartDateTime = evt.StartDateTime.addSeconds(-(tz.getOffset(evt.StartDateTime)/1000));
            evtObj.StartDateTime = evt.StartDateTime;
            evtObj.WhoId = evt.WhoId;
            evtObj.WhoName = evt.Who.Name;
            evtObj.Subject = evt.Subject;
            evtObj.VisitaRealizada = evt.BR_Visita_Realizada__c;
            eventsObjs.add(evtObj);
        }

        return eventsObjs;
    }

    @AuraEnabled
    public static String handleCheckinCheckout(String recordId, Double lat, Double lon){
        Event evt = [SELECT Id, BR_InitialCheckinDate__c, Subject, BR_InitialLocation__c, WhatId FROM Event WHERE Id = :recordId];
        ResponseObj response = new ResponseObj();
        if (evt.BR_InitialCheckinDate__c == null && evt.BR_InitialLocation__c == null) {
            response.hasResearch = makeCheckin(recordId, lat, lon);
            response.action = 'checkin';
        }
        else {
            makeCheckout(recordId, lat, lon);
            response.action = 'checkout';
            response.hasResearch = true;
        }
            
        return JSON.serialize(response);
    }
    
    public static Boolean makeCheckin(String recordId, Double lat, Double lon){
        Event evt = [SELECT Id, BR_InitialCheckinDate__c, Subject, BR_InitialLocation__c, WhatId FROM Event WHERE Id = :recordId];
        evt.BR_InitialCheckinDate__c = DateTime.now();
        evt.BR_InitialLocation__Latitude__s = lat;
        evt.BR_InitialLocation__Longitude__s = lon;
        evt.Description = evt.Subject;
        update evt;

        if (evt.WhatId != null) {
        String sObjName = evt.WhatId.getSObjectType().getDescribe().getName();
        if (sObjName == 'Account')
            return hasResearch(evt.WhatId);
        else
            return true;
        } else 
            return true;
    }

    @TestVisible
    private static Boolean hasResearch(Id recordId) {
        List<Account_Segmentation__c> acctSegmentation = [SELECT Id FROM Account_Segmentation__c WHERE Account__c = :recordId];
        if (!acctSegmentation.isEmpty())
            return true;

        List<Adocoes_Cs__c> adocoes = [SELECT Id FROM Adocoes_Cs__c WHERE Institui_o__c = :recordId];
        if (!adocoes.isEmpty())
            return true;

        List<IDEB_Code__c> ideb = [SELECT Id FROM IDEB_Code__c WHERE BR_Account__c = :recordId];
        if (!ideb.isEmpty())
            return true;

        return false;
    }
    
    public static void makeCheckout(String recordId, Double lat, Double lon){
        Event evt = [SELECT Id, BR_FinalCheckinDate__c, BR_FinalLocation__c, Subject FROM Event WHERE Id = :recordId];
        evt.BR_FinalCheckinDate__c = DateTime.now();
        evt.BR_FinalLocation__Latitude__s = lat;
        evt.BR_FinalLocation__Longitude__s = lon;
        evt.Description = evt.Subject;
        update evt;
    }
}