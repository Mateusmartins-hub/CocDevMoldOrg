public class LeadDAO {

    public static Lead BuscaLead(Id idLead)
    {
        return [SELECT Id, Name, SistemaEnsino__c, Email, OwnerId, Owner.Email, Owner.Name, Status,
                (SELECT Id, Name, Data1__c, Data2__c, Data3__c, EnviadoPor__c, TipoVisita__c, DataConfirmada__c, HoraInicialSugerida__c, HoraFinalSugerida__c, HoraInicialConfirmada__c, HoraFinalConfirmada__c FROM SugestoesVisitas__r ORDER BY CreatedDate DESC LIMIT 1)
                  FROM Lead 
                 WHERE Id =: idLead];
    }

    public static Lead BuscaApenasLeadPorId(Id idLead)
    {
        return [SELECT Email
                  FROM Lead 
                 WHERE Id =: idLead];
        
    }


    public static List<Lead> BuscarLeads(Set<Id> leadIds)
    {
        return [SELECT Id, Name, SistemaEnsino__c, Email, OwnerId, Owner.Email, Status
                FROM Lead
                WHERE Id IN: leadIds];
    }
}