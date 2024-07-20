/*******************************************************************************
*                     Copyright (C) 2013 - Cloud2b
*-------------------------------------------------------------------------------
*
* Controlador do componente Amostra_Digital que faz o cálculo de MD5 para o envio
* de email
* NAME: Amostra_Digital_Controller.cls
* AUTHOR: ROGERIO ALVARENGA                         DATE: 22/06/2013
*
*******************************************************************************/

public with sharing class Amostra_Digital_Controller {
	
	private static final String TOKEN = '94e310985841949d9c';
	
	public ID OpportID { get; set; }
	public Opportunity Opp;
	public OpportunityLineItem[] OppItems;
	
	public Opportunity getOpp()
	{
		if ( OpportID != null ) return [ Select id, BR_Contact__r.Name from Opportunity where id=:OpportID ];
		Opportunity lOpp = [ Select id, BR_Contact__r.Name from Opportunity limit 1 ];
		OpportID = lOpp.id;
		return lOpp;
	}
	
	public OpportunityLineItem[] getOppItems()
	{
		OpportunityLineItem[] lListItems = [ Select id, PriceBookEntry.name, BR_Link_Biblioteca_Virtual__c,
		  PricebookEntry.Product2.BR_ISBN__c, Opportunity.BR_Contact__r.BR_CPF_Num__c
		  from OpportunityLineItem where OpportunityID =: OpportID ];
		  
		for ( OpportunityLineItem lOppItem : lListItems )
		{
			String lData = DateTime.now().addDays( 90 ).format( 'yyyyMMdd' );
			String lMD5 = calcularMD5( lOppItem, lData );  
		  lOppItem.BR_Link_Biblioteca_Virtual_MD5__c = String.format( lOppItem.BR_Link_Biblioteca_Virtual__c, new List< String >{ lMD5, lData } );
		}
		return lListItems;
	}
	
	private String calcularMD5( OpportunityLineItem aOppItem, String aData )
	{
		return EncodingUtil.convertToHex( Crypto.generateDigest( 'MD5', Blob.valueOf( 
		  aOppItem.PricebookEntry.Product2.BR_ISBN__c + 
		  aOppItem.Opportunity.BR_Contact__r.BR_CPF_Num__c + 
		  aData + 
		  TOKEN
		   ) ) );
	}
	

}