({
    getOldCaseFields : function(cmp) {
        var getOldCaseFields = cmp.get("c.getOldCaseFields")
        getOldCaseFields.setCallback(this, function(response) {
            var retorno = response.getReturnValue()
            var campos = []
            
            for(var key in retorno){
                var mapCamposDaSessao = []
                
                for(var key2 in retorno[key]) {
                    mapCamposDaSessao.push({key:key2, value:retorno[key][key2]})
                }
                
                campos.push({key:key, value:mapCamposDaSessao})
            }
            
            cmp.set("v.mapCamposCaso", campos)
        })
        $A.enqueueAction(getOldCaseFields)
	},
    
    verificaPlataforma : function(cmp) {
        var isClassic = cmp.get("c.isClassic");
        isClassic.setCallback(this, function(response) {
            var retorno = response.getReturnValue();
            
            cmp.set("v.isClassic", retorno);
        });
        $A.enqueueAction(isClassic);
    },

    verificaUsuarioGrupo : function (cmp, event) {
        var verificaUsuarioGrupo = cmp.get("c.verificaUsuarioGrupo");
        verificaUsuarioGrupo.setParams({idCaso : cmp.get("v.recordId")});
        verificaUsuarioGrupo.setCallback(this, function(response) {
            if(response.getState() == "SUCCESS") {
                cmp.set("v.pertenceAoGrupo", response.getReturnValue());
            }else{
                this.exibeMensagemErro(cmp, response.getError());
            }
            this.carregado(cmp, true);
        });
        $A.enqueueAction(verificaUsuarioGrupo);
    },
    
    exibeMensagemSucesso : function(cmp) {
        var toastParams = {
            title: "Sucesso",
            message: "Dados atualizados com sucesso",
            type: "success"
        };
        
        cmp.set("v.msgSucesso", toastParams.message);
    },
    
    exibeMensagemErro : function(cmp, errors) {    
         if(!$A.util.isUndefinedOrNull(errors)) {     
            if (errors.length > 0) {
                if(!$A.util.isUndefinedOrNull(errors[0].fieldErrors)) {
                    if(errors[0].fieldErrors.length > 0) {
                        cmp.set("v.msgErro", errors[0].fieldErrors[0].message);
                    }else if(errors[0].pageErrors.length > 0) {
                        cmp.set("v.msgErro", errors[0].pageErrors[0].message);
                    }
                }
            }
        }else{
            console.log(errors);
        }
    },
    
    insertSolution : function (cmp, solutionId) {
        var insertSolution = cmp.get("c.insertSolution");
        insertSolution.setParams({idCaso : cmp.get("v.recordId"), idSolution : solutionId});
        $A.enqueueAction(insertSolution);   
    },
    
    addObservadores : function(cmp, event) {
        this.editar(cmp, event); 
        cmp.set("v.processoDeAddObservadores", true); 
        this.carregado(cmp);
    },
    
    getBaseURL: function (cmp, event) {
        var url = location.href;
        var baseURL = url.substring(0, url.indexOf('/', 14));  
        cmp.set("v.baseURL", baseURL + "/");
    },
    
    getCase : function (cmp, event) {
        var getCase = cmp.get("c.getCase")
        getCase.setParams({idCaso : cmp.get("v.recordId")})
        getCase.setCallback(this, function(response) {
            var state = response.getState()
            if (state === "SUCCESS") {
                var retorno = response.getReturnValue();
                if($A.util.isUndefinedOrNull(retorno)) {
                    alert("Este caso não pertence mais ao seu grupo solucionador")
                    location.href = cmp.get("v.baseURL") + "/500"
                }else{
                    if($A.util.isEmpty(cmp.get("v.recordId")))
                        document.title = "Novo caso ~ Pearson"
                    else
                        document.title = "Caso: " + retorno.CaseNumber + " ~ Pearson"
                    cmp.set("v.caso", retorno)
                }
            }else if(state === "ERROR"){
                this.exibeMensagemErro(cmp, response.getError())
            }
            this.carregado(cmp)
        })
        $A.enqueueAction(getCase)
    },
    
    getDependentes : function(cmp, event, helper) {
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
    
    getSLAs : function(cmp, event, helper) {
        var getSLAs = cmp.get("c.getSLAs");
        getSLAs.setParams({  casoId : cmp.get("v.recordId")  });
        getSLAs.setCallback(this, function(response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                //cmp.set("v.linkAllSLAs", cmp.get("v.baseURL") + "/" + "a10" + "?" + "rlid=" + "00N0m000002YZwo" + "&id=" + cmp.get("v.recordId")); // DEV
                cmp.set("v.linkAllSLAs", cmp.get("v.baseURL") + "/" + "a10" + "?" + "rlid=" + "00N4C000001Kz2m" + "&id=" + cmp.get("v.recordId")); // HML
                cmp.set("v.SLAs", response.getReturnValue());
                var gruposAnteriores = [];
                var c = 1;
                response.getReturnValue().forEach(function(item) {
                    if(c > 1)
                        gruposAnteriores.push({'label': item.NomeGrupoSolucionador__c, 'value': item.GrupoSolucionador__c});
                    c++;
                });
                gruposAnteriores.reverse();
                
                cmp.set("v.gruposSolucionadoresAnteriores", gruposAnteriores);
            }
        });
        $A.enqueueAction(getSLAs); 
	},
    
    getObservadores: function(cmp, event) {
        var getUsers = cmp.get("c.getObservadores");
        getUsers.setParams({idCaso : cmp.get("v.recordId")});
        getUsers.setCallback(this, function(response) {
            var state = response.getState();
            var options = [];
            if (state === "SUCCESS") {
                response.getReturnValue().forEach(function(item) {
                    options.push({ type: 'icon', iconName: 'standard:user', alternativeText: 'Account', value: item.Observador__c, label: item.Observador__r.Name, existente : true, informacao : item.Informacao__c});
                });
                cmp.set("v.items", options);
                cmp.set("v.observadores", response.getReturnValue());
                
                var millisecondsToWait = 3000;
                setTimeout(function() { 
                    cmp.set("v.loading", false); 
                }, millisecondsToWait);
            }else if(state === "ERROR"){
                this.exibeMensagemErro(cmp, response.getError());
            }
        });
        $A.enqueueAction(getUsers);
    },

    getEmails : function(cmp, event, helper) {
        var getEmails = cmp.get("c.getEmails");
        getEmails.setParams({  casoId : cmp.get("v.recordId")  });
        getEmails.setCallback(this, function(response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                cmp.set("v.linkAllEmails", cmp.get("v.baseURL") + "/" + "ui/email/EmailMessageListPage?id=" + cmp.get("v.recordId"));
                cmp.set("v.emails", response.getReturnValue());
            }
        });
        $A.enqueueAction(getEmails); 
	}, 
    
    getComments : function(cmp, event, helper) {
        var getComments = cmp.get("c.getComments");
        getComments.setParams({  casoId : cmp.get("v.recordId")  });
        getComments.setCallback(this, function(response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                cmp.set("v.comments", response.getReturnValue());
            }
        });
        $A.enqueueAction(getComments); 
	},
    
    getNotes : function(cmp, event, helper) {
        var getNotes = cmp.get("c.getNotes");
        getNotes.setParams({  casoId : cmp.get("v.recordId")  });
        getNotes.setCallback(this, function(response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                cmp.set("v.linkAllNotes", cmp.get("v.baseURL") + "a03" + "?" + "rlid=" + "00Nd0000007eKPl" + "&id=" + cmp.get("v.recordId"));
                cmp.set("v.notasVinculadas", response.getReturnValue());
            }
        });
        $A.enqueueAction(getNotes); 
	},
    
    getMaterials : function(cmp, event, helper) {
        var getMaterials = cmp.get("c.getMaterials");
        getMaterials.setParams({  casoId : cmp.get("v.recordId")  });
        getMaterials.setCallback(this, function(response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                cmp.set("v.linkAllMaterials", cmp.get("v.baseURL") + "a04" + "?" + "rlid=" + "00Nd0000007eKPr" + "&id=" + cmp.get("v.recordId"));
                cmp.set("v.materiais", response.getReturnValue());
            }
        });
        $A.enqueueAction(getMaterials); 
	},
    
    getSolutions : function(cmp, event, helper) {
        var getSolutions = cmp.get("c.getSolutions");
        getSolutions.setParams({  casoId : cmp.get("v.recordId")  });
        getSolutions.setCallback(this, function(response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                cmp.set("v.solutions", response.getReturnValue());
            }
        });
        $A.enqueueAction(getSolutions); 
	},
    
    getAttachments : function(cmp, event, helper) {
        var getAttachments = cmp.get("c.getAttachments");
        getAttachments.setParams({  casoId : cmp.get("v.recordId")  });
        getAttachments.setCallback(this, function(response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                cmp.set("v.attachments", response.getReturnValue());
                cmp.set("v.linkAllAttachments", cmp.get("v.baseURL") + "ui/content/ViewAllAttachmentsPage?id=" + cmp.get("v.recordId") + "&retURL=%2F" + cmp.get("v.recordId"));
            }
        });
        $A.enqueueAction(getAttachments); 
	},
    
    getCaseHistories : function(cmp, event, helper) {
        var getCaseHistories = cmp.get("c.getCaseHistories");
        getCaseHistories.setParams({  casoId : cmp.get("v.recordId")  });
        getCaseHistories.setCallback(this, function(response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                cmp.set("v.linkAllCaseHistories", cmp.get("v.baseURL") + "_ui/common/history/ui/EntityHistoryFilterPage?" + "id=" + cmp.get("v.recordId"));
                cmp.set("v.caseHistories", response.getReturnValue());
            }
        });
        $A.enqueueAction(getCaseHistories); 
	},
    
    fecharCaso : function(cmp, event) {
        if(confirm("Tem certeza que deseja fechar esse caso?")) {
            var fecharCaso = cmp.get("c.fecharCaso");
            fecharCaso.setParams({idCaso : cmp.get("v.recordId")});
            fecharCaso.setCallback(this, function(response) {
                var state = response.getState();
                if (state === "SUCCESS") {
                    var retorno = response.getReturnValue();
                    if(retorno == "FECHADO") {
                        alert("O caso foi fechado com sucesso");
                        location.reload();
                    }else if(retorno == "JAESTAFECHADO") {
                        alert("O caso não está aberto");
                    }
                }else if(state === "ERROR"){
                    alert("Aconteceu um erro inesperado");
                    console.log(response.getError());
                }
                this.carregado(cmp);
            });
            $A.enqueueAction(fecharCaso);
        }else{
            this.carregado(cmp);
        }
    },
    
    cancelarForm : function(cmp, event) {
        var url_string = window.location.href;
        var url = new URL(url_string);
        var id = url.searchParams.get("id");
        if(id == null) 
            id = cmp.get("v.recordId");
        if(id != '' && id != null) {
            cmp.set("v.edit", false);
            cmp.set("v.view", true);
            this.carregado(cmp);
        }else{
            window.history.back();
        }
    },
    
    cancelarCaso : function(cmp, event) {
        if(confirm("Tem certeza que deseja cancelar esse caso?")) {
            var cancelarCaso = cmp.get("c.cancelarCaso");
            cancelarCaso.setParams({idCaso : cmp.get("v.recordId")});
            cancelarCaso.setCallback(this, function(response) {
                var state = response.getState();
                if (state === "SUCCESS") {
                    var retorno = response.getReturnValue();
                    if(retorno == 'CANCELADO') {
                        alert("O caso foi cancelado com sucesso");
                        location.reload();
                    }else if(retorno == 'SEMPERMISSAO') {
                        alert("Você não tem permissão para cancelar esse caso, caso seja necessário, solicite ao Atendimento Pearson");
                    }
                }else if(state === "ERROR"){
                    alert("Aconteceu um erro inesperado");
                    console.log(response.getError());
                }
                this.carregado(cmp);
            });
            $A.enqueueAction(cancelarCaso);
        }else{
            this.carregado(cmp);
        }
    },
    
    openDetail : function(campo, cmp, event) {
        var caso = cmp.get("v.caso");
        var valor = caso[campo];
        
        if(!$A.util.isUndefined(valor) && !$A.util.isEmpty(valor))
            location.href = cmp.get("v.baseURL") + '/' + valor;   
    },
    
    addUser : function(cmp, event) {   
        var options = cmp.get("v.items");
        var mycmp = cmp.find("usuarioCombo");
        if(!$A.util.isUndefined(mycmp.get("v.value")) && !$A.util.isEmpty(mycmp.get("v.value"))) {
            var getUser = cmp.get("c.getUser");
            getUser.setParams({idUser : mycmp.get("v.value")});
            getUser.setCallback(this, function(response) {
                var state = response.getState();
                if (state === "SUCCESS") {
                    var userName = response.getReturnValue().Name;
                    var opcao = { type: 'icon', iconName: 'standard:user', alternativeText: 'Account', value: mycmp.get("v.value"), label: userName};
                    
                    for(var i = 0; i < options.length; i++) {
                        if(options[i].value == opcao.value) {
                            this.carregado(cmp, false);
                            return;
                        }
                    }
                    
                    options.push(opcao);
                    cmp.set("v.items", options);
                    this.carregado(cmp, false);
                }else if(state === "ERROR"){
                    this.exibeMensagemErro(cmp, response.getError());
                }
            });
            $A.enqueueAction(getUser);
        }else{
            this.carregado(cmp, false);
        }
    },
    
    showRelatedLists : function(cmp) {
        var showObj = {SlasDoCaso: false, 
                       ComentariosDoCaso: true, 
                       ObservadoresDoCaso: true	, 
                       EmailsDoCaso: true, 
                       NotasDoCaso: true, 
                       MateriaisDoCaso: true, 
                       AtividadesAbertasDoCaso: true, 
                       SolucoesDoCaso: true, 
                       AnexosDoCaso: true, 
                       HistoricosDoCaso: true, 
                       HistoricosDeAprovacao: true };
        cmp.set("v.showRelatedLists", showObj);
    },
    
	carregando : function(cmp) {
		cmp.set("v.loading", true)
	},
    
	carregado : function(cmp) {
		cmp.set("v.loading", false)
	},
    
	salvarForm : function(cmp, event) {
        event.preventDefault(); // stop form submission
        var eventFields = event.getParam("fields");
        var cancelouAlert = false;
                
        if(cmp.get("v.processoDeAddObservadores")) {
            var observadores = cmp.get("v.items"); 
            var stringObservadores = '';
            var informacoesObservadores = [];
            var contemErro = false;
            
            if(confirm("Tem certeza que deseja adicionar estes observadores? Não será possível excluí-los.")) {
                observadores.forEach(function(response) {
                    const inputs = cmp.find("InputInformacoes");
                    
                    if ($A.util.isArray(inputs)) {
                        inputs.forEach(function(input) {
                            if(input.get("v.name") == response.value) {
                                if($A.util.isUndefinedOrNull(input.get("v.value")) || $A.util.isEmpty(input.get("v.value"))) {
                                    input.setCustomValidity("Preencha este campo");
                                    input.reportValidity();
                                    contemErro = true;
                                }else{
                                    if(!input.get("v.disabled")) 
                                        informacoesObservadores.push({ observador : response.value, informacao : input.get("v.value"), casoId : cmp.get("v.recordId") });
                                }
                            }
                        });
                    } else {
                        if($A.util.isUndefinedOrNull(inputs.get("v.value")) || $A.util.isEmpty(inputs.get("v.value"))) {
                            inputs.setCustomValidity("Preencha este campo");
                            inputs.reportValidity();
                            contemErro = true;
                        }else if(!inputs.get("v.disabled")) {
                            informacoesObservadores.push({observador : response.value, informacao : inputs.get("v.value"), casoId : cmp.get("v.recordId") });
                        }
                    }
                    stringObservadores += ';' + response.value;
                });
                
                if(contemErro) {
                    this.carregado(cmp, false)
                    return;
                }
                
                var salvarInformacoes = cmp.get("c.salvarInformacoes");
                salvarInformacoes.setParams({  informacoes : JSON.stringify(informacoesObservadores) });
                salvarInformacoes.setCallback(this, function(response) {
                    var state = response.getState();
                });
                $A.enqueueAction(salvarInformacoes); 
                
                eventFields["AddObservador__c"] = null;
                eventFields["Observadores__c"] = stringObservadores;
            }else{
                cancelouAlert = true;
            }
        }else{
            if($A.util.isUndefinedOrNull(eventFields["MarcaAtendimento__c"])  || eventFields["MarcaAtendimento__c"] == "") {
                alert('Preencha o campo de marca do atendimento');
                this.carregado(cmp, false);
                return;
            }
        }
        if(cancelouAlert) {
            this.carregado(cmp, false);
            return;
        }
        
        cmp.find('caseFormEdit').submit(eventFields);    
	},
    
	visualizar : function(cmp) {
		cmp.set("v.view", true)
        cmp.set("v.edit", false)
	},
    
	editar : function(cmp) {
		cmp.set("v.view", false)
        cmp.set("v.edit", true)
	}
})