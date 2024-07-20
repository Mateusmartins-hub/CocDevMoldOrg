trigger OpportunityLineItemVerifyDuplicate on OpportunityLineItem (before insert) {
	/*
    for( OpportunityLineItem oli : trigger.new ){
	 	
	 	Id oppRTUniv = RecordTypeMemory.getRecType( 'Opportunity', 'Sample_Order_University' );
	 	Id oppRTIdio = RecordTypeMemory.getRecType( 'Opportunity', 'Sample_Order_Languages' );
	 	
	 	for(Opportunity opp:[Select Id, Name, RecordTypeId From Opportunity Where Id=:oli.OpportunityId]){
	 		if(opp.RecordTypeId==oppRTUniv || opp.RecordTypeId==oppRTIdio){
	 			List<OpportunityLineItem> oppLI = [Select Id From OpportunityLineItem Where ClienteProduto__c=:oli.ClienteProduto__c];
	 			if(oppLI.size()>0){
	 				oli.adderror('Este contato já adquiriu uma amostra do produto ' + oli.BR_ERP_Product_Code__c);
	 			}	 			
	 		}
	 	}
	 }
    */
}