@isTest
public class ContarVisitasTeste {
	@isTest
    static void testInsertSuccess() {
		// Teste Contagem Única Modalidade - Presencial ---------------------------------------------------
        BR_Procedimento_Visita__c rc = ContarVisitasTesteDataFactory.createRCsAndConsultorias(1,'Presencial')[0];
        
        Decimal visitasBefore = [SELECT id,Visitas_Realizadas__c FROM FR_Procedimento_Franquias__c WHERE id = :rc.BR_FR_Procedimento_Franquias_Visita__c].Visitas_Realizadas__c;
        
        insert rc;
        
        Decimal visitasAfter = [SELECT id,Visitas_Realizadas__c FROM FR_Procedimento_Franquias__c WHERE id = :rc.BR_FR_Procedimento_Franquias_Visita__c].Visitas_Realizadas__c;
        
        System.assertEquals(visitasBefore+1, visitasAfter);
        
        // Teste Contagem Única Modalidade - Online -------------------------------------------------------
        
        BR_Procedimento_Visita__c rcOnline = ContarVisitasTesteDataFactory.createRCsAndConsultorias(1,'Online')[0];
        
        Decimal visitasBeforeOnline = [SELECT id,Visitas_Realizadas__c FROM FR_Procedimento_Franquias__c WHERE id = :rcOnline.BR_FR_Procedimento_Franquias_Visita__c].Visitas_Realizadas__c;
        
        insert rcOnline;
        
        Decimal visitasAfterOnline = [SELECT id,Visitas_Realizadas__c FROM FR_Procedimento_Franquias__c WHERE id = :rcOnline.BR_FR_Procedimento_Franquias_Visita__c].Visitas_Realizadas__c;
        
        System.assertEquals(visitasBeforeOnline, visitasAfterOnline);
        
        // Teste Contagem Múltipla Mesma Data e Mesma Consultoria -------------------------------------------------------
        
        List<BR_Procedimento_Visita__c> rcs = ContarVisitasTesteDataFactory.createRCsAndConsultoriaComData(200, 1, 'Presencial', true);
        
        visitasBefore = [SELECT id,Visitas_Realizadas__c FROM FR_Procedimento_Franquias__c WHERE id = :rcs[0].BR_FR_Procedimento_Franquias_Visita__c].Visitas_Realizadas__c;
        
        insert rcs;
        
        visitasAfter = [SELECT id,Visitas_Realizadas__c FROM FR_Procedimento_Franquias__c WHERE id = :rcs[0].BR_FR_Procedimento_Franquias_Visita__c].Visitas_Realizadas__c;
        
        System.assertEquals(visitasBefore+1, visitasAfter);
        
        // Teste Contagem Diferentes Datas e Mesma Consultoria -------------------------------------------------------
        
        rcs = ContarVisitasTesteDataFactory.createRCsAndConsultoriaComData(10, 1, 'Presencial', false);
        insert ContarVisitasTesteDataFactory.createRCsAndConsultoriaComData(20, rcs[0].BR_FR_Procedimento_Franquias_Visita__c, 'Presencial', true);
        
        visitasBefore = [SELECT id,Visitas_Realizadas__c FROM FR_Procedimento_Franquias__c WHERE id = :rcs[0].BR_FR_Procedimento_Franquias_Visita__c].Visitas_Realizadas__c;
        
        insert rcs;
        
        visitasAfter = [SELECT id,Visitas_Realizadas__c FROM FR_Procedimento_Franquias__c WHERE id = :rcs[0].BR_FR_Procedimento_Franquias_Visita__c].Visitas_Realizadas__c;
        
        System.assert(visitasAfter > visitasBefore);
        
        // Teste Contagem Múltipla Mesma Data e Diferentes Consultorias -------------------------------------------------------
		
        rcs = ContarVisitasTesteDataFactory.createRCsAndConsultoriasComData(100, 'Presencial', true);
        
        Set<Id> consultorias = new Set<Id>();
        
        for(BR_Procedimento_Visita__c rc1 : rcs) {
            consultorias.add(rc1.BR_FR_Procedimento_Franquias_Visita__c);
        }
        
        Map<Id, FR_Procedimento_Franquias__c> visitasBeforeMap = new Map<Id, FR_Procedimento_Franquias__c>([SELECT Visitas_Realizadas__c FROM FR_Procedimento_Franquias__c WHERE id IN :consultorias]);
        
        insert rcs;
        
        Map<Id, FR_Procedimento_Franquias__c> visitasAfterMap = new Map<Id, FR_Procedimento_Franquias__c>([SELECT Visitas_Realizadas__c FROM FR_Procedimento_Franquias__c WHERE id IN :consultorias]);
        
        for(BR_Procedimento_Visita__c rc1 : rcs) {
            System.assertEquals(visitasBeforeMap.get(rc1.BR_FR_Procedimento_Franquias_Visita__c).Visitas_Realizadas__c+1, visitasAfterMap.get(rc1.BR_FR_Procedimento_Franquias_Visita__c).Visitas_Realizadas__c);
        }
        
        // Teste Contagem Múltipla Diferentes Datas e Diferentes Consultorias -------------------------------------------------------
        
        rcs = ContarVisitasTesteDataFactory.createRCsAndConsultoriasComData(20, 'Presencial', false);
        
        consultorias = new Set<Id>();
        
        for(BR_Procedimento_Visita__c rc1 : rcs) {
            consultorias.add(rc1.BR_FR_Procedimento_Franquias_Visita__c);
        }
        
        visitasBeforeMap = new Map<Id, FR_Procedimento_Franquias__c>([SELECT Visitas_Realizadas__c FROM FR_Procedimento_Franquias__c WHERE id IN :consultorias]);
        
        insert rcs;
        
        visitasAfterMap = new Map<Id, FR_Procedimento_Franquias__c>([SELECT Visitas_Realizadas__c FROM FR_Procedimento_Franquias__c WHERE id IN :consultorias]);
        
        for(BR_Procedimento_Visita__c rc1 : rcs) {
            System.assertEquals(visitasBeforeMap.get(rc1.BR_FR_Procedimento_Franquias_Visita__c).Visitas_Realizadas__c+1, visitasAfterMap.get(rc1.BR_FR_Procedimento_Franquias_Visita__c).Visitas_Realizadas__c);
        }
        
    }
    
