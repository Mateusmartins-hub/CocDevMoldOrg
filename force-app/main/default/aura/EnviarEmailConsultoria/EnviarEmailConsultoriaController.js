({
    doInit : function(cmp, event, helper) {
        var action = cmp.get("c.EnviarEmail");
        action.setParams({idConsultoria : cmp.get("v.recordId")});
        action.setCallback(this, function(response) {

            var retorno = response.getReturnValue();
            
            var toastEvent = $A.get("e.force:showToast");
            if (retorno == 'sucesso')
            {
                toastEvent.setParams({
                    "title": "Sucesso",
                    "message": "Email enviado com sucesso!",
                    "type": "SUCCESS"
                });
            }
            else
            {
                toastEvent.setParams({
                    "title": "Falha",
                    "message": "Erro ao enviar email: " + retorno,
                    "type": "ERROR"
                });
            }
			
			toastEvent.fire();
			
			$A.get("e.force:closeQuickAction").fire();

        });
        $A.enqueueAction(action);
    }
})