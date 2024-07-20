/*******************************************************************************
*                     Copyright (C) 2012 - Cloud2b
*-------------------------------------------------------------------------------
* RESPONSIBLE TO PERFORM DML FUNCTION ON QUOTA__c OBJECT..
* 
* NAME: QuotaDAO.cls
* AUTHOR: CARLOS CARVALHO                            DATE: 01/02/2013
*******************************************************************************/
public class QuotaDAO {
    
    
    //get an Quota__c List by Ids
    //@aListIdsRep ( Ids Account of presentant type )
    //@aCureentYear ( Current Year )
    public static List< Quota__c > getListQuotaByIdRepCurrentYear( List< String > aListIdsRep, String aCureentYear ){
    	return [ Select SystemModstamp, RecordTypeId, OwnerId, Name, LastModifiedDate, 
    	LastModifiedById, IsDeleted, Id, CreatedDate, CreatedById, BR_Value_Quota_Year__c, 
    	BR_Value_Quota_Sep__c, BR_Value_Quota_Oct__c, BR_Value_Quota_Nov__c, BR_Value_Quota_Month__c, 
    	BR_Value_Quota_May__c, BR_Value_Quota_Mar__c, BR_Value_Quota_Jun__c, BR_Value_Quota_Jul__c,
    	BR_Value_Quota_Jan__c, BR_Value_Quota_Feb__c, BR_Value_Quota_Dec__c, BR_Value_Quota_Ago__c,
    	BR_Value_Quota_Abr__c, BR_Value_Actual_Year__c, BR_Value_Actual_Sep__c, BR_Value_Actual_Oct__c,
    	BR_Value_Actual_Nov__c, BR_Value_Actual_Month__c, BR_Value_Actual_May__c, BR_Value_Actual_Mar__c, 
    	BR_Value_Actual_Jun__c, BR_Value_Actual_Jul__c, BR_Value_Actual_Jan__c, BR_Value_Actual_Feb__c,
    	BR_Value_Actual_Dec__c, BR_Value_Actual_Ago__c, BR_Value_Actual_Abr__c, BR_Rep__c, 
    	BR_Quantity_Quota__c, BR_Quantity_Actual__c, BR_Product__c, BR_Current_month__c, 
    	BR_Current_Year__c, BR_Active__c 
    	FROM Quota__c
    	WHERE BR_Rep__c =: aListIdsRep
    	AND BR_Current_Year__c =: aCureentYear ];
    } 
    
    //get an Quota__c List by Ids
    //@aListIdsProd ( Ids Product2 )
    //@aCureentYear ( Current Year )
    public static List< Quota__c > getListQuotaByIdProductCurrentYear( List< String > aListIdsProd, String aCureentYear ){
        return [ Select SystemModstamp, RecordTypeId, OwnerId, Name, LastModifiedDate, 
        LastModifiedById, IsDeleted, Id, CreatedDate, CreatedById, BR_Value_Quota_Year__c, 
        BR_Value_Quota_Sep__c, BR_Value_Quota_Oct__c, BR_Value_Quota_Nov__c, BR_Value_Quota_Month__c, 
        BR_Value_Quota_May__c, BR_Value_Quota_Mar__c, BR_Value_Quota_Jun__c, BR_Value_Quota_Jul__c,
        BR_Value_Quota_Jan__c, BR_Value_Quota_Feb__c, BR_Value_Quota_Dec__c, BR_Value_Quota_Ago__c,
        BR_Value_Quota_Abr__c, BR_Value_Actual_Year__c, BR_Value_Actual_Sep__c, BR_Value_Actual_Oct__c,
        BR_Value_Actual_Nov__c, BR_Value_Actual_Month__c, BR_Value_Actual_May__c, BR_Value_Actual_Mar__c, 
        BR_Value_Actual_Jun__c, BR_Value_Actual_Jul__c, BR_Value_Actual_Jan__c, BR_Value_Actual_Feb__c,
        BR_Value_Actual_Dec__c, BR_Value_Actual_Ago__c, BR_Value_Actual_Abr__c, BR_Rep__c, 
        BR_Quantity_Quota__c, BR_Quantity_Actual__c, BR_Product__c, BR_Current_month__c, 
        BR_Current_Year__c, BR_Active__c 
        FROM Quota__c
        WHERE BR_Product__c =: aListIdsProd
        AND BR_Current_Year__c =: aCureentYear ];
    } 
    
    //get an Quota__c List by Ids
    //@aListIdsQuota ( Ids Quota )
    public static List< Quota__c > getListQuotaByIdQuota( List< String > aListIdsQuota ){
        return [ Select SystemModstamp, RecordTypeId, OwnerId, Name, LastModifiedDate, 
        LastModifiedById, IsDeleted, Id, CreatedDate, CreatedById, BR_Value_Quota_Year__c, 
        BR_Value_Quota_Sep__c, BR_Value_Quota_Oct__c, BR_Value_Quota_Nov__c, BR_Value_Quota_Month__c, 
        BR_Value_Quota_May__c, BR_Value_Quota_Mar__c, BR_Value_Quota_Jun__c, BR_Value_Quota_Jul__c,
        BR_Value_Quota_Jan__c, BR_Value_Quota_Feb__c, BR_Value_Quota_Dec__c, BR_Value_Quota_Ago__c,
        BR_Value_Quota_Abr__c, BR_Value_Actual_Year__c, BR_Value_Actual_Sep__c, BR_Value_Actual_Oct__c,
        BR_Value_Actual_Nov__c, BR_Value_Actual_Month__c, BR_Value_Actual_May__c, BR_Value_Actual_Mar__c, 
        BR_Value_Actual_Jun__c, BR_Value_Actual_Jul__c, BR_Value_Actual_Jan__c, BR_Value_Actual_Feb__c,
        BR_Value_Actual_Dec__c, BR_Value_Actual_Ago__c, BR_Value_Actual_Abr__c, BR_Rep__c, 
        BR_Quantity_Quota__c, BR_Quantity_Actual__c, BR_Product__c, BR_Current_month__c,
        BR_Value_Actual_Jan_Novo_Idioma__c, BR_Value_Actual_Feb_Novo_Idioma__c, 
        BR_Value_Actual_Mar_Novo_Idioma__c, BR_Value_Actual_Abr_Novo_Idioma__c,
        BR_Value_Actual_May_Novo_Idioma__c, BR_Value_Actual_Jun_Novo_Idioma__c,
        BR_Value_Actual_Jul_Novo_Idioma__c, BR_Value_Actual_Aug_Novo_Idioma__c,
        BR_Value_Actual_Sep_Novo_Idioma__c, BR_Value_Actual_Oct_Novo_Idioma__c,
        BR_Value_Actual_Nov_Novo_Idioma__c, BR_Value_Actual_Dec_Novo_Idioma__c, 
        BR_Current_Year__c, BR_Active__c 
        FROM Quota__c
        WHERE Id =: aListIdsQuota];
    } 
}