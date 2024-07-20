({
    buscarClienteSAP: function (cmp) {
        cmp.set("v.loading", true);
        var action = cmp.get("c.BuscarClienteSAP");
        action.setParams({ objectId: cmp.get("v.recordId") });
        action.setCallback(this, function (response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                var retorno = response.getReturnValue();
                if (!retorno)
                    this.showToast("success", "Sucesso", "Cliente encontrado e atualizado no Salesforce");
                else
                    this.showToast("error", "Erro", "Erro, verifique os logs.");
                $A.get("e.force:closeQuickAction").fire();
                $A.get("e.force:refreshView").fire();
            } else if (state === "ERROR") {
                let message = "Erro desconhecido";
                
                let errors = response.getError();
                if (errors && Array.isArray(errors) && errors.length > 0)
                    message = errors[0].message;
                
                this.showToast("error", "Erro", message);
                $A.get("e.force:closeQuickAction").fire();
                $A.get("e.force:refreshView").fire();
            }
        });
        $A.enqueueAction(action);
    },
    showToast: function (tipo, titulo, erro) {
        var toastEvent = $A.get("e.force:showToast");
        toastEvent.setParams({
            "title": titulo,
            "message": erro,
            "type": tipo
        });
        toastEvent.fire();
    },
})