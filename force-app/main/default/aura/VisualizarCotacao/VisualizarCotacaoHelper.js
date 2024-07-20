({
	getPdf : function(cmp) {
		  var action = cmp.get('c.getPDFURL');
          action.setParams({  idQuote : cmp.get("v.recordId") });
        	action.setCallback(this, function(response){
            var state = response.getState();
            if(state === 'SUCCESS') {
                var retorno =  response.getReturnValue();
                                
                var ifrm = document.createElement("iframe");
                ifrm.setAttribute("src", retorno + '?id=' + cmp.get("v.recordId"));
                ifrm.style.width = "100%";
                ifrm.style.height = "480px";
                document.getElementById("pdf").appendChild(ifrm);
            } else if (state === "ERROR") {
                var toastEvent = $A.get("e.force:showToast");
                toastEvent.setParams({
                    "title": "Erro!",
                    "type": "error",
                    "message": "Erro, contate o Tech."
                });
                toastEvent.fire();
                $A.get("e.force:closeQuickAction").fire();
            }
        });
        $A.enqueueAction(action);
	}
})