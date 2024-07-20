({
    
    save : function(component) {      
        const documents = component.get("v.documentsToUpload");        
        const promises = new Array();        
        if (documents.length > 0) {
            component.set("v.loading", true);        
            component.set("v.iterations", documents.length);
        }
        
        for (let file of documents) {
            if (file.file.size > 750000) {
                alert('O tamanho não pode exceder 750000 bytes.\n O tamanho do arquivo escolhido é: ' + file.size);
                const iterations = component.get("v.iterations") - 1;
                if (iterations == 0)
                    component.set("v.loading", false);        

                return;
            }
            const self = this;
            let fr = new FileReader();       
            fr.onload = () => {                
                var fileContent = fr.result;
                var base64 = 'base64,';
                var dataStart = fileContent.indexOf(base64) + base64.length;
                
                const fileResult = fileContent.substring(dataStart);
                
                const processedFile = {    
                "fieldName" : file.fieldName,
                "file": file.file,
                "fileContents":  fileResult };  
            self.upload(component, processedFile);            
        };    
        fr.readAsDataURL(file.file);  
    }
},
 
 upload: function(component, processedFile) {
    var action = component.get("c.saveTheFile");   
    action.setParams({
        parentId: component.get("v.recordId"),
        fieldName: processedFile.fieldName,
        base64Data: encodeURIComponent(processedFile.fileContents),
        fileName: processedFile.file.name,
        contentType: processedFile.file.type
    });
    action.setCallback(this, function(response) {
        const state = response.getState();           
        
        if (state === "SUCCESS") {            
         	let iterationsLeft = component.get("v.iterations") - 1;        
			component.set("v.iterations", iterationsLeft);            
            if (iterationsLeft == 0) {
                component.set("v.loading", false);
                alert('Arquivos enviados!');
                
                const termsAction = component.get("c.acceptTerms");   
                termsAction.setParams({
                    recordId: component.get("v.recordId")
                });
                $A.enqueueAction(termsAction);         
            }                
        } else
            console.log(response.getError()[0].message);
    });
    
    $A.enqueueAction(action);         
},
    
    getDocumentsUrls : function(cmp) {      
        const documentsArray = cmp.get("v.documentsToSend").split(',');				
        const action = cmp.get("c.getDocumentsURL");
        
        action.setParams({ documentsToSend : documentsArray,
                          accountState : cmp.get("v.state")});
        action.setCallback(this, function(response) {
            const state = response.getState();
            if (state === "SUCCESS") {
                var retorno = response.getReturnValue();
                cmp.set("v.documentsURL", retorno);				
            }
        });
        $A.enqueueAction(action);
    },
        
})