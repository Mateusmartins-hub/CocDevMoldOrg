({
    getCamposCaso: function (cmp, event) {
        var getCamposCaso = cmp.get("c.getCamposCaso");
        getCamposCaso.setParams({
            idCaso: cmp.get("v.recordId")
        })
        getCamposCaso.setCallback(this, function (response) {
            var retorno = response.getReturnValue();
            var campos = [];

            for (var key in retorno) {
                var mapCamposDaSessao = [];

                for (var key2 in retorno[key]) {
                    mapCamposDaSessao.push({
                        key: key2,
                        value: retorno[key][key2]
                    });
                }

                campos.push({
                    key: key,
                    value: mapCamposDaSessao
                });
            }

            cmp.set("v.mapCamposCaso", campos);
        });
        $A.enqueueAction(getCamposCaso);
    },

    getTipos: function (cmp, event) {
        var getTiposParametrizacoes = cmp.get("c.getTipos");
        getTiposParametrizacoes.setCallback(this, function (response) {
            var arr = response.getReturnValue();
            var options = [];
            options.push({
                value: "",
                label: "--Nenhum--"
            });
            arr.forEach(function (element) {
                options.push({
                    value: element,
                    label: element
                });
            });

            cmp.set("v.tipos", options);
        });
        $A.enqueueAction(getTiposParametrizacoes);
    },

    verificaUsuarioGrupo: function (cmp, event) {
        var verificaUsuarioGrupo = cmp.get("c.verificaUsuarioGrupo");
        verificaUsuarioGrupo.setParams({
            idCaso: cmp.get("v.recordId")
        });
        verificaUsuarioGrupo.setCallback(this, function (response) {
            if (response.getState() == "SUCCESS") {
                cmp.set("v.pertenceAoGrupo", response.getReturnValue());
            } else {
                this.exibeMensagemErro(cmp, response.getError());
            }
            this.carregado(cmp, true);
        });
        $A.enqueueAction(verificaUsuarioGrupo);
    },

    message: function (cmp, type, title, msg) {
        if (cmp.get("v.isClassic")) {
            alert(msg);
        } else {
            var toastEvent = $A.get("e.force:showToast");
            toastEvent.setParams({
                "title": title,
                "message": msg,
                "type": type
            });
            toastEvent.fire();
        }
    },

    verificaUltimoGrupo: function (cmp, event) {
        var verificaUltimoGrupo = cmp.get("c.verificaUltimoGrupo");
        verificaUltimoGrupo.setParams({
            idCaso: cmp.get("v.recordId")
        });
        verificaUltimoGrupo.setCallback(this, function (response) {
            if (response.getState() == "SUCCESS") {
                cmp.set("v.isLastGrupoSolucionador", response.getReturnValue());
            } else {
                this.exibeMensagemErro(cmp, response.getError());
            }
            this.carregado(cmp, true);
        });
        $A.enqueueAction(verificaUltimoGrupo);
    },

    verificaPlataforma: function (cmp) {
        var isClassic = cmp.get("c.isClassic");
        isClassic.setCallback(this, function (response) {
            var retorno = response.getReturnValue();

            cmp.set("v.isClassic", retorno);
        });
        $A.enqueueAction(isClassic);
    },

    insertSolution: function (cmp, solutionId) {
        var insertSolution = cmp.get("c.insertSolution");
        insertSolution.setParams({
            idCaso: cmp.get("v.recordId"),
            idSolution: solutionId
        });
        $A.enqueueAction(insertSolution);
    },

    verificaContaPreenchida: function (cmp, event) {
        var value = this.getParameterByName(cmp, event, 'inContextOfRef');
        var accountId;

        if (!$A.util.isUndefinedOrNull(value)) {
            var context = JSON.parse(window.atob(value));
            accountId = context.attributes.recordId;
        }

        if (!$A.util.isUndefinedOrNull(accountId)) {
            var campos = cmp.find("campoEdicao");

            var convertIdToEighteen = cmp.get("c.convertIdToEighteen");
            convertIdToEighteen.setParams({
                idConta: accountId
            });
            convertIdToEighteen.setCallback(this, function (response) {
                if (response.getState() == 'SUCCESS') {
                    accountId = response.getReturnValue();

                    //Se houver apenas um campo na tela precisa complementar esse codigo para tratar
                    //do objeto campos sem ser um array
                    if (Array.isArray(campos)) {
                        campos.forEach(function (item) {
                            if (item.get("v.id") == "InputAccountId") {
                                item.set("v.value", accountId);
                            }
                        });
                    }
                }
            });
            $A.enqueueAction(convertIdToEighteen);
        }
    },

    verificaUsuarioAtualFila: function (cmp, event) {
        var payload = event.getParams().response;
        var isCriation = $A.util.isEmpty(cmp.get("v.recordId"));
        cmp.set("v.recordId", payload.id);

        var verificaUsuarioAtualFila = cmp.get("c.verificaUsuarioAtualFila");
        verificaUsuarioAtualFila.setParams({
            grupoSolucionador: cmp.get("v.grupoSolucionador")
        })
        verificaUsuarioAtualFila.setCallback(this, function (response) {
            if (response.getState() == "SUCCESS") {
                if (response.getReturnValue()) {
                    var url = location.href;
                    var link = url.substring(0, url.indexOf('/', 14)) + '/' + payload.id;
                    window.location.href = link;
                } else {
                    if (cmp.get("v.processoDeProxGrupo")) {
                        this.message(cmp, "success", "Sucesso!", "Enviado ao próximo grupo, você será redirecionado para a tela de início");
                        location.href = cmp.get("v.baseURL") + "/500";
                    } else {
                        var url = location.href;
                        var link = url.substring(0, url.indexOf('/', 14)) + '/' + payload.id;
                        window.location.href = link;
                    }
                }
            } else {
                var url = location.href;
                var link = url.substring(0, url.indexOf('/', 14)) + '/' + payload.id;
                window.location.href = link;
            }
        });
        $A.enqueueAction(verificaUsuarioAtualFila);
    },

    getRecordTypeIdPadrao: function (cmp) {
        var getRecordTypeId = cmp.get("c.getRecordTypeIdPadrao");
        getRecordTypeId.setCallback(this, function (response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                cmp.set("v.recordTypeId", response.getReturnValue());
            }
        });
        $A.enqueueAction(getRecordTypeId);
    },

    getDependentes: function (cmp, event, helper) {
        this.getSLAs(cmp, event, helper);
        this.getEmails(cmp, event, helper);
        this.getObservadores(cmp, event);
        this.getComments(cmp, event, helper);
        this.getNotes(cmp, event, helper);
        this.getMaterials(cmp, event, helper);
        this.getSolutions(cmp, event, helper);
        this.getAttachments(cmp, event, helper);
        this.getCaseHistories(cmp, event, helper);
    },

    getSLAs: function (cmp, event, helper) {
        var getSLAs = cmp.get("c.getSLAs");
        getSLAs.setParams({
            casoId: cmp.get("v.recordId")
        });
        getSLAs.setCallback(this, function (response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                //cmp.set("v.linkAllSLAs", cmp.get("v.baseURL") + "/" + "a10" + "?" + "rlid=" + "00N0m000002YZwo" + "&id=" + cmp.get("v.recordId")); // DEV
                //cmp.set("v.linkAllSLAs", cmp.get("v.baseURL") + "/" + "a10" + "?" + "rlid=" + "00N4C000001Kz2m" + "&id=" + cmp.get("v.recordId")); // HML
                cmp.set("v.linkAllSLAs", cmp.get("v.baseURL") + "/" + "a10" + "?" + "rlid=" + "00N0V0000093kIv" + "&id=" + cmp.get("v.recordId")); // PRD
                cmp.set("v.SLAs", response.getReturnValue());
                var gruposAnteriores = [];
                var listLabelGruposAnteriores = [];
                var c = 1;
                response.getReturnValue().forEach(function (item) {
                    if (c > 1) {
                        if (!listLabelGruposAnteriores.includes(item.NomeGrupoSolucionador__c) && item.Caso__r.GrupoSolucionador__c != item.NomeGrupoSolucionador__c) {
                            listLabelGruposAnteriores.push(item.NomeGrupoSolucionador__c);
                            gruposAnteriores.push({
                                value: item.GrupoSolucionador__c,
                                label: item.NomeGrupoSolucionador__c
                            });
                        }
                    }
                    c++;
                });
                gruposAnteriores.reverse();
                cmp.set("v.gruposSolucionadoresAnteriores", gruposAnteriores);
            }
        });
        $A.enqueueAction(getSLAs);
    },

    getObservadores: function (cmp, event) {
        var getUsers = cmp.get("c.getObservadores");
        getUsers.setParams({
            idCaso: cmp.get("v.recordId")
        });
        getUsers.setCallback(this, function (response) {
            var state = response.getState();
            var options = [];
            if (state === "SUCCESS") {
                response.getReturnValue().forEach(function (item) {
                    options.push({
                        type: 'icon',
                        iconName: 'standard:user',
                        alternativeText: 'Account',
                        value: item.Observador__c,
                        label: item.Observador__r.Name,
                        existente: true,
                        informacao: item.Informacao__c
                    });
                });
                cmp.set("v.items", options);
                cmp.set("v.observadores", response.getReturnValue());
            } else if (state === "ERROR") {
                this.exibeMensagemErro(cmp, response.getError());
            }
        });
        $A.enqueueAction(getUsers);
    },

    getEmails: function (cmp, event, helper) {
        var getEmails = cmp.get("c.getEmails");
        getEmails.setParams({
            casoId: cmp.get("v.recordId")
        });
        getEmails.setCallback(this, function (response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                cmp.set("v.linkAllEmails", cmp.get("v.baseURL") + "/" + "ui/email/EmailMessageListPage?id=" + cmp.get("v.recordId"));
                cmp.set("v.emails", response.getReturnValue());
            }
        });
        $A.enqueueAction(getEmails);
    },

    getComments: function (cmp, event, helper) {
        var getComments = cmp.get("c.getComments");
        getComments.setParams({
            casoId: cmp.get("v.recordId")
        });
        getComments.setCallback(this, function (response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                cmp.set("v.comments", response.getReturnValue());
            }
        });
        $A.enqueueAction(getComments);
    },

    getNotes: function (cmp, event, helper) {
        var getNotes = cmp.get("c.getNotes");
        getNotes.setParams({
            casoId: cmp.get("v.recordId")
        });
        getNotes.setCallback(this, function (response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                cmp.set("v.linkAllNotes", cmp.get("v.baseURL") + "a03" + "?" + "rlid=" + "00Nd0000007eKPl" + "&id=" + cmp.get("v.recordId"));
                cmp.set("v.notasVinculadas", response.getReturnValue());
            }
        });
        $A.enqueueAction(getNotes);
    },

    getMaterials: function (cmp, event, helper) {
        var getMaterials = cmp.get("c.getMaterials");
        getMaterials.setParams({
            casoId: cmp.get("v.recordId")
        });
        getMaterials.setCallback(this, function (response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                cmp.set("v.linkAllMaterials", cmp.get("v.baseURL") + "a04" + "?" + "rlid=" + "00Nd0000007eKPr" + "&id=" + cmp.get("v.recordId"));
                cmp.set("v.materiais", response.getReturnValue());
            }
        });
        $A.enqueueAction(getMaterials);
    },

    getSolutions: function (cmp, event, helper) {
        var getSolutions = cmp.get("c.getSolutions");
        getSolutions.setParams({
            casoId: cmp.get("v.recordId")
        });
        getSolutions.setCallback(this, function (response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                cmp.set("v.solutions", response.getReturnValue());
            }
        });
        $A.enqueueAction(getSolutions);
    },

    getAttachments: function (cmp, event, helper) {
        var getAttachments = cmp.get("c.getAttachments");
        getAttachments.setParams({
            casoId: cmp.get("v.recordId")
        });
        getAttachments.setCallback(this, function (response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                cmp.set("v.attachments", response.getReturnValue());
                cmp.set("v.linkAllAttachments", cmp.get("v.baseURL") + "ui/content/ViewAllAttachmentsPage?id=" + cmp.get("v.recordId") + "&retURL=%2F" + cmp.get("v.recordId"));
            }
        });
        $A.enqueueAction(getAttachments);
    },

    getCaseHistories: function (cmp, event, helper) {
        var getCaseHistories = cmp.get("c.getCaseHistories");
        getCaseHistories.setParams({
            casoId: cmp.get("v.recordId")
        });
        getCaseHistories.setCallback(this, function (response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                cmp.set("v.linkAllCaseHistories", cmp.get("v.baseURL") + "_ui/common/history/ui/EntityHistoryFilterPage?" + "id=" + cmp.get("v.recordId"));
                cmp.set("v.caseHistories", response.getReturnValue());
            }
        });
        $A.enqueueAction(getCaseHistories);
    },

    salvarForm: function (cmp, event) {
        event.preventDefault();
        var eventFields = event.getParam("fields");

        if (cmp.find("tipoCombobox") != undefined) eventFields["Tipo__c"] = cmp.find("tipoCombobox").get("v.value");
        if (cmp.find("subtipoCombobox") != undefined) eventFields["Subtipo__c"] = cmp.find("subtipoCombobox").get("v.value");
        if (cmp.find("detalhamentoCombobox") != undefined) eventFields["Detalhamento__c"] = cmp.find("detalhamentoCombobox").get("v.value");
        if (cmp.find("detalhamento2Combobox") != undefined) eventFields["Detalhamento2__c"] = cmp.find("detalhamento2Combobox").get("v.value");

        if (!this.validarArvoreAssunto(cmp, eventFields))
            return;

        var cancelouAlert = false;
        eventFields["RecordTypeId"] = cmp.get('v.recordTypeId');
        eventFields["EnviandoAoProxGrupo__c"] = cmp.get("v.processoDeProxGrupo");

        if (eventFields["EnviandoAoProxGrupo__c"] || $A.util.isEmpty(cmp.get("v.recordId")) || (eventFields["Tipo__c"] == "Atendimento" && eventFields["Subtipo__c"] == "Suporte")) {
            var grupoSolucionadorName = "";

            cmp.get("v.listGrupoSolucionador").forEach(function (grupo) {
                if (grupo.value == cmp.get("v.grupoSolucionador"))
                    grupoSolucionadorName = grupo.label;
            });

            eventFields["GrupoSolucionador__c"] = grupoSolucionadorName;
            eventFields["OrdemGrupoSolucionador__c"] = cmp.get("v.ordemGrupoSolucionador");
            eventFields["Status"] = "Novo";
        }

        eventFields["AreaDonaDoProcesso__c"] = cmp.get("v.areaDonaDoProcesso");
        eventFields["RetornandoSLA__c"] = false;

        if (cmp.get("v.processoDeParametrizacao") && eventFields["Tipo__c"] == "Atendimento" && eventFields["Subtipo__c"] == "Suporte") {
            eventFields["OrdemGrupoSolucionador__c"] = 0;
        }

        if (cmp.get("v.processoDeAddObservadores")) {
            var observadores = cmp.get("v.items");
            var stringObservadores = '';
            var informacoesObservadores = [];
            var contemErro = false;

            if (confirm("Tem certeza que deseja adicionar estes observadores? Não será possível excluí-los.")) {
                observadores.forEach(function (response) {
                    const inputs = cmp.find("InputInformacoes");

                    if ($A.util.isArray(inputs)) {
                        inputs.forEach(function (input) {
                            if (input.get("v.name") == response.value) {
                                if ($A.util.isUndefinedOrNull(input.get("v.value")) || $A.util.isEmpty(input.get("v.value"))) {
                                    input.setCustomValidity("Preencha este campo");
                                    input.reportValidity();
                                    contemErro = true;
                                } else {
                                    if (!input.get("v.disabled"))
                                        informacoesObservadores.push({
                                            observador: response.value,
                                            informacao: input.get("v.value"),
                                            casoId: cmp.get("v.recordId")
                                        });
                                }
                            }
                        });
                    } else {
                        if ($A.util.isUndefinedOrNull(inputs.get("v.value")) || $A.util.isEmpty(inputs.get("v.value"))) {
                            inputs.setCustomValidity("Preencha este campo");
                            inputs.reportValidity();
                            contemErro = true;
                        } else if (!inputs.get("v.disabled")) {
                            informacoesObservadores.push({
                                observador: response.value,
                                informacao: inputs.get("v.value"),
                                casoId: cmp.get("v.recordId")
                            });
                        }
                    }
                    stringObservadores += ';' + response.value;
                });

                if (contemErro) {
                    this.carregado(cmp, false)
                    return;
                }

                var salvarInformacoes = cmp.get("c.salvarInformacoes");
                salvarInformacoes.setParams({
                    informacoes: JSON.stringify(informacoesObservadores)
                });
                $A.enqueueAction(salvarInformacoes);

                eventFields["AddObservador__c"] = null;
                eventFields["Observadores__c"] = stringObservadores;
            } else {
                cancelouAlert = true;
            }
            location.reload();
        }
        if (cancelouAlert) {
            this.carregado(cmp, false);
            return;
        }

        if (cmp.get("v.processoDeVoltarAoGrupo")) {
            var inputDescricao = cmp.find("inputDescBackGrupoSolucionador").get("v.value");
            var grupoAEnviar = cmp.find("inputBackGrupoSolucionador").get("v.value");

            var gruposSolAnteriores = cmp.get("v.gruposSolucionadoresAnteriores"),
                index = gruposSolAnteriores.findIndex(item => item.value == grupoAEnviar),
                grupoAEnviarLabel = index >= 0 ? gruposSolAnteriores[index].label : null;

            if ($A.util.isUndefinedOrNull(grupoAEnviar)) {
                cmp.set("v.erroComboGrupoAnterior", "Preencha este campo");
                this.carregado(cmp, false);
                return;
            }
            if ($A.util.isUndefinedOrNull(inputDescricao)) {
                cmp.set("v.erroDescricaoGrupoAnterior", "Preencha este campo");
                this.carregado(cmp, false);
                return;
            }
            if (confirm("Tem certeza que deseja voltar a este grupo solucionador? Não será possível ver este caso na sua fila.")) {
                var buscarGrupoSolucionadorAtual = cmp.get("c.buscarGrupoSolucionadorAtual");
                buscarGrupoSolucionadorAtual.setParams({
                    grupoSolucionadorId: grupoAEnviar
                });
                buscarGrupoSolucionadorAtual.setCallback(this, function (response) {
                    var state = response.getState();

                    if (state === "SUCCESS") {
                        var grupo = response.getReturnValue();
                        eventFields["GrupoSolucionador__c"] = $A.util.isUndefinedOrNull(grupo.GrupoSolucionador__c) ? grupoAEnviarLabel : grupo.GrupoSolucionador__c;
                        eventFields["OrdemGrupoSolucionador__c"] = grupo.Ordem__c;
                        eventFields["RetornandoSLA__c"] = true;
                        eventFields["AceitoPor__c"] = null;
                        eventFields["Status"] = "Novo";
                        cmp.find('caseFormEdit').submit(eventFields);
                    } else if (state === "ERROR") {
                        this.exibeMensagemErro(cmp, response.getError());
                    }
                });
                $A.enqueueAction(buscarGrupoSolucionadorAtual);

                var criarComentario = cmp.get("c.criarComentario");
                criarComentario.setParams({
                    descComentario: inputDescricao,
                    casoId: cmp.get("v.recordId")
                });
                $A.enqueueAction(criarComentario);

                var retomarSLA = cmp.get("c.retomarSLA");
                retomarSLA.setParams({
                    casoId: cmp.get("v.recordId"),
                    grupoSolucionadorId: grupoAEnviar
                });
                $A.enqueueAction(retomarSLA);
            } else {
                cancelouAlert = true;
            }
        }
        if (cancelouAlert) {
            this.carregado(cmp, false);
            return;
        }

        if (cmp.get("v.processoDeProxGrupo")) {
            eventFields["AceitoPor__c"] = "";
        }

        if (!cmp.get("v.processoDeVoltarAoGrupo") && !cmp.get("v.processoDeProxGrupo") && !cmp.get("v.processoDeAddObservadores")) {
            if ($A.util.isUndefinedOrNull(eventFields["MarcaAtendimento__c"]) || eventFields["MarcaAtendimento__c"] == "") {
                this.message(cmp, "error", "Erro!", 'Preencha o campo de marca do atendimento');
                this.carregado(cmp, false);
                return;
            }
        }

        if (!cmp.get("v.processoDeVoltarAoGrupo")) {
            cmp.find('caseFormEdit').submit(eventFields);
        }
    },

    validarArvoreAssunto: function (cmp, eventFields) {
        if (!$A.util.isUndefinedOrNull(cmp.find("tipoCombobox"))) {
            cmp.find("tipoCombobox").setCustomValidity("");
            cmp.find("tipoCombobox").reportValidity();
        }

        if (!$A.util.isUndefinedOrNull(cmp.find("subtipoCombobox"))) {
            cmp.find("subtipoCombobox").setCustomValidity("");
            cmp.find("subtipoCombobox").reportValidity();
        }

        if (!$A.util.isUndefinedOrNull(cmp.find("detalhamentoCombobox"))) {
            cmp.find("detalhamentoCombobox").setCustomValidity("");
            cmp.find("detalhamentoCombobox").reportValidity();
        }

        if (!$A.util.isUndefinedOrNull(cmp.find("detalhamento2Combobox"))) {
            cmp.find("detalhamento2Combobox").setCustomValidity("");
            cmp.find("detalhamento2Combobox").reportValidity();
        }

        if (!$A.util.isUndefinedOrNull(cmp.find("grupoSolucionador"))) {
            cmp.find('grupoSolucionador').setCustomValidity("");
            cmp.find("grupoSolucionador").reportValidity();
        }

        if ($A.util.isEmpty(cmp.get("v.recordId")) && ($A.util.isUndefinedOrNull(eventFields["Tipo__c"]) || eventFields["Tipo__c"] == "") && !$A.util.isUndefinedOrNull(cmp.find("tipoCombobox"))) {
            cmp.find("tipoCombobox").setCustomValidity("Preencha este campo");
            cmp.find("tipoCombobox").reportValidity();
            this.carregado(cmp, false);
            return false;
        }

        if (($A.util.isUndefinedOrNull(eventFields["Tipo__c"]) || eventFields["Tipo__c"] == "") && !$A.util.isUndefinedOrNull(cmp.find("tipoCombobox"))) {
            cmp.find("tipoCombobox").setCustomValidity("Preencha este campo");
            cmp.find("tipoCombobox").reportValidity();
            this.carregado(cmp, false);
            return false;
        }

        if (!cmp.get("v.subtipoDesativado") && ($A.util.isUndefinedOrNull(eventFields["Subtipo__c"]) || eventFields["Subtipo__c"] == "") && !$A.util.isUndefinedOrNull(cmp.find("subtipoCombobox"))) {
            cmp.find("subtipoCombobox").setCustomValidity("Preencha este campo");
            cmp.find("subtipoCombobox").reportValidity();
            this.carregado(cmp, false);
            return false;
        }

        if (!cmp.get("v.detalhamentoDesativado") && ($A.util.isUndefinedOrNull(eventFields["Detalhamento__c"]) || eventFields["Detalhamento__c"] == "") && !$A.util.isUndefinedOrNull(cmp.find("detalhamentoCombobox"))) {
            cmp.find("detalhamentoCombobox").setCustomValidity("Preencha este campo");
            cmp.find("detalhamentoCombobox").reportValidity();
            this.carregado(cmp, false);
            return false;
        }

        if (!cmp.get("v.detalhamento2Desativado") && ($A.util.isUndefinedOrNull(eventFields["Detalhamento2__c"]) || eventFields["Detalhamento2__c"] == "") && !$A.util.isUndefinedOrNull(cmp.find("detalhamento2Combobox"))) {
            cmp.find("detalhamento2Combobox").setCustomValidity("Preencha este campo");
            cmp.find("detalhamento2Combobox").reportValidity();
            this.carregado(cmp, false);
            return false;
        }

        if (!$A.util.isUndefinedOrNull(cmp.find('grupoSolucionador')) && ($A.util.isUndefinedOrNull(cmp.find('grupoSolucionador').get('v.value')) || $A.util.isEmpty(cmp.find('grupoSolucionador').get('v.value')))) {
            cmp.find('grupoSolucionador').setCustomValidity("Preencha este campo");
            cmp.find('grupoSolucionador').reportValidity();
            this.carregado(cmp, false);
            return false;
        }

        return true;
    },

    exibeMensagemSucesso: function (cmp) {
        var toastParams = {
            title: "Sucesso",
            message: "Dados atualizados com sucesso",
            type: "success"
        };

        if (cmp.get('v.isClassic'))
            cmp.set("v.msgSucesso", toastParams.message);
        else
            this.message(cmp, "success", "Sucesso!", toastParams.message);
    },

    exibeMensagemErro: function (cmp, errors) {
        if (!$A.util.isUndefinedOrNull(errors)) {
            if (errors.length > 0) {
                if (!$A.util.isUndefinedOrNull(errors[0].fieldErrors)) {
                    if (errors[0].fieldErrors.length > 0) {
                        if (cmp.get('v.isClassic'))
                            cmp.set("v.msgErro", errors[0].fieldErrors[0].message);
                        else
                            this.message(cmp, "error", "Erro!", errors[0].fieldErrors[0].message);
                    } else if (errors[0].pageErrors.length > 0) {
                        if (cmp.get('v.isClassic'))
                            cmp.set("v.msgErro", errors[0].pageErrors[0].message);
                        else
                            this.message(cmp, "error", "Erro!", errors[0].fieldErrors[0].message);
                    }
                }
            }
        }

        console.log(JSON.stringify(errors));
    },

    getBaseURL: function (cmp, event) {
        var url = location.href;
        var baseURL = url.substring(0, url.indexOf('/', 14));
        cmp.set("v.baseURL", baseURL + "/");
    },

    cancelarForm: function (cmp, event) {
        var url_string = window.location.href;
        var url = new URL(url_string);
        var id = url.searchParams.get("id");
        if (id == null)
            id = cmp.get("v.recordId");
        if (id != '' && id != null) {
            cmp.set("v.processoDeProxGrupo", false);
            cmp.set("v.processoDeAddObservadores", false);
            cmp.set("v.processoDeVoltarAoGrupo", false);
            cmp.set("v.processoDeParametrizacao", false);
            cmp.set("v.processoDeFecharCaso", false);
            cmp.set("v.detalhamentoDesativado", true);
            cmp.set("v.detalhamento2Desativado", true);
            cmp.set("v.informouCliente", true);
            cmp.set("v.edit", false);
            cmp.set("v.view", true);
        } else {
            window.history.back();
        }
    },

    retornar: function (cmp, event) {
        window.history.back();
    },

    montarArvoreDeAssunto: function (cmp, event) {
        if (!$A.util.isUndefinedOrNull(cmp.get("v.caso"))) {
            var tipo = cmp.get("v.caso.Tipo__c");
            var subtipo = cmp.get("v.caso.Subtipo__c");
            var detalhamento = cmp.get("v.caso.Detalhamento__c");
            var detalhamento2 = cmp.get("v.caso.Detalhamento2__c");

            var tipos = [];
            var subtipos = [];
            var detalhamentos = [];
            var detalhamentos2 = [];

            tipos.push({
                value: tipo,
                label: tipo
            });
            cmp.set("v.tipos", tipos);

            if (tipo != null && subtipo != null && detalhamento != null && detalhamento2 != null) {
                subtipos.push({
                    value: subtipo,
                    label: subtipo
                });
                cmp.set("v.subtipos", subtipos);

                detalhamentos.push({
                    value: detalhamento,
                    label: detalhamento
                });
                cmp.set("v.detalhamentos", detalhamentos);

                detalhamentos2.push({
                    value: detalhamento2,
                    label: detalhamento2
                });
                cmp.set("v.detalhamentos2", detalhamentos2);

            } else if (tipo != null && subtipo != null && detalhamento != null) {
                subtipos.push({
                    value: subtipo,
                    label: subtipo
                });
                cmp.set("v.subtipos", subtipos);

                detalhamentos.push({
                    value: detalhamento,
                    label: detalhamento
                });
                cmp.set("v.detalhamentos", detalhamentos);
            } else if (tipo != null && subtipo != null) {
                subtipos.push({
                    value: subtipo,
                    label: subtipo
                });
                cmp.set("v.subtipos", subtipos);
            } else if (tipo != null) {
                cmp.set("v.subtipoDesativado", false);
            }
        }

        this.carregado(cmp, false);
    },

    editar: function (cmp, event, helper) {
        this.carregando(cmp);

        if (cmp.get("v.caso.Tipo__c") == "Atendimento" && cmp.get("v.caso.Subtipo__c") == "Suporte" && $A.util.isUndefinedOrNull(cmp.get("v.caso.Detalhamento__c"))) {
            cmp.set("v.processoDeParametrizacao", true);
            cmp.set("v.processoDeProxGrupo", false);
            cmp.set("v.processoDeAddObservadores", false);
            cmp.set("v.processoDeVoltarAoGrupo", false);

            cmp.set("v.tipoDesativado", false);
        } else {
            this.montarArvoreDeAssunto(cmp, event);
            cmp.set("v.processoDeProxGrupo", false);
            cmp.set("v.processoDeAddObservadores", false);
            cmp.set("v.processoDeVoltarAoGrupo", false);
            cmp.set("v.processoDeParametrizacao", false);
        }

        cmp.set("v.edit", true);
        cmp.set("v.view", false);
    },

    editar2: function (cmp, event, helper) {
        this.carregando(cmp);

        cmp.set("v.edit", true);
        cmp.set("v.view", false);
    },

    alteracaoTipo: function (cmp, event) {
        cmp.find("tipoCombobox").setCustomValidity("");
        cmp.find("tipoCombobox").reportValidity();

        cmp.find("subtipoCombobox").setCustomValidity("");
        cmp.find("subtipoCombobox").reportValidity();

        cmp.find("detalhamentoCombobox").setCustomValidity("");
        cmp.find("detalhamentoCombobox").reportValidity();

        cmp.find("detalhamento2Combobox").setCustomValidity("");
        cmp.find("detalhamento2Combobox").reportValidity();

        cmp.find('grupoSolucionador').setCustomValidity("");
        cmp.find('grupoSolucionador').reportValidity();

        cmp.find("subtipoCombobox").set("v.value", null);
        cmp.find("detalhamentoCombobox").set("v.value", null);
        cmp.find("detalhamento2Combobox").set("v.value", null);

        var options = [];
        var action = cmp.get("c.getSubtipos");
        var caso = cmp.get("v.caso");

        caso.Tipo__c = event.getParam("value");

        if (caso.Tipo__c != null && caso.Id == null) {
            action.setParams({
                tipo: caso.Tipo__c
            });
            action.setCallback(this, function (response) {
                var state = response.getState();
                if (state === "SUCCESS") {
                    var arr = response.getReturnValue();
                    options.push({
                        value: "",
                        label: "--Nenhum--"
                    });
                    cmp.set("v.subtipoDesativado", true);
                    cmp.set("v.detalhamentoDesativado", true);
                    cmp.set("v.detalhamento2Desativado", true);

                    arr.forEach(function (element) {
                        options.push({
                            value: element,
                            label: element
                        });
                        cmp.set("v.subtipoDesativado", false);
                    });
                    cmp.set("v.subtipos", options);

                    this.alteracaoSubtipo(cmp, event);
                } else if (state === "ERROR") {
                    this.exibeMensagemErro(cmp, response.getError());
                }
                this.carregado(cmp, false);
            });
            $A.enqueueAction(action);
        } else {
            action.setParams({
                tipo: caso.Tipo__c
            });
            action.setCallback(this, function (response) {
                var state = response.getState();
                if (state === "SUCCESS") {
                    var arr = response.getReturnValue();
                    options.push({
                        value: "",
                        label: "--Nenhum--"
                    });
                    cmp.set("v.subtipoDesativado", true);
                    cmp.set("v.detalhamentoDesativado", true);
                    cmp.set("v.detalhamento2Desativado", true);

                    arr.forEach(function (element) {
                        options.push({
                            value: element,
                            label: element
                        });
                        cmp.set("v.subtipoDesativado", false);
                    });
                    cmp.set("v.subtipos", options);
                    this.alteracaoSubtipo(cmp, event);

                    cmp.find("tipoCombobox").set("v.value", caso.Tipo__c);
                } else if (state === "ERROR") {
                    this.exibeMensagemErro(cmp, response.getError());
                }
                this.carregado(cmp, false);
            });
            $A.enqueueAction(action);
        }
    },

    alteracaoSubtipo: function (cmp, event) {
        cmp.find("subtipoCombobox").setCustomValidity("");
        cmp.find("subtipoCombobox").reportValidity();

        cmp.find("detalhamentoCombobox").setCustomValidity("");
        cmp.find("detalhamentoCombobox").reportValidity();

        cmp.find("detalhamento2Combobox").setCustomValidity("");
        cmp.find("detalhamento2Combobox").reportValidity();

        cmp.find('grupoSolucionador').setCustomValidity("");
        cmp.find('grupoSolucionador').reportValidity();

        cmp.find("detalhamentoCombobox").set("v.value", null);
        cmp.find("detalhamento2Combobox").set("v.value", null);

        var options = [];
        var action = cmp.get("c.getDetalhamentos");
        var caso = cmp.get("v.caso");

        var subtipoDesativado = cmp.get("v.subtipoDesativado");

        caso.Tipo__c = cmp.find("tipoCombobox").get("v.value");
        caso.Subtipo__c = subtipoDesativado ? '' : cmp.find("subtipoCombobox").get("v.value");

        if (caso.Subtipo__c != null && caso.Id == null) {
            action.setParams({
                tipo: caso.Tipo__c,
                subtipo: caso.Subtipo__c
            });
            action.setCallback(this, function (response) {
                var state = response.getState();
                if (state === "SUCCESS") {
                    var arr = response.getReturnValue();
                    options.push({
                        value: "",
                        label: "--Nenhum--"
                    });
                    cmp.set("v.detalhamentoDesativado", true);
                    cmp.set("v.detalhamento2Desativado", true);

                    arr.forEach(function (element) {
                        options.push({
                            value: element,
                            label: element
                        });
                        cmp.set("v.detalhamentoDesativado", false);
                    });
                    cmp.set("v.detalhamentos", options);
                    this.alteracaoDetalhamento(cmp, event);
                } else if (state === "ERROR") {
                    this.exibeMensagemErro(cmp, response.getError());
                }
                this.carregado(cmp, false);
            });
            $A.enqueueAction(action);
        } else {
            action.setParams({
                tipo: caso.Tipo__c,
                subtipo: caso.Subtipo__c
            });
            action.setCallback(this, function (response) {
                var state = response.getState();
                if (state === "SUCCESS") {
                    var arr = response.getReturnValue();
                    options.push({
                        value: "",
                        label: "--Nenhum--"
                    });
                    cmp.set("v.subtipoDesativado", false);
                    cmp.set("v.detalhamentoDesativado", true);
                    cmp.set("v.detalhamento2Desativado", true);

                    arr.forEach(function (element) {
                        options.push({
                            value: element,
                            label: element
                        });
                        cmp.set("v.detalhamentoDesativado", false);
                    });
                    cmp.set("v.detalhamentos", options);
                    this.alteracaoDetalhamento(cmp, event);
                } else if (state === "ERROR") {
                    this.exibeMensagemErro(cmp, response.getError());
                }
                this.carregado(cmp, false);
            });
            $A.enqueueAction(action);
        }
    },

    alteracaoDetalhamento: function (cmp, event) {
        cmp.find("detalhamentoCombobox").setCustomValidity("");
        cmp.find("detalhamentoCombobox").reportValidity();

        cmp.find("detalhamento2Combobox").setCustomValidity("");
        cmp.find("detalhamento2Combobox").reportValidity();

        cmp.find('grupoSolucionador').setCustomValidity("");
        cmp.find('grupoSolucionador').reportValidity();

        cmp.find("detalhamento2Combobox").set("v.value", null);

        var options = [];
        var action = cmp.get("c.getDetalhamentos2");

        var caso = cmp.get("v.caso");

        var subtipoDesativado = cmp.get("v.subtipoDesativado");
        var detalhamentoDesativado = cmp.get("v.detalhamentoDesativado");

        caso.Tipo__c = cmp.find("tipoCombobox").get("v.value");
        caso.Subtipo__c = subtipoDesativado ? '' : cmp.find("subtipoCombobox").get("v.value");
        caso.Detalhamento__c = detalhamentoDesativado ? '' : cmp.find("detalhamentoCombobox").get("v.value");

        if (caso.Detalhamento__c != null && caso.Id == null) {
            action.setParams({
                tipo: caso.Tipo__c,
                subtipo: caso.Subtipo__c,
                detalhamento: caso.Detalhamento__c
            });
            action.setCallback(this, function (response) {
                var state = response.getState();
                if (state === "SUCCESS") {
                    var arr = response.getReturnValue();
                    options.push({
                        value: "",
                        label: "--Nenhum--"
                    });
                    cmp.set("v.detalhamento2Desativado", true);

                    arr.forEach(function (element) {
                        options.push({
                            value: element,
                            label: element
                        });
                        cmp.set("v.detalhamento2Desativado", false);
                    });
                    cmp.set("v.detalhamentos2", options);
                    this.alteracaoDetalhamento2(cmp, event);
                } else if (state === "ERROR") {
                    this.exibeMensagemErro(cmp, response.getError());
                }
                this.carregado(cmp, false);
            });
            $A.enqueueAction(action);
        } else {
            action.setParams({
                tipo: caso.Tipo__c,
                subtipo: caso.Subtipo__c,
                detalhamento: caso.Detalhamento__c
            });
            action.setCallback(this, function (response) {
                var state = response.getState();
                if (state === "SUCCESS") {
                    var arr = response.getReturnValue();
                    options.push({
                        value: "",
                        label: "--Nenhum--"
                    });
                    cmp.set("v.detalhamento2Desativado", true);

                    arr.forEach(function (element) {
                        options.push({
                            value: element,
                            label: element
                        });
                        cmp.set("v.detalhamento2Desativado", false);
                    });
                    cmp.set("v.detalhamentos2", options);
                    this.alteracaoDetalhamento2(cmp, event);
                } else if (state === "ERROR") {
                    this.exibeMensagemErro(cmp, response.getError());
                }
                this.carregado(cmp, false);
            });
            $A.enqueueAction(action);
        }
    },

    alteracaoDetalhamento2: function (cmp, event) {
        cmp.find("detalhamento2Combobox").setCustomValidity("");
        cmp.find("detalhamento2Combobox").reportValidity();

        cmp.find('grupoSolucionador').setCustomValidity("");
        cmp.find('grupoSolucionador').reportValidity();

        this.enviarProxGrupoSolucionadorOnChange(cmp, event);
    },


    visualizar: function (cmp, event) {
        cmp.set("v.edit", false);
        cmp.set("v.view", true);
    },

    excluirRegistro: function (cmp, caso, event) {
        var action = cmp.get("c.deleteCase");
        action.setParams({
            "caso": caso
        });
        action.setCallback(this, function (response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                this.message(cmp, "success", "Sucesso!", "Registro excluído com sucesso!");
                var url = window.location.href;
                var value = url.substr(0, url.lastIndexOf('/') + 1);
                window.location = value;
            } else if (state === "ERROR") {
                this.exibeMensagemErro(cmp, response.getError());
            }
            this.carregado(cmp, false);
        });
        $A.enqueueAction(action);
    },

    enviarProxGrupoSolucionadorOnClick: function (cmp, event) {
        var casoPagina = cmp.get("v.caso");

        if ($A.util.isUndefinedOrNull(casoPagina.AceitoPor__c) || $A.util.isEmpty(casoPagina.AceitoPor__c)) {
            this.message(cmp, "error", "Erro!", "Aceite o caso antes de enviar ao próximo grupo solucionador!");
            this.carregado(cmp, false);
            return;
        }

        if ($A.util.isUndefinedOrNull(casoPagina.MarcaAtendimento__c) || $A.util.isEmpty(casoPagina.MarcaAtendimento__c)) {
            this.message(cmp, "error", "Erro!", "Edite o caso e preencha a marca de atendimento!");
            this.carregado(cmp, false);
            return;
        }
        /*
        if(casoPagina.Status != "Novo") {
            this.message(cmp, "error", "Erro!", "Altere o Status para 'Novo' antes de enviar ao próximo grupo solucionador!");
            this.carregado(cmp, false);
            return;
        } */

        var buscarProxGrupo = cmp.get("c.buscarProxGrupo");
        cmp.set("v.temCampoProxGrupo", false);

        buscarProxGrupo.setParams({
            tipo: casoPagina.Tipo__c,
            subtipo: casoPagina.Subtipo__c,
            detalhamento: casoPagina.Detalhamento__c,
            detalhamento2: casoPagina.Detalhamento2__c,
            ordemAtual: casoPagina.OrdemGrupoSolucionador__c
        });

        buscarProxGrupo.setCallback(this, function (response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                var proxGrupos = response.getReturnValue();
                var casoAtual = cmp.get("v.caso");

                if (proxGrupos != null) {
                    var proxGrupo = proxGrupos[0];
                    var grupos = [];

                    proxGrupos.forEach(function (grupo) {
                        grupos.push({
                            value: grupo.Id,
                            label: grupo.GrupoSolucionador__c,
                            grupo: grupo
                        })
                    });

                    cmp.set("v.listGrupoSolucionador", grupos);
                    cmp.set("v.ordemGrupoSolucionador", proxGrupo.Ordem__c);
                    cmp.set("v.grupoSolucionador", proxGrupo.Id);

                    if (proxGrupos.length > 1) cmp.set("v.grupoSolucionadorDesativado", false);

                    cmp.set("v.areaDonaDoProcesso", proxGrupo.ParametrizacaoCasos__r.AreaDonaProcesso__c);

                    if (proxGrupo.CamposObrigatorios__c != undefined || proxGrupo.CamposObrigatorios__c != null) {

                        var a = proxGrupo.CamposObrigatorios__c.split(";"),
                            i;
                        var campos = [];

                        for (i = 0; i < a.length; i++) {
                            campos.push(a[i]);
                        }
                        cmp.set("v.temCampoProxGrupo", true);
                        cmp.set("v.camposProxGrupo", campos);
                    }
                    this.editar(cmp, event);
                    cmp.set("v.processoDeProxGrupo", true);
                    cmp.set("v.tipoDesativado", true);
                    cmp.set("v.subtipoDesativado", true);
                    cmp.set("v.detalhamentoDesativado", true);
                    cmp.set("v.detalhamento2Desativado", true);

                    cmp.find("tipoCombobox").set("v.value", casoPagina.Tipo__c);
                    cmp.find("subtipoCombobox").set("v.value", casoPagina.Subtipo__c);
                    cmp.find("detalhamentoCombobox").set("v.value", casoPagina.Detalhamento__c);
                    cmp.find("detalhamento2Combobox").set("v.value", casoPagina.Detalhamento2__c);
                } else {
                    this.message(cmp, "error", "Erro!", "Não há mais um próximo grupo solucionador");
                }
            } else if (state === "ERROR") {
                this.exibeMensagemErro(cmp, response.getError());
            }
            this.carregado(cmp, true);
        });
        $A.enqueueAction(buscarProxGrupo);
    },

    enviarProxGrupoSolucionadorOnChange: function (cmp, event) {
        this.carregando(cmp);

        var buscarProxGrupo = cmp.get("c.buscarProxGrupo");
        var casoPagina = cmp.get("v.caso");
        var eventFields = event.getParam("fields");

        var tipoDesativado = cmp.get("v.tipoDesativado");
        var subtipoDesativado = cmp.get("v.subtipoDesativado");
        var detalhamentoDesativado = cmp.get("v.detalhamentoDesativado");
        var detalhamento2Desativado = cmp.get("v.detalhamento2Desativado");

        casoPagina.Tipo__c = tipoDesativado ? '' : cmp.find("tipoCombobox").get("v.value");
        casoPagina.Subtipo__c = subtipoDesativado ? '' : cmp.find("subtipoCombobox").get("v.value");
        casoPagina.Detalhamento__c = detalhamentoDesativado ? '' : cmp.find("detalhamentoCombobox").get("v.value");
        casoPagina.Detalhamento2__c = detalhamento2Desativado ? '' : cmp.find("detalhamento2Combobox").get("v.value");

        cmp.set("v.ordemGrupoSolucionador", '');
        cmp.set("v.grupoSolucionador", '');
        cmp.set("v.areaDonaDoProcesso", '');
        cmp.set("v.temCampoProxGrupo", false);

        var ordemGrupo = !$A.util.isUndefinedOrNull(casoPagina.Origin) && casoPagina.Origin.includes("Email") ? 0 : casoPagina.OrdemGrupoSolucionador__c;
        ordemGrupo = $A.util.isEmpty(cmp.get("v.recordId")) ? -1 : ordemGrupo;

        buscarProxGrupo.setParams({
            tipo: casoPagina.Tipo__c,
            subtipo: casoPagina.Subtipo__c,
            detalhamento: casoPagina.Detalhamento__c,
            detalhamento2: casoPagina.Detalhamento2__c,
            ordemAtual: 0
        });
        buscarProxGrupo.setCallback(this, function (response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                var proxGrupos = response.getReturnValue();
                if (!$A.util.isUndefinedOrNull(proxGrupos)) {
                    /*
                    var buscar = cmp.get("c.buscarGruposDoUser");
                    buscar.setParams({
                        idUsuario: $A.get("$SObjectType.CurrentUser.Id")
                    });
                    buscar.setCallback(this, function (response) {
                        var state = response.getState();
                        if (state === "SUCCESS") {
                            var arr = response.getReturnValue();
                            var options = [];

                            if (arr.length == 0) {
                                cmp.find('grupoSolucionador').setCustomValidity("Você não foi encontrado em nenhum grupo, contate o Tech.");
                                cmp.find('grupoSolucionador').reportValidity();
                            } else {
                                var i = 1;
                                arr.forEach(function (element) {
                                    options.push({
                                        value: i + 'grupoSolucionadorZero' + proxGrupos[0].Id,
                                        label: element
                                    });
                                    i++;
                                });

                                cmp.set("v.listGrupoSolucionador", options);
                                cmp.set("v.grupoSolucionadorDesativado", false);
                            }
                        }

                        this.carregado(cmp, false);
                    });
                    $A.enqueueAction(buscar);
        */

                    var proxGrupo = proxGrupos[0];
                    var grupos = [];

                    if (proxGrupos.length > 1) {
                        proxGrupos.forEach(function (grupo) {
                            grupos.push({
                                value: grupo.Id,
                                label: grupo.GrupoSolucionador__c,
                                grupo: grupo
                            })
                        });
                        cmp.set("v.listGrupoSolucionador", grupos);
                        cmp.set("v.ordemGrupoSolucionador", proxGrupo.Ordem__c);
                        cmp.set("v.grupoSolucionador", proxGrupo.Id);

                        cmp.set("v.grupoSolucionadorDesativado", false);
                    } else {
                        cmp.set("v.ordemGrupoSolucionador", proxGrupo.Ordem__c);
                        cmp.set("v.grupoSolucionador", proxGrupo.GrupoSolucionador__c);

                        cmp.set("v.listGrupoSolucionador", [{
                            label: proxGrupo.GrupoSolucionador__c,
                            value: proxGrupo.GrupoSolucionador__c
                        }]);

                        cmp.set("v.grupoSolucionadorDesativado", true);
                    }

                    cmp.set("v.areaDonaDoProcesso", proxGrupo.ParametrizacaoCasos__r.AreaDonaProcesso__c);
                    if (!$A.util.isUndefinedOrNull(proxGrupo.CamposObrigatorios__c)) {
                        var a = proxGrupo.CamposObrigatorios__c.split(";"),
                            i;
                        var campos = [];

                        for (i = 0; i < a.length; i++) {
                            campos.push(a[i]);
                        }

                        cmp.set("v.temCampoProxGrupo", true);
                        cmp.set("v.camposProxGrupo", campos);
                    }
                    this.carregado(cmp, false);
                }

            } else if (state === "ERROR") {
                this.exibeMensagemErro(cmp, response.getError());
            }
        });
        $A.enqueueAction(buscarProxGrupo);
    },

    voltarAoGrupo: function (cmp, event) {
        var casoPagina = cmp.get("v.caso");

        if ($A.util.isUndefinedOrNull(casoPagina.AceitoPor__c) || $A.util.isEmpty(casoPagina.AceitoPor__c)) {
            this.message(cmp, "error", "Erro!", "Aceite o caso antes de enviar ao grupo solucionador anterior!");
            this.carregado(cmp, false);
            return;
        }
        /*
        if(casoPagina.Status != "Novo") {
            this.message(cmp, "error", "Erro!", "Altere o Status para 'Novo' antes de enviar ao grupo solucionador anterior!");
            this.carregado(cmp, false);
            return;
        }
        */
        this.editar(cmp, event);
        cmp.set("v.processoDeVoltarAoGrupo", true);
        cmp.set("v.tipoDesativado", true);
        cmp.set("v.subtipoDesativado", true);
        cmp.set("v.detalhamentoDesativado", true);
        cmp.set("v.detalhamento2Desativado", true);

        var casoPagina = cmp.get("v.caso");
        cmp.find("tipoCombobox").set("v.value", casoPagina.Tipo__c);
        cmp.find("subtipoCombobox").set("v.value", casoPagina.Subtipo__c);
        cmp.find("detalhamentoCombobox").set("v.value", casoPagina.Detalhamento__c);
        cmp.find("detalhamento2Combobox").set("v.value", casoPagina.Detalhamento2__c);
        cmp.find("grupoSolucionador").set("v.value", casoPagina.GrupoSolucionador__c);
        cmp.set("v.grupoSolucionador", casoPagina.GrupoSolucionador__c);
        cmp.set("v.areaDonaDoProcesso", casoPagina.AreaDonaProcesso__c);
    },

    addObservadores: function (cmp, event) {
        this.editar(cmp, event);
        cmp.set("v.processoDeAddObservadores", true);
        cmp.set("v.tipoDesativado", true);
        cmp.set("v.subtipoDesativado", true);
        cmp.set("v.detalhamentoDesativado", true);
        cmp.set("v.detalhamento2Desativado", true);

        var casoPagina = cmp.get("v.caso");
        cmp.find("tipoCombobox").set("v.value", casoPagina.Tipo__c);
        cmp.find("subtipoCombobox").set("v.value", casoPagina.Subtipo__c);
        cmp.find("detalhamentoCombobox").set("v.value", casoPagina.Detalhamento__c);
        cmp.find("detalhamento2Combobox").set("v.value", casoPagina.Detalhamento2__c);
        cmp.find("grupoSolucionador").set("v.value", casoPagina.GrupoSolucionador__c);
        cmp.set("v.grupoSolucionador", casoPagina.GrupoSolucionador__c);
        cmp.set("v.areaDonaDoProcesso", casoPagina.AreaDonaProcesso__c);
    },

    retornarFila: function (cmp, event) {
        var retornarFila = cmp.get("c.retornarFila");
        retornarFila.setParams({
            idCaso: cmp.get("v.recordId")
        });
        retornarFila.setCallback(this, function (response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                var retorno = response.getReturnValue();
                if (!retorno) {
                    this.message(cmp, "error", "Erro!", "Você não tem permissão para retornar esse caso à fila, caso seja necessário, solicite à um Coordenador do Customer Care.");
                } else {
                    this.message(cmp, "success", "Sucesso!", 'Caso retornado à fila com sucesso');
                }
            } else if (state === "ERROR") {
                this.message(cmp, "error", "Erro!", "Aconteceu um erro inesperado");
                console.log(response.getError());
            }
            this.carregado(cmp, false);
        });
        $A.enqueueAction(retornarFila);
    },

    sendEmail: function (cmp, event) {
        this.carregando(cmp);
        var contemErro = false;
        
        var emailDe = cmp.find("emailDe").get("v.value");
        var emailPara = cmp.find("emailPara").get("v.value");
        var descricaoEmail = cmp.find("inputDescEmailFechamento").get("v.value");

        if ($A.util.isUndefinedOrNull(descricaoEmail) || $A.util.isEmpty(descricaoEmail)) {
            cmp.find("inputDescEmailFechamento").setCustomValidity("Preencha este campo");
            cmp.find("inputDescEmailFechamento").reportValidity();
            contemErro = true;
        }

        if ($A.util.isUndefinedOrNull(emailDe) || $A.util.isEmpty(emailDe)) {
            cmp.find("emailDe").setCustomValidity("Preencha este campo");
            cmp.find("emailDe").reportValidity();
            contemErro = true;
        }

        if ($A.util.isUndefinedOrNull(emailPara) || $A.util.isEmpty(emailPara)) {
            cmp.find("emailPara").setCustomValidity("Preencha este campo");
            cmp.find("emailPara").reportValidity();
            contemErro = true;
        }

        if (contemErro) {
            this.carregado(cmp, false);
            return;
        }

        var enviarEmailFechamento = cmp.get("c.enviarEmailFechamento");
        enviarEmailFechamento.setParams({
            de: emailDe,
            para: emailPara,
            texto: descricaoEmail,
            casoId: cmp.get("v.recordId")
        });

        enviarEmailFechamento.setCallback(this, function (response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                this.message(cmp, "success", "Sucesso!", 'Email enviado com sucesso!');
                location.reload();
            } else if (state === "ERROR") {
                this.message(cmp, "error", "Erro!", "Aconteceu um erro inesperado");
                console.log(response.getError());
            }
        });

        $A.enqueueAction(enviarEmailFechamento);
    },

    addUser: function (cmp, event) {
        var options = cmp.get("v.items");
        var mycmp = cmp.find("usuarioCombo");
        if (!$A.util.isUndefined(mycmp.get("v.value")) && !$A.util.isEmpty(mycmp.get("v.value"))) {
            var getUser = cmp.get("c.getUser");
            getUser.setParams({
                idUser: mycmp.get("v.value")
            });
            getUser.setCallback(this, function (response) {
                var state = response.getState();
                if (state === "SUCCESS") {
                    var userName = response.getReturnValue().Name;
                    var opcao = {
                        type: 'icon',
                        iconName: 'standard:user',
                        alternativeText: 'Account',
                        value: mycmp.get("v.value"),
                        label: userName
                    };

                    for (var i = 0; i < options.length; i++) {
                        if (options[i].value == opcao.value) {
                            this.carregado(cmp, false);
                            return;
                        }
                    }

                    options.push(opcao);
                    cmp.set("v.items", options);
                    this.carregado(cmp, false);
                } else if (state === "ERROR") {
                    this.exibeMensagemErro(cmp, response.getError());
                }
            });
            $A.enqueueAction(getUser);
        } else {
            this.carregado(cmp, false);
        }
    },

    clonarCaso: function (cmp, event) {
        if (confirm("Tem certeza que deseja clonar esse caso?")) {
            var clonarCaso = cmp.get("c.clonarCaso");
            clonarCaso.setParams({
                idCaso: cmp.get("v.recordId")
            });
            clonarCaso.setCallback(this, function (response) {
                var state = response.getState();
                if (state === "SUCCESS") {
                    var retorno = response.getReturnValue();
                    if (retorno == 'SEMPERMISSAO') {
                        this.message(cmp, "error", "Erro!", "Você não tem permissão para clonar esse caso, caso seja necessário, solicite ao Customer Care");
                    } else {
                        this.message(cmp, "success", "Sucesso!", 'Caso clonado com sucesso');
                        location.href = cmp.get("v.baseURL") + '/' + retorno;
                    }
                } else if (state === "ERROR") {
                    this.message(cmp, "error", "Erro!", "Aconteceu um erro inesperado");
                    console.log(response.getError());
                }
                this.carregado(cmp, false);
            });
            $A.enqueueAction(clonarCaso);
        } else {
            this.carregado(cmp, false);
        }
    },

    fecharCaso: function (cmp, event) {
        var fecharCaso = cmp.get("c.fecharCaso");
        fecharCaso.setParams({
            idCaso: cmp.get("v.recordId")
        });
        fecharCaso.setCallback(this, function (response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                var retorno = response.getReturnValue();
                if (retorno == "POSSUIGRUPONAFRENTE") {
                    this.message(cmp, "error", "Erro!", "Não é possível fechar este caso, ainda há um próximo grupo solucionador");
                } else if (retorno == "FECHADO") {
                    this.message(cmp, "success", "Sucesso!", "O caso foi fechado com sucesso");
                    if (confirm("Deseja informar o cliente?")) {
                        this.editar(cmp);
                        this.carregarEmailsDe(cmp, event);
                        cmp.set("v.processoDeFecharCaso", true);
                        this.carregado(cmp, true);
                    } else {
                        location.reload();
                    }
                } else if (retorno == "JAESTAFECHADO") {
                    this.message(cmp, "error", "Erro!", "O caso não está aberto");
                } else if (retorno == 'CASOAGUARDANDOCLIENTE') {
                    this.message(cmp, "error", "Erro!", "Você não pode fechar um caso que está com a situação \"Aguardando Cliente\"");
                } else if (retorno == 'CASONAOFOIACEITOPELOUSUARIO') {
                    this.message(cmp, "error", "Erro!", "Aceite o caso antes de fechá-lo");
                }
            } else if (state === "ERROR") {
                this.message(cmp, "error", "Erro!", "Aconteceu um erro inesperado");
                console.log(response.getError());
            }
            this.carregado(cmp, false);
        });
        $A.enqueueAction(fecharCaso);
    },

    carregarEmailsDe: function (cmp, event) {
        var carregarEmailsDe = cmp.get("c.carregarEmailsDe");
        carregarEmailsDe.setParams({
            ouvidoria: cmp.get("v.caso.CasoOuvidoria__c"),
            marca: cmp.get("v.caso.MarcaAtendimento__c"),
            lob: cmp.get("v.caso.LinhaNegocioAtendimento__c")
        });
        carregarEmailsDe.setCallback(this, function (response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                var arr = response.getReturnValue();
                var options = [];

                arr.forEach(function (element) {
                    options.push({
                        value: element,
                        label: element
                    });
                });

                cmp.set("v.emailsDe", options);
                cmp.set("v.emailDe", arr[0]);
            } else if (state === "ERROR") {
                this.message(cmp, "error", "Erro!", "Aconteceu um erro inesperado");
                console.log(response.getError());
            }
            this.carregado(cmp, false);
        });
        $A.enqueueAction(carregarEmailsDe);
    },

    cancelarCaso: function (cmp, event) {
        if (confirm("Tem certeza que deseja cancelar esse caso?")) {
            var cancelarCaso = cmp.get("c.cancelarCaso");
            cancelarCaso.setParams({
                idCaso: cmp.get("v.recordId")
            });
            cancelarCaso.setCallback(this, function (response) {
                var state = response.getState();
                if (state === "SUCCESS") {
                    var retorno = response.getReturnValue();
                    this.message(cmp, "success", "Sucesso!", "O caso foi cancelado com sucesso");
                    location.reload();
                } else if (state === "ERROR") {
                    this.message(cmp, "error", "Erro!", "Aconteceu um erro inesperado");
                    console.log(response.getError());
                }
                this.carregado(cmp, false);
            });
            $A.enqueueAction(cancelarCaso);
        } else {
            this.carregado(cmp, false);
        }
    },

    getCase: function (cmp, event) {

        var getCase = cmp.get("c.getCase");
        getCase.setParams({
            idCaso: cmp.get("v.recordId")
        });
        getCase.setCallback(this, function (response) {
            this.carregando(cmp);
            var state = response.getState();
            if (state === "SUCCESS") {
                var retorno = response.getReturnValue();
                if ($A.util.isUndefinedOrNull(retorno)) {
                    this.message(cmp, "error", "Erro!", "Este caso não pertence mais ao seu grupo solucionador")
                    location.href = cmp.get("v.baseURL") + "/500";
                } else {
                    if ($A.util.isEmpty(cmp.get("v.recordId")))
                        document.title = "Novo caso ~ Pearson";
                    else
                        document.title = "Caso: " + retorno.CaseNumber + " ~ Pearson";

                    cmp.set("v.caso", retorno);
                }
            } else if (state === "ERROR") {
                this.exibeMensagemErro(cmp, response.getError());
            }
        });
        $A.enqueueAction(getCase);
    },

    openDetail: function (campo, cmp, event) {
        var caso = cmp.get("v.caso");
        var valor = caso[campo];

        if (!$A.util.isUndefined(valor) && !$A.util.isEmpty(valor))
            location.href = cmp.get("v.baseURL") + '/' + valor;
    },

    showRelatedLists: function (cmp) {
        var showObj = {
            SlasDoCaso: true,
            ComentariosDoCaso: true,
            ObservadoresDoCaso: true,
            EmailsDoCaso: true,
            NotasDoCaso: true,
            MateriaisDoCaso: true,
            SolucoesDoCaso: true,
            AnexosDoCaso: true,
            HistoricosDoCaso: true
        };
        cmp.set("v.showRelatedLists", showObj);
    },

    aceitar: function (cmp, event) {
        var aceitarAction = cmp.get("c.aceitarCaso");

        aceitarAction.setParams({
            idCaso: cmp.get("v.recordId")
        });
        aceitarAction.setCallback(this, function (response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                var resp = response.getReturnValue();
                if (resp == "sucesso") {
                    this.message(cmp, "success", "Sucesso!", "Agora você é responsável por este caso");
                    location.reload();
                } else {
                    this.message(cmp, "error", "Erro!", response.getReturnValue());
                }
            } else if (state === "ERROR") {
                this.message(cmp, "error", "Erro!", "Aconteceu um erro inesperado");
                console.log(JSON.stringify(response.getError()));
            }
            this.carregado(cmp, false);
        });
        $A.enqueueAction(aceitarAction);
    },

    getParameterByName: function (component, event, name) {
        name = name.replace(/[\[\]]/g, "\\$&");
        var url = window.location.href;
        var regex = new RegExp("[?&]" + name + "(=1\.([^&#]*)|&|#|$)");
        var results = regex.exec(url);
        if (!results) return null;
        if (!results[2]) return '';
        return decodeURIComponent(results[2].replace(/\+/g, " "));
    },

    getMotivosNaoEnvioPesquisa: function (cmp) {
        const actionCallback = (response) => {
            if (response.getState() == "SUCCESS") {
                const values = response.getReturnValue();
                const options = new Array();
                values.forEach(function (element) {
                    options.push({
                        value: element,
                        label: element
                    });
                });
                cmp.set("v.motivosNaoEnvioPesquisaSatisfacao", options);
            } else {
                this.exibeMensagemErro(cmp, response.getError());
            }
        };

        const action = cmp.get("c.getMotivosNaoEnvioPesquisa");
        action.setCallback(this, actionCallback);
        $A.enqueueAction(action);
    },

    enviarPesquisaOuMotivo: function (cmp, event) {
        const actionCallback = (response) => {
            if (response.getState() == "SUCCESS") {
                cmp.set("v.informouCliente", true);
                this.carregando(cmp);
                this.fecharCaso(cmp, event);
            } else {
                this.exibeMensagemErro(cmp, response.getError());
            }
        };

        const motivoNaoEnvioField = cmp.find('motivoNaoEnvio');
        let motivoNaoEnvio;

        if (motivoNaoEnvioField == undefined || motivoNaoEnvioField == '--Nenhum--')
            motivoNaoEnvio = '';
        else
            motivoNaoEnvio = motivoNaoEnvioField.get('v.value');

        const action = cmp.get("c.enviarPesquisaMotivo");
        action.setCallback(this, actionCallback);
        action.setParams({
            recordId: cmp.get("v.recordId"),
            sendPesquisa: cmp.get("v.enviarPesquisaSatisfacao"),
            motivoNaoEnvio: motivoNaoEnvio
        });
        $A.enqueueAction(action);
    },

    carregando: function (cmp) {
        cmp.set("v.loading", true);
    },

    carregado: function (cmp, adicionatime) {
        if (adicionatime) {
            var millisecondsToWait = 3000;
            setTimeout(function () {
                cmp.set("v.loading", false);
            }, millisecondsToWait);
        } else {
            cmp.set("v.loading", false);
        }
    }

})