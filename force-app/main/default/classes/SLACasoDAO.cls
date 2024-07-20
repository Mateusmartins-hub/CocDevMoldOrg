public class SLACasoDAO {

    public static SLACaso__c getSLAByCasoAndGrupoSolucionador(String idCaso, String grupoSolucionadorId) {
        List<SLACaso__c> listSLACaso = [SELECT Id, Name, Caso__c, ClosedDate__c, GrupoSolucionador__c, SLA__c, SLAUtilizado__c 
                                        FROM SLACaso__c 
                                        WHERE Caso__c =: idCaso AND GrupoSolucionador__c =: grupoSolucionadorId
                                        ORDER BY CreatedDate DESC LIMIT 1];
        
        return listSLACaso.isEmpty() ? null : listSLACaso[0];
    }
    
    public static SLACaso__c getUltimoSLACaso(String idCaso) {
        List<SLACaso__c> listSLACaso = [SELECT Id, Name, Caso__c, ClosedDate__c, GrupoSolucionador__c, SLA__c, SLAUtilizado__c 
                                        FROM SLACaso__c 
                                        WHERE Caso__c =: idCaso 
                                        ORDER BY CreatedDate DESC LIMIT 1];
        
        return listSLACaso.isEmpty() ? null : listSLACaso[0];
    }
    
    public static List<SLACaso__c> getSLASbyCaseId(String idCaso) {
        List<SLACaso__c> listSLACaso = [SELECT Id, Name, Caso__c, ClosedDate__c, GrupoSolucionador__c, SLA__c, SLAUtilizado__c 
                                        FROM SLACaso__c 
                                        WHERE Caso__c =: idCaso
                                        ORDER BY CreatedDate DESC];
            
        return listSLACaso;
    }
    
    public static Map<Id, List<SLACaso__c>> getSLAsbyCasesIds(Set<Id> idsCasos) {
        Map<Id, List<SLACaso__c>> mapSLACasos = new Map<Id, List<SLACaso__c>>();
        for(SLACaso__c sla : [SELECT Id, Name, Caso__c, ClosedDate__c, DataAbertura__c, GrupoSolucionador__c, SLA__c, SLAUtilizado__c 
                              FROM SLACaso__c 
                              WHERE Caso__c IN: idsCasos
                              ORDER BY CreatedDate DESC]) 
        {
            if(!mapSLACasos.containsKey(sla.Caso__c))
                mapSLACasos.put(sla.Caso__c, new List<SLACaso__c>());
            
            mapSLACasos.get(sla.Caso__c).add(sla);
        }
        
        return mapSLACasos;
        
    }
}