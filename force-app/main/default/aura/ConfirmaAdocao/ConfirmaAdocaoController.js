({
    doInit: function(component, event, helper) {
        helper.buscaOportunidade(component);
    },

    respostaConfirmacao : function(cmp, event, helper) {
        var message = event.getParam("message");
        if(message == 'Visita de Expansão') {
            cmp.set('v.TipoVisita', 'VisitaExpansao');
        } else if(message == 'Visita Pedagógica') {
            cmp.set('v.TipoVisita', 'VisitaPedagogica');
        }
    }, 
    
    respostaConfirmacao : function(cmp, event) {

        var message = event.getParam("message");
        if(message == 'Sim')
        {
            var action = cmp.get("c.ConfirmaAdocao");
            action.setParams({idOportunidade : cmp.get("v.recordId")});
            action.setCallback(this, function(response) {
                var toastEvent = $A.get("e.force:showToast");
                toastEvent.setParams({
                    "title": "Sucesso", 
                    "message": "Adoção confirmada",
                    "type": "SUCCESS"
                }); 
                toastEvent.fire();
                
                $A.get("e.force:closeQuickAction").fire();
                $A.get('e.force:refreshView').fire();
            });
            $A.enqueueAction(action);
        }
        else if(message == 'Não')
        {
            $A.get("e.force:closeQuickAction").fire();
        }
    }
})