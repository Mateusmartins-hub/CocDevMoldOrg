/*******************************************************************************
*                     Copyright (C) 2012 - Cloud2b
*-------------------------------------------------------------------------------
* RESPONSIBLE TO PERFORM DML FUNCTION ON STOCK OBJECT..
* 
* NAME: StockDAO.cls
* AUTHOR: CARLOS CARVALHO                            DATE: 14/02/2013
*******************************************************************************/
public class StockDAO {
    
    //get an Stock List by Ids
    //@aIdsProduct (Product Ids)
    //@aIdsRep (Representant Ids)
    public static List< Stock__c > getListStockBy( List< String > aIdsProduct, List< String > aIdsRep ){
    	return [ SELECT Id, BR_Quantidade__c, BR_Data_da_Ultima_Baixa__c,
    	   BR_Product__c, BR_representante__c FROM Stock__c WHERE BR_Product__c =: aIdsProduct
    	   AND BR_representante__c =: aIdsRep ];
    }
    
}