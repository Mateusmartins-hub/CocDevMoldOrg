@isTest
private class RecordTypeDAOTest {
    
    @isTest 
    static void test_method(){
        
        List<String> lstObj = new List<String>();
        lstObj.add('Case');
        
        List<RecordType> lstRecordTypeByObject = RecordTypeDAO.getInstance().getRecordTypeByObject(lstObj);
        List<RecordType> lstRecordTypeByObjectAndDeveloperName = RecordTypeDAO.getInstance().getRecordTypeByObjectAndDeveloperName(lstObj, new List<String>{lstRecordTypeByObject[0].DeveloperName} );
        List<RecordType> lstRecordTypeByDeveloperName = RecordTypeDAO.getInstance().getRecordTypeByDeveloperName(new List<String>{lstRecordTypeByObject[0].DeveloperName});
        
    }

}