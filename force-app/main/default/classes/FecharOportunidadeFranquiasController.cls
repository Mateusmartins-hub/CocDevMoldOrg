public class FecharOportunidadeFranquiasController {

    @AuraEnabled
    public static Opportunity getOportunidade(String idOportunidade) {
        try{
            List<Opportunity> opps = [SELECT Id, IsClosed, BR_MotivoRecusa__c FROM Opportunity WHERE Id =: idOportunidade];

            if(opps.isEmpty()){
                throw new AuraHandledException('Oportunidade não encontrada');    
            }

            return opps[0];
        }catch(Exception e) {
            throw new AuraHandledException('Oportunidade não encontrada');
        }
    }

    @AuraEnabled
    public static List<String> getMotivos() {
        try{
            List<String> pickListValuesList = new List<String>();
            
            Schema.DescribeFieldResult fieldResult = Opportunity.BR_MotivoRecusa__c.getDescribe();
            List<Schema.PicklistEntry> ple = fieldResult.getPicklistValues();
            for(Schema.PicklistEntry pickListVal : ple){
                pickListValuesList.add(pickListVal.getLabel());
            }
            
            return pickListValuesList;
        }catch(Exception e) {
            throw new AuraHandledException('Erro ao encontrar motivos');
        }
    }
    
    @AuraEnabled
    public static List<String> getClosedStages() {
        try{
            List<String> pickListValuesList = new List<String>();
            pickListValuesList.add('Cancelada');
            pickListValuesList.add('Contrato Fechado');
            return pickListValuesList;
        }catch(Exception e) {
            throw new AuraHandledException('Erro ao encontrar fases de fechamento');
        }
    }
    
    @AuraEnabled
    public static void saveAndIntegrateRDStation(String idOportunidade, String stage, String motivoRecusa) {
        try{
            Opportunity opp = OpportunityDAO.buscaOportunidade(idOportunidade);            
            opp.StageName = stage;
            opp.BR_MotivoRecusa__c = motivoRecusa;
            
            RDStationIntegration.returnOppToLead(opp);
            update opp;
        }catch(Exception e) {
            throw new AuraHandledException(e.getMessage());
        }
    }
}