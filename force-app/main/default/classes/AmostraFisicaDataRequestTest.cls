@IsTest
public class AmostraFisicaDataRequestTest {
    
    @testSetup static void testSetup() {
        User u = new User(
            ProfileId = [SELECT Id FROM Profile WHERE Name = 'Brazil Global'].Id,
            LastName = 'TestU1',
            Email = 'test@test.com',
            Username = 'test@testtest.com' + System.currentTimeMillis(),
            CompanyName = 'TEST',
            Title = 'title',
            Alias = 'alias',
            TimeZoneSidKey = 'America/Los_Angeles',
            EmailEncodingKey = 'UTF-8',
            LanguageLocaleKey = 'en_US',
            LocaleSidKey = 'en_US',
            IsActive = true
        );
        insert u;
        
        User u2 = new User(ProfileId = [SELECT Id FROM Profile WHERE Name = 'System Administrator' OR Name = 'Administrador do Sistema' LIMIT 1].Id, 
            LastName = 'TestU2',
            Email = 'test@test.com',
            Username = 'test@testtest.com' + System.currentTimeMillis(),
            CompanyName = 'TEST',
            Title = 'title',
            Alias = 'alias',
            TimeZoneSidKey = 'America/Los_Angeles',
            EmailEncodingKey = 'UTF-8',
            LanguageLocaleKey = 'en_US',
            LocaleSidKey = 'en_US',
            ManagerId = u.Id
        );
        insert u2;
        
        System.runAs(u) {
            SaldoParaAmostras__c saldo = new SaldoParaAmostras__c();
            saldo.Funcionario__c = u.Id;
            saldo.Saldo__c = 100;
            insert saldo;
            
            SaldoParaAmostras__c saldo2 = new SaldoParaAmostras__c();
            saldo2.Funcionario__c = u2.Id;
            saldo2.Saldo__c = 100;
            insert saldo2;
        }
    }
    
    static testMethod void testParse() {
        String json = '{\"VTWEG\":\"1\",\"VKORG\":\"OVE7\",\"VKBUR\":\"EV01\",\"VDATU\":\"20191104\",\"TG_CONDITIONS\":[],\"TG_BAPISDITM\":[{\"USAGE_IND\":\"001\",\"TARGET_QTY\":\"10\",\"STORE_LOC\":\"\",\"PURCH_DATE\":\"20190919\",\"PLANT\":\"PE21\",\"MATERIAL\":\"000009781447925552\",\"INCOTERMS2\":\"\",\"INCOTERMS1\":\"\",\"BILL_DATE\":\"\"},{\"USAGE_IND\":\"001\",\"TARGET_QTY\":\"10\",\"STORE_LOC\":\"\",\"PURCH_DATE\":\"20190919\",\"PLANT\":\"PE21\",\"MATERIAL\":\"000009780133180992\",\"INCOTERMS2\":\"\",\"INCOTERMS1\":\"\",\"BILL_DATE\":\"\"},{\"USAGE_IND\":\"001\",\"TARGET_QTY\":\"10\",\"STORE_LOC\":\"\",\"PURCH_DATE\":\"20190919\",\"PLANT\":\"PE21\",\"MATERIAL\":\"000009781447931386\",\"INCOTERMS2\":\"\",\"INCOTERMS1\":\"\",\"BILL_DATE\":\"\"},{\"USAGE_IND\":\"001\",\"TARGET_QTY\":\"10\",\"STORE_LOC\":\"\",\"PURCH_DATE\":\"20190919\",\"PLANT\":\"PE21\",\"MATERIAL\":\"000009781405833523\",\"INCOTERMS2\":\"\",\"INCOTERMS1\":\"\",\"BILL_DATE\":\"\"},{\"USAGE_IND\":\"001\",\"TARGET_QTY\":\"10\",\"STORE_LOC\":\"\",\"PURCH_DATE\":\"20190919\",\"PLANT\":\"PE21\",\"MATERIAL\":\"000009781405882774\",\"INCOTERMS2\":\"\",\"INCOTERMS1\":\"\",\"BILL_DATE\":\"\"}],\"SERIES\":\"\",\"RG\":null,\"RAZAO_SOCIAL\":null,\"PYMT_METH\":\"\",\"PF_RECEBEDOR\":\"\",\"PF_EMISSOR\":\"X\",\"PAIS\":\"BR\",\"OBS\":\"AOS CUIDADOS: null TIPO DE ENTREGA:Outros   \",\"NUMERO\":null,\"NOME_FANTASIA\":\"Escola do Professor Fernando\",\"NFNUM\":\"\",\"KVGR2\":\"20191104\",\"KVGR1\":\"7\",\"KOSTL\":null,\"INCO2\":\"null/null\",\"INCO1\":\"CIF\",\"FRETE\":\"0\",\"FONE\":\"null\",\"ESTADO\":null,\"ENTREGA\":\"null null null null null-null null\",\"ENDERECO\":null,\"EMAIL\":\"fernando.santos1@pearson.com\",\"DZTERM\":\"Z000\",\"DTA_CADASTRO\":\"20190919\",\"COND_PAGTO\":\"Z000\",\"COMPLEMENTO\":null,\"COMPLEM\":\"0\",\"CNPJ_CPF_RECEBEDOR\":\"\",\"CNPJ_CPF_EMISSOR\":\"03282579000110\",\"CIDADE\":null,\"CEP\":null,\"BSTKD\":\"0060t00000Hmu5TAAR\",\"BSTDK1\":\"20191104\",\"BAIRRO\":null,\"AUART\":\"ZBAG\"}';
        AmostraFisicaDataRequest obj = AmostraFisicaDataRequest.parse(json);
        String json2 = AmostraFisicaDataRequest.unparse(obj);
        User u = [SELECT Id FROM User WHERE LastName = 'TestU2'][0];
        System.runAs(u) {
            Opportunity opp = TestHelper.createOpportunity();
            opp.OwnerId = u.Id;
            insert opp;
            
            PricebookEntry pbEntry = TestHelper.createPricebookEntry();
            insert pbEntry;
            
            Pricebook2 pb = new Pricebook2();
            pb.Id = pbEntry.Pricebook2Id;
            pb.AmostraFisica__c = true;
            update pb;
            
            AmostraFisica__c amostra = new AmostraFisica__c();
            amostra.Oportunidade__c = opp.Id;
            amostra.TipoFrete__c = 'Normal';
            insert amostra;
            
            ItemAmostraFisica__c item = new ItemAmostraFisica__c();
            item.AmostraFisica__c = amostra.Id;
            item.Produto__c = pbEntry.Product2Id;
            item.Quantidade__c = 1;
            insert item;
            
            item.Quantidade__c = 2;
            update item;
            
            AmostraFisicaDataRequest.makeDataRequest(opp, amostra);
        }
    }
    
    
}