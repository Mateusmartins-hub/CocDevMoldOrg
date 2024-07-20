@isTest
public class LGPD_DataMask_BATest {
    @testSetup 
    public static void setup() {
        Account conta = TestHelper.createAccount();
        insert conta;
        
        Lead ld = TestHelper.createLead();
        ld.DataNascimento__c = Util.generateRandomDate();
        ld.AnnualRevenue = Util.generateRandomInteger(2);
        ld.PotencialFaturamento__c = Util.generateRandomInteger(2);
        ld.Industry = Util.generateRandomStringChar(10);
        insert ld;
        
        Contact ct = TestHelper.createContact();
        insert ct;
        
        DataMask__c customSetting = new DataMask__c();
        customSetting.TriggersToBypass__c = Util.generateRandomStringChar(10);
        customSetting.QueryLimit__c = Util.generateRandomStringNumber(2);
        insert customSetting;
    }

    @isTest
    public static void LGPDDataMaskAccountTest(){
        Test.startTest();
        
        LGPD_DataMask_BA accBatch = new LGPD_DataMask_BA('Account');
        Database.executeBatch(accBatch);

        Test.stopTest();
    }
    
    @isTest
    public static void LGPDDataMaskLeadTest(){
        Test.startTest();

        LGPD_DataMask_BA ldBatch = new LGPD_DataMask_BA('Lead');
        Database.executeBatch(ldBatch);   

        Test.stopTest();
    }
    
    @isTest
    public static void LGPDDataMaskContactTest(){
        Test.startTest();

        LGPD_DataMask_BA ctBatch = new LGPD_DataMask_BA('Contact');
        Database.executeBatch(ctBatch);

        Test.stopTest();
    }
    
    @isTest
    public static void LGPDDataMaskProductionTest(){
        Test.startTest();
        
        LGPD_DataMask_BA ldBatchN = new LGPD_DataMask_BA('Lead');
        ldBatchN.isSandbox = FALSE;
        Database.executeBatch(ldBatchN);

        Test.stopTest();
    }
}