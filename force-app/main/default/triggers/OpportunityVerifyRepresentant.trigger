trigger OpportunityVerifyRepresentant on Opportunity (before insert, before update) {
    
    List< String > listIdsUsers = new List< String >();
    List< User > listUser = new List< User >();
    List< String > listIdSAP = new List< String >();
    List< String > listIdSSA = new List< String >();
    Map< String, User > mapIdUser = new Map< String, User >();
    
    //Check which of the opportunities are fit for field value update and adds it and its OwnerId to listOpp and listIdsUsers lists
    for( Opportunity opp : Trigger.new ){
      listIdsUsers.add( opp.OwnerId );
    }
    
    listUser = UserDAO.getListUserByIdsUsers( listIdsUsers );
    
    for( User u : listUser ){
        if( u.BR_Account_ID_SAP__c != null ) listIdSAP.add( u.BR_Account_ID_SAP__c );
        if( u.BR_Account_ID_SSA__c != null ) listIdSSA.add( u.BR_Account_ID_SSA__c );
    }   

    for( Account acc : AccountDAO.getListAccountsByIdSAPIdSSA( listIdSAP, listIdSSA ) ){
        for( Opportunity opp : Trigger.new ){
            opp.BR_rep__c = acc.Id;
        }
        break;
    }
}