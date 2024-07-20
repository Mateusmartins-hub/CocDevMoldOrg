({
	fetchUser : function(cmp) {
        var action = cmp.get("c.fetchUser");
        action.setCallback(this, function(response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                this.criarConsultoria(cmp, response.getReturnValue().Profile.Name);
            }else if (state === "ERROR") {
                let message = "Erro desconhecido";
                
                let errors = response.getError();
                if (errors && Array.isArray(errors) && errors.length > 0)
                    message = errors[0].message;
                
                this.showToast("Erro!", message, "error");
                $A.get("e.force:closeQuickAction").fire();
            }
        });
        $A.enqueueAction(action);
	},
    
    criarConsultoria : function(cmp, profileName) {
        if('Comercial FR' == profileName || 'Pedagógico FR' == profileName ||
           'Especializada FR' == profileName || 'Backoffice FR' == profileName ||
           'Gerência Comercial FR' == profileName || 'Operacional FR' == profileName ||
           'Planejamento FR' == profileName || 'ADM Franquias' == profileName ||
           'Retenção FR' == profileName || 'Auditoria FR' == profileName) {
            var createRecord = $A.get("e.force:createRecord");
            createRecord.setParams({
                "entityApiName": "FR_Procedimento_Franquias__c",
                "defaultFieldValues": {
                    'BR_Conta__c' : cmp.get('v.recordId')
                }
            });
            createRecord.fire();
            $A.get("e.force:closeQuickAction").fire();
        }else{
            var action = cmp.get("c.criarConsultoria");
            action.setParams({contaId : cmp.get('v.recordId')});
            action.setCallback(this, function(response) {
                var state = response.getState();
                if (state === "SUCCESS") {
                    this.showToast("Sucesso!", "Consultoria criada, direcionado para página de novo compromisso.", "success");
                    this.novoEvent(cmp, response.getReturnValue(), profileName);
                }else if (state === "ERROR") {
                    let message = "Erro desconhecido";
                    
                    let errors = response.getError();
                    if (errors && Array.isArray(errors) && errors.length > 0)
                        message = errors[0].message;
                    
                    this.showToast("Erro!", message, "error");
                    $A.get("e.force:refreshView").fire();
                    $A.get("e.force:closeQuickAction").fire();
                }
            });
            $A.enqueueAction(action);
        }
    },
    
    novoEvent : function(cmp, consultoriaId, profileName) {
        var action = cmp.get("c.getRecordTypes");
        
        var listParam = [];
        listParam.push('EDU Pearson English Pedagógico');
        listParam.push('K12 - Compromisso Pedagógico');
        action.setParams({names : listParam});
        action.setCallback(this, function(response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                var retorno = response.getReturnValue();
                var recordTypeId;
                
                if('Consultoria Pedagógica ELT' == profileName)
                    recordTypeId = retorno['EDU Pearson English Pedagógico'];
                else
                    recordTypeId = retorno['K12 - Compromisso Pedagógico'];
                
                var createRecord = $A.get("e.force:createRecord");
                createRecord.setParams({
                    "entityApiName": "Event",
                    "recordTypeId" : recordTypeId,
                    "defaultFieldValues": {
                        'WhatId' : consultoriaId
                    }
                });
                createRecord.fire();
                
                $A.get("e.force:refreshView").fire();
                $A.get("e.force:closeQuickAction").fire();
            }else if (state === "ERROR") {
                let message = "Erro desconhecido";
                
                let errors = response.getError();
                if (errors && Array.isArray(errors) && errors.length > 0)
                    message = errors[0].message;
                
                this.showToast("Erro!", message, "error");
                $A.get("e.force:refreshView").fire();
                $A.get("e.force:closeQuickAction").fire();
            }
        });
        $A.enqueueAction(action);
    },
    
    showToast : function(title, message, type) {
        let toastParams = {title: title, message: message, type: type};
        let toastEvent = $A.get("e.force:showToast");
        toastEvent.setParams(toastParams);
        toastEvent.fire();
    }
})