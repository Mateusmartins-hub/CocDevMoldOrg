({
    getBaseURL: function (cmp) {
        var url = location.href;
        var baseURL = url.substring(0, url.indexOf('/', 14));  
        cmp.set("v.baseURL", baseURL + "/");
    },
    
    salvar : function(component)
    {
        var layoutCaso = component.get("v.layoutCaso");
        
        var camposSelecionados = component.get("v.camposCasoSelecionados");
        var gruposSelecionados = component.get("v.gruposSelecionados");
        
        layoutCaso.Id = component.get("v.recordId");
        layoutCaso.CamposLayout__c = camposSelecionados.join(";");
        layoutCaso.GruposSolucionadores__c = gruposSelecionados.join(";");
        layoutCaso.CasosAntigos__c = component.get("v.casosAntigos");
        
        var action = component.get("c.salvarLayout");
                
        action.setParams({
            "layoutCaso": layoutCaso
        });
        
        action.setCallback(this, function(response) {
            var state = response.getState();
            
            if (state === "SUCCESS")
            {
                this.exibeMensagemSucesso();
                layoutCaso.Id = response.getReturnValue();
                console.log(response.getReturnValue());
                console.log(layoutCaso.Id);
                
                var url = location.href;  // entire url including querystring - also: window.location.href;7
                var link = url.substring(0, url.indexOf('/', 14)) + '/' + layoutCaso.Id;
                console.log(link);
                window.location.href = link;
            }
            else if (state === "ERROR")
            {
                this.exibeMensagemErro(response.getError());
            }
            
            this.carregado(component);
        });

        $A.enqueueAction(action);       
    },
    clonar : function(component)
    {
        var layoutCaso = component.get("v.layoutCaso");
        
        var camposSelecionados = component.get("v.camposCasoSelecionados");
        var gruposSelecionados = component.get("v.gruposSelecionados");
        
        layoutCaso.CamposLayout__c = camposSelecionados.join(";");
        layoutCaso.GruposSolucionadores__c = gruposSelecionados.join(";");
        
        var action = component.get("c.clonarLayout");
                
        action.setParams({
            "layoutCaso": layoutCaso
        });
        
        action.setCallback(this, function(response) {
            var state = response.getState();
            
            if (state === "SUCCESS")
            {
                layoutCaso = response.getReturnValue();
                component.set("v.recordId", null);
                component.set("v.gruposSelecionados", []);
                component.set("v.camposCasoSelecionados", layoutCaso.CamposLayout__c.split(";"));
                
            }
            else if (state === "ERROR")
            {
                this.exibeMensagemErro(response.getError());
            }
            
            this.carregado(component);
        });

        $A.enqueueAction(action);       
    },
	listarCamposCaso : function(component) 
    {
		var action = component.get("c.getCamposCaso");
        
        action.setCallback(this, function(response){
            var retorno = response.getReturnValue();
            
            var campos = [];
            for (var key in retorno) {
                if (retorno.hasOwnProperty(key)) {
                    campos.push({value: key, label: retorno[key]});
                }
            }
                        
            component.set("v.camposCaso", campos);
            this.buscarCaso(component); 
        });
        
        $A.enqueueAction(action);
	},
    listarGruposSolucionadores : function(component)
    {
    	var action = component.get("c.getGruposSolucionadores");

        action.setCallback(this, function(response){
            var retorno = response.getReturnValue();
            
            var grupos = [];
            for (var key in retorno) {
                if (retorno.hasOwnProperty(key)) {
                    grupos.push({value: key, label: retorno[key]});
                }
            }
            
            component.set("v.grupos", grupos);
        });
        
        $A.enqueueAction(action);
	},
    buscarCaso : function(component)
    {
        var id = component.get("v.recordId");
        
        var action = component.get("c.getLayoutCaso");
        
        if (id)
        {
            action.setParams({
                "idTela": id
            });
        }
        
        action.setCallback(this, function(response){
            var layout = response.getReturnValue();
            component.set("v.layoutCaso", layout);
            
            var camposSelecionados = [];
            var camposCaso = component.get("v.camposCaso");
            
            if(!$A.util.isUndefined(layout.SessoesLayoutCaso__r) && !$A.util.isEmpty(layout.SessoesLayoutCaso__r)) {
                layout.SessoesLayoutCaso__r.forEach(function(element) {
                    var nome = '===' + element.Name + '===';
                    
                    camposCaso.push({value : nome, label : nome});
                    camposSelecionados.push(nome);
                    if(!$A.util.isUndefined(element.CamposSessao__c) && !$A.util.isEmpty(element.CamposSessao__c)) {
                        element.CamposSessao__c.split(';').forEach(function(element2) {
                            camposSelecionados.push(element2);
                        });
                    }
                });
            }
            
            component.set("v.camposCasoSelecionados", camposSelecionados);
            component.set("v.camposCaso", camposCaso); 
			component.set("v.casosAntigos", layout.CasosAntigos__c);
            if(layout.CasosAntigos__c) {
                component.set("v.labelButtonCasosAntigos", "Desabilitar para Casos Antigos");
            }else{
                component.set("v.labelButtonCasosAntigos", "Habilitar para Casos Antigos");
            }
            if (layout != null && layout.GruposSolucionadores__c != null)
            	component.set("v.gruposSelecionados", layout.GruposSolucionadores__c.split(";"));
            
        	this.carregado(component);
        });
        
        $A.enqueueAction(action);
    },
    inserirSessao : function(component) 
    {
        var camposSelecionados = component.get("v.camposCasoSelecionados");
        var camposCaso = component.get("v.camposCaso");
        
        var nome = '===' + component.get("v.sessaoNome") + '===';
        if(!$A.util.isUndefined(nome) 
           && !$A.util.isEmpty(nome)
           && !camposSelecionados.includes(nome)) {
            camposCaso.push({ value: nome, label: nome });
            camposSelecionados.push(nome);
        }
        
        component.set("v.camposCaso", camposCaso);
        component.set("v.camposCasoSelecionados", camposSelecionados);
    },
    fetchRecords : function(component,event, helper) {
        var action = component.get("c.fetchOpptyRecords");
        action.setParams({
        });
        action.setCallback(this, function(resp) {
            var state=resp.getState();
            console.log('state ' + state);
            if(state === "SUCCESS"){
                var res = resp.getReturnValue();
                var opptylist = [];
                var key;
                for(key in res){
                    opptylist.push({key: key, value: res[key]});
                }
                component.set("v.Opportunities", opptylist);
                console.log(opptylist);
            }
        });
        $A.enqueueAction(action);
    },
    popularMapCampos : function(component, lista) 
    {
        var action = component.get("c.popularMapCampos");
        
        action.setParams({
            "lista": lista
        });
        
        action.setCallback(this, function(response){
            var res = response.getReturnValue();
            var camposPorSessao = [];
            var key;
            for(key in res){
                camposPorSessao.push({key: key, value: res[key]});
            }
            component.set("v.camposPorSessao", camposPorSessao);
            
            this.carregado(component);
        });
        
        $A.enqueueAction(action);
    },
    desabilitarCasosAntigos : function(cmp) {
        cmp.set("v.casosAntigos", false);
        cmp.set("v.labelButtonCasosAntigos", "Habilitar para Casos Antigos");
    },
    habilitarCasosAntigos : function(cmp) {
        cmp.set("v.casosAntigos", true);
        cmp.set("v.labelButtonCasosAntigos", "Desabilitar para Casos Antigos");
    },
    exibeMensagemErro : function(errors)
    {            
        var toastParams = {
            title: "Erro",
            message: "Ocorreu um erro inesperado",
            type: "error"
        };
        
        if (errors && Array.isArray(errors) && errors.length > 0) {
            toastParams.message = errors[0].message;
        }
        
        var toastEvent = $A.get("e.force:showToast");
        
        if (toastEvent)
        {
            toastEvent.setParams(toastParams);
        	toastEvent.fire();
        }
        else
        {
            alert(toastParams.message);
        }
	},
    exibeMensagemSucesso : function()
    {
        var toastParams = {
            title: "Sucesso",
            message: "Dados atualizados com sucesso",
            type: "success"
        };
        
        var toastEvent = $A.get("e.force:showToast");
        
        if (toastEvent)
        {
            toastEvent.setParams(toastParams);
        	toastEvent.fire();
        }
        else
        {
            alert(toastParams.message);
        }
    },
    carregando : function(component) 
    {
        component.set("v.loading", true);
    },
    carregado : function(component) 
    {
        component.set("v.loading", false);
    }
})