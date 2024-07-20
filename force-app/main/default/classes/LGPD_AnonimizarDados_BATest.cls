@isTest
public with sharing class LGPD_AnonimizarDados_BATest {

    @testSetup 
    public static void setup() {
        Account conta = TestHelper.createAccount();
        conta.Name = Util.generateRandomStringChar(10);
        insert conta;
        
        Lead ld = TestHelper.createLead();
        ld.DataNascimento__c = Util.generateRandomDate();
        ld.AnnualRevenue = Util.generateRandomInteger(2);
        ld.PotencialFaturamento__c = Util.generateRandomInteger(2);
        ld.Industry = Util.generateRandomStringChar(10);
        ld.FirstName = Util.generateRandomStringChar(10);
        ld.LastName = Util.generateRandomStringChar(40);
        ld.DDD__c = Util.generateRandomStringNumber(2);
        ld.Email = Util.generateRandomStringChar(10)+'@test.com';
        insert ld;
        
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
    }

    @isTest
    public static void test(){
        List<Account> contas = [SELECT Id FROM Account LIMIT 100];
        List<Lead> leads = [SELECT Id FROM Lead LIMIT 100];
        Set<Id> Ids = (new Map<Id,Account>(contas)).keySet();
        Ids = (new Map<Id,Lead>(leads)).keySet();
        
        Test.startTest();
        
        LGPD_AnonimizarDados_BA batch = new LGPD_AnonimizarDados_BA(Ids);
        Database.executeBatch(batch);

        Test.stopTest();
    }
}