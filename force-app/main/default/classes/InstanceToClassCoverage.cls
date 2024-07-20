/*
Nome do Arquivo:                        InstanceToClassCoverage.cls
Empresa:                                Pearson
Desenvolvedor:                          Luiz Prandini
Descrição do Código:                    Classe que armazena os objetos para auxiliar nas classes de testes.

Histórico de Alterações:
Versão        Data              Responsável             Descrição da Alteração
1.0         29/10	/2014          Luiz Prandini           Criação da controller

*/

public with sharing class InstanceToClassCoverage {

	public static Adocoes_Cs__c createAdocao(){
		return new Adocoes_Cs__c(
			
		);
	} 
	
	public static Opportunity createOpp(){
		return new Opportunity(
			Name = 'PrandiniOpp',
			CloseDate = System.today(),
			BR_Request_Type__c 		= 'Prandini',
			BR_Shipping_Address__c 	= 'test',
			BR_shipping_type__c		= 'test',
			StageName				= 'Em elaboração'									
		);
	} 
	
	public static Contact createIndividuo(){
		return new Contact(
			LastName = 'Prandini',
			BR_CPF__c = '891.537.260-30'
						
		);
	} 
	
	public static Account createAccount(){
		return new Account(
			Name  				= 'PrandiniAccount',
			BR_Area_code__c 	= 11,
			BR_Area_code_cel__c	= 11,
			BR_Title__c 		= 'CEO',
			BR_Account_email__c = 'prandini@4kode.com.br',
			BR_Status__c		= 'teste',
			BR_Main_City__c		= 'teste',
			BR_Main_State__c	= 'teste',
			Phone				= '2324-4242'											
		);
	}
	
	public static Account_Contact__c createAccountContact(){
		return new Account_Contact__c(
			Name  				= 'PrandiniAccount'
											
		);
	} 
	
	
	
	public static Product2 createProduct2(){
		return new Product2(
			Description						= 'Teste',
			Family							= 'Teste',
			Name							= 'c3po',
			ProductCode						= 'c3po'
		);
	}
	
	
	
	
	
	public static    PricebookEntry createPricebookEntry()	{
		return new PricebookEntry(
			UseStandardPrice				= false,
			UnitPrice						= 23,
			IsActive						= true 
		);
	}
	
	public static Course_Structure_Discipline__c createCourse(){ 
		return new Course_Structure_Discipline__c(
			Name = 'Teste'
		);
	}
	
	public static Account_Segmentation__c createAccountSeg(){ 
		return new Account_Segmentation__c(
			
		);
	}
	
	
}