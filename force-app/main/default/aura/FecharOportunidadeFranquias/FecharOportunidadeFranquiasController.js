({
	doInit : function(cmp, event, helper) {
        helper.getOportunidade(cmp);
        helper.getClosedStages(cmp);
        helper.getMotivos(cmp);
        cmp.set("v.loading", true);
	}, 
    
    respostaConfirmacao : function(cmp, event, helper) {
        var message = event.getParam("message");
        if(message == 'Cancelar') { 
            helper.cancelar(cmp);
        } else if(message == 'Sim') {
            helper.integrarRDStation(cmp);
        }
    }, 
    
    salvar : function(cmp, event, helper) {
        cmp.set("v.loading", true);
        
        if(cmp.get("v.stage") == "Cancelada" && ($A.util.isUndefinedOrNull(cmp.get("v.motivoRecusa")) || $A.util.isEmpty(cmp.get("v.motivoRecusa")))) {
            helper.showToast("ERROR", "Erro", "Preencha o motivo da recusa.");
            cmp.set("v.loading", false);
            return;
        }
        
        $A.createComponent("c:Confirmation", {}, function(content, status) {
            if (status === "SUCCESS") {
                var modalBody = content;                   
                content.set('v.text', 'Deseja retornar esta oportunidade como um lead para a RDStation?');
                content.set('v.botaoCancelado', 'Cancelar');         
                content.set('v.botaoConfirmacao', 'Sim');
                cmp.find('overlayLib').showCustomModal({
                    header: "Retornar à RDStation?",
                    body: modalBody, 
                    showCloseButton: false,
                    closeCallback: function() {  
                    }
                });
            }
        });
    },
                                                              
    cancelar : function(cmp, event, helper) {
        helper.cancelar(cmp);
    },
})