({
	saveRate : function(component) {
		const selectedRate = component.get("v.selectedRate");
		const recordId = component.get("v.recordId");
		component.set("v.loading", true);

		const actionCallback = (response) => {
			component.set("v.loading", false);
			alert('Nota enviada com sucesso!');            
		};

		const action = component.get("c.saveRate");
		action.setParams({recordId: recordId,
						  rateToSave: selectedRate});
		action.setCallback(this, actionCallback);
		$A.enqueueAction(action);
	}
})