({
    getEmails: function (cmp) {
        var action = cmp.get('c.getEmails');
        action.setCallback(this, function (response) {
            var state = response.getState();
            if (state === 'SUCCESS') {
                var retorno = response.getReturnValue();
                var emails = [];

                retorno.forEach(function (item) {
                    emails.push({
                        value: item.Id,
                        label: item.Name
                    });
                });

                cmp.set('v.modelosEmails', emails);
            } else if (state === "ERROR") {
                this.showToast('error', 'Erro', 'Erro, contate o Tech.');
            }
        });
        $A.enqueueAction(action);
    },

    enviar: function (cmp) {
        if ($A.util.isUndefinedOrNull(cmp.get('v.modeloEmail'))) {
            this.showToast('error', 'Erro', 'Selecione um modelo de e-mail');
            return;
        }
        var action = cmp.get('c.enviarEmail');
        action.setParams({
            idProcesso: cmp.get('v.recordId'),
            idTemplate: cmp.get('v.modeloEmail')
        });
        action.setCallback(this, function (response) {
            var state = response.getState();
            if (state === 'SUCCESS') {
                $A.get('e.force:closeQuickAction').fire();
                this.showToast('success', 'Sucesso', 'E-mail enviado com sucesso');
            } else if (state === "ERROR") {
                var message = "Erro, contate o Tech.";

                let errors = response.getError();
                if (errors && Array.isArray(errors) && errors.length > 0)
                    message = errors[0].message;

                this.showToast('error', 'Erro', message);
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