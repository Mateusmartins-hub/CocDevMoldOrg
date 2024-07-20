@IsTest
public with sharing class ClienteSAPPOJOTest {
    
    public HTTPResponse respond(HTTPRequest req) {

        ClienteSAPPOJO.RootObject mock1 = new ClienteSAPPOJO.RootObject();
        mock1.Status = '';
        mock1.Data = new ClienteSAPPOJO.Data();
        mock1.Data.Tables = new List<ClienteSAPPOJO.Table>();
        ClienteSAPPOJO.Table table = new ClienteSAPPOJO.Table();
        table.Name = 'Test';
        table.Structures = new List<ClienteSAPPOJO.Structure>();
        mock1.Data.Tables.add(table);
        ClienteSAPPOJO.Structure struc = new ClienteSAPPOJO.Structure();
        struc.KUNNR = 'test';
		struc.NAME1 = 'test';
		struc.REGIO = 'SP';
		struc.KNKLI = 'test';
		struc.KLIMK = '1';
		struc.SKFOR = '1';
		struc.SALDO = '1';
		struc.CMGST = 'test';
		struc.TOTAL_AT = 'test';
        struc.I_VKORG = 'test';
        table.Structures.add(struc);

        ClienteSAPPOJO.RootObject mock2 = new ClienteSAPPOJO.RootObject();
        mock2.Status = '';
        mock2.Data = new ClienteSAPPOJO.Data();
        mock2.Data.Tables = new List<ClienteSAPPOJO.Table>();
        ClienteSAPPOJO.Table table2 = new ClienteSAPPOJO.Table();
        table2.Name = 'Test';
        table2.Structures = new List<ClienteSAPPOJO.Structure>();
        mock2.Data.Tables.add(table2);

        HttpResponse res = new HttpResponse();
        res.setHeader('Content-Type', 'application/json');
        
        if(req.getEndpoint() == 'https://test1.com'){
            res.setBody(JSON.serialize(mock1));
        }
        else if(req.getEndpoint() == 'https://test2.com'){
            res.setBody(JSON.serialize(mock2));
        }
        res.setStatusCode(200);
        return res;
    }

    @IsTest
    static void shouldTest(){

        Test.setMock(HttpCalloutMock.class, new ClienteSAPBOTest());

        IntegracaoClienteSAP__c integra = new IntegracaoClienteSAP__c();
        integra.EndpointURL__c = 'https://test1.com';
        insert integra;

        String cnpj = '79.468.386/0001-10';

        Test.startTest();
        ClienteSAPPOJO pojo = new ClienteSAPPOJO();

        Map<String, String> customers = pojo.buscarClienteSAP(cnpj);

        ClienteSAPPOJO.RootObject root = pojo.parse(customers.values()[0]);

        Test.stopTest();

    }
}