    @isTest
    static void testUpdateSuccess() {
        // Teste Contagem Múltipla Mesma Data e Mesma Consultoria -------------------------------------------------------
        
        List<BR_Procedimento_Visita__c> rcs = ContarVisitasTesteDataFactory.createRCsAndConsultoria(200, 'Presencial');
        
        Decimal visitasBefore = [SELECT id,Visitas_Realizadas__c FROM FR_Procedimento_Franquias__c WHERE id = :rcs[0].BR_FR_Procedimento_Franquias_Visita__c].Visitas_Realizadas__c;
        
        insert rcs;
        
        rcs = ContarVisitasTesteDataFactory.updateRCsAndConsultoriaComData(rcs, true);
        
        Decimal visitasAfter = [SELECT id,Visitas_Realizadas__c FROM FR_Procedimento_Franquias__c WHERE id = :rcs[0].BR_FR_Procedimento_Franquias_Visita__c].Visitas_Realizadas__c;
        
        System.assertEquals(visitasBefore+1, visitasAfter);
        
        // Teste Contagem Diferentes Datas e Mesma Consultoria -------------------------------------------------------
        
        rcs = ContarVisitasTesteDataFactory.createRCsAndConsultoria(10, 'Presencial');
        insert ContarVisitasTesteDataFactory.createRCsAndConsultoriaComData(20, rcs[0].BR_FR_Procedimento_Franquias_Visita__c, 'Presencial', true);
        
        visitasBefore = [SELECT id,Visitas_Realizadas__c FROM FR_Procedimento_Franquias__c WHERE id = :rcs[0].BR_FR_Procedimento_Franquias_Visita__c].Visitas_Realizadas__c;
        
        insert rcs;
        
        rcs = ContarVisitasTesteDataFactory.updateRCsAndConsultoriaComData(rcs, false);
        
        update rcs;
        
        visitasAfter = [SELECT id,Visitas_Realizadas__c FROM FR_Procedimento_Franquias__c WHERE id = :rcs[0].BR_FR_Procedimento_Franquias_Visita__c].Visitas_Realizadas__c;
        
        System.assert(visitasAfter > visitasBefore);
        
        // Teste Contagem Múltipla Mesma Data e Diferentes Consultorias -------------------------------------------------------
		
        rcs = ContarVisitasTesteDataFactory.createRCsAndConsultorias(30, 'Presencial');
        
        Set<Id> consultorias = new Set<Id>();
        
        for(BR_Procedimento_Visita__c rc1 : rcs) {
            consultorias.add(rc1.BR_FR_Procedimento_Franquias_Visita__c);
        }
        
        Map<Id, FR_Procedimento_Franquias__c> visitasBeforeMap = new Map<Id, FR_Procedimento_Franquias__c>([SELECT Visitas_Realizadas__c FROM FR_Procedimento_Franquias__c WHERE id IN :consultorias]);
        
        insert rcs;
        
        rcs = ContarVisitasTesteDataFactory.updateRCsAndConsultoriaComData(rcs, true);
        
        update rcs;
        
        Map<Id, FR_Procedimento_Franquias__c> visitasAfterMap = new Map<Id, FR_Procedimento_Franquias__c>([SELECT Visitas_Realizadas__c FROM FR_Procedimento_Franquias__c WHERE id IN :consultorias]);
        
        for(BR_Procedimento_Visita__c rc1 : rcs) {
            System.assertEquals(visitasBeforeMap.get(rc1.BR_FR_Procedimento_Franquias_Visita__c).Visitas_Realizadas__c+1, visitasAfterMap.get(rc1.BR_FR_Procedimento_Franquias_Visita__c).Visitas_Realizadas__c);
        }
        
        // Teste Contagem Múltipla Diferentes Datas e Diferentes Consultorias -------------------------------------------------------
        
        rcs = ContarVisitasTesteDataFactory.createRCsAndConsultorias(20, 'Presencial');
        
        consultorias = new Set<Id>();
        
        for(BR_Procedimento_Visita__c rc1 : rcs) {
            consultorias.add(rc1.BR_FR_Procedimento_Franquias_Visita__c);
        }
        
        visitasBeforeMap = new Map<Id, FR_Procedimento_Franquias__c>([SELECT Visitas_Realizadas__c FROM FR_Procedimento_Franquias__c WHERE id IN :consultorias]);
        
        insert rcs;
        
        rcs = ContarVisitasTesteDataFactory.updateRCsAndConsultoriaComData(rcs, false);
        
        visitasAfterMap = new Map<Id, FR_Procedimento_Franquias__c>([SELECT Visitas_Realizadas__c FROM FR_Procedimento_Franquias__c WHERE id IN :consultorias]);
        
        for(BR_Procedimento_Visita__c rc1 : rcs) {
            System.assertEquals(visitasBeforeMap.get(rc1.BR_FR_Procedimento_Franquias_Visita__c).Visitas_Realizadas__c+1, visitasAfterMap.get(rc1.BR_FR_Procedimento_Franquias_Visita__c).Visitas_Realizadas__c);
        }
    }
}