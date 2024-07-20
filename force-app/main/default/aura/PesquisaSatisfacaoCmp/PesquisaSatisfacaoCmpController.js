({
	handleRate: function(component, event, helper) {
		const label = event.getSource().get("v.label");
		component.set("v.selectedRate", label);
	},

	sendRate: function(component, event, helper) {
		helper.saveRate(component);
	}
})