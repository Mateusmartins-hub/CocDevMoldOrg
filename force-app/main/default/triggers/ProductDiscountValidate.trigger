/*********************
 * Marcos Aurélio - 29/05/2014
 * Trigger responsável por evitar duplicidade nos produtos com desconto para o cliente.
 ********************/
trigger ProductDiscountValidate on Produtos_com_desconto__c (before insert, after update) {
 	
    for(Produtos_com_desconto__c a:Trigger.new)
    {
        /*
        List<Produtos_com_desconto__c> prddesc=[select ID, ISBN__c from Produtos_com_desconto__c Where Titulo__c=:a.Titulo__c and Professor__c=:a.Professor__c];
		
        if ((Trigger.isInsert && prddesc.size()>0) || (Trigger.isUpdate && prddesc.size()>1))
        {
        	a.adderror('Este produto já foi cadastrado com desconto para este professor!<br/>');
        }
        
        for(Opportunity opp:[select ID from Opportunity Where BR_Contact__c=:a.Professor__c]){
            for(OpportunityLineItem oppLI:[Select Product2Id From OpportunityLineItem Where OpportunityId =: opp.Id]){
                If(a.Titulo__c == oppLI.Product2Id){
            		a.adderror('Este produto já foi enviado como amostra para este professor!<br/>');        
                }
            }
        }
		*/
	}
}