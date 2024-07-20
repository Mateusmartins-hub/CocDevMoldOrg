/*******************************************************************************
*                     Copyright (C) 2012 - Cloud2b
*-------------------------------------------------------------------------------
* Update the stock value on STOCK object if the field BR_Stock_Update__c equals 
* TRUE and following recordtypes: Sample_Order_University, Sample_Order_Languages
* and Sample_Order_Transit_Stock_Withdraw.
* 
* NAME: OpportunityUpdateStock.trigger
* AUTHOR: CARLOS CARVALHO                            DATE: 14/02/2013
*******************************************************************************/
trigger OpportunityUpdateStock on Opportunity (before insert, before update) {
    
    //Invoke Log Limits
    LogLimits.print('TRIGGER: OpportunityUpdateStock - BEGIN CODE', false);
    
    //Variables declaration
    Id idRecTypeSOTSW;
    List< String > listIdsOpp = new List< String >();
    List< String > listIdsRep = new List< String >();
    List< OpportunityLineItem > listOli= new List< OpportunityLineItem >();
    List< OpportunityLineItem > listOliToUpdate= new List< OpportunityLineItem >();
    List< Stock__c > listStockToInsert = new List< Stock__c >();
    List< Stock__c > listStockToUpdate = new List< Stock__c >();
    List< String > listIdsProd = new List< String >();
    Map< String, Stock__c > mapStock = new Map< String, Stock__c >();
    Map< String, OpportunityLineItem > mapOli = new Map< String, OpportunityLineItem >();
    
    //Get RecordTypeId of Opportunity
    idRecTypeSOTSW = RecordTypeMemory.getRecType( 'Opportunity', 'Sample_Order_Transit_Stock_Withdraw' );
    for( Opportunity opp : trigger.new ){
        //Validate if BR_Stock_Update__c  equals TRUE AND BR_rep__c not equals null
        //AND recordtypeId in setRecTypeOpp OR equals idRecTypeSOTSW
        if( opp.BR_Stock_Update__c ){
            //Validate if trigger is Insert
            if( Trigger.isInsert ){
                //Put opportunity Id inside list
                listIdsOpp.add( opp.Id );
                //Put Repsentant (Account) ID inside list
                listIdsRep.add( opp.BR_rep__c );
                //set BR_Stock_Update__c field equals FALSE, again
                opp.BR_Stock_Update__c = false;
            //Validate if trigger is Update and old value of BR_Stock_Update__c not TRUE
            }else if( Trigger.isUpdate && !Trigger.oldMap.get( opp.Id ).BR_Stock_Update__c ){
                listIdsOpp.add( opp.Id );
                //Put Repsentant (Account) ID inside list
                listIdsRep.add( opp.BR_rep__c );
                //set BR_Stock_Update__c field equals FALSE, again
                opp.BR_Stock_Update__c = false;
            }
        }
    }
    
    //Validate if there're opportunity ids inside list and stop this code case listIdsOpp is empty
    if( listIdsOpp.size() == 0 ) return;
    
    //Invoke Log Limits
    LogLimits.print('TRIGGER: OpportunityUpdateStock - BEFORE FOR OpportunityLineItem', false);
    
    //Scroll through all OpportunityLineItem that return from select
    //Get all OpportunityLineItem by ids opportunity
    for( OpportunityLineItem oli : OpportunityLineItemDAO.getListOliByIdsOpp( listIdsOpp )){
        //Put Product2 Id inside list
        listIdsProd.add( oli.PricebookEntry.Product2Id );
        //Create a map (Key=PricebookEntry.Product2Id more Opportunity.BR_rep__c and VALUE= opportunitylineitem object)
        mapOli.put( oli.PricebookEntry.Product2Id +' '+ oli.Opportunity.BR_rep__c, oli );
        listOli.add( oli );
    }
    
    //Invoke Log Limits
    LogLimits.print('TRIGGER: OpportunityUpdateStock - BEFORE FOR Stock__c WITH SELECT', false);
    
    //Scroll through the list returned, Get all Stocks object where BR_Product__c inside listIdsProd
    //and BR_representante__c inside listIdsRep
    for( Stock__c s : StockDAO.getListStockBy( listIdsProd, listIdsRep) ){
        //Create a map (Key=BR_Product__c more BR_representante__c and VALUE= Stock object)
        mapStock.put( s.BR_Product__c +' '+s.BR_representante__c, s );
    }
    
    //Invoke Log Limits
    LogLimits.print('TRIGGER: OpportunityUpdateStock - BEFORE FOR OpportunityLineItem', false);

    for( OpportunityLineItem oli : listOli ){
        //Get Stock__c object
        Stock__c lStock = mapStock.get( oli.PricebookEntry.Product2Id +' '+ oli.Opportunity.BR_rep__c );
        
        //Validate if lStock equals null and create a new Stock
        if( lStock == null ){
            lStock = new Stock__c();
            lStock.BR_Product__c = oli.PricebookEntry.Product2Id;
            lStock.BR_representante__c = oli.Opportunity.BR_rep__c;
            lStock.BR_Quantidade__c = 0;
            listStockToInsert.add( lStock );
        }
    }

    //Validate if there're some Stock object to create 
    if( listStockToInsert.size() > 0 ) insert listStockToInsert;
    
    //Scroll through the list objects was created
    for( Stock__c s : listStockToInsert ){
        //Create a map (Key=BR_Product__c more BR_representante__c and VALUE= Stock object)
        mapStock.put( s.BR_Product__c +' '+s.BR_representante__c, s );
        
    }

    for( OpportunityLineItem oli : listOli ){
        //Get Stock__c object
        Stock__c lStock = mapStock.get( oli.PricebookEntry.Product2Id +' '+ oli.Opportunity.BR_rep__c );
        
        //update the BR_Stock__c field with Stock ID
        oli.BR_Stock__c = lStock.Id;
        
        //Validate if recordtype equals idRecTypeSOTSW
      //In this case the value is subtracted the quantity value
        if( oli.Opportunity.RecordTypeId == idRecTypeSOTSW )
        lStock.BR_Quantidade__c = lStock.BR_Quantidade__c - oli.Quantity;
        else lStock.BR_Quantidade__c = lStock.BR_Quantidade__c + oli.Quantity;
        
        //Put Opportunitylineitem record inside of the list
        listOliToUpdate.add( oli );
        //Put Opportunitylineitem record inside of the list
        listStockToUpdate.add( lStock );
    }
    
    //Invoke Log Limits
    LogLimits.print('TRIGGER: OpportunityUpdateStock - BEFORE UPDATES', false);
    
    //VALIDATE IF THE listOliToUpdate LIST CONTAIN OpportunityLineItem RECORDS TO UPDATE
    if( listOliToUpdate.size() > 0 ) update listOliToUpdate;
    //VALIDATE IF THE listStockToUpdate LIST CONTAIN Stock__c RECORDS TO UPDATE
    if( listStockToUpdate.size() > 0 ) update listStockToUpdate;
    
    //Invoke Log Limits
    LogLimits.print('TRIGGER: OpportunityUpdateStock - END CODE', false);
}