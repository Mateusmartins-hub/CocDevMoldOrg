public with sharing class TaskDAO {
	private static final TaskDAO instance = new TaskDAO();

	private TaskDAO(){}

	public static TaskDAO getInstance(){
		return instance;
	}   
	
	public Task getTaskById(Id id){
		return [SELECT Id, 
						AccountId,
						Account.Name,
						Account.Marca__c, 
						WhatId,
						Who.Name, 
						Description, 
						Status 
				FROM Task 
				WHERE Id =: id];
	}
}