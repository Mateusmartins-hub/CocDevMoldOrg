({
	doInit : function(cmp, event, helper) {
		helper.getDates(cmp, event);
	},
    
    cancelar : function(cmp, event, helper) {
        helper.cancelar(cmp);
    },
    
    setHorarios : function(cmp, event, helper) {
        helper.setHorarios(cmp);
    },
    
    setHorarioApresentacao : function(cmp, event, helper) {
        helper.setHorarioApresentacao(cmp);
    },
    
    respostaConfirmacao : function(cmp, event, helper) {
        var message = event.getParam("message");
        if(message == 'Visita de Expansão') {
            cmp.set('v.TipoVisita', 'VisitaExpansao');
            cmp.set('v.loading', false);
        } else if(message == 'Visita Pedagógica') {
            cmp.set('v.TipoVisita', 'VisitaPedagogica');
            cmp.set('v.loading', false);
        }
    }, 
    
    enviar : function(cmp, event, helper) {
       helper.enviar(cmp);
    }
})