public with sharing class ClienteSAPPOJO {

	public String OppId;
	public String Mensagem;

    private static final IntegracaoClienteSAP__c ENDPOINT_INFO = IntegracaoClienteSAP__c.getOrgDefaults();

	public class Structure {
		public string KUNNR { get; set; }
		public string NAME1 { get; set; }
		public string REGIO { get; set; }
		public string KNKLI { get; set; }
		public string KLIMK { get; set; }
		public string SKFOR { get; set; }
		public string SALDO { get; set; }
		public string CMGST { get; set; }
		public string TOTAL_AT { get; set; }
		public string I_VKORG { get; set; }


	}

	public class Table {
		public string Name { get; set; }
		public List<Structure> Structures { get; set; }
	}

	public class Data {
		public List<Table> Tables { get; set; }
	}

	public class RootObject {
		public string Status { get; set; }
		public Data Data { get; set; }
	}

	public RootObject parse(string jsonString) {
		JSONParser parser = JSON.createParser(jsonString);
		RootObject cliente = new RootObject();

		while(parser.nextToken() != null) {
			if(parser.getCurrentToken() == JSONToken.START_OBJECT) {
				cliente = (RootObject) parser.readValueAs(RootObject.class);
			}
		}

		return cliente;

	}

	public Map<String,String> buscarClienteSAP(String cnpj) {
		Map<String,String> retorno = new Map<String,String>();
		retorno.put('OV0',buscarClienteSAP('OV0',cnpj));
		retorno.put('OV1',buscarClienteSAP('OV1',cnpj));
		retorno.put('OV2',buscarClienteSAP('OV2',cnpj));
		retorno.put('OV4',buscarClienteSAP('OV4',cnpj));
		retorno.put('OV5',buscarClienteSAP('OV5',cnpj));
		retorno.put('OV7',buscarClienteSAP('OV7',cnpj));
		return retorno;
	}

	private String buscarClienteSAP(String OV, String cnpj) {

		//------- Acesso a base clientes  ------------
		String retorno;
		String endpoint;
		String body;
		String str_datarequest;


		HTTPExterno portal = new HTTPExterno();

		str_datarequest = '{"I_STCD":"' + cnpj + '","I_VKORG":"' + OV + '","I_BUKRS":"PEBR"}';
		body = 'key=' + ENDPOINT_INFO.EndpointKey__c + '&User=' + ENDPOINT_INFO.EndpointUser__c + '&ConnectionName=' + ENDPOINT_INFO.ConnectionName__c + '&Application=' + ENDPOINT_INFO.EndpointApplication__c + '&EndPoint=' + ENDPOINT_INFO.RFC__c + '&DataRequest=' + str_datarequest;

		retorno = portal.getContent(ENDPOINT_INFO.EndpointURL__c, 'POST', 'application/x-www-form-urlencoded', body);

		return retorno;
	}






}