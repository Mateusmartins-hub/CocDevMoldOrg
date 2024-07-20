({
    addObservadores : function(cmp, event) {
        var p = cmp.get("v.parent");
        p.addObservadores();
        
    },
    
    searchSolution : function(cmp, event) {
        window.open(cmp.get("v.baseURL") + "/ui/solution/SolutionSearchCasesPage?caseid=" + cmp.get("v.recordId") + "&search=" + ($A.util.isUndefinedOrNull(cmp.get("v.searchSolutionValue")) ? "" : cmp.get("v.searchSolutionValue")) + "&srchbtn=Find+Solution", '_blank');
    },
    
    sendEmail : function(cmp, event, helper) {        
        if(cmp.get("v.caso.IsClosed") && cmp.get("v.caso.Novo__c")) {
            alert("Este chamado foi encerrado, para uma nova solicitação por gentileza entre em contato com o Atendimento ou nos encaminhe um novo e-mail. Obrigado.");
            return;
        }
        window.open(cmp.get("v.baseURL") + "/_ui/core/email/author/EmailAuthor?p3_lkid=" + cmp.get("v.recordId").substring(0, 15) + "&retURL=%2F" + cmp.get("v.recordId"), '_blank');
    },
    
    newComment : function(cmp, event, helper) {
        window.open(cmp.get("v.baseURL") + "/00a/e?parent_id=" + cmp.get("v.recordId") + "&retURL=%2F" + cmp.get("v.recordId"), '_blank');
    },
    
    newNote : function(cmp, event, helper) {
        window.open(cmp.get("v.baseURL") + "/a03/e?CF00Nd0000007eKPl=" + cmp.get("v.caso.CaseNumber") + "&CF00Nd0000007eKPl_lkid=" + cmp.get("v.recordId") + "&retURL=%2F" + cmp.get("v.recordId"), '_blank');
    },
    
    newMaterial : function(cmp, event, helper) {
        window.open(cmp.get("v.baseURL") + "/a04/e?CF00Nd0000007eKPr=" + cmp.get("v.caso.CaseNumber") + "&CF00Nd0000007eKPr_lkid=" + cmp.get("v.recordId") + "&retURL=%2F" + cmp.get("v.recordId"), '_blank');
    },
    
    searchSuggestedSolutions : function(cmp, event, helper) {
        window.open(cmp.get("v.baseURL") + "/ui/solution/SolutionSuggestionPage?caseid=" + cmp.get("v.recordId"), '_blank');
    },
    
    attachFile : function(cmp, event, helper) {
        window.open(cmp.get("v.baseURL") + "/p/attach/NoteAttach?pid=" + cmp.get("v.recordId") + "&parentname=" + cmp.get("v.caso.CaseNumber") + "&retURL=%2F" + cmp.get("v.recordId"), '_blank');
    },
})