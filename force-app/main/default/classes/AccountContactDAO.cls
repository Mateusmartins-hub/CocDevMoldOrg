public class AccountContactDAO { 
	private static final AccountContactDAO instance = new AccountContactDAO ();
    
    private AccountContactDAO(){}
    
    public static AccountContactDAO getInstance(){
        return instance;
    }

    public static List< Account_Contact__c > getListAccountContact( List< String > aListIds ){
    	return [ SELECT Id, Contact__c, Account__c, BR_AcademicRole__c, BR_Friday_OfficeHours__c,
    	       BR_Monday_OfficeHours__c, BR_Thursday_OfficeHours__c, BR_Tuesday_OfficeHours__c, 
    	       BR_Wednesday_OfficeHours__c  FROM Account_Contact__c WHERE Id =: aListIds ];
    }
     
    public List<Account_Contact__c> getListAccountContactByAccountId( String accountId ) {
    	return [SELECT Id, Name, Contact__c, Contact__r.Name, Account__c, Contact__r.BR_CPF__c FROM Account_Contact__c
    				WHERE Account__c = :accountId 
    				AND BR_Inactive__c = false 
    				order by Contact__r.Name];
    }

    public List<Account_Contact__c> getListAccountContactByAccountIdAndContactName( String accountId, String contactNameOrCPF ) {
        return [SELECT Id, Name, Contact__c, Contact__r.Name, Account__c, Contact__r.BR_CPF__c FROM Account_Contact__c
                    WHERE Account__c = :accountId 
                    AND BR_Inactive__c = false
                    AND (Contact__r.Name LIKE : contactNameOrCPF OR Contact__r.BR_CPF__c LIKE : contactNameOrCPF) 
                    order by Contact__r.Name];
    }
    
    
    public List<Account_Contact__c> getListAccountContactByAccountIdRemoveContact( String accountId, List<String> contactToRemove ) {
    	return [SELECT Id, Name, Contact__c, Contact__r.Name, Account__c, Contact__r.BR_CPF__c FROM Account_Contact__c
    				WHERE Account__c = :accountId
    				AND Contact__c not in :contactToRemove 
    				AND BR_Inactive__c = false 
    				order by Contact__r.Name];
    }
    
    public List<Account_Contact__c> getListAccountContactByAccountIdAndContactNameRemoveContact( String accountId, String contactNameOrCPF, List<String> contactToRemove ) {
        return [SELECT Id, Name, Contact__c, Contact__r.Name, Account__c, Contact__r.BR_CPF__c FROM Account_Contact__c
                    WHERE Account__c = :accountId
                    AND Contact__c not in :contactToRemove 
                    AND BR_Inactive__c = false 
                    AND (Contact__r.Name LIKE : contactNameOrCPF OR Contact__r.BR_CPF__c LIKE : contactNameOrCPF)
                    order by Contact__r.Name];
    }

    public static List<Account_Contact__c> getAccountContactByAccountId(String accountId, List<String> lstLetrasIniciais)
    {
        return [ Select 
                    Id,
                    Name,
                    BR_AcademicRole__c,
                    Account__c,
                    Account__r.Name,
                    Contact__c,
                    Contact__r.Name,
                    Contact__r.BR_Address_Sidewalk__c,
                    Contact__r.BR_Address__c,
                    Contact__r.BR_Address_number__c,
                    Contact__r.BR_Address_complement__c,
                    Contact__r.BR_Address_district__c,
                    Contact__r.BR_Address_zip_code__c,
                    Contact__r.BR_Address_city__c,
                    Contact__r.BR_Address_state__c,
                    Contact__r.BR_Area_code__c,
                    Contact__r.Phone,
                    Contact__r.BR_Area_code_cel__c,
                    Contact__r.MobilePhone,
                    Contact__r.BR_RG__c,
                    Contact__r.BR_CPF__c,
                    Contact__r.Email,
                    Contact__r.AccountId,
                    Contact__r.Account.BR_Birthdate__c
                 From 
                    Account_Contact__c
                 Where 
                     Account__c =: accountId 
                 And Contact__r.Account.LetraInicialNome__c IN: lstLetrasIniciais   
                 And BR_Inactive__c = false
                 Order By Contact__r.Name   
                 ];
    }

    public static List<Account_Contact__c> getAccountContactByAccountId(String accountId, String contactId)
    {
        return [ Select 
                    Id,
                    Name,
                    BR_AcademicRole__c,
                    Account__c,
                    Account__r.Name,
                    Contact__c,
                    Contact__r.Name,
                    Contact__r.BR_Address_Sidewalk__c,
                    Contact__r.BR_Address__c,
                    Contact__r.BR_Address_number__c,
                    Contact__r.BR_Address_complement__c,
                    Contact__r.BR_Address_district__c,
                    Contact__r.BR_Address_zip_code__c,
                    Contact__r.BR_Address_city__c,
                    Contact__r.BR_Address_state__c,
                    Contact__r.BR_Area_code__c,
                    Contact__r.Phone,
                    Contact__r.BR_Area_code_cel__c,
                    Contact__r.MobilePhone,
                    Contact__r.BR_RG__c,
                    Contact__r.BR_CPF__c,
                    Contact__r.Email,
                    Contact__r.AccountId,
                    Contact__r.Account.BR_Birthdate__c
                From 
                    Account_Contact__c
                Where 
                    Account__c =: accountId 
                And Contact__c =: contactId    
                And BR_Inactive__c = false 
            ];
    }

    public static List<Account_Contact__c> getAccountContactByContactIds(Set<String> setContactIds)
    {
        return [ Select 
                    Id,
                    Name,
                    BR_AcademicRole__c,
                    Account__c,
                    Account__r.Name,
                    Account__r.BR_Account_Id_SSA__c,
                    Contact__c,
                    Contact__r.Name,
                    Contact__r.BR_Address_Sidewalk__c,
                    Contact__r.BR_Address__c,
                    Contact__r.BR_Address_number__c,
                    Contact__r.BR_Address_complement__c,
                    Contact__r.BR_Address_district__c,
                    Contact__r.BR_Address_zip_code__c,
                    Contact__r.BR_Address_city__c,
                    Contact__r.BR_Address_state__c,
                    Contact__r.BR_Area_code__c,
                    Contact__r.Phone,
                    Contact__r.BR_Area_code_cel__c,
                    Contact__r.MobilePhone,
                    Contact__r.BR_RG__c,
                    Contact__r.BR_CPF__c,
                    Contact__r.Email,
                    Contact__r.AccountId,
                    Contact__r.Account.BR_Birthdate__c,
                    Contact__r.Account.BR_Account_Id_SSA__c
                 From 
                    Account_Contact__c
                 Where 
                    Contact__c IN: setContactIds 
                    And BR_Inactive__c = false
                 Order By Contact__r.Name   
                 ];
    }

	public List<Account_Contact__c> getContatosIstituicao( String accountId ) {

		return [SELECT
				Id,
				Name,
				Email__c,
				Account__c,
				CPF__c,
				Contact__c,
				BR_Email__c,
				Contact__r.MailingStreet,
				Contact__r.MailingCity,
				Contact__r.MailingPostalCode,
				Contact__r.MailingState,
				Contact__r.MailingCountry,
				Contact__r.BR_Address__c,
				Contact__r.BR_Address_number__c,
				Contact__r.BR_Address_complement__c,
				Contact__r.BR_Address_district__c,
				Contact__r.BR_Address_city__c,
				Contact__r.BR_Address_zip_code__c,
				Contact__r.BR_Address_state__c,
				Contact__r.BR_Address_country__c
				FROM Account_Contact__c
				WHERE Account__c =: accountId];
	}
	public Account_Contact__c buscaContatos( String contatoID) {

	   Account_Contact__c contato = new Account_Contact__c();
	   //contato = [SELECT Id, Contact__c FROM Account_Contact__c WHERE Id =: contatoID];
        for(Account_Contact__c contTemp :  [SELECT Id, Contact__c FROM Account_Contact__c WHERE Id =: contatoID]){
            contato = contTemp;
        } 
	   return contato;

	 }

	public Account_Contact__c buscaContatosIstituicao( String contatoID) {

	   Account_Contact__c contato = new Account_Contact__c();
	   //contato = [SELECT Id, BR_QuantidadeRespondidaEmail__c FROM Account_Contact__c WHERE Id =: contatoID];
        for(Account_Contact__c contTemp : [SELECT Id, BR_QuantidadeRespondidaEmail__c FROM Account_Contact__c WHERE Id =: contatoID]){
            contato = contTemp;
        }
	   return contato;

	 }
}