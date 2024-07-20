public class EventDAO {

	public static List<Event> getEventByConsultoriaId(Id consultoriaId){
		return [SELECT Id,
				BR_Contato__c,
				StartDateTime,
				Owner.Name,
				BR_TipoConsultoria__c,
				Subject,
				BR_SubtipoConsultoria__c,
				BR_Contato__r.Id,
				BR_Contato__r.Name,
				BR_Contato__r.Email,
				BR_Visita_Realizada__c,
				RecordType.DeveloperName,
				WhoId
				FROM Event
				WHERE WhatId =:consultoriaId
		Order by Id desc];
	}

	public static List<Event> getEventsByRelatedAndRecordType(Set<Id> oppsIds, Id evtRecordType) {
		return [SELECT Id, WhatId FROM Event WHERE WhatId IN :oppsIds AND RecordTypeId = :evtRecordType];
	}

	public static Event getEventById(Id eventId){
		return [SELECT Id, AccountId, Description, BR_FinalCheckinDate__c, WhatId, WhoId, StartDateTime,
					   OwnerId, RecordTypeId, ObjetivoVisita__c
				FROM Event
				WHERE Id =: eventId
				LIMIT 1];
	}
}