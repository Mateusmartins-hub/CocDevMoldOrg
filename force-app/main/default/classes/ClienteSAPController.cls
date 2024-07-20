global class ClienteSAPController {

    @AuraEnabled
    public static Boolean BuscarClienteSAP(String objectId) {
        List<Opportunity> opps = [SELECT Id, AccountId, RecordTypeId, StatusConsultaCliente__c FROM Opportunity WHERE Id = :objectId];
        
		if(opps.size() > 0)
            objectId = opps[0].AccountId;
        
        Account acc = [SELECT Id, BR_CNPJ_CPF__c, StatusConsultaCliente__c, BR_FI_Dividas_a_receber__c, BR_FI_Limite_de_credito_do_cliente__c, BR_Account_Id_SAP__c, BR_Integrate_to_SAP__c, BR_Integration_Status_SAP__c FROM Account WHERE Id = :objectId][0];

		/*if(acc.BR_Integrate_to_SAP__c)
			throw createAuraHandledException('Conta já integrada com o SAP');
*/
		if(String.isBlank(acc.BR_CNPJ_CPF__c))
			throw createAuraHandledException('Preencha o CNPJ para consultar o Cliente no SAP');
        
        Boolean temErro = ClienteSAPIntegration.getClientSAPAndUpdate(acc);
        
        return temErro;
	}
    
	private static AuraHandledException createAuraHandledException(String Message) {
		AuraHandledException e = new AuraHandledException(Message);
		e.setMessage(Message);
		return e;
	}

}