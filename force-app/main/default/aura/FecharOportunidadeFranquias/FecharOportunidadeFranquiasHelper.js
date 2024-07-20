({    
    getOportunidade : function(cmp) {
        cmp.set("v.loading", true);
        const params = {idOportunidade : cmp.get("v.recordId")};
        
        var action = cmp.get("c.getOportunidade");
        action.setParams(params);
        action.setCallback(this, function (response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                var retorno = response.getReturnValue();
                if(retorno.IsClosed) {
                    this.showToast("ERROR", "Erro", "Oportunidade já está fechada.");
                    this.refreshAndClose(cmp);
                }else{
                    cmp.set("v.loading", false);
                }
            } else if (state === "ERROR") {
                this.buildError(response.getError());
                this.refreshAndClose(cmp);
            }
        });
        
        $A.enqueueAction(action);
    },
    
    getMotivos : function(cmp) {
        cmp.set("v.loading", true);
        const params = {};
        
        var action = cmp.get("c.getMotivos");
        action.setParams(params);
        action.setCallback(this, function (response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                var retorno = response.getReturnValue(); 
                let motivos = [];
                
                retorno.forEach(function(item) {
                    motivos.push({label : item, value : item});    
                });
                
                cmp.set("v.motivos", motivos);
                cmp.set("v.loading", false);
            } else if (state === "ERROR") {
                this.buildError(response.getError());
                this.refreshAndClose(cmp);
            }
        });
        
        $A.enqueueAction(action);
    },
    
    getClosedStages : function(cmp) {
        cmp.set("v.loading", true);
        const params = {};
        
        var action = cmp.get("c.getClosedStages");
        action.setParams(params);
        action.setCallback(this, function (response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                var retorno = response.getReturnValue(); 
                let closedStages = [];
                
                retorno.forEach(function(item) {
                    closedStages.push({label : item, value : item});    
                });
                
                cmp.set("v.closedStages", closedStages);
                cmp.set("v.loading", false);
            } else if (state === "ERROR") {
                this.buildError(response.getError());
                this.refreshAndClose(cmp);
            }
        });
        
        $A.enqueueAction(action);
    },
        
    integrarRDStation : function(cmp) {
        cmp.set("v.loading", true);    
        const params = {
            idOportunidade : cmp.get("v.recordId"), 
            stage : cmp.get("v.stage"), 
            motivoRecusa : (cmp.get("v.stage") == "Cancelada" ? cmp.get("v.motivoRecusa") : "")
        };
        
        var action = cmp.get("c.saveAndIntegrateRDStation");
        action.setParams(params);
        action.setCallback(this, function (response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                this.showToast("SUCCESS", "Sucesso", "Oportunidade fechada com sucesso e lead criado na RDStation.");
                this.refreshAndClose(cmp);
            } else if (state === "ERROR") {
                this.buildError(response.getError());
                this.refreshAndClose(cmp);
            }
        });
        
        $A.enqueueAction(action);
    },
    
    buildError : function(errors) {
        let message = "Erro desconhecido";
        
        if (errors && Array.isArray(errors) && errors.length > 0)
            message = errors[0].message;
        
        this.showToast("error", "Erro", message);
    },
    
    refreshAndClose : function(cmp) {
        $A.get('e.force:refreshView').fire();
        $A.get("e.force:closeQuickAction").fire();  
    },
    
    showToast : function(tipo, titulo, erro) {
        var toastEvent = $A.get("e.force:showToast");
        toastEvent.setParams({
            "title": titulo,   
            "message": erro,
            "type": tipo
        }); 
        toastEvent.fire();
    },
    
    cancelar : function(cmp) {
        $A.get("e.force:closeQuickAction").fire();
    }
})