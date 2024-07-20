/*******************************************************************************
*                     Copyright (C) 2012 - Cloud2b
*-------------------------------------------------------------------------------
* UPDATE THE N_Alunos__c FIELD ON OpportunityLineItem WITH ACCOUNT SEGMENTATION
* VALUE USING SERIE + SEGMENT COMBINATION.  
* 
* NAME: OpportunityLineItemUpdateNumberStudents.trigger
* AUTHOR: CARLOS CARVALHO                            DATE: 07/02/2013
*******************************************************************************/
trigger OpportunityLineItemUpdateNumberStudents on OpportunityLineItem (before insert, before update) {
    
    //Invoke Log Limits
    LogLimits.print('TRIGGER: OpportunityLineItemUpdateNumberStudents - BEGIN CODE', false);
    
    //VARIABLE DECLARATION
    List< String > listIdsPBE = new List< String >();
    List< String > listIdsOpp = new List< String >();
    List< String > listIdsAccSegmentation = new List< String >();
    Map< String, String > mapPricebookEntrySeg = new Map< String, String >(); 
    Map< String, String > mapOliSeg = new Map< String, String >(); 
    Map< String, String > mapOppAccSeg = new Map< String, String >();
    Map< String, Map< String, Double > > mapIdOppSegSerie = new Map< String, Map< String, Double > >();
    
    for( OpportunityLineItem oli : trigger.new ){
        //Put OpportunityId inside list
        listIdsOpp.add( oli.OpportunityId );
        //Put PricebookEntryId inside list
        listIdsPBE.add( oli.PricebookEntryId );
        //Validaate if BR_Serie__c and BR_Segmentation__c on OpportunityLineItem contaisn value
        String lSeg = oli.BR_Segmentation__c;
        String lSer = oli.BR_Serie__c;
        if( lSeg == null ) lSeg = '';
        if( lSer == null ) lSer = '';
        mapOliSeg.put( oli.PricebookEntryId, lSeg +' '+ lSer );
    }
    
    //Invoke Log Limits
    LogLimits.print('TRIGGER: OpportunityLineItemUpdateNumberStudents - AFTER FOR OpportunityLineItem', false);
    
    for( Opportunity opp : OpportunityDAO.getListOppById( listIdsOpp ) ){
        //Put Account Segmentation ID inside list
        listIdsAccSegmentation.add( opp.BR_Account_Segmentation__c );
        //Create a map (KEY=OpportunityId and VALUE=Account Segmentation ID)
        mapOppAccSeg.put( opp.Id, opp.BR_Account_Segmentation__c );
    }
    
    //Invoke Log Limits
    LogLimits.print('TRIGGER: OpportunityLineItemUpdateNumberStudents - AFTER FOR Opportunity WITH SELECT', false);
    
    Map< String, Double > lMap;
    //Get ALL Account_Segmentation__c where id equals id list
    for( Account_Segmentation__c aseg : AccountSegmentationDAO.getAccSegById( listIdsAccSegmentation ) ){
         //Create a map (KEY=Segment+serie and VALUE=<Account segmentation field>)
         lMap = new Map< String, Double >(); 
         lMap.put( 'EI'+' '+'', aseg.Total_of_students_EI__c );
         lMap.put( 'EI'+' '+'1 ano', aseg.Nbr_of_child_1_year__c );
         lMap.put( 'EI'+' '+'2 anos', aseg.Nbr_of_child_2_years__c ); 
         lMap.put( 'EI'+' '+'3 anos', aseg.Nbr_of_child_3_years__c );
         lMap.put( 'EI'+' '+'4 anos', aseg.Nbr_of_child_4_years__c );
         lMap.put( 'EI'+' '+'5 anos', aseg.Nbr_of_child_5_years__c );
         lMap.put( 'Creche'+' '+'', aseg.Total_of_students_kindergarden__c );
         lMap.put( 'Pré escola'+' '+'', aseg.Total_of_students_pre_school__c );
         lMap.put( 'EF'+' '+'', aseg.Total_of_students_EF__c );
         lMap.put( 'EF1'+' '+'1o ano', aseg.Nbr_of_students_EF1_1st_year__c );
         lMap.put( 'EF1'+' '+'2o ano', aseg.Nbr_of_students_EF1_2nd_year__c );
         lMap.put( 'EF1'+' '+'3o ano', aseg.Nbr_of_students_EF1_3rd_year__c );
         lMap.put( 'EF1'+' '+'4o ano', aseg.Nbr_of_students_EF1_4th_year__c );
         lMap.put( 'EF1'+' '+'5o ano', aseg.Nbr_of_students_EF1_5th_year__c );
         lMap.put( 'EF2'+' '+'6o ano', aseg.Nbr_of_students_EF2_6th_year__c );
         lMap.put( 'EF2'+' '+'7o ano', aseg.Nbr_of_students_EF2_7th_year__c );
         lMap.put( 'EF2'+' '+'8o ano', aseg.Nbr_of_students_EF2_8th_year__c );
         lMap.put( 'EF2'+' '+'9o ano', aseg.Nbr_of_students_EF2_9th_year__c );
         lMap.put( 'EF1'+' '+'',aseg.Total_of_students_EF1__c );
         lMap.put( 'EF2'+' '+'', aseg.Total_of_students_EF2__c );
         lMap.put( 'EM'+' '+'', aseg.Total_of_students_EM__c );
         lMap.put( 'EM'+' '+'1a serie', aseg.Nbr_of_students_EM_1st_year__c );
         lMap.put( 'EM'+' '+'2a serie', aseg.Nbr_of_students_EM_2nd_year__c );
         lMap.put( 'EM'+' '+'3a serie', aseg.Nbr_of_students_EM_3rd_year__c );
         lMap.put( 'EM'+' '+'4a serie', aseg.Nbr_of_students_EM_4th_year__c );
         lMap.put( 'EJA'+' '+'', aseg.Total_of_students_EJA__c );
         lMap.put( 'EJA'+' '+'EF', aseg.Nbr_of_students_EJA_EF__c );
         lMap.put( 'EJA'+' '+'EM', aseg.Nbr_of_students_EJA_EM__c );
         lMap.put( 'PV' +' '+ '', aseg.Nbr_of_students_semi_ext__c );
         lMap.put( 'PV' +' '+ 'Pré-vestibular', aseg.Total_of_students_preparatory_course__c );
         lMap.put( 'PV' +' '+ 'EM Terceirão', aseg.Nbr_of_students_Terceirao__c );
         lMap.put( 'PV' +' '+ 'Pré-vestibular', aseg.Nbr_of_students_preparatory_course__c );
         lMap.put( 'PV' +' '+ 'Extensivo', aseg.Nbr_of_students_extensive__c );
         lMap.put( 'PV' +' '+ 'Semi extensivo', aseg.Nbr_of_students_semi_ext__c );
         lMap.put( 'PV' +' '+ 'Intensivo', aseg.Nbr_of_students_semi_int__c );
         lMap.put( 'PV' +' '+ 'Semi Intensivo', aseg.Nbr_of_students_semi_int__c );
         lMap.put( 'Pre-primary' +' '+ '', aseg.Nbr_of_students_pre_primary__c );
             lMap.put( 'Primary' +' '+ '', aseg.Nbr_of_students_primary__c );
                 lMap.put( 'Secondary' +' '+ '', aseg.Nbr_of_students_secondary__c );
                 lMap.put( 'Lower secondary' +' '+ '', aseg.Nbr_of_students_young_adults__c );
                 lMap.put( 'Upper secondary' +' '+ '', aseg.Nbr_of_students_adults__c );
                 lMap.put( 'Tertiary' +' '+ '', aseg.Total_of_students_preparatory_course__c );
                 lMap.put( 'Business' +' '+ '', aseg.Nbr_of_students_business__c );
         lMap.put( 'Exams' +' '+ '', aseg.Nbr_of_students_exams__c );

         //Create a map (KEY=Account segmentation ID and VALUE=lMap)
         mapIdOppSegSerie.put( aseg.Id ,lMap );
    }
    //Invoke Log Limits
    LogLimits.print('TRIGGER: OpportunityLineItemUpdateNumberStudents - AFTER FOR Account_Segmentation__c', false);
    
    for( PricebookEntry pbe : PricebookEntryDAO.getListPricebookEntryById( listIdsPBE ) ){
    //System.debug('CARLOS=pbe= ' +pbe);
        //System.debug('CARLOS=pbe.Product2.BR_Segmento__c= ' +pbe.Product2.BR_Segmento__c);
        //System.debug('CARLOS=pbe.Product2.BR_Serie__c = ' +pbe.Product2.BR_Serie__c );
        //Create a map (KEY=PricebookEntry ID and VALUE=Segment+serie from product2)
        if( pbe.Product2.BR_Segmento__c != null)// && pbe.Product2.BR_Serie__c != null)
            mapPricebookEntrySeg.put( pbe.Id, pbe.Product2.BR_Segmento__c+' '+pbe.Product2.BR_Serie__c );
    }
    //System.debug('CARLOS=mapPricebookEntrySeg= '+mapPricebookEntrySeg);
    //System.debug('CARLOS=mapIdOppSegSerie= '+mapIdOppSegSerie);
    
    //Invoke Log Limits
    LogLimits.print('TRIGGER: OpportunityLineItemUpdateNumberStudents - AFTER FOR PricebookEntry WITH SELECT', false);
    
    for( OpportunityLineItem oli : trigger.new ){
        //Local Variable Declaration
        String lSegmentoSerie;
        String lIdAccSeg;
        Double lNAlunos;
        
        //Get a Account Segmentation ID by OpportunityId 
        lIdAccSeg = mapOppAccSeg.get( oli.OpportunityId );
        //System.debug('CARLOS=lIdAccSeg = '+lIdAccSeg );
        //Get a Key Segmentation + Serie from map 
        lSegmentoSerie = mapPricebookEntrySeg.get( oli.PricebookEntryId );
        //System.debug('CARLOS=lSegmentoSerie= '+lSegmentoSerie);
        lNAlunos = oli.N_Alunos__c;
        //System.debug('CARLOS=lNAlunos= '+lNAlunos);
        //Validate if mapIdOppSegSerie there're some value
        if( mapIdOppSegSerie.size() > 0 ){
            //Get a number of students throws Account segmentation ID + ( Key segment +Serie )
            lNAlunos = mapIdOppSegSerie.get( lIdAccSeg ).get( lSegmentoSerie );
            //System.debug('CARLOS=lNAlunos= '+lNAlunos);
            //Validate if mapOliSeg there're some value AND the variable lNAlunos it's not null
            if( lNAlunos == null && mapOliSeg.size() > 0 ){
                //Get a Key Segmentation + Serie from map
                lSegmentoSerie = mapOliSeg.get(oli.PricebookEntryId);
                //System.debug('CARLOS=lSegmentoSerie = '+lSegmentoSerie );
                //Get a number of students throws Account segmentation ID + ( Key segment +Serie ) 
                lNAlunos = mapIdOppSegSerie.get( lIdAccSeg ).get( lSegmentoSerie );
                //System.debug('CARLOS=lNAlunos = '+lNAlunos );
            }
        }
        //The field N_Alunos__c on OpportunityLineItem is fill with lNAlunos or is fill 0 value
        if( lNAlunos != null ){ oli.N_Alunos__c = lNAlunos; }
        else oli.N_Alunos__c = 0;
    }
    
    //Invoke Log Limits
    LogLimits.print('TRIGGER: OpportunityLineItemUpdateNumberStudents - END CODE', false);
}