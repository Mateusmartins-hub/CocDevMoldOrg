public with sharing class RecordTypeDAO {
	private static RecordTypeDAO instance = new RecordTypeDAO();
	private static Map<String, List<RecordType>> cache = new Map<String, List<RecordType>>();
	private RecordTypeDAO() {
	}

	public static RecordTypeDAO getInstance(){
		return instance;
	}

	public List<RecordType> getRecordTypeByDeveloperName(List<String> lstRcTypeDevName){
		lstRcTypeDevName.sort();
		String keyCache = String.valueOf(lstRcTypeDevName);
		List<RecordType> lstReturn = cache.get(keyCache);
		if(lstReturn == null){
			lstReturn = [SELECT Id, Name, DeveloperName, SObjectType
						  FROM RecordType
						 WHERE DeveloperName IN: lstRcTypeDevName
						   AND IsActive = true];
			cache.put(keyCache, lstReturn);

		}
		return lstReturn;
	}

	public List<RecordType> getRecordTypeByObjectAndDeveloperName(List<String> lstObjectName, List<String> lstRcTypeDevName){
		lstRcTypeDevName.sort();
		String keyCache = String.valueOf(lstObjectName) + '_' + String.valueOf(lstRcTypeDevName);
		List<RecordType> lstReturn = cache.get(keyCache);
		if(lstReturn == null){
			lstReturn = [SELECT Id, Name, DeveloperName, SObjectType
						  FROM RecordType
						 WHERE DeveloperName IN: lstRcTypeDevName
						   AND SObjectType IN: lstObjectName
						   AND IsActive = true];
			cache.put(keyCache, lstReturn);

		}
		return lstReturn;
	}

	public List<RecordType> getRecordTypeByObject(List<String> lstObjectName){
		lstObjectName.sort();
		String keyCache = String.valueOf(lstObjectName);
		List<RecordType> lstReturn = cache.get(keyCache);
		if(lstReturn == null){
			lstReturn = [SELECT Id, Name, DeveloperName, SObjectType
						  FROM RecordType
						 WHERE SObjectType IN: lstObjectName
						   AND IsActive = true];
			cache.put(keyCache, lstReturn);

		}
		return lstReturn;
	}
}