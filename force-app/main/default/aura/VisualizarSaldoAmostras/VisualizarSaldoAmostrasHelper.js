({
	setUsuarioOwner : function(cmp) {
		cmp.set("v.loading", true);
        var action = cmp.get('c.getUsuarioOwner');
        action.setParams({amostraId : cmp.get('v.recordId')});
        action.setCallback(this, function(response){
            var state = response.getState();
            if(state === 'SUCCESS') {
                var retorno =  response.getReturnValue();
                
                cmp.set("v.loading", false);
                cmp.set("v.usuarioOwner", retorno);
            }else if (state === "ERROR") {
                this.showToast('error', 'Erro', 'Erro, contate o Tech.');
                cmp.set("v.loading", false);
            }
        });
        $A.enqueueAction(action);
	},
    
	setUsuarioLogado : function(cmp) {
		cmp.set("v.loading", true);
        var action = cmp.get('c.getUsuarioLogado');
        action.setParams({amostraId : cmp.get('v.recordId')});
        action.setCallback(this, function(response){
            var state = response.getState();
            if(state === 'SUCCESS') {
                var retorno =  response.getReturnValue();
                
                cmp.set("v.loading", false);
                cmp.set("v.usuarioLogado", retorno);
            }else if (state === "ERROR") {
                this.showToast('error', 'Erro', 'Erro, contate o Tech.');
                cmp.set("v.loading", false);
            }
        });
        $A.enqueueAction(action);
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
})