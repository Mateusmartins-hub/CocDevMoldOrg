({
    cancelado : function(component, event, helper) {

        var appEvent = $A.get("e.c:ConfirmationEvent");
        appEvent.setParams({
            "message" : component.get("v.botaoCancelado") });
        appEvent.fire();
        component.find("overlayLib").notifyClose();
    },
    
    confirmado : function(component, event, helper) {
        var appEvent = $A.get("e.c:ConfirmationEvent");
        appEvent.setParams({
            "message" : component.get("v.botaoConfirmacao") });
        appEvent.fire();
        component.find("overlayLib").notifyClose();
    }
})