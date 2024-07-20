public with sharing class ProcessInstanceDAO {
    public static List<ProcessInstance> getApprovedProcessById(Set<Id> Ids) {
		return [SELECT TargetObjectID FROM ProcessInstance WHERE TargetObjectID IN :Ids AND Status = 'Approved'];
	}
}