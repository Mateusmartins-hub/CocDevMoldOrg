/*******************************************************************************
*                     Copyright (C) 2013 - Cloud2b
*-------------------------------------------------------------------------------
*
* This trigger retrieves the IBGE Code from the object IBGE_Code__c, using the 
* fields UF_acronym__c and City_name__c of Account as parameters, and fills the
* Account's field IBGE_Code__c with the retrieved code.
*
* NAME: AccountFillIBGECode.trigger
* AUTHOR: MARCOS DOBROWOLSKI                        DATE: 2013/07/16
*
*******************************************************************************/

trigger AccountFillIBGECode on Account (before insert, before update) {

  // Sets to store the fields UF and City from the Account
  set<String> lstUF = new set<String>();
  set<String> lstCity = new set<String>();
  
  // Loops through the triggered itens, getting the UF and City names
  for ( Account acc : Trigger.new ) {
    lstUF.add( acc.BR_Main_State__c );
    lstCity.add( acc.BR_Main_City__c );
  }

  // Retrieves the IBGE Code from the object IBGE_Code__c, using the UF and City lists
  list<IBGE_Code__c> lstIBGECode = [ SELECT UF_acronym__c, City_name__c, Name FROM IBGE_Code__c 
                                     WHERE UF_acronym__c = :lstUF AND City_name__c = :lstCity ];

  // Map to store the IBGE Code, referred by a string formed by the concatenation of the fields UF_acronym__c and City_name__c   
  map<String, IBGE_Code__c> mapIBGE = new map<String, IBGE_Code__c>();
  
  // For each IBGE Code on the list, record on the map the object, with the concatenation of the fields 
  // UF_acronym__c and City_name__c as key
  for ( IBGE_Code__c ibgeCode : lstIBGECode ) {
    if ( ibgeCode.UF_acronym__c != null && ibgeCode.City_name__c != null ) {
      mapIBGE.put( ibgeCode.UF_acronym__c.toUpperCase() + ibgeCode.City_name__c.toUpperCase(), ibgeCode );
    }
  }
  
  // Retrieves the IBGE Code from the map and put it on the Account's IBGE_Code__c field 
  for ( Account acc : Trigger.new ) {
    IBGE_Code__c ibgeCode;
    if ( acc.BR_Main_State__c != null && acc.BR_Main_City__c != null ) {
      ibgeCode = mapIBGE.get( acc.BR_Main_State__c.toUpperCase() + acc.BR_Main_City__c.toUpperCase() );
    }
    if ( ibgeCode != null ) acc.IBGE_Code__c = ibgeCode.Id;
  } 

}