/*******************************************************************************
*                     Copyright (C) 2012 - Cloud2b
*-------------------------------------------------------------------------------
* Update the BR_Approver1__c and BR_Approver2__c with Owner.ManagerId and 
* Owner.Manager.ManagerId respectively.
* 
* NAME: OpportunityUpdateApprovers.cls
* AUTHOR: CARLOS CARVALHO                            DATE: 18/02/2013
*******************************************************************************/
trigger OpportunityUpdateApprovers on Opportunity (before insert, before update) {
    
    //Variables declaration
    List< String > listIdsOwner = new List< String >();
    List< User > listManagers = new List< User >();
    Map< String, User > mapUsers = new Map< String, User >();
    
    for( Opportunity opp : trigger.new ){
        listIdsOwner.add( opp.OwnerId );
    }
    
    //Validate if there're Ids inside of opportunity owner inside list
    //If doesn't stop the code
    if( listIdsOwner.size() == 0 ) return;
    
    for( User u : UserDAO.getListUserByIdsUsers( listIdsOwner ) ){
        //Create a MAP (KEY= User Id and VALUE=User object)
        mapUsers.put( u.Id, u );
    }
    
    for( Opportunity opp : trigger.new ){
        //Get the user inside map by Opportunity Owner Id
        User lUser = mapUsers.get( opp.OwnerId );
        
        //Validate if ManagerId field contain value
        if( opp.BR_OportunidadeReadocao__c == null ){
            if( lUser.ManagerId == null){
               //Show a message error
               opp.addError( 'Esse usuário não possui aprovador designado. Favor consultar seu gestor.' );
            }else{
                //Fill BR_Approver1__c field with Manager Opportunity Owner
            opp.BR_Approver1__c = lUser.ManagerId;
            }
        }else{
            break;
        }
        
        //Validate if ManagerId field contain value
        if( lUser.Manager.ManagerId != null ){
            //Fill BR_Approver2__c field with Manager of Manager Opportunity Owner
        opp.BR_Approver2__c = lUser.Manager.ManagerId;
        }
    }
}