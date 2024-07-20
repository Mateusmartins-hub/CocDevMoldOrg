@isTest
public class RDStationWebhookTest {
    
    @isTest
    static void shouldWebhookReceiveDataAndSuccess(){

        List<Lead> leads = [
            SELECT Id
            FROM Lead
        ];

        System.assertEquals(0, leads.size());

        RestResponse res = new RestResponse();
        res.statusCode = 200;
        
        RestRequest req = new RestRequest(); 
        req.addHeader('httpMethod', 'POST');
        req.requestUri = '/services/apexrest/RDStation/';
        String json = '{"leads":[{"id":"1104289076","email":"teste@teste.com","name":"Luiz Campos","company":"Empresa teste","job_title":"Desenvolvedor","bio":null,"public_url":"http://app.rdstation.com.br/leads/public/f00d8a74-d98a-42b6-9551-b822bd109bff","created_at":"2020-09-08T15:25:32.505-03:00","opportunity":"true","number_conversions":"1","user":"user@pearson.com","first_conversion":{"content":{"bio":null,"user_id":"397222","lead_info_attributes":{"mobile_phone":null,"personal_phone":"14999999999","twitter":null,"facebook":null,"linkedin":null,"website":null},"company_attributes":{"name":"Empresa teste","site":null,"twitter":null,"facebook":null,"phone":"99999999999","address":"Rua A, 202","email":"teste@teste.com","size":"5","company_sector_id":"16"},"email_lead":"teste@teste.com","Nome":"Luiz Campos","Cargo":"Desenvolvedor","UF":"SP","Cidade Aberto":"Cidade"},"created_at":"2020-09-08T15:25:32.553-03:00","cumulative_sum":"1","source":"Luiz Campos","conversion_origin":{"source":"unknown","medium":"unknown","value":null,"campaign":"unknown","channel":"Unknown"}},"last_conversion":{"content":{"bio":null,"user_id":"397222","lead_info_attributes":{"mobile_phone":null,"personal_phone":"99999999999","twitter":null,"facebook":null,"linkedin":null,"website":null},"company_attributes":{"name":"Empresateste","site":null,"twitter":null,"facebook":null,"phone":"99999999999","address":"Rua A, 202","email":"teste@teste.com","size":"5","company_sector_id":"16"},"email_lead":"teste@teste.com","Nome":"Luiz Campos","Cargo":"Desenvolvedor","UF":"SP","Cidade Aberto":"Cidade"},"created_at":"2020-09-08T15:25:32.553-03:00","cumulative_sum":"1","source":"Luiz Campos","conversion_origin":{"source":"unknown","medium":"unknown","value":null,"campaign":"unknown","channel":"Unknown"}},"custom_fields":{"Interesse em cursos":"Mais ou menos","Motivação educacional":"Ser um melhor profissional","Curso de interesse":"Direito,Administração,Engenharia,Medicina,Nutrição,Outros","Formação profissional":"Arquiteto","Escolaridade":"Ensino médio","Idade":"Entre 15 a 18 anos","Nome completo":"Luiz Campos","Instituição":"Casa","Sou-escolha a função":"Diretor(a)","Escola":"Escola Teste","Nome da escola":"Escola","Qual o seu cargo atual?":"Diretor(a)","Em qual segmento você atua?":"Ensino Fundamental Anos Finais","Qual número de alunos?":"Até 300 alunos","Este website não coleta dados de menores de 18 anos.":"Declaro ter mais de 18 anos"},"website":null,"personal_phone":"99999999999","mobile_phone":null,"city":"Cidade","state":"SP","tags":null,"lead_stage":"Lead","last_marked_opportunity_date":"2020-09-08T15:47:19.412-03:00","uuid":"f00d8a74-d98a-42b6-9551-b822bd109bff","fit_score":"d","interest":0}]}';
        
        req.requestBody = Blob.valueof(json);
        RestContext.request = req; 
        RestContext.response = res;
        
        Test.startTest();
        String responseBody = RDStationWebhook.doPost();
        Test.stopTest();

        leads = [
            SELECT Id
            FROM Lead
        ];

        System.assertEquals(1, leads.size());
        System.assertEquals('Ok', responseBody);

    }

    @isTest
    static void shouldReturnOwnerId(){

        Id standardOwnerId = [SELECT Id FROM Group WHERE Type = 'Queue' AND DeveloperName = 'Lead_RDStation'][0].Id;
        User newUser = [SELECT Id FROM User LIMIT 1];

        Map<String, User> mapUsers = new Map<String, User>{
            'teste@teste.com' => newUser
        };

        Id ownerId1 = RDStationWebhook.getOwnerId(mapUsers, 'teste@teste.com');
        System.assertEquals(newUser.Id, ownerId1);

        Id ownerId2 = RDStationWebhook.getOwnerId(mapUsers, 'otherEmail@teste.com');
        System.assertEquals(standardOwnerId, ownerId2);

    }

    @isTest
    static void shouldRetrieveLeadByEmail(){

        Lead lead = new Lead();
        lead.FirstName = 'Test';
        lead.LastName = 'Test';
        lead.Email = 'test@test.com';
        lead.Company = 'Test';
        insert lead;

        Set<String> emails = new Set<String>();
        emails.add('test@test.com');
        emails.add('test2@test.com');

        Map<String, Lead> leadMap = RDStationWebhook.retrieveLeadsByEmail(emails);

        System.assertEquals(1, leadMap.size());
        System.assertEquals(false, leadMap.containsKey('test2@test.com'));
    }

    @isTest
    static void shouldInitiateLead(){

        RDStationModel.Lead leadRD = new RDStationModel.Lead();
        leadRD.name = 'Test';
        leadRD.company = 'Company';
        leadRD.email = 'test@test.com';
        leadRD.city = 'City';
        leadRD.state = 'State';
        leadRD.website = 'https://test.com';

        Lead lead = RDStationWebhook.initiateNewLead(leadRD);

        System.assertEquals('Test', lead.FirstName);
        System.assertEquals('Não informado', lead.LastName);
        System.assertEquals('Company', lead.Company);
        System.assertEquals('test@test.com', lead.Email);
        System.assertEquals('City', lead.City);
        System.assertEquals('State', lead.State);
        System.assertEquals('https://test.com', lead.Website);
        System.assertEquals(null, lead.Description);
    }

    @isTest
    static void shouldSplitFullName(){

        Map<String, String> nameMapping1 = RDStationWebhook.splitFullName('Jonh Lennon Zappa');
        System.assertEquals('Jonh', nameMapping1.get('firstName'));
        System.assertEquals('Lennon Zappa', nameMapping1.get('lastName'));

        Map<String, String> nameMapping2 = RDStationWebhook.splitFullName('Jonh');
        System.assertEquals('Jonh', nameMapping2.get('firstName'));
        System.assertEquals('', nameMapping2.get('lastName'));
    }



}