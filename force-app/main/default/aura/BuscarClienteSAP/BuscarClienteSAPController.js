({
    doInit : function(cmp, event, helper) {
        helper.buscarClienteSAP(cmp);
    },
    cancelar : function(cmp, event, helper) {
        $A.get("e.force:closeQuickAction").fire();
    }
})