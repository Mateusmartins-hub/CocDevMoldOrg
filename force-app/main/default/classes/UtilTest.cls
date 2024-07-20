@isTest
private class UtilTest {

    static testMethod void myUnitTest() {
        String txt = 'teste 12345';
        String valor = Util.getInstance().getString(txt);
    }

    static testMethod void generateRandomStringAlphaTest() {
        Test.startTest();
        String stringAlpha = Util.generateRandomStringAlpha(20);
        System.assert(stringAlpha.isAlphanumeric());
        System.assertEquals(20, stringAlpha.length(), 'Different size than expected!');
        Test.stopTest();
    }

    static testMethod void generateRandomStringNumberTest() {
        Test.startTest();
        String stringNumber = Util.generateRandomStringNumber(20);
        System.assert(stringNumber.isNumeric());
        System.assertEquals(20, stringNumber.length(), 'Different size than expected!');
        Test.stopTest();
    }

    static testMethod void generateRandomStringCharTest() {
        Test.startTest();
        String stringChar = Util.generateRandomStringChar(20);
        System.assert(stringChar.isAlpha());
        System.assertEquals(20, stringChar.length(), 'Different size than expected!');
        Test.stopTest();
    }

    static testMethod void generateRandomIntegerTest() {
        Test.startTest();
        Integer integerNumber = Util.generateRandomInteger(20);
        //System.assertEquals(9, String.valueOf(integerNumber).length(), 'Different size than expected!');
        Test.stopTest();
    }

    static testMethod void generateRandomValueBasedOnStringTest() {
        Test.startTest();
        String originalString = Util.generateRandomStringChar(20);
        String ramdonValue = Util.generateRandomValueBasedOnString(originalString);
        //System.assertNotEquals(originalString, ramdonValue, 'Different value expected!');
        Test.stopTest();
    }
    
    static testMethod void generateRandomValueBasedOnStringNumericTest() {
        Test.startTest();
        String originalString = Util.generateRandomStringNumber(20);
        String ramdonValue = Util.generateRandomValueBasedOnString(originalString);
        System.assertNotEquals(originalString, ramdonValue, 'Different value expected!');
        Test.stopTest();
    }
    
    static testMethod void generateRandomValueBasedOnStringURLTest() {
        Test.startTest();
        String originalString = 'www.'+Util.generateRandomStringChar(20);
        String ramdonValue = Util.generateRandomValueBasedOnString(originalString);
        System.assertNotEquals(originalString, ramdonValue, 'Different value expected!');
        Test.stopTest();
    }
    
    static testMethod void generateRandomValueBasedOnStringSpecialTest() {
        Test.startTest();
        String originalString = Util.generateRandomStringChar(20)+'@ test.com';
        String ramdonValue = Util.generateRandomValueBasedOnString(originalString);
        System.assertNotEquals(originalString, ramdonValue, 'Different value expected!');
        Test.stopTest();
    }

    static testMethod void generateRandomTimeNowTest() {
        Test.startTest();
        Time nowTime = Util.generateRandomTime();
        System.assertNotEquals(NULL, nowTime, 'Time expected!');
        Test.stopTest();
    }

    static testMethod void generateRandomTimeTest() {
        Test.startTest();
        Time nowTime = Util.generateRandomTime();
        Time randomTime = Util.generateRandomTime(nowTime);
        System.assertNotEquals(nowTime, randomTime, 'Different time expected!');
        Test.stopTest();
    }

    static testMethod void generateRandomDateTodayTest() {
        Test.startTest();
        Date todayDate = Util.generateRandomDate();
        System.assertNotEquals(NULL, todayDate, 'Date expected!');
        Test.stopTest();
    }

    static testMethod void generateRandomDateTest() {
        Test.startTest();
        Date todayDate = Util.generateRandomDate();
        Date randomDate = Util.generateRandomDate(todayDate);
        System.assertNotEquals(todayDate, randomDate, 'Different date expected!');
        Test.stopTest();
    }

    static testMethod void generateRandomDateTimeTodayTest() {
        Test.startTest();
        DateTime todayDateTime = Util.generateRandomDateTime();
        System.assertNotEquals(NULL, todayDateTime, 'Date time expected!');
        Test.stopTest();
    }

    static testMethod void generateRandomDateTimeTest() {
        Test.startTest();
        DateTime todayDateTime = Util.generateRandomDateTime();
        DateTime randomDateTime = Util.generateRandomDateTime(todayDateTime);
        //System.assertNotEquals(todayDateTime, randomDateTime, 'Different date time expected!');
        Test.stopTest();
    }
    
    static testMethod void generateCPFTest() {
        Test.startTest();
        String CPF = Util.generateCPF(TRUE);
        //System.assertNotEquals(CPF, NULL, 'Different value expected!');
        Test.stopTest();
    }
    
    static testMethod void generateCNPJTest() {
        Test.startTest();
        String CNPJ = Util.generateCNPJ(TRUE);
        //System.assertNotEquals(CNPJ, NULL, 'Different value expected!');
        Test.stopTest();
    }
}