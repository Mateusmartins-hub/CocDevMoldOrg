trigger ContagemSegmentoTrigger on Contagem_de_alunos_por_segmento__c (before insert) {
    if(Trigger.isBefore){
        if(Trigger.isInsert){
            ContagemSegmentoHandler.getInstance().beforeInsert();
        }   
    }
}