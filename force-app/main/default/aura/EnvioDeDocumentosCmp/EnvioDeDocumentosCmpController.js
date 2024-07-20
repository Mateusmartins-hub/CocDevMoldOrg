({	
    doInit : function(component, event, helper) {
        helper.getDocumentsUrls(component);
    },
    
    save: function(component, event, helper) {		
        helper.save(component);
    },

    handleAceite: function(component, event, helper) {
        const buttonState = component.get("v.isSendButtonDisabled");
        component.set("v.isSendButtonDisabled", !buttonState);
    },
    
    handleFiles: function(component, event, helper) {
        const componentsToUpload = component.get("v.documentsToUpload");
        const fieldName = event.currentTarget.name;
        const fieldId = event.currentTarget.id;
        const file = event.currentTarget.files[0];
        let found = false;
        const fileDetails = {
            "fieldName": fieldName,
            "file": file
        };
        const labelElement = document.getElementById("label"+fieldId);
        labelElement.textContent = file.name;
        for (let i = 0; i < componentsToUpload.length; i++) {
            
            if (componentsToUpload[i].fieldName == fieldName){                
                componentsToUpload[i]= fileDetails;   
                found = true;
            }     
        }
        
        if (!found)
            componentsToUpload.push(fileDetails);  
        
        component.set("v.documentsToUpload", componentsToUpload);        
    },
   
})