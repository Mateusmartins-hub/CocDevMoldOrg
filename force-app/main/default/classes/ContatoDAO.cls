public with sharing class ContatoDAO {
	
	public static List<Contact> getListContactById(String idContact){
		return[Select Id, BR_CPF__c From Contact Where Id=:idContact];
	}

	public static List<Contact> getEmailListContactById(String id){
		return[Select Id, Name, Email From Contact Where Id=:id];
	}

	public static Contact buscaContato(String ContatoId){
		Contact contato = new Contact();
		//contato = [Select Name From Contact Where Id =: ContatoId];
        for(Contact contTemp : [Select Name From Contact Where Id =: ContatoId]){
          contato = contTemp;  
        }
		return contato; 
	}

	public static Contact buscaEmail(String ContatoId){
		Contact contato = new Contact();
		//contato = [Select Name, Email From Contact Where Id =: ContatoId];
        for(Contact contTemp : [Select Name, Email From Contact Where Id =: ContatoId]){
          contato = contTemp;  
        }
		return contato; 
	}
	
}