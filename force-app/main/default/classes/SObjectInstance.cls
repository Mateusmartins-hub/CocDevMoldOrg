/*******************************************************************************
*                     Copyright (C) 2012 - Cloud2b
*-------------------------------------------------------------------------------
* Class responsible for assisting in the creation of objects.
* 
* NAME: SObjectInstance.trigger
* AUTHOR: CARLOS CARVALHO                            DATE: 05/02/2013
*******************************************************************************/
public class SObjectInstance {
    
    static {
    	Database.insert( getIBGECode() );
    }
    
    //METHOD FOR TEST
    public static void setTestClass(){
        
        getAccount( null );
        getProfile( 'teste', 'test' );
        getUser( 'teste@3344.com', 'teste@3344.com', null );
        getOpportunity(null, null);
        getProduct2(null);
        getPricebook2(true);
        getCustomPricebook2();
        getPricebookEntry(null, null);
        getOpportunityLineItem(null, null, false);
        getAccountSegmentation( null, null );
        getAccountContact( null, null );
        getContact( null );
        getQuota(null, null, null);
        getAuditoria( null, null );
    }
    
    //Return a Contact Object
    //@aIdAccount (Account Id)
    public static Contact getContact( String aIdAccount ){
        
        //Create a new Contact
        Contact con = new Contact();
        con.FirstName = 'Name';
        con.LastName = 'Last';
        con.AccountId = aIdAccount;
        
        return con;
    }
    
    //Return an Account Object
    //@aRecType (RecordType Id)
    public static Account getAccount( String aRecType ){
        
        //Create a new Account
        Account acc = new Account();
        acc.Name = 'teste teste';
        acc.BR_Title__c = 'Autor';
        acc.BR_Main_Sidewalk__c = 'Aeroporto';
        acc.RecordTypeId = aRecType;
        acc.BR_Account_Id_SAP__c = '1';
        acc.BR_Account_Id_SSA__c = '2';
        acc.BR_Main_City__c = 'São Paulo';
        acc.BR_Main_State__c = 'SP';
        
        return acc;
    }
    
    //Return a Profile Object by select
    //@aProfileName (Profile name in english)
    //@aNomePerfil (Profile name in portuguese)
    public static Profile getProfile( String aProfileName, String aNomePerfil ){
        Profile profile;
        //Get id administrator profile
        try{
            profile = [Select Id From Profile Where Name =: aNomePerfil OR Name =: aProfileName ];
        }catch(QueryException e){
            System.debug(e.getMessage());
        }
        return profile;
    }
    
    //Return an User Object
    //@aUserEmail (User Email)
    //@aUserName (User Name)
    //@aIdProfile (Profile Id)
    public static User getUser( String aUserEmail, String aUserName, String aIdProfile ){
        
        //Create a new user
        User user = new User();
        user.FirstName       = 'Name';
        user.LastName      = 'LastName';
        user.Alias       = 'NLast34';
        user.Email         = aUserEmail;
        user.Username      = aUserName;
        user.CommunityNickname   = '123Test';
        user.EmailEncodingKey  = 'ISO-8859-1';
        user.TimeZoneSidKey    = 'GMT';
        user.LocaleSidKey    = 'en_Us';
        user.LanguageLocaleKey = 'en_Us';
        user.ProfileId       = aIdProfile;
        user.Country = 'BR';
        user.BR_Account_ID_SAP__c = '1';
        user.BR_Account_ID_SSA__c = '2';
        
        return user;
    }
    
    //Return an Oppotunity object
    //@aIdAccount (Account Id)
    //@aRecType (RecordType Id of Opportunity)
    public static Opportunity getOpportunity( String aIdAccount, String aRecType ){
        
        //Create a new opportunity
        Opportunity opp = new Opportunity();
        opp.AccountId = aIdAccount;
        opp.RecordTypeId = aRecType;
        opp.BR_shipping_type__c = 'Correio';
        opp.BR_Shipping_Address__c = 'Residencial';
        opp.Name = 'Teste';
        opp.StageName = 'Elaboração';
        opp.CloseDate = System.today()+5;
        
        return opp;
    }
    
    //Return a Product2 object
    //@aRecType (RecordType Id of Product2)
    public static Product2 getProduct2( String aRecType ){ 
        
        //Create a new product
        Product2 prod = new Product2();
        prod.Name = 'Cloud2b';
        prod.IsActive = true;
        prod.RecordTypeId = aRecType;
        
        return prod;
    }
    
