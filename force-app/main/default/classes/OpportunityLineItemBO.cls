public without sharing class OpportunityLineItemBO {
	private static final OpportunityLineItemBO instance = new OpportunityLineItemBO();
   
    public static OpportunityLineItemBO getInstance(){
        return instance;
    }
    
    public void updateDiscountItem(Id opp, Id RecTyp, Decimal desconto){
    	List<String> listOppId = new list<String>();
    	List<OpportunityLineItem> listOppLI = new List<OpportunityLineItem>();
    	listOppId.add(opp);
    	
    	Id RTOppVendCOC   = RecordTypeMemory.getRecType('Opportunity', 'Sales_Opportunities_COC');
		Id RTOppVendPD    = RecordTypeMemory.getRecType('Opportunity', 'Sales_Opportunities_Pueri_Domus');
		Id RTOppVendDB    = RecordTypeMemory.getRecType('Opportunity', 'Sales_Opportunities_Dom_Bosco');
		Id RTOppVendA    = RecordTypeMemory.getRecType('Opportunity', 'Sales_Opportunities_Atitude');
    	
        Id RTOppExCOC   = RecordTypeMemory.getRecType('Opportunity', 'Sales_Extension_COC');
		Id RTOppExPD    = RecordTypeMemory.getRecType('Opportunity', 'Sales_Extension_Dom_Bosco');
		Id RTOppExDB    = RecordTypeMemory.getRecType('Opportunity', 'Sales_Extension_Pueri_Domus');
		Id RTOppExESA    = RecordTypeMemory.getRecType('Opportunity', 'Oportunidade_de_Extensao_Segmento_Atitude');
        
        system.debug('RTOppExCOC = ' + RTOppExCOC );
        
    	if(RecTyp == RTOppVendCOC || RecTyp == RTOppVendPD || RecTyp == RTOppVendDB || RecTyp == RTOppExCOC || RecTyp == RTOppExPD || RecTyp == RTOppExDB || RecTyp == RTOppVendA || RecTyp == RTOppExESA){
    		for(OpportunityLineItem oppLI : OpportunityLineItemDAO.getListOliByIdsOpp(listOppId)){
    			oppLI.Discount = desconto;
    			listOppLI.add(oppLI);
    		}
    		update listOppLI;
    	}
    }
    
    public void updateDiscountItem(List<Opportunity> lstOpp){
        
        Id RTOppVendCOC	= RecordTypeMemory.getRecType('Opportunity', 'Sales_Opportunities_COC');
		Id RTOppVendPD  = RecordTypeMemory.getRecType('Opportunity', 'Sales_Opportunities_Pueri_Domus');
		Id RTOppVendDB  = RecordTypeMemory.getRecType('Opportunity', 'Sales_Opportunities_Dom_Bosco');
		Id RTOppVendA   = RecordTypeMemory.getRecType('Opportunity', 'Sales_Opportunities_Atitude');
    	
        Id RTOppExCOC   = RecordTypeMemory.getRecType('Opportunity', 'Sales_Extension_COC');
		Id RTOppExPD    = RecordTypeMemory.getRecType('Opportunity', 'Sales_Extension_Dom_Bosco');
		Id RTOppExDB    = RecordTypeMemory.getRecType('Opportunity', 'Sales_Extension_Pueri_Domus');
		Id RTOppExESA   = RecordTypeMemory.getRecType('Opportunity', 'Oportunidade_de_Extensao_Segmento_Atitude');
        
        List<String> listOppId 				= new list<String>();
        List<OpportunityLineItem> listOppLI	= new List<OpportunityLineItem>();
        
        for(Opportunity opp : lstOpp){
            Id oppId 			= opp.Id;
            Id RecTyp			= opp.RecordTypeId;
            
            system.debug('RTOppExCOC = ' + RTOppExCOC );
            
            if(RecTyp == RTOppVendCOC || RecTyp == RTOppVendPD || RecTyp == RTOppVendDB || RecTyp == RTOppExCOC || RecTyp == RTOppExPD || RecTyp == RTOppExDB || RecTyp == RTOppVendA || RecTyp == RTOppExESA){
                listOppId.add(oppId);
            }
        }
        
        List<OpportunityLineItem> lstOppLI = OpportunityLineItemDAO.getListOliByIdsOpp(listOppId);
        
        for(OpportunityLineItem oppLI : lstOppLI){
            oppLI.Discount = oppLI.Opportunity.BR_Desconto_1_ano__c;
            listOppLI.add(oppLI);
        }
    	    	
    	update listOppLI;        
    }
    
    public static void UpdateDiscount(List<OpportunityLineItem> items, Map<Id, Opportunity> mapOpp)
	{                                             
		List<string> recordTypesDiscount = new List<string> { 'Sales_Opportunities_COC',
                                                        'Sales_Opportunities_Pueri_Domus',
                                                        'Sales_Opportunities_Dom_Bosco', 
                                                        'Sales_Opportunities_Atitude',
                                                        'Sales_Opportunities_Solutions' };
		for (OpportunityLineItem item : items)
		{
			Opportunity opp = mapOpp.get(item.OpportunityId);

			if(opp == null){
				continue;
			}
                 
			if(recordTypesDiscount.contains(opp.RecordType.DeveloperName)){
				item.Discount = opp.BR_Desconto_1_ano__c;
			}
		}
	}
    
    public static void updateStock(List<OpportunityLineItem> items)
    {
        List<string> recordtypes = new List<string> { 'Oportunidade de Negócio Pearson English EDU',
													  'Sample Order - Languages',
													  'Sample Order - University' };
                                  
		List<string> idsOportunities = new List<string>();
		for (OpportunityLineItem oli : items)
		{
			idsOportunities.add(oli.OpportunityId);
		}
                         
		Map<Id, Opportunity> mapOpportunity = new Map<Id, Opportunity>(OpportunityDAO.getListOppById(idsOportunities));
		List<Id> ids = new List<Id>();
        for (OpportunityLineItem item : items) {
			Opportunity opp = mapOpportunity.get(item.OpportunityId);
                        
			if (recordtypes.contains(opp.RecordType.Name)){
                ids.add(item.Id);
			}
		}
        
        captura_estoque_SAP.parseJSONResponseFuture(ids);
    }
    
    public void updateSalesPrice(List<OpportunityLineItem> lstOppLI){
    	for(OpportunityLineItem oppLI : lstOppLI){
    		IF(oppLI.TotalMes__c > 0){
    			oppLI.UnitPrice = oppLI.Valor_Unitario__c * oppLI.TotalMes__c;
    		}
    	}
    }

    public List<OpportunityLineItem> getOppLineItemByOppId(String idOpp){
        return OpportunityLineItemDAO.getListOliByIdsOpp(new List<String>{idOpp});
    }

	public static void updateDiscountsNewOpps(List<OpportunityLineItem> lstOppItems) {
		List<string> idsOportunities = new List<string>();
		for (OpportunityLineItem oli : lstOppItems) {
			idsOportunities.add(oli.OpportunityId);
		}

		for (OpportunityLineItem oli : lstOppItems) {
			idsOportunities.add(oli.OpportunityId);
		}
		
		Map<Id, Opportunity> mapOpportunity = new Map<Id, Opportunity>(OpportunityDAO.getListOppById(idsOportunities));

		UpdateDiscount(lstOppItems, mapOpportunity);
	}
    
    public class cException extends Exception{}

    public void processaDadosOportunidadeRelacionada(List<OpportunityLineItem> lstOppLineItem, Map<Id, OpportunityLineItem> mapOldValues, Boolean isDelete){
        Set<String> setOppId = new Set<String>();
        if(isDelete){
            for(OpportunityLineItem oppLineItem : mapOldValues.values()){
                setOppId.add(oppLineItem.OpportunityId);
            }
        } else {
            for(OpportunityLineItem oppLineItem : lstOppLineItem){
                setOppId.add(oppLineItem.OpportunityId);
            }
        }
        
        OpportunityBO.getInstance().setDadosEmailToOpportunity(new List<String>(setOppId));
    }
}