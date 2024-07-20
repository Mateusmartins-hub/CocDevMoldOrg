@isTest
public class LGPD_DataMaskTest {
    @testSetup 
    public static void setup() {
        Account conta = TestHelper.createAccount();
        conta.Name = Util.generateRandomStringChar(15);
        insert conta;
        
        Lead ld = TestHelper.createLead();
        ld.DataNascimento__c = Util.generateRandomDate();
        ld.AnnualRevenue = Util.generateRandomInteger(2);
        ld.PotencialFaturamento__c = Util.generateRandomInteger(2);
        insert ld;
        
        DataMask__c customSetting = new DataMask__c();
        customSetting.ObjectsToAvoid__c = 'Lead';
        customSetting.QueryLimit__c = Util.generateRandomStringNumber(2);
        insert customSetting;
    }

    @isTest
    public static void test(){        
        Test.startTest();
        
        LGPD_DataMask dataMask = new LGPD_DataMask();

        Test.stopTest();
    }
}