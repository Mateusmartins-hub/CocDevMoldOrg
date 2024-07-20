@IsTest
public class MeetimeParamTest {
	
	static testMethod void testParse() {
		String json = '{'+
		'  \"event\": \"LEAD.WON\",'+
		'  \"prospection\": {'+
		'    \"id\": 2128318,'+
		'    \"lead\": {'+
		'      \"id\": 1924635,'+
		'      \"email\": \"matheus.salesf@hotmail.com\",'+
		'      \"firstName\": \"Matheus\",'+
		'      \"name\": \"Sales\",'+
		'      \"company\": \"Sottelli\",'+
		'      \"phones\": [],'+
		'      \"position\": \"Desenvolvedor\",'+
		'      \"site\": \"www.sottelli.com\",'+
		'      \"state\": \"SP\",'+
		'      \"city\": \"Campinas\",'+
		'      \"twitter\": null,'+
		'      \"facebook\": null,'+
		'      \"linkedIn\": null,'+
		'      \"annotations\": \"\",'+
		'      \"customFields\": {'+
		'        \"marcaSf\": \"e9304b37-b6de-490a-9892-eb71a6f01732\",'+
		'        \"origemDoLead\": \"Meetime\"'+
		'      },'+
		'      \"publicUrl\": \"https://meetime.com.br/dashboard/public/leads/EDFOjVE9W3uglUZk62eGp69IPfghsZm-mX4BMsU5--4\"'+
		'    },'+
		'    \"cadence\": {'+
		'      \"id\": 5555,'+
		'      \"name\": \"Inbound  Ativo\"'+
		'    },'+
		'    \"originType\": \"IMPORTED_MANUALLY\",'+
		'    \"inbound\": false,'+
		'    \"startDate\": \"2020-01-31T17:07:10.492Z\",'+
		'    \"endDate\": \"2020-01-31T18:32:27.713Z\",'+
		'    \"status\": \"WON\",'+
		'    \"salesman\": {'+
		'      \"id\": 12829,'+
		'      \"name\": \"Victor Bolzon\"'+
		'    },'+
		'    \"activities\": [],'+
		'    \"extraActivities\": [],'+
		'    \"origin\": {'+
		'      \"campaign\": null,'+
		'      \"source\": null,'+
		'      \"conversion\": null,'+
		'      \"channel\": \"UNKNOWN\"'+
		'    }'+
		'  }'+
		'}';
		MeetimeParam r = MeetimeParam.parse(json);
		System.assert(r != null);

		json = '{\"TestAMissingObject\": { \"TestAMissingArray\": [ { \"TestAMissingProperty\": \"Some Value\" } ] } }';
		MeetimeParam.Origin objOrigin = new MeetimeParam.Origin(System.JSON.createParser(json));
		System.assert(objOrigin != null);
		System.assert(objOrigin.campaign == null);
		System.assert(objOrigin.source == null);
		System.assert(objOrigin.conversion == null);
		System.assert(objOrigin.channel == null);

		json = '{\"TestAMissingObject\": { \"TestAMissingArray\": [ { \"TestAMissingProperty\": \"Some Value\" } ] } }';
		MeetimeParam.Prospection objProspection = new MeetimeParam.Prospection(System.JSON.createParser(json));
		System.assert(objProspection != null);
		System.assert(objProspection.id == null);
		System.assert(objProspection.lead == null);
		System.assert(objProspection.cadence == null);
		System.assert(objProspection.originType == null);
		System.assert(objProspection.inbound == null);
		System.assert(objProspection.startDate == null);
		System.assert(objProspection.endDate == null);
		System.assert(objProspection.status == null);
		System.assert(objProspection.salesman == null);
		System.assert(objProspection.activities == null);
		System.assert(objProspection.extraActivities == null);
		System.assert(objProspection.origin == null);

		json = '{\"TestAMissingObject\": { \"TestAMissingArray\": [ { \"TestAMissingProperty\": \"Some Value\" } ] } }';
		MeetimeParam.CustomFields objCustomFields = new MeetimeParam.CustomFields(System.JSON.createParser(json));
		System.assert(objCustomFields != null);
		System.assert(objCustomFields.marcaSf == null);
		System.assert(objCustomFields.origemDoLead == null);

		json = '{\"TestAMissingObject\": { \"TestAMissingArray\": [ { \"TestAMissingProperty\": \"Some Value\" } ] } }';
		MeetimeParam.Phones objPhones = new MeetimeParam.Phones(System.JSON.createParser(json));
		System.assert(objPhones != null);

		json = '{\"TestAMissingObject\": { \"TestAMissingArray\": [ { \"TestAMissingProperty\": \"Some Value\" } ] } }';
		MeetimeParam objMeetimeParam = new MeetimeParam(System.JSON.createParser(json));
		System.assert(objMeetimeParam != null);
		System.assert(objMeetimeParam.event == null);
		System.assert(objMeetimeParam.prospection == null);

		json = '{\"TestAMissingObject\": { \"TestAMissingArray\": [ { \"TestAMissingProperty\": \"Some Value\" } ] } }';
		MeetimeParam.Lead objLead = new MeetimeParam.Lead(System.JSON.createParser(json));
		System.assert(objLead != null);
		System.assert(objLead.id == null);
		System.assert(objLead.email == null);
		System.assert(objLead.firstName == null);
		System.assert(objLead.name == null);
		System.assert(objLead.company == null);
		System.assert(objLead.phones == null);
		System.assert(objLead.position == null);
		System.assert(objLead.site == null);
		System.assert(objLead.state == null);
		System.assert(objLead.city == null);
		System.assert(objLead.twitter == null);
		System.assert(objLead.facebook == null);
		System.assert(objLead.linkedIn == null);
		System.assert(objLead.annotations == null);
		System.assert(objLead.customFields == null);
		System.assert(objLead.publicUrl == null);

		json = '{\"TestAMissingObject\": { \"TestAMissingArray\": [ { \"TestAMissingProperty\": \"Some Value\" } ] } }';
		MeetimeParam.Cadence objCadence = new MeetimeParam.Cadence(System.JSON.createParser(json));
		System.assert(objCadence != null);
		System.assert(objCadence.id == null);
		System.assert(objCadence.name == null);
	}
}