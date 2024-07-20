public class LayoutTelaCasoController {
	@AuraEnabled
    public static Map<string, string> getCamposCaso() 
    {
        SObjectType objToken = Schema.getGlobalDescribe().get('Case');
        DescribeSObjectResult objDef = objToken.getDescribe();
        Map<String, SObjectField> fields = objDef.fields.getMap(); 
        
        Set<String> fieldSet = fields.keySet();
        
        Map<string, string> camposOrderMap = new Map<string, string>();
        Map<string, string> camposMap = new Map<string, string>();
        
        for(String s : fieldSet)
        {
            SObjectField fieldToken = fields.get(s);
            DescribeFieldResult selectedField = fieldToken.getDescribe();
            string apiName = selectedField.getName();
            
            camposOrderMap.put(selectedField.label + apiName, apiName);
            camposMap.put(apiName, selectedField.label);
        }
        
        List<string> keys = new List<string>(camposOrderMap.keySet());
        keys.sort();
        
        Map<string, string> mapOrdenado = new Map<string, string>();
        for (string v : keys)
            mapOrdenado.put(camposOrderMap.get(v), camposMap.get(camposOrderMap.get(v)));
        
        return mapOrdenado;
    }
     
    @AuraEnabled
    public static Id salvarLayout(LayoutCaso__c layoutCaso)
    {       
        try
        {            
            upsert layoutCaso;
            
            List<SessaoLayoutCaso__c> sessoesInsert = new List<SessaoLayoutCaso__c>();
            
            String sessaoAtual = '';
            Map<String, List<String>> mapCamposPorSessao = new Map<String, List<String>>();
            List<String> camposLayout = layoutCaso.CamposLayout__c.split(';');
            
            for(String campo : camposLayout) {
                if(campo.contains('=')) {
                    campo = campo.replace('=', '');
                    sessaoAtual = campo;
                    mapCamposPorSessao.put(campo, new List<String>());
                }else{
                    campo = campo.replace('=', '');
                    if(camposLayout[0].replace('=', '') == campo) {
                        sessaoAtual = 'Detalhes do caso';
                        mapCamposPorSessao.put(sessaoAtual, new List<String>());
                    }
                    
                    mapCamposPorSessao.get(sessaoAtual).add(campo);
                }
            }
            
            for(String sessaoNome : mapCamposPorSessao.keySet()) {
                SessaoLayoutCaso__c sessao = new SessaoLayoutCaso__c();
                sessao.Name = sessaoNome;
                sessao.LayoutCaso__c = layoutCaso.Id;
                sessao.CamposSessao__c = String.join(mapCamposPorSessao.get(sessaoNome), ';');
                sessoesInsert.add(sessao);
            }
            
            List<SessaoLayoutCaso__c> sessoesExistentes = [SELECT Id FROM SessaoLayoutCaso__c WHERE LayoutCaso__c =: layoutCaso.Id];
            if(sessoesExistentes.size() > 0)
                delete sessoesExistentes;
            
            if(sessoesInsert.size() > 0)
                insert sessoesInsert;
            
            return layoutCaso.Id;
        }
        catch (Exception e)
        {            
            throw new AuraHandledException(e.getMessage().subStringBetween(',', ': ['));
        }
    }
    
    @AuraEnabled
    public static LayoutCaso__c clonarLayout(LayoutCaso__c layoutCaso)
    {       
        try
        {
            LayoutCaso__c layoutCasoClone = layoutCaso.clone(false, true, false, false);
            
            return layoutCasoClone;
        }
        catch (Exception e)
        {            
            throw new AuraHandledException(e.getMessage().subStringBetween(',', ': ['));
        }
    }
    
    @AuraEnabled
    public static LayoutCaso__c getLayoutCaso(Id idTela)
    {
        if (idTela == null)
            return new LayoutCaso__c();
        
        return LayoutCasoDAO.BuscaLayoutTelaCaso(idTela);
    }
    
    @AuraEnabled
    public static Map<String, List<String>> popularMapCampos(List<String> lista)
    {
        Map<String, List<String>> mapRetorno = new Map<String, List<String>>();
        String sessaoAtual = '';
        for(String valor : lista) {
            if(valor.contains('=')) {
                sessaoAtual = valor.replace('=', '');
                mapRetorno.put(valor.replace('=', ''), new List<String>());
            }else{
                valor = valor.replace('=', '');
                if(lista[0].replace('=', '') == valor) {
                    sessaoAtual = 'Detalhes do caso';
                    mapRetorno.put(sessaoAtual, new List<String>());
                }
                
                mapRetorno.get(sessaoAtual).add(valor);
            }
        }
        
        return mapRetorno;
    }
    
    @AuraEnabled
    public static Map<string, string> getGruposSolucionadores()
    {        
        Map<string, string> valores = new Map<string, string>();
        
        Schema.DescribeFieldResult fieldResult = LayoutCaso__c.GruposSolucionadores__c.getDescribe();
        List<Schema.PicklistEntry> ple = fieldResult.getPicklistValues();
        for(Schema.PicklistEntry pickListVal : ple) 
        {
            valores.put(pickListVal.getValue(), pickListVal.getLabel());
        }
        
        return valores;
    }
}