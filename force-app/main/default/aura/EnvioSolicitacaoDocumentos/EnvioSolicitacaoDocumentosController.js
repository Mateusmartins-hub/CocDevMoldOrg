({
    doInit : function(component, event, helper) {
        helper.getNameAndEmail(component);
    },
    
    sendEmail: function(component, event, helper) {
        helper.sendDocumentsRequest(component);
    },
    
    handleDocumentCheckbox: function(component, event, helper) {        
        const checkboxId = event.getSource().getLocalId();
        helper.handleCheckbox(component,checkboxId);		
    },
    
    handleSelectAll: function(component, event, helper) {
        const checkboxId = event.getSource().getLocalId();
        const selectAllState = event.getSource().get("v.value");        
        if (checkboxId == 'select-all-PJ')
            helper.checkCheckboxes(component, "documentsPJ", selectAllState);
        else 
            helper.checkCheckboxes(component, "documentsPF", selectAllState);
    },

})