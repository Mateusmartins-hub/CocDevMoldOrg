public class CaseTriggerHandler extends TriggerHandler {

    public List<Case> casosFluxoAntigo = new List<Case>();
    public List<Case> casosFluxoNovo = new List<Case>();
    
    public CaseTriggerHandler() {
        NovoFluxoCasos__c config = NovoFluxoCasos__c.getOrgDefaults();
        
        for(Case c : (List<Case>)Trigger.new) {
            if(Test.isRunningTest()) {
                casosFluxoAntigo.add(c);
                casosFluxoNovo.add(c);
                
                continue;
            }
            
            if(c.CreatedDate <= config.DataCorte__c)
                casosFluxoAntigo.add(c);
            else
                casosFluxoNovo.add(c);
        }
    }
    
    public override void beforeUpdate() {
        CaseBO.validarRetornoAFila(casosFluxoNovo, (Map<Id, Case>)Trigger.oldMap);
        CaseBO.validarRedefinicaoArvoreAssunto(casosFluxoNovo, (Map<Id, Case>)Trigger.oldMap);
        CaseBO.atribuirAceitoPor(casosFluxoNovo, (Map<Id, Case>)Trigger.oldMap);
        CaseBO.popularCampos((List<Case>)Trigger.new);
        CaseBO.setPriority(casosFluxoNovo, (Map<Id, Case>)Trigger.oldMap);
        CaseBO.validarUsuarioDaFilaAtual(casosFluxoAntigo, (Map<Id, Case>)Trigger.oldMap);
        CaseBO.validarCamposObrigatorios(casosFluxoAntigo);
        CaseBO.validarStatusCaso((List<Case>)Trigger.new, (Map<Id, Case>)Trigger.oldMap);
        CaseBo.atribuirGrupoSolucionadorAnterior((List<Case>)Trigger.new, (Map<Id, Case>)Trigger.oldMap);
        CaseBO.alterarEmAtuacao(casosFluxoAntigo);
        CaseUtil.contagem((List<Case>)Trigger.new,(Map<Id, Case>)Trigger.oldMap);
    }
    
    public override void afterUpdate() {
        Set<Id> ids = new Set<Id>();
        Set<Id> idsCriadosFechado = new Set<Id>();
        for(Case caso : (List<Case>)Trigger.new) {
            ids.add(caso.Id);
            if(caso.CriadoFechado__c) idsCriadosFechado.add(caso.Id);
        }
        
        /*if (System.isFuture() || System.isBatch())
            CaseBO.atribuirParaFilaBatch(ids);
        else*/
        if (!System.isFuture() && !System.isBatch()){
            CaseBO.atribuirParaFila(ids);
        }

        CaseBO.validarStatusAguardandoCliente(casosFluxoAntigo, (Map<Id, Case>)Trigger.oldMap);
        CaseBO.criarSLAs(casosFluxoAntigo, (Map<Id, Case>)Trigger.oldMap);
    }
     
    public override void beforeInsert() {  
        CaseBO.setDescriptionFieldChat(casosFluxoNovo);
        CaseBO.setContactBySuppliedEmail(casosFluxoNovo);
        CaseBO.validarClonarCaso(casosFluxoNovo);
        CaseBO.popularCampos((List<Case>)Trigger.new);
        CaseBO.setPriority(casosFluxoNovo, (Map<Id, Case>)Trigger.oldMap);
        CaseBO.validarCamposObrigatorios(casosFluxoAntigo);
        CaseBO.alterarEmAtuacao(casosFluxoAntigo); 
        CaseBO.validarStatusCaso((List<Case>)Trigger.new, (Map<Id, Case>)Trigger.oldMap);
    }
    
    public override void afterInsert() {
        Set<Id> ids = new Set<Id>();
        Set<Id> idsCriadosFechado = new Set<Id>();
        for(Case caso : (List<Case>)Trigger.new) {
            ids.add(caso.Id);
            if(caso.CriadoFechado__c) idsCriadosFechado.add(caso.Id);
        }
        /*if (System.isFuture() || System.isBatch())
            CaseBO.atribuirParaFilaBatch(ids);
        else */
        if (!System.isFuture() && !System.isBatch()){
            CaseBO.atribuirParaFila(ids);
        }

        CaseBO.criarSLAs(casosFluxoAntigo, null);

        if (!System.isFuture() && !System.isBatch()){
            CaseBO.tratarCasosAbertosFechado(idsCriadosFechado);
        }
    }
}