    //Get a Pricebook2 object by select
    //@aIsStandard (Sets if profile is standard or custom)
    public static Pricebook2 getPricebook2( Boolean aIsStandard ){    
        
        //Get Pricebook
        Pricebook2 standardPB = [Select Id From Pricebook2 Where isStandard =: aIsStandard];
        
        return standardPB;
    }
    
    //Return a Pricebook2 object
    public static Pricebook2 getCustomPricebook2(){
        
        //Create a new pricebook
        Pricebook2 customPB = new Pricebook2();
        customPB.Name = '1';
        customPB.Description = '1';
        customPB.isActive = true;
        
        return customPB;
    }
    
    //Return a PricebookEntry object
    //@aIdPricebook (Pricebook Id)
    //@aIdProduct (Product2 Id)
    public static PricebookEntry getPricebookEntry( String aIdPricebook, String aIdProduct ){
        
        //create a new Pricebookentry for Standard Pricebook
        PricebookEntry pbe = new PricebookEntry();
        pbe.Product2Id = aIdProduct;
        pbe.UnitPrice = 12;
        pbe.Pricebook2Id = aIdPricebook;
        pbe.IsActive =true;
        pbe.UseStandardPrice = false;
        
        return pbe;
    }
    
    //Return a OpportunityLineItem Object
    //@aIdPricebookEntry (PricebookEntry Id)
    //@aIdOpp (Opportunity Id)
    //@aIsUpdateQuota (Defines if the quota can be updated)
    public static OpportunityLineItem getOpportunityLineItem( String aIdPricebookEntry, String aIdOpp,
         Boolean aIsUpdateQuota){        
        
        //Crerate a new OpportunityLineItem
        OpportunityLineItem oli = new OpportunityLineItem();
        oli.PricebookEntryId = aIdPricebookEntry;
        oli.Quantity = 5;
        oli.OpportunityId = aIdOpp;
        oli.TotalPrice = 4;
        oli.BR_Update_quota__c = aIsUpdateQuota;
        
        return oli;
    }
    
    //Return an Account Segmentation object
    //@aIdAccount (Account ID)
    //@aRecType (Account recordtype id)
    public static Account_Segmentation__c getAccountSegmentation( String aIdAccount, String aRecType ){
        
        //Crerate a new Account Segmentation
        Account_Segmentation__c aseg = new Account_Segmentation__c();
        aseg.Account__c = aIdAccount;
        aseg.RecordTypeId = aRecType;
        
        return aseg;
    }
    
    //Return an Account Contact object
    //@aIdContact (Contact Id)
    //@aIdAccount (Account Id)
    public static Account_Contact__c getAccountContact( String aIdContact, String aIdAccount ){
        
        //Crerate a new Account Contact
        Account_Contact__c acon = new Account_Contact__c();
        acon.Account__c = aIdAccount;
        acon.Contact__c = aIdContact;
        
        return acon;
    }
    
    //Return a quota object
    //@aIdRecType (Quota Recordtype id)]
    //@aIdRep (Representant (account) ID )
    //@aIdProduct (Product2 ID )
    public static Quota__c getQuota( String aIdRecType, String aIdRep, String aIdProduct ){
        
        //Crerate a new Account Contact
        Quota__c quota = new Quota__c();
        quota.BR_Rep__c = ( aIdRep != null ) ? aIdRep : null;
        quota.BR_Product__c = ( aIdProduct != null ) ? aIdProduct : null;
        quota.RecordTypeId = aIdRecType;
        
        return quota;
    }
    
    //Return a quota object
    //@aIdRecType (Auditoria__c Recordtype id)]
    //@aIdAccount (Account ID )
    public static Auditoria__c getAuditoria( String aIdAccount, String aIdRecType ){
      
      //Create a new Auditoria__c
      Auditoria__c aud = new Auditoria__c();
      aud.BR_account__c = aIdAccount;
      aud.RecordTypeId = aIdRecType;
      
      return aud;
    }
    
    //Return an IBGE Code object. By default, with 'São Paulo' as City and 'SP' as UF.
    public static IBGE_Code__c getIBGECode () {
    	return new IBGE_Code__c (
        City_name__c = 'São Paulo',
        UF_acronym__c = 'SP',
        Name = '3550308'
    	);
    }
    
}