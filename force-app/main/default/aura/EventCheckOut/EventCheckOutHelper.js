({
    realizaCheckout: function (cmp) {
        var action = cmp.get("c.BuscarFormulario");
        if (cmp.get("v.eventId") == undefined)
          cmp.set("v.eventId", cmp.get("v.recordId"));

        action.setParams({ idEvent: cmp.get("v.eventId") });
        action.setCallback(this, function (response) {
            var state = response.getState();

            var toastEvent = $A.get("e.force:showToast");
            if (state === 'SUCCESS') {
                var response = response.getReturnValue();

                if ($A.util.isUndefinedOrNull(response) || $A.util.isUndefinedOrNull(response.Perguntas)) {
                    toastEvent.setParams({
                        "title": "Sucesso",
                        "message": "Checkout realizado",
                        "type": "SUCCESS"
                    });

                    toastEvent.fire();

                    $A.get("e.force:closeQuickAction").fire();
                    $A.get('e.force:refreshView').fire();
                }
                else {
                    response.Perguntas.forEach(function (item) {
                        if (item.TipoResposta == 'Lista de opções única' || item.TipoResposta == 'Lista de opções múltipla') {
                            item.OpcoesResposta = [];

                            item.Opcoes.forEach(function (op) {
                                item.OpcoesResposta.push({ label: op, value: op });
                            });

                            if (item.OpcoesResposta.length > 0)
                                item.Resposta = item.OpcoesResposta[0];
                        }
                    });

                    cmp.set('v.titulo', response.Titulo);
                    cmp.set('v.perguntaRespostas', response.Perguntas);
                    cmp.set('v.formulario', response);
                    cmp.set('v.loading', false);
                }

            }
            else if (state === 'ERROR') {
                let message = "Ocorreu um erro inesperado, contate o administrador";

                let errors = response.getError();
                if (errors && Array.isArray(errors) && errors.length > 0)
                    message = errors[0].message;

                toastEvent.setParams({
                    "title": "Falha",
                    "message": message,
                    "type": "ERROR"
                });

                $A.get("e.force:closeQuickAction").fire();
                $A.get('e.force:refreshView').fire();

                toastEvent.fire();
            }
        });
        $A.enqueueAction(action);

    },
    
    enviarCheckList: function (cmp){
        var action = cmp.get("c.EnviarChecklistCliente");
        action.setParams({ idEvent: cmp.get("v.eventId") });

        action.setCallback(this, function (response) {
            var state = response.getState();

            var toastEvent = $A.get("e.force:showToast");
            if (state === 'SUCCESS') {
                var response = response.getReturnValue();
                toastEvent.setParams({
                    "title": "Sucesso",
                    "message": "Checklist Enviado",
                    "type": "SUCCESS"
                });
                toastEvent.fire();

                $A.get("e.force:closeQuickAction").fire();
                $A.get('e.force:refreshView').fire();
                const navEvt = $A.get("e.force:navigateToSObject");
                navEvt.setParams({
                "recordId": cmp.get('v.eventId')
                });
                navEvt.fire();
            } else if (state === 'ERROR') {
                let message = "Ocorreu um erro inesperado, contate o administrador";

                let errors = response.getError();
                if (errors && Array.isArray(errors) && errors.length > 0)
                    message = errors[0].message;

                toastEvent.setParams({
                    "title": "Falha",
                    "message": message,
                    "type": "ERROR"
                });

                toastEvent.fire();
            }
        });
        $A.enqueueAction(action);
    },

    salvar: function (cmp) {
        cmp.set('v.loading', true);
        var action = cmp.get("c.SalvarRespostas");

        var formulario = cmp.get("v.formulario");

        formulario.Perguntas.forEach(function (item) {
            item.OpcoesResposta = null;
            if (item.Resposta && item.Resposta.value)
                item.Resposta = item.Resposta.value;
        });
        action.setParams({
            idEvent: cmp.get("v.eventId"),
            form: formulario
        });
        action.setCallback(this, function (response) {
            var state = response.getState();

            var toastEvent = $A.get("e.force:showToast");
            if (state === 'SUCCESS') {
                var response = response.getReturnValue();

                if ($A.util.isUndefinedOrNull(response)) {
                    cmp.set('v.enviarChecklist', true);
                }
                else {
                    response.Perguntas.forEach(function (item) {
                        if (item.TipoResposta == 'Lista de opções única' || item.TipoResposta == 'Lista de opções múltipla') {
                            item.OpcoesResposta = [];

                            item.Opcoes.forEach(function (op) {
                                item.OpcoesResposta.push({ label: op, value: op });
                            });

                            if (item.OpcoesResposta.length > 0)
                                item.Resposta = item.OpcoesResposta[0];
                        }
                    });

                    cmp.set('v.formulario', response);
                }
                cmp.set('v.loading', false);
            }
            else if (state === 'ERROR') {
                let message = "Ocorreu um erro inesperado, contate o administrador";

                let errors = response.getError();
                if (errors && Array.isArray(errors) && errors.length > 0)
                    message = errors[0].message;

                toastEvent.setParams({
                    "title": "Falha",
                    "message": message,
                    "type": "ERROR"
                });

                toastEvent.fire();
            }

        });
         $A.enqueueAction(action);
    }
})