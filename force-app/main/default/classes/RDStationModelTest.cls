@isTest
public class RDStationModelTest {
    
    @isTest
    static void shouldCreateNewInstanceOfEventoModel(){

        RDStationModel.Evento event = new RDStationModel.Evento();
        event.event_type = 'Type';
        event.payload.email = 'test@test.com';
        event.payload.reason = 'reason';
        event.payload.value = 0;

        System.assertEquals(true, event.isValid());
        System.assertEquals('CDP', event.event_family);
        System.assertEquals('default', event.payload.funnel_name);

    }

    @isTest
    static void shouldCreateNewInstanceOfContatoModel(){

        RDStationModel.Contato contact = new RDStationModel.Contato();
        System.assertEquals(false, contact.isValid());
        
        contact.email = 'test@test.com';
        System.assertEquals(true, contact.isValid());

    }
    
    @isTest
    static void shouldCreateNewInstanceOfLeadModel(){

        String leadData = '{"id":"1104289076","email":"teste@teste.com","name":"Luiz Campos","company":"Empresa teste","job_title":"Desenvolvedor","bio":null,"public_url":"http://app.rdstation.com.br/leads/public/f00d8a74-d98a-42b6-9551-b822bd109bff","created_at":"2020-09-08T15:25:32.505-03:00","opportunity":"true","number_conversions":"1","user":"user@pearson.com","first_conversion":{"content":{"bio":null,"user_id":"397222","lead_info_attributes":{"mobile_phone":null,"personal_phone":"14999999999","twitter":null,"facebook":null,"linkedin":null,"website":null},"company_attributes":{"name":"Empresa teste","site":null,"twitter":null,"facebook":null,"phone":"99999999999","address":"Rua A, 202","email":"teste@teste.com","size":"5","company_sector_id":"16"},"email_lead":"teste@teste.com","Nome":"Luiz Campos","Cargo":"Desenvolvedor","UF":"SP","Cidade Aberto":"Cidade"},"created_at":"2020-09-08T15:25:32.553-03:00","cumulative_sum":"1","source":"Luiz Campos","conversion_origin":{"source":"unknown","medium":"unknown","value":null,"campaign":"unknown","channel":"Unknown"}},"last_conversion":{"content":{"bio":null,"user_id":"397222","lead_info_attributes":{"mobile_phone":null,"personal_phone":"99999999999","twitter":null,"facebook":null,"linkedin":null,"website":null},"company_attributes":{"name":"Empresateste","site":null,"twitter":null,"facebook":null,"phone":"99999999999","address":"Rua A, 202","email":"teste@teste.com","size":"5","company_sector_id":"16"},"email_lead":"teste@teste.com","Nome":"Luiz Campos","Cargo":"Desenvolvedor","UF":"SP","Cidade Aberto":"Cidade"},"created_at":"2020-09-08T15:25:32.553-03:00","cumulative_sum":"1","source":"Luiz Campos","conversion_origin":{"source":"unknown","medium":"unknown","value":null,"campaign":"unknown","channel":"Unknown"}},"custom_fields":{"Interesse em cursos":"Mais ou menos","Motivação educacional":"Ser um melhor profissional","Curso de interesse":"Direito,Administração,Engenharia,Medicina,Nutrição,Outros","Formação profissional":"Arquiteto","Escolaridade":"Ensino médio","Idade":"Entre 15 a 18 anos","Nome completo":"Luiz Campos","Instituição":"Casa","Sou-escolha a função":"Diretor(a)","Escola":"Escola Teste","Nome da escola":"Escola","Qual o seu cargo atual?":"Diretor(a)","Em qual segmento você atua?":"Ensino Fundamental Anos Finais","Qual número de alunos?":"Até 300 alunos","Este website não coleta dados de menores de 18 anos.":"Declaro ter mais de 18 anos"},"website":null,"personal_phone":"99999999999","mobile_phone":null,"city":"Cidade","state":"SP","tags":null,"lead_stage":"Lead","last_marked_opportunity_date":"2020-09-08T15:47:19.412-03:00","uuid":"f00d8a74-d98a-42b6-9551-b822bd109bff","fit_score":"d","interest":0}';

        RDStationModel.Lead lead = (RDStationModel.Lead)JSON.deserialize(leadData, RDStationModel.Lead.class);
        System.assert(lead.first_conversion != null);
        System.assert(lead.first_conversion.content != null);
        System.assert(lead.first_conversion.conversion_origin != null);
        System.assert(lead.last_conversion != null);
        System.assert(lead.last_conversion.content != null);
        System.assert(lead.last_conversion.conversion_origin != null);
        System.assert(lead.brand == null);

    }


}