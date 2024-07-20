({
    doInit: function (cmp, event, helper) {
        helper.carregando(cmp);
        helper.getCase(cmp);
        helper.getOldCaseFields(cmp);
        helper.getBaseURL(cmp, event);
        helper.showRelatedLists(cmp);
        helper.verificaPlataforma(cmp);   

        if(!$A.util.isEmpty(cmp.get("v.recordId"))) {
            helper.visualizar(cmp, event);
            var url = new URL(window.location.href);
            if(!$A.util.isUndefinedOrNull(url.searchParams.get("a_case_soln"))){
                helper.insertSolution(cmp, url.searchParams.get("a_case_soln"))
            }
            helper.getDependentes(cmp, event, helper)
            helper.verificaUsuarioGrupo(cmp, event)
        }else{
            helper.editar(cmp, event)
        }
    },
    
    fechar: function (cmp, event, helper) {
        helper.carregando(cmp);
        helper.fecharCaso(cmp, event);
    },
    
    addObservadores: function (cmp, event, helper) {
        helper.carregando(cmp);
        helper.addObservadores(cmp, event);
    },
    
    addUser: function (cmp, event, helper) {
        helper.carregando(cmp);
        helper.addUser(cmp, event);
    },
    
    cancelarForm: function (cmp, event, helper) {
        helper.carregando(cmp);
        helper.cancelarForm(cmp, event);
    },  
    
    salvarForm: function(cmp, event, helper) {
        helper.carregando(cmp);
    },
    
    inicio: function (cmp, event, helper) {
        location.href = cmp.get("v.baseURL") + "/500";
    },  
    
    salvar: function (cmp, event, helper) {
        helper.carregando(cmp);
        helper.salvarForm(cmp, event); 
    },   
    
    editarForm: function(cmp, event, helper) {
        helper.editar(cmp, event)
	}, 
    
    errorInformation: function(cmp, event, helper) {
        alert("Erro! Contate um administrador");
        console.log(event.getParams());
        helper.carregado(cmp);
        location.reload();
    },
    
    successInformation: function(cmp, event, helper) {
        alert("Caso atualizado com sucesso!");
        helper.carregado(cmp);
        location.reload();
    },
    
    clickSpan: function (cmp, event, helper) {
        var campo = event.currentTarget.dataset.value;
        helper.openDetail(campo, cmp, event);
    }
})