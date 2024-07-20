public with sharing class OpportunityUpdateURL {
    public static void updateURLAdocao(List<Opportunity> lstOpp) {
        Id tipoRegistro = RecordTypeMemory.getRecType('Opportunity', 'Oportunidade_de_Negocio_Pearson_English_EDU');
        Id tpRegistroSample = RecordTypeMemory.getRecType('Opportunity', 'Sample_Order_University');
        for (Opportunity opp : lstOpp){
            if(opp.RecordTypeId == tipoRegistro ){
                opp.BR_URL__c = 'http://pearsonlatam-br.force.com/ConfirmaAdocaoEDU?RespEmail=' + opp.Id;
            }else {
                if(opp.RecordTypeId == tpRegistroSample){
                    opp.BR_URL2__c = 'http://pearsonlatam-br.force.com/PesquisaSatisfacao?RespEmail=' + opp.Id ;
                    if(opp.StageName == 'Adotado' || opp.StageName  == 'Pedido Gerado' || opp.StageName  == 'Enviado para Integração'){
                        opp.BR_RespondeuAdocao__c = true;
                        opp.BR_AdocaoRecorrente__c = false;
                        opp.BR_URL__c = 'http://pearsonlatam-br.force.com/ConfirmaReAdocao?RespEmail=' + opp.Id;
                    } 
                }
            }
        }
    }
}