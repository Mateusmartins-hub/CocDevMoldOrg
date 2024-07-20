public class AccountDAO 
{
    public static List<Account> getListAccountsByIdSAPIdSSA(List<String> aListIdsSAP, List<String> aListIdsSSA)
    {    
        return [SELECT Id, BR_Account_ID_SAP__c, BR_Account_ID_SSA__c
                FROM Account
                WHERE BR_Account_ID_SAP__c =: aListIdsSAP 
                OR BR_Account_ID_SSA__c =: aListIdsSSA];
    }

    public static Database.QueryLocator listarContaExcluir(String query) {

        return Database.getQueryLocator(query);
    }

    public static Account buscaConta(String accId)
    {
    	return [SELECT Id, name, RecordTypeId, Marca__c, BR_Account_ID_SAP__c, BR_Account_ID_SSA__c, BR_Account_email__c, Owner.Name, Owner.Email, Website, BR_Telefone2__c, Phone, BR_Main_Country__c, BR_Main_State__c, Description, BR_Main_City__c,
                       SistemaEnsino__c, (SELECT Id, Email FROM Contacts ORDER BY CreatedDate ASC)
               FROM Account
               WHERE Id =: accId];
    }

    public static List<Account> buscaContas(Set<id> idsContas)
    {
        return [SELECT Id, Name, BillingStreet, RecordTypeId, Phone, BR_Telefone2__c, BR_CNPJ__c, Marca__c,
                       BR_CPF__c, BR_DomicilioFiscal__c, BR_RG__c, BillingState, CreatedDate, BR_Account_ID_SAP__c,
                       CreatedBy.Name, BR_EquipeVendas__c, BR_EscritorioVendas__c, BillingCity, BR_Account_ID_SSA__c,
                       BR_Account_email__c, RecordType.Name,  BillingCountry, BillingPostalCode
                  FROM Account
                 WHERE Id IN: idsContas];
    }

    public static Database.QueryLocator buscarContasErroIntegracao()
    {
        return Database.getQueryLocator(' SELECT Id, Name, BillingStreet, Phone, BR_Telefone2__c, BR_CNPJ__c,             ' +
                                        '        BR_CPF__c, BR_DomicilioFiscal__c, BR_RG__c, BillingState, CreatedDate,   ' +
                                        '        CreatedBy.Name, BR_EquipeVendas__c, BR_EscritorioVendas__c, BillingCity, ' +
                                        '        BR_Account_email__c, RecordType.Name,  BillingCountry, BillingPostalCode ' +
                                        '   FROM Account                                                                  ' +
                                        '  WHERE BR_ErroIntegracao__c = true');
    }
}