({
	doInit : function(component, event, helper) {
		$A.get('e.force:refreshView').fire();
		const eventId = component.get('v.recordId');
		helper.handleCheckinCheckout(component, eventId);		
	}
})