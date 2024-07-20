@isTest
public class ReclameAquiWSTest {
    
    @isTest
    public static void Test(){
        
        IntegracaoRA__c settingsRA = TestHelper.createCustomSettingsRA();
        String count = '{"data":91}';
        String token = '{"access_token":"bab03215-afd9-4f5a-b500-e79c0f45731e","token_type":"bearer","expires_in":10799,"scope":"trust read write","rate_limit":2500,"license_start_at":"2018-10-16 00:00:00"}';
        Test.startTest();

        ReclameAquiWS.getToken();
        ReclameAquiWS.count();
        ReclameAquiWS.requisicao(settingsRA.EndpointPublicMessage__c,'POST','Body');
        ReclameAquiWS.requisicaoAnexo(settingsRA.EndpointPublicMessage__c,'POST','Body');
        ReclameAquiWS.requisicaoFormData(settingsRA.EndpointPublicMessage__c,'POST',Blob.valueOf(token));
        ReclameAquiWS.parseCount(count);
        ReclameAquiWS.parseToken(token);
        Test.stopTest();

    }

}