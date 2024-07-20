({
    doInit: function (cmp, event, helper) {
        helper.getEmails(cmp);
    },

    enviar: function (cmp, event, helper) {
        helper.enviar(cmp);
    },

    cancelar: function(cmp, event, helper) {
        $A.get('e.force:closeQuickAction').fire();
    }
})