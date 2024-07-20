({
	doInit : function(cmp, event, helper) {
		var action = cmp.get("c.ReenviaIntegracao");
        action.setParams({idOportunidade : cmp.get("v.recordId")})
        action.setCallback(this, function(response) {

            var retorno = response.getReturnValue();
			
			var toastEvent = $A.get("e.force:showToast");
            toastEvent.setParams({
                "title": "Sucesso",
                "message": retorno,
                "type": "SUCCESS"
            });
			toastEvent.fire();
			
			$A.get("e.force:closeQuickAction").fire();

        });
        $A.enqueueAction(action);
	}
})