({
    buscaConta : function(cmp) {
        var action = cmp.get("c.GetObject");
        action.setParams({id : cmp.get("v.recordId")});
        action.setCallback(this, function(response) {
            var retorno = response.getReturnValue();

            cmp.set("v.objeto", retorno);

            if (!$A.util.isEmpty(retorno.Erro))
            {
                this.showToast("ERROR", "Falha", retorno.Erro);

                $A.get("e.force:closeQuickAction").fire();
            }
            else
            {
                this.buscaMetodoEnsino(cmp, retorno);
                cmp.set("v.name", retorno.Nome);
                cmp.set("v.email", retorno.Email);
            }
            
        });
        $A.enqueueAction(action);
    },

    buscaMetodoEnsino : function(cmp, objeto) {
        var action = cmp.get("c.GetFormulario");

        console.log('objeto ', objeto);

        action.setParams({metodoEnsino : objeto.SistemaEnsino});
        action.setCallback(this, function(response) {
            var retorno = response.getReturnValue();

            console.log('retorno ', retorno);

            if ($A.util.isUndefinedOrNull(retorno))
            {
                this.showToast("ERROR", "Falha", `Não existe formulário para o sistema de ensino "${objeto.SistemaEnsino}" cadastrado`);

                $A.get("e.force:closeQuickAction").fire();
            }
            else if ($A.util.isUndefinedOrNull(retorno.Amostras) || retorno.Amostras.length == 0)
            {
                this.showToast("ERROR", "Falha", "Nenhuma amostra virtual cadastrada no sistema de ensino");

                $A.get("e.force:closeQuickAction").fire();
            }
            else if (retorno.Amostras.length > 1)
            {
                let amostras = [];

                retorno.Amostras.forEach(function(item) {
                    amostras.push({label: item.Name, value: item.Id});
                });

                this.showToast("", "Selecione", "Selecione qual amostra virtual deseja enviar");
                cmp.set("v.amostras", amostras);
                cmp.set("v.formularioId", retorno.IdFormulario);
                cmp.set("v.loading", false);
            }
            else
            {
                cmp.set("v.formularioId", retorno.IdFormulario);
                cmp.set("v.amostraVirtual", retorno.Amostras[0].Id);
                this.validaEnvioPosterior(cmp, objeto, retorno.Amostras[0].Id);
            }
        });
        $A.enqueueAction(action);
    },

    validaEnvioPosterior : function(cmp, objeto, idProduto) {
        var action = cmp.get("c.ValidaEnvioPosterior");
        action.setParams({idObjeto : objeto.IdObjeto, 
                          idProduto : idProduto,
                          metodoEnsino : objeto.SistemaEnsino});
        action.setCallback(this, function(response) {

            if (response.getReturnValue() == true)
            {
                this.showToast("ERROR", "Falha", "Essa amostra já foi enviada para esse cliente");
                $A.get("e.force:closeQuickAction").fire();
            }
            else
            {                
                this.enviaEmail(cmp, objeto, cmp.get("v.formularioId"), cmp.get("v.amostraVirtual"));
            }
            
        });

        $A.enqueueAction(action);
    },

    enviaEmail : function(cmp, objeto, idFormulario, amostraVirtual) {
        var action = cmp.get("c.SendEmail");
        action.setParams({objeto : objeto, 
                          idFormulario : idFormulario,
                          amostra: amostraVirtual});
        action.setCallback(this, function(response) {
            this.showToast("SUCCESS", "Sucesso", "E-mail enviado");
            $A.get("e.force:closeQuickAction").fire();
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
    }
})