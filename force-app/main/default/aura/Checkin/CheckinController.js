({
	doInit: function (component, event, helper) {
		document.title = "Eventos da semana | Salesforce";
		helper.setColumns(component);
		helper.getEvents(component);
	},

	handleAction: function (component, event, helper) {		
		const eventId = event.getParam('row').Id;		
		helper.handleCheckinCheckout(component, eventId);
	}
})