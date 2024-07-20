public class LayoutCasoDAO {
    public static LayoutCaso__c BuscaLayoutTelaCaso(Id idTelaCaso) 
    {
        return [SELECT Id, Name, CamposLayout__c, GruposSolucionadores__c, CasosAntigos__c,
                (SELECT Id, Name, CamposSessao__c FROM SessoesLayoutCaso__r)
                FROM LayoutCaso__c WHERE Id = :idTelaCaso];
    }
    
    public static List<LayoutCaso__c> BuscarTodosLayouts()
    {
        return [SELECT Id, Name, CamposLayout__c, GruposSolucionadores__c, CasosAntigos__c,
                (SELECT Id, Name, CamposSessao__c FROM SessoesLayoutCaso__r)
                FROM LayoutCaso__c];
    }
    
    public static LayoutCaso__c BuscarLayoutCasoAntigo() {
        List<LayoutCaso__c> layout = [SELECT Id, Name, CamposLayout__c, GruposSolucionadores__c, CasosAntigos__c,
                                      (SELECT Id, Name, CamposSessao__c FROM SessoesLayoutCaso__r) 
                                      FROM LayoutCaso__c 
                                      WHERE CasosAntigos__c = true];
        
        return layout.isEmpty() ? null : layout[0];
    }
    
    public static LayoutCaso__c BuscarLayoutsPorGrupoSolucionador(string grupo)
    {
        List<LayoutCaso__c> layout = [SELECT Id, Name, CamposLayout__c, GruposSolucionadores__c, CasosAntigos__c,
                                      (SELECT Id, Name, CamposSessao__c FROM SessoesLayoutCaso__r) 
                                      FROM LayoutCaso__c 
                                      WHERE GruposSolucionadores__c INCLUDES (:grupo)];    
        system.debug('vazio ?' + layout);
        return layout.isEmpty() ? BuscaLayoutPadrao() : layout[0];
    }
    
    public static LayoutCaso__c BuscaLayoutPadrao()
    {
        List<LayoutCaso__c> layout = [SELECT Id, Name, CamposLayout__c, GruposSolucionadores__c, CasosAntigos__c,
                                      (SELECT Id, Name, CamposSessao__c FROM SessoesLayoutCaso__r) 
                                      FROM LayoutCaso__c 
                                      WHERE GruposSolucionadores__c = null];
        system.debug('padrao' + layout);
        return layout.isEmpty() ? null : layout[0];
    }
}