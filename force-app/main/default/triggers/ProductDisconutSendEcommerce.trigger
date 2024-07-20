/**
 *
 * Trigger - ProductDiscontSendEcommerce  - 04/09/2014 - Robinson Mioshi
 * Call Venda_Especial_Job.LevarItemParaEcommerce - Callout
 * 
 */
trigger ProductDisconutSendEcommerce on Produtos_com_desconto__c (after insert) {
//
// Rotina de Cortesia 75% será executada
//
    // After
    if (Trigger.isAfter) {
	    for(Produtos_com_desconto__c item:Trigger.new)
	    {
	    	if (
	    	    (item.Integrado__c == false) && 
	    	    (item.Ativo__c == true)
	    	    ) {
	            // Executa a rotina 
	            system.debug('ProductDiscontSendEcommerce trigger:' + item.id);
	            Venda_Especial_Job.LevarItemParaEcommerce(String.valueOf(item.id));
	    	}
	    }
    }
 
}