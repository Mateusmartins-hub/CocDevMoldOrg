({
    buscaOportunidade : function(cmp) {
    	var action = cmp.get("c.BuscaOportunidade");
        action.setParams({idOportunidade : cmp.get("v.recordId")});
        action.setCallback(this, function(response) {
            
            var retorno = response.getReturnValue();
            
            console.log(retorno);

            if (retorno.BR_ConfirmarAdocao__c == true)
            {
                var toastEvent = $A.get("e.force:showToast");
                toastEvent.setParams({
                    "title": "Falha", 
                    "message": "A adoção já foi confirmada para essa oportunidade",
                    "type": "ERROR"
                }); 
                toastEvent.fire();
                
                $A.get("e.force:closeQuickAction").fire();
            }
            else if ($A.util.isEmpty(retorno.BR_PrevisaoCompra__c) || 
                     $A.util.isEmpty(retorno.BR_Compras_atraves_de__c) || 
                     $A.util.isEmpty(retorno.BR_Ano__c))
            {
                var texto = "Para confirmar a adoção, é necessário preencher o(s) campo(s):";
                if ($A.util.isEmpty(retorno.BR_PrevisaoCompra__c))
                    texto += " 'Previsão de Compra',";
                
                if ($A.util.isEmpty(retorno.BR_Compras_atraves_de__c))
                    texto += " 'Compras através de',";
                
                if ($A.util.isEmpty(retorno.BR_Ano__c))
                    texto += " 'Ano',";

                texto = texto.substr(0, (texto.length - 1));

                var toastEvent = $A.get("e.force:showToast");
                toastEvent.setParams({
                    "title": "Falha", 
                    "message": texto,
                    "type": "ERROR"
                }); 
                toastEvent.fire();
                
                $A.get("e.force:closeQuickAction").fire();
            }
            else if ($A.util.isEmpty(retorno.BR_Account_Contact__c) || $A.util.isEmpty(retorno.BR_Account_Contact__r.Contact__r.Email))
            {
                var toastEvent = $A.get("e.force:showToast");
                toastEvent.setParams({
                    "title": "Falha", 
                    "message": "É necessário ter um e-mail cadastrado para um contato da instituição",
                    "type": "ERROR"
                }); 
                toastEvent.fire();
                
                $A.get("e.force:closeQuickAction").fire();
            }
            else
            {
                this.buscaProdutos(cmp);
            }
        });
        $A.enqueueAction(action);    
    },
    
    buscaProdutos : function(cmp) {
   		var action = cmp.get("c.BuscaProdutos");
        action.setParams({idOportunidade : cmp.get("v.recordId")});
        action.setCallback(this, function(response) {
            
            var retorno = response.getReturnValue();
            
            if (retorno.length == 0)
            {
                var toastEvent = $A.get("e.force:showToast");
                toastEvent.setParams({
                    "title": "Falha", 
                    "message": "É necessário inserir produtos",
                    "type": "ERROR"
                }); 
                toastEvent.fire();
                
                $A.get("e.force:closeQuickAction").fire();
            }
            else
            {
                this.exibeConfirmacao(cmp);
            }
        });
        $A.enqueueAction(action);  
    },
    
    exibeConfirmacao : function(component) {
        $A.createComponent("c:Confirmation", {},
                           function(content, status) {
                               if (status === "SUCCESS") {
                                   var modalBody = content;
                                   content.set('v.botaoCancelado', 'Não');
                                   content.set('v.botaoConfirmacao', 'Sim');
                                   component.find('overlayLib').showCustomModal({
                                       header: "Tem certeza que desja confirmar a adoção?",
                                       body: modalBody, 
                                       showCloseButton: false,
                                       closeCallback: {}
                                   });
                               }
                           });
    },
})