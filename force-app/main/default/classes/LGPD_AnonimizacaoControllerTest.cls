@isTest
public without sharing class LGPD_AnonimizacaoControllerTest {
    
    @isTest
    public static void findRecordsTest() {
        Contact c = new Contact();
        c.Email = 'test@lgpd.com';
        c.LastName = 'Contact Test LGPD';
        c.BR_CPF__c = '007.171.733-13';
        
        insert c;
        
        Account a = new Account();
        a.Name = 'Account Test LGPD';
        a.BR_Account_email__c = 'test@lgpd.com';
        
        insert a;
        
        Case cs = new Case();
        cs.BR_NomeCompleto__c = 'Test Case LGPD';
        cs.BR_CPF__c = '007.171.733-13';
        cs.Description = 'Test';
        cs.Subject = 'Test';
        cs.SuppliedEmail = 'test@lgpd.com';
        
        insert cs;
        
        DataMask__c customSetting = new DataMask__c();
        customSetting.TriggersToBypass__c = Util.generateRandomStringChar(10);
        customSetting.QueryLimit__c = Util.generateRandomStringNumber(2);
        insert customSetting;
        
        Anonimizacao__c customSettingAnonimizacao = new Anonimizacao__c();
        customSettingAnonimizacao.TextFieldValue__c = Util.generateRandomStringChar(10);
        customSettingAnonimizacao.CheckboxFieldValue__c = FALSE;
        customSettingAnonimizacao.EmailFieldValue__c = Util.generateRandomStringChar(10)+'@test.com';
        customSettingAnonimizacao.NumericFieldValue__c = Util.generateRandomInteger(1);
        insert customSettingAnonimizacao;
        
        Test.setFixedSearchResults(new List<String>{String.valueOf(c.Id), String.valueOf(a.Id), String.valueOf(cs.Id)});
        
        Test.startTest();
        List<String> cpfList = LGPD_AnonimizacaoController.findCPFRecords('007.171.733-13');
        List<LGPD_AnonimizacaoController.RecordResult> cpfEmailList = LGPD_AnonimizacaoController.findCPFEmailRecords('007.171.733-13', new List<String>{'test@lgpd.com'});
        Id batchJobId = LGPD_AnonimizacaoController.executeBatchJob(new List<ID>{c.Id, a.Id, cs.Id});
        LGPD_AnonimizacaoController.getBatchJobStatus(batchJobId);
        System.assertEquals(1, cpfList.size());
        System.assertEquals(3, cpfEmailList.size());
        Test.stopTest();
    }
    
}