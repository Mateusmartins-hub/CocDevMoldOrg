/*******************************************************************************
*                     Copyright (C) 2012 - Cloud2b
*-------------------------------------------------------------------------------
* UPDATE THE QUANTITYOLD__C FIELD WITH OPPORTUNITYLINEITEM.QUANTITY OLD VALUE.  
* 
* NAME: OpportunityLineItemFillQuantityOld.trigger
* AUTHOR: CARLOS CARVALHO                            DATE: 06/02/2013
*******************************************************************************/
trigger OpportunityLineItemFillQuantityOld on OpportunityLineItem (before update) {
     
    //Invoke Log Limits
    LogLimits.print('TRIGGER: OpportunityLineItemFillQuantityOld - BEGIN CODE', false);
    
    for( OpportunityLineItem oli : trigger.new ){
        //VALIDATE IF THE Quantity WAS CHANGED
        if( oli.Quantity != Trigger.oldMap.get( oli.Id).Quantity ) 
           oli.QuantityOld__c = Trigger.oldMap.get( oli.Id ).Quantity;
    }
    
    //Invoke Log Limits
    LogLimits.print('TRIGGER: OpportunityLineItemFillQuantityOld - END CODE', false);
}