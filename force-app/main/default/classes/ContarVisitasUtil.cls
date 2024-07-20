public class ContarVisitasUtil {
    public static void ContagemUnica(List<BR_Procedimento_Visita__c> visitas){
        boolean presencial = false;
        for(BR_Procedimento_Visita__c tipo: visitas){
            if(tipo.BR_Modalidade__c == 'Presencial'){ presencial = true;}
        }
        if(presencial){
                Set<id> COs = new Set<id>();
                for(BR_Procedimento_Visita__c contagem : visitas){
                    COs.add(contagem.BR_FR_Procedimento_Franquias_Visita__c);
                }
                FR_Procedimento_Franquias__c CO = [SELECT id,Visitas_Realizadas__c FROM FR_Procedimento_Franquias__c WHERE id IN :COs];
                CO.Visitas_Realizadas__c = CO.Visitas_Realizadas__c + 1;
                update CO;
      	}
    }
    public static void ContageMultipla(List<BR_Procedimento_Visita__c> visitas){
    	Set<Date> datas = new Set<Date>();
        Set<Id> COs = new Set<id>();
        Set<Date> RCDate = new Set<Date>();
        Map<Id, Set<Date>> datasPorConsultoria = new Map<Id, Set<Date>>();
        Set<Date> tmp;
        for(BR_Procedimento_Visita__c data : visitas ){
            datas.add(data.BR_DataDaAplicacao__c);
            COs.add(data.BR_FR_Procedimento_Franquias_Visita__c);
            if(datasPorConsultoria.get(data.BR_FR_Procedimento_Franquias_Visita__c) == null) {
                tmp = new Set<Date>();
                tmp.add(data.BR_DataDaAplicacao__c);
                datasPorConsultoria.put(data.BR_FR_Procedimento_Franquias_Visita__c, tmp);
            } else {
            	datasPorConsultoria.get(data.BR_FR_Procedimento_Franquias_Visita__c).add(data.BR_DataDaAplicacao__c);   
            }
        }
        if(COs.size() == 1){
        	List<BR_Procedimento_Visita__c> RCs = [SELECT Id,BR_DataDaAplicacao__c,BR_FR_Procedimento_Franquias_Visita__c FROM BR_Procedimento_Visita__c
                                                    WHERE BR_FR_Procedimento_Franquias_Visita__c IN :Cos AND BR_DataDaAplicacao__c IN :datas];
            FR_Procedimento_Franquias__c CO = [SELECT id,Visitas_Realizadas__c FROM FR_Procedimento_Franquias__c WHERE id IN :COs];
            Integer cont = 0;
            if(RCs.size() > 0){
                for(BR_Procedimento_Visita__c dif : RCs){
					RCDate.add(dif.BR_DataDaAplicacao__c);                
                }
                cont = datas.size() - RCDate.size();
                CO.Visitas_Realizadas__c = cont;
            }else{
                CO.Visitas_Realizadas__c = datas.size(); 
            }
            update CO;
        }else{
            List<FR_Procedimento_Franquias__c> consultorias = [SELECT id,Visitas_Realizadas__c FROM FR_Procedimento_Franquias__c WHERE id IN :COs];
            for(FR_Procedimento_Franquias__c CO : consultorias) {
            	CO.Visitas_Realizadas__c = datasPorConsultoria.get(CO.Id).size();   
            }
            update consultorias;
        }
    }
}