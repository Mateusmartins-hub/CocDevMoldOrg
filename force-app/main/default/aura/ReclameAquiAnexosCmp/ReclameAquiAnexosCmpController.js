({
    init : function(cmp, evt) {

        // 

        

        var action = cmp.get("c.retrieveAttachmentsLinks");
        action.setBackground();
        action.setParams({
            "caseId": cmp.get("v.recordId")
        });
        
        action.setCallback(this, function(response){
            var state = response.getState();
            if (state === "SUCCESS") {
                $A.get('e.force:refreshView').fire();
            }
            else{
                var toastEvent = $A.get("e.force:showToast");
                toastEvent.setParams({
                    "title": "Error!",
                    "message": "Não foi possível recuperar os links dos anexos."
                });
                toastEvent.fire();
            }
            $A.get("e.force:closeQuickAction").fire();
        });
        $A.enqueueAction(action);
    }
})