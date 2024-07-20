trigger AdocoesTrigger on Adocoes_Cs__c (after delete, after insert, after update, 
before delete, before insert, before update) {
    /*
    if(Trigger.isAfter){
        if(Trigger.isInsert){
            AdocoesBO.getInstance().calculaQuadrante(Trigger.new);
        }
        if(Trigger.isUpdate){
            AdocoesBO.getInstance().calculaQuadrante(Trigger.new);  
        }
    }
    */
}