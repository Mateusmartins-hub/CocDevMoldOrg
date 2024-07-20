@isTest
public class ContarVisitasTesteDataFactory {
    public static List<BR_Procedimento_Visita__c> createRCsAndConsultorias(Integer quantityRCsCOs, String modalidade) {
        List<FR_Procedimento_Franquias__c> cos = new List<FR_Procedimento_Franquias__c>();
        for(Integer i = 0; i < quantityRCsCOs; i++) {
        	   cos.add(new FR_Procedimento_Franquias__c(OldName__c='Test'+i));
        }
        
        insert cos;
        
        List<BR_Procedimento_Visita__c> rcs = new List<BR_Procedimento_Visita__c>();
        for(Integer i = 0; i < quantityRCsCOs; i++) {
        	   rcs.add(new BR_Procedimento_Visita__c(BR_Modalidade__c=modalidade, BR_FR_Procedimento_Franquias_Visita__c=cos[i].Id));
        }
        
        return rcs;
        
    }
    
    public static List<BR_Procedimento_Visita__c> createRCsAndConsultoria(Integer quantityRCs, String modalidade) {
        FR_Procedimento_Franquias__c cos = new FR_Procedimento_Franquias__c(OldName__c='Test');
        
        insert cos;
        
        List<BR_Procedimento_Visita__c> rcs = new List<BR_Procedimento_Visita__c>();
        for(Integer i = 0; i < quantityRCs; i++) {
        	   rcs.add(new BR_Procedimento_Visita__c(BR_Modalidade__c=modalidade, BR_FR_Procedimento_Franquias_Visita__c=cos.Id));
        }
        
        return rcs;
        
    }
    
    public static List<FR_Procedimento_Franquias__c> createConsultorias(Integer quantityCOs) {
        List<FR_Procedimento_Franquias__c> cos = new List<FR_Procedimento_Franquias__c>();
        for(Integer i = 0; i < quantityCOs; i++) {
        	   cos.add(new FR_Procedimento_Franquias__c(OldName__c='Test'+i));
        }
        
        insert cos;
        return cos;
    }
    
    public static List<BR_Procedimento_Visita__c> createRCs(Integer quantityRCs, String modalidade, Id consultoria) {
        List<BR_Procedimento_Visita__c> rcs = new List<BR_Procedimento_Visita__c>();
        for(Integer i = 0; i < quantityRCs; i++) {
        	   rcs.add(new BR_Procedimento_Visita__c(BR_Modalidade__c=modalidade, BR_FR_Procedimento_Franquias_Visita__c=consultoria, BR_DataDaAplicacao__c=Date.parse('01/06/2022')));
        }
        
        return rcs;
    }
    
    public static List<BR_Procedimento_Visita__c> createRCsAndConsultoriaComData(Integer quantityRCs, Integer quantityCOs, String modalidade, Boolean areDatesEqual) {
        FR_Procedimento_Franquias__c consultoria = ContarVisitasTesteDataFactory.createConsultorias(1)[0];
        List<BR_Procedimento_Visita__c> rcs = ContarVisitasTesteDataFactory.createRCs(quantityRCs, modalidade, consultoria.Id);
        for(Integer i = 1; i < rcs.size(); i++) {
            rcs[i].BR_DataDaAplicacao__c = ContarVisitasTesteDataFactory.getDate(areDatesEqual, i);
        }
        
        return rcs;
        
    } 
    
    public static List<BR_Procedimento_Visita__c> createRCsAndConsultoriaComData(Integer quantityRCs, Id consultoria, String modalidade, Boolean areDatesEqual) {
        List<BR_Procedimento_Visita__c> rcs = ContarVisitasTesteDataFactory.createRCs(quantityRCs, modalidade, consultoria);
        for(Integer i = 1; i < rcs.size(); i++) {
            rcs[i].BR_DataDaAplicacao__c = ContarVisitasTesteDataFactory.getDate(areDatesEqual, i);
        }
        
        return rcs;
        
    } 
    
    public static List<BR_Procedimento_Visita__c> createRCsAndConsultoriasComData(Integer quantity, String modalidade, Boolean areDatesEqual) {
    	List<BR_Procedimento_Visita__c> rcs = createRCsAndConsultorias(quantity, 'Presencial');
        for(Integer i = 1; i < rcs.size(); i++) {
            rcs[i].BR_DataDaAplicacao__c = ContarVisitasTesteDataFactory.getDate(areDatesEqual, i);
        }
        return rcs;
    }
    
    public static List<BR_Procedimento_Visita__c> updateRCsAndConsultoriaComData(List<BR_Procedimento_Visita__c> rcs, Boolean areDatesEqual) {
    	for(Integer i = 1; i < rcs.size(); i++) {
            rcs[i].BR_DataDaAplicacao__c = ContarVisitasTesteDataFactory.getDate(areDatesEqual, i);
        }
        return rcs;
    }
    
    public static Date getDate(Boolean areDatesEqual, Integer i) {
    	if(areDatesEqual) {
            return Date.parse('01/06/2022');    
        } else { 
        	return Date.parse(i+'/06/2022');
        }
    }
    
}