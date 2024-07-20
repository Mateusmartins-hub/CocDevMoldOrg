/*******************************************************************************
*                     Copyright (C) 2012 - Cloud2b
*-------------------------------------------------------------------------------
* RESPONSIBLE TO PERFORM DML FUNCTION ON PRICEBOOKENTRY OBJECT..
* 
* NAME: PricebookEntryDAO.cls
* AUTHOR: CARLOS CARVALHO                            DATE: 04/02/2013
*******************************************************************************/
public class PricebookEntryDAO {
    
    //get an PricebookEntry List by Ids
    //@aListIdsPBE (PricebookEntry Ids)
    public static List< PricebookEntry > getListPricebookEntryById( List< String > aListIdsPBE ){
    	return [ SELECT Id, Product2.Id, Product2.BR_Segmento__c, Product2.BR_Serie__c
    	    FROM PricebookEntry WHERE Id =: aListIdsPBE ];
    }
    
    public static List< PricebookEntry > getListPricebookEntryByPricebookId(Id id, String cWhere, String maxResults){
    	String qString;
    	
    	if(maxResults == Null){
    		maxResults = '10';
    	}
    	
    	qString = 'SELECT Id, Pricebook2Id, Product2Id, IsActive, Product2.Name, Product2.BR_segmento__c,Product2.Family, Product2.IsActive, ';
    	qString+= 'Product2.Description, UnitPrice, Product2.BR_Nivel__c, Product2.BR_Edicao__c ,Product2.BR_Complemento__c, '; 
    	qString+= 'Product2.BR_Product_Code__c, Product2.BR_Author_name__c, Product2.BR_Produto_com_restricao__c, ';
    	qString+= 'Product2.Sample_use_exclusive__c, Product2.BR_Flag_Bloqueado__c, Product2.BR_Link__c ';
    	qString+= 'FROM PricebookEntry ';
    	qString+= 'WHERE Pricebook2Id = \'' + id + '\' ';
    	if(cWhere!=null){
            qString+= ' and (Product2.Descricao_Concatenado__c like \'%' + cWhere + '%\' or ProductCode like \'%' + cWhere + '%\' or Product2.BR_Author_name__c like \'%' + cWhere + '%\')';
            system.debug(qString);
        }
    	qString+= 'ORDER BY Product2.Name ASC LIMIT ' + maxResults;
    	
    	System.Debug('Qyery: ' + qString);
    	return database.query(qString);

    }
    
}