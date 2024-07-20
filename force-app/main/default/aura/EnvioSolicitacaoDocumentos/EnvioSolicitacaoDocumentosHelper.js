({
    getNameAndEmail : function(cmp) {
        const callback = (response) => { 
            const state = response.getState();
            if (state === "SUCCESS") {
            var retorno = response.getReturnValue();
            
            cmp.set("v.name", retorno.nome);
            cmp.set("v.email", retorno.email);                
        } else {
            this.showToast("ERROR", "Falha", response.getError()[0].message);
        }};
    
        const action = cmp.get("c.getNameAndEmail");
        action.setParams({id : cmp.get("v.recordId")});
        action.setCallback(this, callback);
        $A.enqueueAction(action);
    },
    
    sendDocumentsRequest: function(cmp) {
        const documents = cmp.get("v.documentsToRequest");
        console.log(documents);
        if (documents.length > 0) {
            const action = cmp.get("c.sendMissingDocumentsRequest");        
            action.setParams({email: cmp.get("v.email"),
                              documentsToRequest: documents,
                              recordId: cmp.get("v.recordId")});
            action.setCallback(this, response => {
                const state = response.getState();
                
                if (state == "SUCCESS") {
                this.showToast("SUCCESS", "Sucesso", "E-mail enviado com sucessso!");
                $A.get("e.force:closeQuickAction").fire();
            }
                               else
                               this.showToast("ERROR", "Falha", response.getError()[0].message);
        });
        $A.enqueueAction(action);
    } else
    this.showToast("ERROR", "Falha", 'Selecione pelo menos um documento a ser solicitado');
},
 
 showToast : function(type, title, error) {
    var toastEvent = $A.get("e.force:showToast");
    toastEvent.setParams({
        "title": title,
        "message": error,
        "type": type
    });
    toastEvent.fire();
},
    handleCheckbox: function(component, checkboxId) {                
        const documentsToRequest = component.get("v.documentsToRequest");
        const checkboxState = component.find(checkboxId).get("v.value");
        
        if(checkboxState)
            documentsToRequest.push(checkboxId);
        else
            documentsToRequest.splice(documentsToRequest.indexOf(checkboxId), 1);
        
        component.set("v.documentsToRequest", documentsToRequest);
    },
        
        checkCheckboxes: function(component, auraId, selectAllState) {         
            const documents = component.find(auraId).find({instancesOf: "ui:inputCheckbox"});       
            for(let input of documents){                   
                input.set("v.value", selectAllState);      		  
                this.handleCheckbox(component, input.getLocalId());                                      
            }
            console.log(component.get("v.documentsToRequest"));
        }
})