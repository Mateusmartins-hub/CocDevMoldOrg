/*******************************************************************************
*                     Copyright (C) 2012 - Cloud2b
*-------------------------------------------------------------------------------
* UPDATE THE BR_Contact__c FIELD WITH BR_Account_Contact__r.Contact__c.  
* 
* NAME: OpportunityUpdateContact.trigger
* AUTHOR: CARLOS CARVALHO                            DATE: 08/02/2013
*******************************************************************************/
trigger OpportunityUpdateContact on Opportunity (before insert, before update) {
    
    //Invoke Log Limits
    LogLimits.print('TRIGGER: OpportunityUpdateContact - BEGIN CODE', false);
    
    //Declaration variables
    List< String > listIdsAccCon = new List< String >();
    List< Opportunity > listOpp = new List< Opportunity >();
    Map< String, Account_Contact__c > mapAccCon = new Map< String, Account_Contact__c >();
    
    for( Opportunity opp : trigger.new ){
        //Validate if BR_Account_Contact__c field on opportunity it's fill
        if( opp.BR_Account_Contact__c != null ){
            //Put Account_Contact__c Id inside list
            listIdsAccCon.add( opp.BR_Account_Contact__c );
            //Put the opportunity object inside list
            listOpp.add( opp );
        }
    }
    
    //Invoke Log Limits
    LogLimits.print('TRIGGER: OpportunityUpdateContact - AFTER FOR Opportunity', false);
    system.debug('listIdsAccCon ' + listIdsAccCon);
    //Cet all Account_Contact__c by Id in the list (listIdsAccCon)
    for( Account_Contact__c acon : AccountContactDAO.getListAccountContact( listIdsAccCon )){
        //Create map (KEY=Account Id and VALUE=Account_Contact__c object)
        mapAccCon.put( acon.Id, acon );
        system.debug('acon.Id ' + acon.Id);
    }
    
    //Invoke Log Limits
    LogLimits.print('TRIGGER: OpportunityUpdateContact - AFTER FOR Account_Contact__c WITH SELECT', false);
    
    for( Opportunity opp : listOpp ){
        system.debug('opp.BR_Account_Contact__c  ' + opp.BR_Account_Contact__c );
        //Get the Account_Contact__c object by BR_Account_Contact__c field on opportunity
        Account_Contact__c lAccCon = mapAccCon.get( opp.BR_Account_Contact__c );
        
        //validate if the field is fill
        if(lAccCon == null) continue;
        
        if( lAccCon.Contact__c == null ) continue;
        
        //Update BR_Contact__c field value
        system.debug('lAccCon.Contact__c ' + lAccCon.Contact__c);
        opp.BR_Contact__c = lAccCon.Contact__c;
    }
    
    //Invoke Log Limits
    LogLimits.print('TRIGGER: OpportunityUpdateContact - END CODE', false);
}