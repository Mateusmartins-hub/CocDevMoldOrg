public class LayoutCasoBO 
{
    public static void Validar(List<LayoutCaso__c> layouts)
    {
        ValidarCasosAntigos(layouts);
        ValidarLayoutPadrao(layouts);
        ValidarCamposLayout(layouts);
        ValidarCamposObrigatorios(layouts);
        ValidarGruposSolucionadores(layouts);
        ValidarPickListsDependentes(layouts);
    }
    
    public static void ValidarCasosAntigos(List<LayoutCaso__c> layouts) {
        List<LayoutCaso__c> layoutsGrupos = LayoutCasoDAO.BuscarTodosLayouts();
        Map<Id, LayoutCaso__c> mapLayoutsAntigos = new Map<Id, LayoutCaso__c>();
        
        Boolean casosAntigos = false;
        Boolean possuiCasoAntigo = false;
        
        for (LayoutCaso__c l : layouts) {
            if(l.CasosAntigos__c)
                casosAntigos = true;
        }
        
        for (LayoutCaso__c l : layoutsGrupos) {
            if(l.CasosAntigos__c) {
                possuiCasoAntigo = true;
                mapLayoutsAntigos.put(l.Id, l);
            }
        }
        
        for (LayoutCaso__c l : layouts) {
            if(l.CasosAntigos__c && possuiCasoAntigo && !mapLayoutsAntigos.containsKey(l.Id))
                l.addError('Já existe um Layout para Casos Antigos');
        }
    }
    
    public static void ValidarExclusao(List<LayoutCaso__c> layouts)
    {
        for (LayoutCaso__c l : layouts)
        {
            if (l.GruposSolucionadores__c == null)
                l.addError('Não é possível excluir o layout padrão.');
        }
    }
    
    private static void ValidarPickListsDependentes(List<LayoutCaso__c> layouts)
    {
        SObjectType objToken = Schema.getGlobalDescribe().get('Case');
        DescribeSObjectResult objDef = objToken.getDescribe();
        Map<String, SObjectField> fields = objDef.fields.getMap(); 
        
        for(LayoutCaso__c l : layouts)
        {
            Set<string> camposLayout = new Set<string>(l.CamposLayout__c.split(';'));
            
            for (string campo : l.CamposLayout__c.split(';'))
            {
                if(!campo.contains('=')) {
                    SObjectField fieldToken = fields.get(campo);
                    DescribeFieldResult selectedField;
                    try{
                        selectedField = fieldToken.getDescribe();
                    }catch(Exception e){
                        throw new CustomException('Campo não encontrado');
                    }
                    
                    if (selectedField.isDependentPicklist() && !camposLayout.contains(selectedField.getController().getDescribe().getName()))
                    {
                        l.addError('O campo: "' + selectedField.label + '" é dependente do campo: "' + selectedField.getController().getDescribe().label + '", insira-o no layout também.');
                    }
                }
            }
        }
    }
    
    private static void ValidarGruposSolucionadores(List<LayoutCaso__c> layouts)
    {
        List<LayoutCaso__c> layoutsGrupos = LayoutCasoDAO.BuscarTodosLayouts();
        
        Map<string, Id> mapGrupo = new Map<string, Id>();
        for(LayoutCaso__c l : layoutsGrupos)
        {
            
            if (l.GruposSolucionadores__c == null)
                continue;
            
            for (string g : l.GruposSolucionadores__c.split(';'))
            {
                mapGrupo.put(g, l.Id);
            }
                
        }
        
        for (LayoutCaso__c l : layouts)
        {
            if (l.GruposSolucionadores__c == null)
                continue;
            
            for (string g : l.GruposSolucionadores__c.split(';'))
            {
                if (mapGrupo.containsKey(g) && mapGrupo.get(g) != l.Id)
                    l.addError('Já existe um layout cadastrado para o grupo solucionador: ' + g);
            }   
        }
    }
    
	private static void ValidarLayoutPadrao(List<LayoutCaso__c> layouts)
    {
        LayoutCaso__c layout = LayoutCasoDAO.BuscaLayoutPadrao();
        
        boolean cadastrandoLayoutPadrao = false;
        Set<Id> idsLayouts = new Set<Id>();
        for (LayoutCaso__c l : layouts)
        {
            if (l.GruposSolucionadores__c != null)
                idsLayouts.add(l.Id);
            else if (layout != null && layout.Id != l.Id && !l.CasosAntigos__c)
                l.addError('Só pode existir um único layout padrão');
            else
                cadastrandoLayoutPadrao = true;
        }
        
        if (!cadastrandoLayoutPadrao)
        {
            if (layout == null)
            {
                for (LayoutCaso__c l : layouts)
                    l.addError('É necessário cadastrar um layout padrão');
            }
            else if (idsLayouts.contains(layout.Id))
            {
                for (LayoutCaso__c l : layouts)
                    l.addError('É necessário cadastrar um layout padrão');
            }
        }
    }
    
    private static void ValidarCamposLayout(List<LayoutCaso__c> layouts)
    {
        for (LayoutCaso__c l : layouts)
        {
            if (l.CamposLayout__c == null)
                l.addError('É necessário inserir ao menos um campo no layout');
        }
    }    
    
    private static void ValidarCamposObrigatorios(List<LayoutCaso__c> layouts)
    {
        SObjectType objToken = Schema.getGlobalDescribe().get('Case');
        DescribeSObjectResult objDef = objToken.getDescribe();
        Map<String, SObjectField> fields = objDef.fields.getMap(); 
        
        Set<String> fieldSet = fields.keySet();
        
        Map<string, string> camposObrigatorios = new Map<string, string>();
        for(String s : fieldSet)
        {
            SObjectField fieldToken = fields.get(s);
            DescribeFieldResult selectedField = fieldToken.getDescribe();
            
            if (selectedField.isCreateable()  && !selectedField.isNillable() && !selectedField.isDefaultedOnCreate() && selectedField.isCustom())
                camposObrigatorios.put(selectedField.getName(), selectedField.label);
        }
        
        for (LayoutCaso__c l : layouts)
        {
            if (l.CamposLayout__c == null)
                continue;
            
            List<string> camposFaltantes = new List<string>();
            
            for (string co : camposObrigatorios.keySet())
            {
                if (!l.CamposLayout__c.contains(co))
                    camposFaltantes.add(camposObrigatorios.get(co));
            }
            
            if (!camposFaltantes.isEmpty())
            {
                l.addError('Todos os campos obrigatórios deveme estar no layout, campos faltantes: (' + String.join(camposFaltantes, ', ') + ')');
            }      
        }
    }
    
    public class CustomException extends Exception {}

}