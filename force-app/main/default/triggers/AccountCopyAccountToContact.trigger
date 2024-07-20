/**********************************************************************************
*                         Copyright 2012 - Cloud2b
***********************************************************************************
* Trigger responsável por replicar as informações de uma Conta para um Contato 
* relacionado.
*
* NAME: AccountCopyAccountToContact
* AUTHOR: MICHEL AQUINO                              DATE: 12/12/2012
*
* MAINTENANCE
* AUTHOR: ROGERIO ALVARENGA                          DATE: 21/12/2012
***********************************************************************************/

trigger AccountCopyAccountToContact on Account (after insert, after update) {
  
  List<String> stringListId = new List<String>();
  //Carlos Carvalho - Modification - 07/02/2013
  Id idRecTypeAcc = RecordTypeMemory.getRecType( 'Account', 'Academic_Account' );
  Id idRecTypeAccPF = RecordTypeMemory.getRecType( 'Account', 'Pessoa_F_sica' );
  //End Modification
  //system.debug('RT: ' + idRecTypeAccPF);
  for(Account account : trigger.new ){
    if((account.RecordTypeId == idRecTypeAcc || account.RecordTypeId == idRecTypeAccPF) && !Semaphore.hasExec( account.id, false ) ){
        //system.debug('Passou!');
      stringListId.add(account.id);
    }
  }
  
  if( stringListId.size() == 0 ) return;
  //Invoke Log Limits
  LogLimits.print('TRIGGER: AccountCopyAccountToContact - BEFORE SELECT CONTACT', false);
  
  List<Contact> lContactList = [Select AccountId,MobilePhone, LastName, FirstName, Email, BR_RG__c, 
   BR_Gender__c, BR_Contact_department__c, BR_Contact_Title__c, 
   BR_Contact_Birthdate__c, BR_CPF__c, BR_Area_code_cel__c, 
   BR_Area_code__c, BR_Allows_sms__c, BR_Allows_email_marketing__c, BR_Address_zip_code__c, 
   BR_Address_state__c, BR_Address_number__c, BR_Address_district__c, BR_Address_country__c, 
   BR_Address_complement__c, BR_Address_city__c, BR_Address__c, BR_Address_Sidewalk__c From Contact
   where AccountId =:stringListId and isDeleted=false];
   
  //Invoke Log Limits
  LogLimits.print('TRIGGER: AccountCopyAccountToContact - AFTER SELECT CONTACT', false);
  
  Map<String,Contact> lMap = new Map<String,Contact>();
   
  for(Contact lContact : lContactList){
    lMap.put(lContact.AccountId,lContact);
  }
   
  List<Contact> contactList = new List<Contact>();
   //Invoke Log Limits
  LogLimits.print('TRIGGER: AccountCopyAccountToContact - BEFORE FOR ACCOUNT', false);
  
  for(Account account : trigger.new ){
    if((account.RecordTypeId == idRecTypeAcc || account.RecordTypeId == idRecTypeAccPF)  && !Semaphore.hasExec( account.id, true ) )
    {
        Contact contact = lMap.get(account.id);
        if( contact == null || trigger.isInsert )
        {
            contact = new Contact();
            contact.AccountId = account.id;
        }
    
        Integer posInit = account.Name.indexOf(' ');
        if ( posInit < 0 )
        {
            posInit = 0;
            contact.FirstName = '';
        }
        else contact.FirstName = account.Name.substring(0, posInit);
        contact.LastName = account.Name.substring(posInit, account.Name.length());
        
        contact.BR_RG__c                           = account.BR_RG__c;
        contact.BR_CPF__c                          = account.BR_CPF__c;
        contact.BR_Gender__c                       = account.BR_Gender__c;
        contact.BR_Contact_Title__c                = account.BR_Title__c;
        contact.BR_Contact_department__c           = account.BR_Department__c;
        contact.BR_Area_code__c                    = account.BR_Area_code__c;
        contact.BR_Area_code_cel__c                = account.BR_Area_code_cel__c;
        contact.MobilePhone                        = account.BR_Mobile__c;
        contact.BR_Contact_Birthdate__c            = account.BR_Birthdate__c;
        contact.BR_Allows_sms__c                   = account.BR_Allows_sms__c;
        contact.BR_Allows_email_marketing__c       = account.BR_Allows_email_marketing__c;
        contact.Email                              = account.BR_Account_email__c;
        contact.BR_Address_Sidewalk__c             = account.BR_Main_Sidewalk__c;
        contact.BR_Address__c                      = account.BR_Main_Address__c;
        contact.BR_Address_number__c               = account.BR_Main_Nbr__c;
        contact.BR_Address_complement__c           = account.BR_Main_Complement__c;
        contact.BR_Address_district__c             = account.BR_Main_District__c;
        contact.BR_Address_city__c                 = account.BR_Main_City__c;
        contact.BR_Address_state__c                = account.BR_Main_State__c;
        contact.BR_Address_country__c              = account.BR_Main_Country__c;
        contact.BR_Address_zip_code__c             = account.BR_Main_Zip_code__c;     
        //Carlos Carvalho - Modification 07/02/2013
        contact.OtherPhone                         = account.BR_Other_phone__c;
        contact.Phone                              = account.Phone;
        contact.Fax                                = account.Fax;
        contact.BR_Approval_status__c              = account.BR_Approval_status__c;
        //End Modification
        
        //Marcos Aurélio - ID 19 - 11/01/2018
        //Sidney Ferreira Coutinho 28/01/2018 (substituição de BR_Bairro__c por BR_Main_Distric__c,
        //e desativar concatenação do campo account.BR_BillingAddressComplement__c e account.BR_Main_District pois já tem o complemento no billingstreet)
        contact.MailingStreet                       = account.BillingStreet /*+ ' ' + account.BR_BillingAddressComplement__c + ' ' + account.BR_Main_District__c*/;
        contact.MailingCity                         = account.BillingCity;
        contact.MailingState                        = account.BillingState;
        contact.MailingCountry                      = account.BillingCountry;
        contact.MailingPostalCode                   = account.BillingPostalCode;
        
      contact.ELT__c                             = account.ELT__c;
      contact.ELE__c                             = account.ELE__c;
      contact.Universitario__c                   = account.Universitario__c ;
        
        contactList.add(contact);
        }
    } 
  //Invoke Log Limits
  LogLimits.print('TRIGGER: AccountCopyAccountToContact - AFTER FOR ACCOUNT', false);
  
  if( contactList.size() > 0 )
    try
    {
        upsert contactList;
    }
    catch( Dmlexception e )
    {
        for ( Account account : trigger.new )
          account.addError( e.getDmlMessage( 0 ) );
    }
    
  
  //Invoke Log Limits
  LogLimits.print('TRIGGER: AccountCopyAccountToContact - AFTER UPSERT CONTACT', false); 
}