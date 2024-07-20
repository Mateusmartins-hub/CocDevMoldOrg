/*******************************************************************************
*                     Copyright (C) 2012 - Cloud2b
*-------------------------------------------------------------------------------
* WHEN AN OpportunityLineItem WAS CREATED THE BR_Quota__c FIELD IS COMPLETED WITH THE 
* QUOTA__C ID WHERE THE OPPORTUNITY.BR_rep__c EQUALS QUOTA__C.BR_rep__c AND THE 
* FIELD BR_Current_Year__c ON QUOTA__C EQUALS CURRENT YEAR.
* 
* NAME: OpportunityVerifyQuota.trigger
* AUTHOR: CARLOS CARVALHO                            DATE: 01/02/2013
*******************************************************************************/
trigger OpportunityLineItemVerifyQuota on OpportunityLineItem (before insert,before update) {
    /* 
    //Invoke Log Limits
    LogLimits.print('TRIGGER: OpportunityLineItemVerifyQuota - BEGIN CODE', false);
    
    map<String, Id> mapRecTypeQuote = new map<String, Id>();
    mapRecTypeQuote.put('IDIOMAS', RecordTypeMemory.getRecType('Quota__c', 'Idiomas'));
    mapRecTypeQuote.put('UNIVERSITARIO', RecordTypeMemory.getRecType('Quota__c', 'Idiomas_Universit_rio'));
    mapRecTypeQuote.put('SISTEMAS', RecordTypeMemory.getRecType('Quota__c', 'Sistemas'));
    
    //Variables declaration
    Set< String > setRecTypeOpp = new Set< String >();
    List< String > listIdOpp = new List< String >();
    Map< String, Opportunity > mapOpp = new Map< String, Opportunity >();
    Map< String, String > mapPBE = new Map< String, String >();
    Map< String, Quota__c > mapQuota = new Map< String, Quota__c >();
    List< String > listIdsPBE = new List< String >();
    List< String > listIdsProduct = new List< String >();
    List< OpportunityLineItem > listOli = new List< OpportunityLineItem >();
    String currentYear = String.valueOf( System.today().year() );
    List< OpportunityLineItem > listOliToInsertQuota = new List< OpportunityLineItem >();
    List< Quota__c > listQuotaToInsert = new List< Quota__c >();
    
    //Get RecordTypeId of Opportunity
    setRecTypeOpp.add( RecordTypeMemory.getRecType('Opportunity', 'Sample_Order_COC'));
    setRecTypeOpp.add( RecordTypeMemory.getRecType('Opportunity', 'Sample_Order_Dom_Bosco'));
    setRecTypeOpp.add( RecordTypeMemory.getRecType('Opportunity', 'Sample_Order_NAME'));
    setRecTypeOpp.add( RecordTypeMemory.getRecType('Opportunity', 'Sample_Order_Pueri_Domus'));
    setRecTypeOpp.add( RecordTypeMemory.getRecType('Opportunity', 'Sample_Order_University'));
    setRecTypeOpp.add( RecordTypeMemory.getRecType('Opportunity', 'Sample_Order_Languages'));
    
    
    //Invoke Log Limits
    LogLimits.print('TRIGGER: OpportunityLineItemVerifyQuota - BEFORE FOR OpportunityLineItem', false);
    
    for( OpportunityLineItem oli : trigger.new ){
        //Include the OpportunityId inside the list
        listIdOpp.add( oli.OpportunityId );
        //Include the PricebookEntryId inside the list
        listIdsPBE.add( oli.PricebookEntryId );
        oli.ExclusiveOpportProd__c = null;
    }
    
    //Invoke Log Limits
    LogLimits.print('TRIGGER: OpportunityLineItemVerifyQuota - BEFORE FOR Opportunity WITH SELECT', false);
    
    for( Opportunity opp : OpportunityDAO.getListOppById( listIdOpp, setRecTypeOpp ) ){
        //Create a map( KEY= Opportunity ID / Value = Opportunity Object)
        mapOpp.put( opp.Id, opp );
    }
    
    //Invoke Log Limits
    LogLimits.print('TRIGGER: OpportunityLineItemVerifyQuota - BEFORE FOR PricebookEntry WITH SELECT', false);
    
    for( PricebookEntry pbe : PricebookEntryDAO.getListPricebookEntryById( listIdsPBE )){
        //Create a map( KEY= Pricebookentry ID / Value = Product2 Id)
        mapPBE.put( pbe.Id, pbe.Product2.Id );
        //Include the ProductId inside the list
        listIdsProduct.add( pbe.Product2.Id );
    }
    
    //Invoke Log Limits
    LogLimits.print('TRIGGER: OpportunityLineItemVerifyQuota - BEFORE FOR Quota__c WITH SELECT', false);
    
    for( Quota__c q : QuotaDAO.getListQuotaByIdProductCurrentYear( listIdsProduct, currentYear )){
        //Create a map( KEY= Product ID / Value = Quota__c Object)
        mapQuota.put( q.BR_Product__c, q );
    }
    
    //Invoke Log Limits
    LogLimits.print('TRIGGER: OpportunityLineItemVerifyQuota - BEFORE FOR OpportunityLineItem', false);
    
    for( OpportunityLineItem oli : trigger.new ){
        String strLine;
        //Get the Opportunity object
        Opportunity lOpp = mapOpp.get( oli.OpportunityId );
        if( lOpp == null ) continue;
      
      if( lOpp.BR_rep__r.Business_Line__c != null && lOpp.BR_rep__r.Business_Line__c != 'IDIOMAS' &&
          lOpp.BR_rep__r.Business_Line__c != 'UNIVERSITÁRIO' ) strLine = 'SISTEMAS';
      else strLine = lOpp.BR_rep__r.Business_Line__c;
      
      //Get the Product2 Id
        String lProd = mapPBE.get( oli.PricebookEntryId );
        if( lProd == null ) continue;
        
        //Get the Quota__c object
        Quota__c lQuota = mapQuota.get( lProd );
        
        //If lQuota equals NULL Will be created a new Quota__c
        if( lQuota == null ) {
            
            if(strLine == 'UNIVERSITÁRIO') strLine = 'UNIVERSITARIO';
            
            lQuota = new Quota__c();
            lQuota.BR_Active__c = true;
            lQuota.BR_Current_Year__c = currentYear;
            lQuota.BR_Product__c = lProd;
            lQuota.OwnerId = lOpp.OwnerId;
            //if ( lOpp.BR_rep__c != null ) lQuota.OwnerId = lOpp.BR_rep__c;
            lQuota.RecordTypeId = mapRecTypeQuote.get(strLine);
            //Include the OpportunityLineItem Object inside the list
            listOliToInsertQuota.add( oli );
            //Include the Quota__c Object inside the list
            listQuotaToInsert.add( lQuota );
        }else{
            //Update BR_Quota__c field value
            oli.BR_Quota__c = lQuota.Id;
        }
    }
    
    //Invoke Log Limits
    LogLimits.print('TRIGGER: OpportunityLineItemVerifyQuota - AFTER FOR OpportunityLineItem', false);
    */
    //*****************************************************************************************//
    //**************** THIS STEP ONLY ESCUTE FOR PRODUCTS WITHOUT QUOTA__C ********************//
    //*****************************************************************************************//
    
    //VALIDATE IF THERE ARE QUOTA__C TO CREATE
    
    /*
    if( listQuotaToInsert.size() > 0 ){
        //INSERT THE NEW QUOTAS
        insert listQuotaToInsert;
        
        for( Quota__c q : listQuotaToInsert ){
            //Create a map( KEY= Product ID / Value = Quota__c Object)
            mapQuota.put( q.BR_Product__c, q );
        }
        
        for( OpportunityLineItem oli : listOliToInsertQuota ){
            //Get the Opportunity object
            Opportunity lOpp = mapOpp.get( oli.OpportunityId );
            if( lOpp == null ) continue;
           
            //Get the Product2 Id
            String lProd = mapPBE.get( oli.PricebookEntryId );
            if( lProd == null ) continue;
            
            //Get the Quota__c object
            Quota__c lQuota = mapQuota.get( lProd );
            if( lQuota == null ) continue;
            
            //Update BR_Quota__c field value
            oli.BR_Quota__c = lQuota.Id;
        }
    }
    
    //Invoke Log Limits
    LogLimits.print('TRIGGER: OpportunityLineItemVerifyQuota - END CODE', false);
    */
}