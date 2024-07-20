public with sharing class ContagemSegmentoHandler {
    private static final ContagemSegmentoHandler INSTANCE = new ContagemSegmentoHandler();
    public static ContagemSegmentoHandler getInstance(){
        return INSTANCE;
    }
    public void beforeInsert(){
        ContagemSegmentoUtil.validarSegmento((List<Contagem_de_alunos_por_segmento__c>) Trigger.new);
    }
}