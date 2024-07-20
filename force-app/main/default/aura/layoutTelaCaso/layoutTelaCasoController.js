({
    doInit : function(component, event, helper) {
        helper.carregando(component);
        helper.listarGruposSolucionadores(component);
        helper.listarCamposCaso(component, event, helper);
        helper.getBaseURL(component);
    },
    cancelar : function(component, event, helper) {
        window.history.back();
    },
    salvar : function(component, event, helper) {
        helper.carregando(component);
        helper.salvar(component);
    },
    clonar : function(component, event, helper) {
        helper.carregando(component);
        if(confirm("Tem certeza que deseja clonar esse registro?"))
            helper.clonar(component);
        else 
            helper.carregado(component);
    },
    inserirSessao : function(component, event, helper) {
        //helper.carregando(component);
        helper.inserirSessao(component);
        component.set("v.inserindoSessao", false);
        component.set("v.sessaoNome", '');
    },
    novaSessao : function(component, event, helper) {
        component.set("v.inserindoSessao", true);
    },
    alterouCamposSelecionados: function(component, evt, helper) {
        helper.popularMapCampos(component, evt.getParam("value"));
    },
    handleSectionToggle: function (cmp, event) {
        var openSections = event.getParam('openSections');

        if (openSections.length === 0) {
            cmp.set('v.activeSectionsMessage', "All sections are closed");
        } else {
            cmp.set('v.activeSectionsMessage', "Open sections: " + openSections.join(', '));
        }
    },
    toggleCasosAntigos: function(cmp, event, helper) {
        if(cmp.get("v.casosAntigos")) {
            helper.desabilitarCasosAntigos(cmp);
        }else{
            helper.habilitarCasosAntigos(cmp);
        }
    }
})