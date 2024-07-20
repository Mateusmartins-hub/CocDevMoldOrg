({
    integrarAmostra: function (cmp) {
        var integrarAmostra = cmp.get("c.integrarAmostraFisica");
        integrarAmostra.setParams({ idAmostra: cmp.get("v.recordId") })
        integrarAmostra.setCallback(this, function (response) {
            var state = response.getState();

            if (state === "SUCCESS") {
                var retorno = response.getReturnValue();
                if (!retorno)
                    this.showToast("Sucesso", "Amostra autorizada", "success");
                /*else if (retorno == 'Cliente não encontrado') {
                    $A.createComponent("c:BuscarClienteSAP", {recordId: cmp.get("v.recordId")}, function(content, status) {
                        if (status === "SUCCESS") {
                            var modalBody = content;                   
                            content.set('v.recordId', cmp.get("v.recordId"));
                        }
                    });
                    }*/
                else
                    this.showToast("Erro", "Erro, verifique os logs.", "error");
                
                $A.get("e.force:closeQuickAction").fire();
                $A.get("e.force:refreshView").fire();
            } else if (state === "ERROR") {
                let message = "Erro desconhecido";

                let errors = response.getError();
                if (errors && Array.isArray(errors) && errors.length > 0)
                    message = errors[0].message;

                this.showToast("Erro", message, "error");
                $A.get("e.force:closeQuickAction").fire();
                $A.get("e.force:refreshView").fire();
            }
        });
        $A.enqueueAction(integrarAmostra);
    },

    showToast: function (title, message, type) {
        let toastParams = { title: title, message: message, type: type };
        let toastEvent = $A.get("e.force:showToast");
        toastEvent.setParams(toastParams);
        toastEvent.fire();
    }
})