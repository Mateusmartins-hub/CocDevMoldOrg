({
	getDates : function(cmp, event) {
        cmp.set('v.loading', true);
        var action = cmp.get("c.getObject");
        action.setParams({id : cmp.get("v.recordId")});
        action.setCallback(this, function(response) {
            var retorno = response.getReturnValue();
            cmp.set("v.objeto", retorno);
            /*cmp.set("v.tempoApresentacao", retorno.tempoApresentacao.replace('.30', '.5'));
            cmp.set("v.horarioApresentacao", retorno.horaInicial.replace('.0', ''));
            
            this.setHorarios(cmp);
*/            
            if (!$A.util.isEmpty(retorno.Erro)) {
                this.showToast("ERROR", "Erro", retorno.Erro);
                this.cancelar(cmp);
            } else {
                cmp.set("v.objeto", retorno);
                if(retorno.Prefixo == 'ld') {
                    this.validaVisitaExpansao(cmp, retorno);
                    cmp.set('v.loading', false);
                }else if(retorno.Prefixo == 'op') {
                    if(!this.validaVisitaExpansao(cmp, retorno))
                        return;
                    
                    $A.createComponent("c:Confirmation", {}, function(content, status) {
                        if (status === "SUCCESS") {
                            var modalBody = content;                   
                            content.set('v.text', 'Qual tipo de visita deseja agendar?');
                            content.set('v.botaoCancelado', 'Visita de Expansão');         
                            content.set('v.botaoConfirmacao', 'Visita Pedagógica');
                            cmp.find('overlayLib').showCustomModal({
                                header: "Qual visita deseja agendar?",
                                body: modalBody, 
                                showCloseButton: false,
                                closeCallback: function() {  
                                }
                            });
                        }
                    });        
                }
            }
        });
        $A.enqueueAction(action);
	},
    
    setHorarioApresentacao : function(cmp) {
        var tempo = parseFloat(cmp.get('v.tempoApresentacao'));
        var horario = parseFloat(cmp.get('v.horarioApresentacao'));
        
        var inicio = horario.toString() + 'h';
        
        var fim = (horario + tempo).toString();
        fim = fim.toString();
        
        if(parseFloat(fim) > 18) {
            fim = '18';
            var tempoApr = (18 - parseFloat(cmp.get('v.horarioApresentacao'))).toString();
            if(!tempoApr.includes('.50'))
                tempoApr += '.0';
            
            cmp.set('v.tempoApresentacao', tempoApr);
            this.setHorarios(cmp);
        }
        
        if(fim.includes('.5'))
            fim = fim.replace('.5', ':30');
        else
            fim = fim + 'h';
        
        cmp.set('v.objeto.horaInicial', inicio);
        cmp.set('v.objeto.horaFinal', fim);
    },
    
    setHorarios : function(cmp) {
        var tempo = parseFloat(cmp.get('v.tempoApresentacao'));
        
        var horarios = [];
        for (var i = 8; i < 18; i++) {
            if((i + tempo) <= 18) {
                var horario = i+'h';
                horarios.push({value:i.toString(), label:horario});
            }
        }
        
        cmp.set('v.opcoesHorarioApresentacao', horarios);
        
        this.setHorarioApresentacao(cmp);
    },
    
    validaVisitaExpansao : function(cmp, retorno) {
        if(retorno.EnviadoPor == 'Consultor') {
            this.showToast("WARNING", "Alerta", "Você já enviou as datas para o parceiro, aguarde o mesmo confirmá-las.");
            this.cancelar(cmp);
            
            return false;
        }
        else if(!$A.util.isUndefinedOrNull(retorno.DataConfirmada)) {
            this.showToast("WARNING", "Alerta", "Visita já está confirmada para " + retorno.DataConfirmada + ".");
            this.cancelar(cmp);
            
            return false;
        }
        
        cmp.find("primeiraData").set("v.value", retorno.dataSug1);
        cmp.find("segundaData").set("v.value", retorno.dataSug2);
        cmp.find("terceiraData").set("v.value", retorno.dataSug3);
        
        return true;
    },
    
    showToast : function(tipo, titulo, erro) {
        var toastEvent = $A.get("e.force:showToast");
        toastEvent.setParams({
            "title": titulo, 
            "message": erro,
            "type": tipo
        }); 
        toastEvent.fire();
    },

    enviarChecklist : function() {
        var toastEvent = $A.get("e.force:showToast");
        toastEvent.setParams({
            "title": titulo, 
            "message": erro,
            "type": tipo
        }); 
        toastEvent.fire();
    },
    
    enviar : function(cmp) {
        var obj = cmp.get("v.objeto");
        var tempo = cmp.get("v.tempoApresentacao");
        
        if(obj.dataSug1 == obj.dataSug2 || obj.dataSug1 == obj.dataSug3 || obj.dataSug2 == obj.dataSug3) {
            this.showToast("ERROR", "Erro", 'As datas não podem ser repetidas.');
            return;
        }
        
        if($A.util.isUndefinedOrNull(tempo)) {
            this.showToast("ERROR", "Erro", 'Escolha a duração da apresentação');
            return;
        }

        var action = cmp.get("c.saveSugestionsAndSendEmail");
        action.setParams({objeto : obj, tipoVisita : cmp.get('v.TipoVisita')});
        action.setCallback(this, function(response) {
            if(response.getState() == "SUCCESS") {
                if(response.getReturnValue() == 'SUCESSO') {
                    this.showToast("SUCCESS", "Sucesso", "E-mail enviado");
                    this.cancelar(cmp);
                }else{
                    this.showToast("ERROR", "Erro", response.getReturnValue());
                }
            }else{
                this.showToast("ERROR", "Erro", 'Data(s) inválida(s).');
            }
        });
        
        $A.enqueueAction(action);
    },
    
    cancelar : function(cmp) {
        $A.get("e.force:closeQuickAction").fire();
    },
    
    reaparecer : function(cmp) {
        var element = document.getElementsByClassName("DESKTOP uiModal forceModal");    
        element.forEach(function(e, t) {
            $A.util.removeClass(e, 'slds-hide');
        });  
    }
})