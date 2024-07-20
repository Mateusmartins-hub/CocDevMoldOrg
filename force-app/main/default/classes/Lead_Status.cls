public class Lead_Status {
    
    public static void popularStatusConformeOrigem(List<Lead> leads) {
        for(Lead l : leads) {                
            if(l.LeadSource == 'Contato Direto' || l.LeadSource == 'Carga' || l.LeadSource == 'Eventos Externos')
                l.Status = 'Aberto';
            
            if(l.LeadSource == 'Recomendação' || l.LeadSource == 'Eventos Internos' || l.LeadSource == 'Website')
                l.Status = 'Contatado';
        }
    }    
    
    public static void validarStatus(List<Lead> leads, Map<Id, Lead> lOld) {
        for(Lead l : leads) {               
            if(l.TipoPessoa__c == 'Física' && l.Status == 'Qualificado' && lOld.get(l.Id).Status != 'Qualificado' && String.isBlank(l.CPF__c)){
                l.CPF__c.addError('CPF obrigatório para este status.');
            }else if(l.TipoPessoa__c == 'Jurídica' && l.Status == 'Qualificado' && lOld.get(l.Id).Status != 'Qualificado' && String.isBlank(l.CNPJ__c)) {
                l.CNPJ__c.addError('CNPJ obrigatório para este status.');
            }
        }
    }
    
    public static void  updateLeadStatus(List<Lead> leads) { 
        for (Lead lead : leads) {
            if (lead.LeadSource == 'Recomendação' || lead.LeadSource == 'Eventos de Expansão' || lead.leadSource == 'Feiras' || lead.leadSource == 'Website')
                lead.Status = 'Aberto';
        }
    }
    
}