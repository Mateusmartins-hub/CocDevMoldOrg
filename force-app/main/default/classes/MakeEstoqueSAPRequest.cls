public class MakeEstoqueSAPRequest {
    private static final IntegracaoEstoqueSAP__c ENDPOINT_INFO = IntegracaoEstoqueSAP__c.getOrgDefaults();

    public class SAPException extends Exception{}

    private class Exports {
        public string V_COUNT { get; set; }
    }

    private class Structure {
        public string MATNR { get; set; }
        public string LABST { get; set; }
    }

    private class Table {
        public string Name { get; set; }
        public List<Structure> Structures { get; set; }
    }

    private class Data {
        public Exports Exports { get; set; }
        public List<Table> Tables { get; set; }
    }

    private class RootObject {
        public string Status { get; set; }
        public Data Data { get; set; }
    }

    public static Map<String, String> getAllStocks() {
        HttpExterno request = new HttpExterno();

        String urlParams = createUrlParamsAllStocks();
        HttpResponse response = request.makeRequest(ENDPOINT_INFO.EndpointURL__c, 'POST', 'application/x-www-form-urlencoded', urlParams);

        if (response.getStatusCode() != 200) {
            throw new SAPException('Erro na conexão com o SAP');
        } else {
            String responseBody = response.getBody();
            List<Structure> newStocks = getStocksFromResponse(responseBody);

            Map<String, String> mapISBN = new Map<String, String>();
            for (Structure struc : newStocks) {
                mapISBN.put(struc.MATNR.replaceFirst('^0+(?!$)', ''), struc.LABST);
            }

            return mapISBN;
        }
    }

    public static String createUrlParamsAllStocks() {
        Map<String, String> mapParams = new Map<String, String>();
        mapParams.put('key', ENDPOINT_INFO.EndpointKey__c);
        mapParams.put('User', ENDPOINT_INFO.EndpointUser__c);
        mapParams.put('ConnectionName', ENDPOINT_INFO.ConnectionName__c);
        mapParams.put('Application', ENDPOINT_INFO.EndpointApplication__c);
        mapParams.put('EndPoint', ENDPOINT_INFO.RFC__c);
        mapParams.put('DataRequest', '[]');

        List<String> listParams = new List<String>();
        for (String mp : mapParams.keySet()) {
            listParams.add(mp + '=' + mapParams.get(mp));
        }

        return string.join(listParams, '&');
    }

    public static List<Structure> getStocksFromResponse(String jsonContent) {
        JSONParser parser = JSON.createParser(jsonContent);
        RootObject inv = (RootObject) parser.readValueAs(RootObject.class);

        return inv.Data.Tables[0].Structures;
    }
}