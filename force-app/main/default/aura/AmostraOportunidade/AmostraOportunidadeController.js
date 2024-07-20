({
	doInit : function(cmp, event, helper) {
        var action = cmp.get("c.getRecsTypesIds");
        action.setCallback(this, function(response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                cmp.set('v.mapRecsTypesIds', response.getReturnValue());
            } else if (state == "INCOMPLETE") {
                var toastEvent = $A.get("e.force:showToast");
                toastEvent.setParams({
                    "title": "Oops!",
                    "type": "error",
                    "message": "Sem conexão com a Internet"
                });
                toastEvent.fire();
                
            } else if (state == "ERROR") {
                var toastEvent = $A.get("e.force:showToast");
                toastEvent.setParams({
                    "title": "Erro!",
                    "type": "error",
                    "message": "Erro inesperado, contate o Tech."
                });
                toastEvent.fire();
            }
        });
        $A.enqueueAction(action);
	},
    
    openCriacao : function(cmp, event, helper) {
        var action = cmp.get("c.getOpportunity");
        action.setParams({idOportunidade : cmp.get('v.recordId')});
        action.setCallback(this, function(response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                var createOpportunity = $A.get("e.force:createRecord");
                
                var opp = response.getReturnValue();
                var recordTypeId;
                var escolheu = event.getSource().get("v.value");
                var objRecsTypesIds = cmp.get('v.mapRecsTypesIds');
                
                if(escolheu == 'Amostra_ELT') {
                    recordTypeId = objRecsTypesIds['Sample_Order_Languages'];
                    createOpportunity.setParams({
                        "entityApiName": "Opportunity",
                        "recordTypeId": recordTypeId,
                        "defaultFieldValues": {
                            'AccountId' : opp.AccountId,
                            'BR_Parent_Oportunity__c' : opp.Id,
                            'StageName' : 'Elaboração'
                        }
                    });
                }
                else if(escolheu == 'Amostra_COC') {
                    recordTypeId = objRecsTypesIds['Sample_Order_COC'];
                    createOpportunity.setParams({
                        "entityApiName": "Opportunity",
                        "recordTypeId": recordTypeId,
                        "defaultFieldValues": {
                            'AccountId' : opp.AccountId,
                            'BR_Parent_Oportunity__c' : opp.Id,
                            'StageName' : 'Elaboração'
                        }
                    });
                }
                else if(escolheu == 'Amostra_Dom_Bosco') {
                    recordTypeId = objRecsTypesIds['Sample_Order_Dom_Bosco'];
                    createOpportunity.setParams({
                        "entityApiName": "Opportunity",
                        "recordTypeId": recordTypeId,
                        "defaultFieldValues": {
                            'AccountId' : opp.AccountId,
                            'BR_Parent_Oportunity__c' : opp.Id,
                            'StageName' : 'Elaboração'
                        }
                    });
                }
                else if(escolheu == 'Amostra_Pueri_Domus') {
                    recordTypeId = objRecsTypesIds['Sample_Order_Pueri_Domus'];
                    createOpportunity.setParams({
                        "entityApiName": "Opportunity",
                        "recordTypeId": recordTypeId,
                        "defaultFieldValues": {
                            'AccountId' : opp.AccountId,
                            'BR_Parent_Oportunity__c' : opp.Id,
                            'StageName' : 'Elaboração'
                        }
                    });
                }
                else if(escolheu == 'Amostra_Universitario') {
                    recordTypeId = objRecsTypesIds['Sample_Order_University'];
                    createOpportunity.setParams({
                        "entityApiName": "Opportunity",
                        "recordTypeId": recordTypeId,
                        "defaultFieldValues": {
                            'AccountId' : opp.AccountId,
                            'BR_Parent_Oportunity__c' : opp.Id,
                            'StageName' : 'Elaboração'
                        }
                    });
                }
                else if(escolheu == 'Amostra_NAME') {
                    recordTypeId = objRecsTypesIds['Sample_Order_NAME'];
                    createOpportunity.setParams({
                        "entityApiName": "Opportunity",
                        "recordTypeId": recordTypeId,
                        "defaultFieldValues": {
                            'AccountId' : opp.AccountId,
                            'BR_Parent_Oportunity__c' : opp.Id,
                            'StageName' : 'Elaboração'
                        }
                    });
                }
                else if(escolheu == 'Amostra_Solucoes') {
                    recordTypeId = objRecsTypesIds['Sample_Order_Solutions'];
                    createOpportunity.setParams({
                        "entityApiName": "Opportunity",
                        "recordTypeId": recordTypeId,
                        "defaultFieldValues": {
                            'AccountId' : opp.AccountId,
                            'BR_Parent_Oportunity__c' : opp.Id,
                            'StageName' : 'Elaboração'
                        }
                    });
                }
                
                if($A.util.isUndefinedOrNull(recordTypeId)) {
                    var toastEvent = $A.get("e.force:showToast");
                    toastEvent.setParams({
                        "title": "Erro!",
                        "type": "error",
                        "message": "Erro inesperado, contate o Tech."
                    });
                    toastEvent.fire();
                    return;
                }
                
                createOpportunity.fire();
            } else if (state == "INCOMPLETE") {
                var toastEvent = $A.get("e.force:showToast");
                toastEvent.setParams({
                    "title": "Oops!",
                    "type": "error",
                    "message": "Sem conexão com a Internet"
                });
                toastEvent.fire();
                
            } else if (state == "ERROR") {
                var toastEvent = $A.get("e.force:showToast");
                toastEvent.setParams({
                    "title": "Erro!",
                    "type": "error",
                    "message": "Erro inesperado, contate o Tech."
                });
                toastEvent.fire();
            }
        });
        $A.enqueueAction(action);
    }
})