({
    doInit : function(cmp, event, helper) {
        helper.buscaConta(cmp);
    },
    amostraSelecionada : function(cmp, event, helper) {
        cmp.set("v.loading", true);
        helper.validaEnvioPosterior(cmp, cmp.get("v.objeto"), cmp.get("v.amostraVirtual"));
    }
})