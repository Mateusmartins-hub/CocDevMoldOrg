({
	doInit : function(cmp, event, helper) {
        var action = cmp.get('c.salvar');
        action.setParams({
            idObjeto : cmp.get('v.recordId')
        });
        action.setCallback(this, function(response){
            var state = response.getState();
            var toastEvent = $A.get("e.force:showToast");
            if(state === 'SUCCESS') {
                toastEvent.setParams({
                    "title": "Sucesso!",
                    "type": "success",
                    "message": "Amostra enviada."
                });
                toastEvent.fire();
                $A.get("e.force:closeQuickAction").fire()
            }else if (state === "ERROR") {
                toastEvent.setParams({
                    "title": "Erro!",
                    "type": "error",
                    "message": "Erro, contate o Tech."
                });
                toastEvent.fire();
                $A.get("e.force:closeQuickAction").fire()
            }
        });
        $A.enqueueAction(action);
	}
})