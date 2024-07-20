({
    doInit: function (cmp, event, helper) {
        helper.carregando(cmp);
        helper.getCase(cmp, event);
        helper.getRecordTypeIdPadrao(cmp);
        helper.getTipos(cmp, event);
        helper.getCamposCaso(cmp, event);
        helper.getBaseURL(cmp, event);
        helper.showRelatedLists(cmp);
        helper.verificaPlataforma(cmp);
        helper.getMotivosNaoEnvioPesquisa(cmp);

        if (!$A.util.isEmpty(cmp.get("v.recordId"))) {
            var url = new URL(window.location.href);

            helper.visualizar(cmp, event);
            if (!$A.util.isUndefinedOrNull(url.searchParams.get("a_case_soln"))) {
                helper.insertSolution(cmp, url.searchParams.get("a_case_soln"));
            }
            helper.getDependentes(cmp, event, helper);
            helper.verificaUsuarioGrupo(cmp, event);
            helper.verificaUltimoGrupo(cmp, event);
        } else {
            helper.editar(cmp, event);
        }
    },

    changeGrupoSolucionador: function (cmp, event, helper) {
        helper.carregando(cmp);

        if (!$A.util.isUndefinedOrNull(cmp.find("grupoSolucionador"))) {
            cmp.find('grupoSolucionador').setCustomValidity("");
            cmp.find("grupoSolucionador").reportValidity();
        }

        cmp.set("v.temCampoProxGrupo", false);

        var idGrupo = event.getParam("value");
        var idGrupoAbertura = "";
        if (idGrupo.includes('grupoSolucionadorZero')) {
            idGrupoAbertura = idGrupo;
            idGrupo = idGrupo.split('grupoSolucionadorZero')[1];
        }

        var buscarGrupo = cmp.get("c.buscarGrupo");
        buscarGrupo.setParams({
            idGrupo: idGrupo
        });
        buscarGrupo.setCallback(this, function (response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                var grupo = response.getReturnValue();
                if (grupo != null) {
                    cmp.set("v.ordemGrupoSolucionador", grupo.Ordem__c);
                    if (idGrupoAbertura.includes('grupoSolucionadorZero')) {
                        cmp.set("v.grupoSolucionador", idGrupoAbertura);
                    } else {
                        cmp.set("v.grupoSolucionador", idGrupo);
                    }
                    cmp.set("v.areaDonaDoProcesso", grupo.ParametrizacaoCasos__r.AreaDonaProcesso__c);

                    if (grupo.CamposObrigatorios__c != undefined || grupo.CamposObrigatorios__c != null) {

                        var a = grupo.CamposObrigatorios__c.split(";"),
                            i;
                        var campos = [];

                        for (i = 0; i < a.length; i++) {
                            campos.push(a[i]);
                        }
                        cmp.set("v.camposProxGrupo", campos);
                        cmp.set("v.temCampoProxGrupo", true);
                    }
                }
            } else if (state === "ERROR") {
                helper.exibeMensagemErro(cmp, response.getError());
            }
            helper.carregado(cmp, false);
        });
        $A.enqueueAction(buscarGrupo);
    },

    clickMenu: function (cmp, event, helper) {
        var btnDiv = cmp.find("buttonMenu");
        $A.util.toggleClass(btnDiv, "slds-is-open");
    },

    clickMenuItem: function (cmp, event, helper) {
        var botaoId = event.target.id;
        var botaoTitle = event.target.title;
        helper.carregando(cmp);
        if (botaoId == "enviaGrupoAnterior" || botaoTitle == "Enviar para um grupo anterior") {
            helper.voltarAoGrupo(cmp, event);
        } else if (botaoId == "enviaProximoGrupo" || botaoTitle == "Enviar para próximo grupo") {
            helper.enviarProxGrupoSolucionadorOnClick(cmp, event);
        } else if (botaoId == "cancelarCaso" || botaoTitle == "Cancelar caso") {
            helper.cancelarCaso(cmp, event);
        } else if (botaoId == "clonarCaso" || botaoTitle == "Clonar caso") {
            helper.clonarCaso(cmp, event, helper);
        } else if (botaoId == "addObservadores" || botaoTitle == "Adicionar observador") {
            helper.addObservadores(cmp, event);
        } else if (botaoId == "retornarFila" || botaoTitle == "Retornar à Fila") {
            helper.retornarFila(cmp, event);
        } else {
            helper.carregado(cmp);
        }
    },

    menuSelect: function (cmp, event, helper) {
        var botao = event.getParam("value");
        helper.carregando(cmp);
        if (botao == "proxGrupoSolucionador") {
            helper.enviarProxGrupoSolucionadorOnClick(cmp, event);
        } else if (botao == "voltarGrupo") {
            helper.voltarAoGrupo(cmp, event, helper);
        } else if (botao == "addObservadores") {
            helper.addObservadores(cmp, event);
        }
    },

    handleSelect: function (cmp, event, helper) {},

    salvar: function (cmp, event, helper) {
        helper.carregando(cmp);
        helper.salvarForm(cmp, event);
    },

    submitForm: function (cmp, event, helper) {
        helper.carregando(cmp);
        helper.salvarForm(cmp, event);
    },

    inicio: function (cmp, event, helper) {
        location.href = cmp.get("v.baseURL") + "/500";
    },

    retornar: function (cmp, event, helper) {
        helper.carregando(cmp);
        helper.retornar(cmp, event);
    },

    editarForm: function (cmp, event, helper) {
        helper.editar(cmp, event, helper);
    },

    aceitar: function (cmp, event, helper) {
        helper.carregando(cmp);
        if (confirm("Tem certeza que deseja aceitar esse caso?")) {
            if (cmp.get("v.caso.AceitoPor__c") == null) {
                helper.aceitar(cmp, event);
            } else {
                helper.message(cmp, "error", "Erro!", "Este caso já foi aceito por " + cmp.get("v.caso.AceitoPor__r.Name"));
                helper.carregado(cmp, false);
            }
        } else {
            helper.carregado(cmp, false);
        }
    },

    onloadForm: function (cmp, event, helper) {
        helper.verificaContaPreenchida(cmp, event);
        helper.carregado(cmp, true);
    },

    cancelarForm: function (cmp, event, helper) {
        helper.cancelarForm(cmp, event);
    },

    excluir: function (cmp, event, helper) {
        helper.carregando(cmp);
        if (confirm("Tem certeza que deseja excluir esse registro?")) {
            helper.excluirRegistro(cmp, cmp.get("v.caso"), event);
        } else {
            helper.carregado(cmp, false);
        }
    },

    alteracaoTipo: function (cmp, event, helper) {
        helper.carregando(cmp);
        helper.alteracaoTipo(cmp, event);
    },

    alteracaoSubtipo: function (cmp, event, helper) {
        helper.carregando(cmp);
        helper.alteracaoSubtipo(cmp, event);
    },

    alteracaoDetalhamento: function (cmp, event, helper) {
        helper.carregando(cmp);
        helper.alteracaoDetalhamento(cmp, event);
    },

    alteracaoDetalhamento2: function (cmp, event, helper) {
        helper.alteracaoDetalhamento2(cmp, event);
    },

    errorInformation: function (cmp, event, helper) {
        var errorsArr = event.getParams();
        cmp.set("v.subtipoErro", "");

        if (!$A.util.isEmpty(errorsArr.output.fieldErrors)) {
            var campoComErro = Object.getOwnPropertyNames(errorsArr.output.fieldErrors)[0];
            var mensagemDoErro = errorsArr.output.fieldErrors[campoComErro][0].message;
            cmp.set("v.campoComErro", campoComErro);

            if (campoComErro == "Subtipo__c")
                cmp.set("v.subtipoErro", mensagemDoErro);
            else if (campoComErro == "Detalhamento__c")
                cmp.set("v.detalhamentoErro", mensagemDoErro);
            else if (campoComErro == "Detalhamento2__c")
                cmp.set("v.detalhamento2Erro", mensagemDoErro);

            if (errorsArr.output.fieldErrors[campoComErro][0].errorCode == "FIELD_FILTER_VALIDATION_EXCEPTION") {
                cmp.set("v.erroCampoMensagem", mensagemDoErro);
            }
        } else {
            helper.message(cmp, "error", errorsArr.message, errorsArr.detail);
            console.log(JSON.stringify(errorsArr));
        }

        helper.carregado(cmp, false);
    },

    successInformation: function (cmp, event, helper) {
        helper.verificaUsuarioAtualFila(cmp, event);
    },

    voltarAoGrupoSolucionador: function (cmp, event, helper) {
        helper.carregando(cmp);
        helper.voltarAoGrupo(cmp, event);
    },

    enviarProxGrupoSolucionador: function (cmp, event, helper) {
        helper.carregando(cmp);
        helper.enviarProxGrupoSolucionadorOnClick(cmp, event);
    },

    clonar: function (cmp, event, helper) {
        helper.carregando(cmp);
        helper.clonarCaso(cmp, event, helper);
    },

    handleItemRemove: function (cmp, event) {
        var name = event.getParam("item").name;
        var items = cmp.get('v.items');
        var item = event.getParam("index");
        if (!items[item].existente) {
            if (confirm("Tem certeza que deseja remover " + items[item].label + " dos observadores?"))
                items.splice(item, 1);
        } else {
            helper.message(cmp, "error", "Erro!", "Não é possível excluir um observador já adicionado");
        }

        cmp.set('v.items', items);
    },

    eviarEmail: function (cmp, event, helper) {
        helper.sendEmail(cmp, event);
    },

    addObservadores: function (cmp, event, helper) {
        helper.carregando(cmp);
        helper.addObservadores(cmp, event);
    },

    addUser: function (cmp, event, helper) {
        helper.carregando(cmp);
        helper.addUser(cmp, event);
    },

    reabrir: function (cmp, event, helper) {
        helper.carregando(cmp);
        helper.reabrir(cmp, event);
    },

    fechar: function (cmp, event, helper) {
        helper.fecharCaso(cmp, event);
        //cmp.set("v.informouCliente", false);
        //helper.editar(cmp);
    },

    closeError: function (cmp, event, helper) {
        cmp.set("v.msgErro", '');
    },

    clickSpan: function (cmp, event, helper) {
        var campo = event.currentTarget.dataset.value;
        helper.openDetail(campo, cmp, event);
    },

    handleEnviarPesquisa: function (cmp, event, helper) {
        const deveEnviarPesquisa = cmp.get("v.enviarPesquisaSatisfacao");
        cmp.set("v.enviarPesquisaSatisfacao", !deveEnviarPesquisa);
    },

    handlePesquisaMotivo: function (cmp, event, helper) {
        const deveEnviarPesquisa = cmp.get("v.enviarPesquisaSatisfacao");
        if (!deveEnviarPesquisa) {
            const motivoNaoEnvioField = cmp.find('motivoNaoEnvio').get('v.value');
            if (motivoNaoEnvioField == undefined || motivoNaoEnvioField == '--Nenhum--')
                alert('É necessário enviar a pesquisa ou preencher o motivo de não envio');
            else
                helper.enviarPesquisaOuMotivo(cmp, event);
        } else
            helper.enviarPesquisaOuMotivo(cmp, event);
    }
})