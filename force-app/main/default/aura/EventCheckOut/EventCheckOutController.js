({
	doInit : function(cmp, event, helper) {
		helper.realizaCheckout(cmp);
	},
	salvar : function(cmp, event, helper) {
		helper.salvar(cmp);
	},
	handleConfirmDialogYes: function (cmp, event, helper) {
		helper.enviarCheckList(cmp)
    },

    handleConfirmDialogNo: function (cmp, event, helper) {
		const navEvt = $A.get("e.force:navigateToSObject");
		navEvt.setParams({
		"recordId": cmp.get('v.eventId')
		});
		navEvt.fire();
		//		$A.get("e.force:closeQuickAction").fire();
        // $A.get('e.force:refreshView').fire();
    }
})