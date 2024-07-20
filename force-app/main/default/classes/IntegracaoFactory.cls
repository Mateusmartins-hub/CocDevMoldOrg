public with sharing class IntegracaoFactory {
	public static Object getConfPersonalizada(String confPersonalizada){
		InstanciaIntegracao__c instanceIntegracao = InstanciaIntegracao__c.getInstance(confPersonalizada);
		Type tipo = Type.forName(instanceIntegracao.NomeClasse__c);
		Object classeIntegracao = tipo.newInstance();
		return classeIntegracao;
	}
}