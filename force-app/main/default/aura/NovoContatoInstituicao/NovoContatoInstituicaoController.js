({
	doInit : function(cmp, event, helper) {
        var action = cmp.get("c.getRecordType");
        action.setCallback(this, function(response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                var record = response.getReturnValue();
                var createRecord = $A.get("e.force:createRecord");
                createRecord.setParams({
                    "entityApiName": "Account_Contact__c",
                    "recordTypeId" : record,
                    "defaultFieldValues": {
                        'Account__c' : cmp.get('v.recordId'),
                        'RecordTypeId' : record,
                        'Name' : 'NÃO PREENCHER'
                    }
                });
                createRecord.fire();
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