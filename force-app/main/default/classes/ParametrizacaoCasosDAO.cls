public class ParametrizacaoCasosDAO {

    public static Map<string, Map<string, Map<string, Map<string, ParametrizacaoCasos__c>>>> mapearParametrizacoesByCampos(List<String> tipos, List<String> subtipos, List<String> detalhamentos, List<String> detalhamentos2) {
        Map<string, Map<string, Map<string, Map<string, ParametrizacaoCasos__c>>>> mapParametrizacao = new Map<string, Map<string, Map<string, Map<string, ParametrizacaoCasos__c>>>>();
        
        List<ParametrizacaoCasos__c> listParam = [SELECT Id, AreaDonaProcesso__c, Identificador__c, Tipo__c, Subtipo__c, Detalhamento__c, Detalhamento2__c, CasoAtuacao__c
                                                  FROM ParametrizacaoCasos__c 
                                                  WHERE Tipo__c IN: tipos AND Subtipo__c IN: subtipos AND Detalhamento__c IN: detalhamentos AND Detalhamento2__c IN: detalhamentos2
                                                  AND RecordType.Name != 'Padrão'];
        
        for(ParametrizacaoCasos__c p : listParam) {
            if (!mapParametrizacao.containsKey(p.Tipo__c)) 
                mapParametrizacao.put(p.Tipo__c, new Map<string, Map<string, Map<string, ParametrizacaoCasos__c>>>());
            
            if (!mapParametrizacao.get(p.Tipo__c).containsKey(p.Subtipo__c)) 
                mapParametrizacao.get(p.Tipo__c).put(p.Subtipo__c, new Map<string, Map<string, ParametrizacaoCasos__c>>());
            
            if (!mapParametrizacao.get(p.Tipo__c).get(p.Subtipo__c).containsKey(p.Detalhamento__c)) 
                mapParametrizacao.get(p.Tipo__c).get(p.Subtipo__c).put(p.Detalhamento__c, new Map<string, ParametrizacaoCasos__c>());
            
            if (!mapParametrizacao.get(p.Tipo__c).get(p.Subtipo__c).get(p.Detalhamento__c).containsKey(p.Detalhamento2__c)) 
                mapParametrizacao.get(p.Tipo__c).get(p.Subtipo__c).get(p.Detalhamento__c).put(p.Detalhamento2__c, p);
        }
        
        return mapParametrizacao;
    }
}