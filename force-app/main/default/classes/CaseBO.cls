public class CaseBO { 
    
    public static void setPriority(List<Case> casos, Map<Id, Case> mapCasosOld) {
        Set<Id> idContas = new Set<Id>();
        Set<Id> idContatos = new Set<Id>();
        
        for(Case caso : casos) {
            if(caso.ContactId != null)
                idContatos.add(caso.ContactId);
            
            if(caso.AccountId != null)
                idContatos.add(caso.ContactId);
        }
        
        Map<Id, Account> mapContas = new Map<Id, Account>([SELECT Id, ClusterComercial__c FROM Account WHERE Id IN: idContas]);
        Map<Id, Contact> mapContatos = new Map<Id, Contact>([SELECT Id, AccountId, Account.ClusterComercial__c FROM Contact WHERE Id IN: idContatos]);
        
        for(Case caso : casos) {
            Account acc;
            
            if(caso.AccountId != null && mapContas.containsKey(caso.AccountId)) 
                acc = mapContas.get(caso.AccountId);
            else if(caso.ContactId != null && mapContatos.containsKey(caso.ContactId) && mapContatos.get(caso.ContactId).AccountId != null) 
                acc = mapContatos.get(caso.ContactId).Account;
            
            if(acc != null && acc.ClusterComercial__c == 'Platina')
                caso.Priority = 'High';
            else if(caso.Origin == 'Reclame Aqui')
                caso.Priority = 'High';
            else if(caso.Status == 'Reaberto' && mapCasosOld.containsKey(caso.Id) && mapCasosOld.get(caso.Id).Status == 'Fechado')
                caso.Priority = 'High';
            else if(caso.Subtipo__c == 'Priorização de pedido' ||
                    caso.Subtipo__c == 'Cancelamento de Pedido' ||
                    caso.Subtipo__c == 'Lead' ||
                    caso.Subtipo__c == 'Licitação' ||
                    caso.Subtipo__c == 'Licitação - GOVERNO' ||
                    caso.Subtipo__c == 'Sala Virtual' ||
                    caso.Subtipo__c == 'Virtual Labs' ||
                    caso.Subtipo__c == 'Virtual Classroom' ||
                    caso.Subtipo__c == 'Pedido realizado' ||
                    caso.Subtipo__c == 'Divergência no pedido' ||
                    caso.Subtipo__c == 'Divergência' ||
                    caso.Subtipo__c == 'Material Avariado' ||
                    caso.Subtipo__c == 'Retenção' ||
                    caso.Subtipo__c == 'Carta de Correção' ||
                    caso.Subtipo__c == 'Boleto')
                caso.Priority = 'Medium';
            else
                caso.Priority = 'Low';
                    
            
        }
    }
    
    public static void setDescriptionFieldChat(List<Case> casos) {
        for(Case c : casos) {
            if(c.Description == null && c.Subject != null)
                c.Description = c.Subject;
        }
    }
    
    public static void setContactBySuppliedEmail(List<Case> casos) {
		Set<String> emails = new Set<String>();
        
        for(Case c : casos) {
            if(c.SuppliedEmail != null)
                emails.add(c.SuppliedEmail);  
        }
        
        List<Contact> contatos = [SELECT Id, Email FROM Contact WHERE Email IN: emails ORDER BY CreatedDate DESC];
        
        Map<String, Contact> mapContatos = new Map<String, Contact>();
        
        for(Contact c : contatos) {
            if(!mapContatos.containsKey(c.Email))
                mapContatos.put(c.Email, c);
        }
        
        for(Case c : casos) {
            if(c.SuppliedEmail != null && mapContatos.containsKey(c.SuppliedEmail))
                c.ContactId = mapContatos.get(c.SuppliedEmail).Id;
        }
    }
    
    public static void validarClonarCaso(List<Case> casos) {
        Set<Id> queueIds = new Set<Id>();
        Set<Id> parametrizacoesIds = new Set<Id>();
        
        List<Group> grupos = [SELECT Id, Name FROM Group WHERE Name =: 'LN: Customer Care - ALL'];
        
        for(Group g : grupos) {
            queueIds.add(g.Id);
        }
        
        for(Case c : casos) {
            parametrizacoesIds.add(c.ParametrizacaoCasos__c);
        }
        
        AllUsersFromQueue users = new AllUsersFromQueue();
        Map<Id, Set<Id>> usuariosDoGrupo = users.getUsers(null, queueIds);
        
        Map<Id, ParametrizacaoCasos__c> mapParams = new Map<Id, ParametrizacaoCasos__c>([SELECT Id, GrupoSolucionador1__c FROM ParametrizacaoCasos__c WHERE Id IN: parametrizacoesIds]);
        
        for(Case caso : casos) {
            if(caso.isClone() && usuariosDoGrupo.containsKey(grupos[0].Id) && !usuariosDoGrupo.get(grupos[0].Id).contains(UserInfo.getUserId()))
                caso.addError('Você não tem permissão para clonar este caso');
        }
	}
	
    public static void validarRetornoAFila(List<Case> casos, Map<Id, Case> mapCasosOld) {
		Set<Id> queueIds = new Set<Id>();
        
        List<Group> grupos = [SELECT Id, Name FROM Group WHERE Name = 'Coordenadores Customer Care'];
        
        for(Group g : grupos) {
            queueIds.add(g.Id);
        }
        
        AllUsersFromQueue users = new AllUsersFromQueue();
        Map<Id, Set<Id>> usuariosDoGrupo = users.getUsers(null, queueIds);
        
        for(Case caso : casos) {
            Case casoOld = mapCasosOld.get(caso.Id);
            
            if(casoOld.AceitoPor__c != null && 
               caso.AceitoPor__c == null &&
               casoOld.GrupoSolucionador__c == caso.GrupoSolucionador__c &&
               usuariosDoGrupo.containsKey(grupos[0].Id) && !usuariosDoGrupo.get(grupos[0].Id).contains(UserInfo.getUserId()) &&
               mapCasosOld.get(caso.Id).AceitoPor__c != UserInfo.getUserId()) 
            {
                caso.addError('Você não tem permissão para retornar este caso à fila.');
            } else if(casoOld.AceitoPor__c != null &&
                      caso.AceitoPor__c == null &&
                      casoOld.GrupoSolucionador__c == caso.GrupoSolucionador__c &&
                      ((usuariosDoGrupo.containsKey(grupos[0].Id) && !usuariosDoGrupo.get(grupos[0].Id).contains(UserInfo.getUserId())) || (mapCasosOld.get(caso.Id).AceitoPor__c == UserInfo.getUserId()))) 
            {
                caso.Status = 'Novo';
			}
        }
    }
    
    public static void atribuirAceitoPor(List<Case> casos, Map<Id, Case> mapCasosOld) {
		Set<Id> ownerIds = new Set<Id>();
        
        for(Case caso : mapCasosOld.values()) {
            ownerIds.add(caso.OwnerId);
        }
        
        Map<Id, User> mapUsers = new Map<Id, User>([SELECT Id, Profile.Name, ProfileId FROM User WHERE Id = :UserInfo.getUserId()]);
        
        AllUsersFromQueue users = new AllUsersFromQueue();
        Map<Id, Set<Id>> usuariosDoGrupo = users.getUsers(null, ownerIds);
        
        for(Case caso : casos) {
            String ownerIdMapOld = mapCasosOld.get(caso.Id).OwnerId;
            String ownerIdNew = caso.OwnerId;
            
            // ACEITAR PELO BOTÃO
            if(ownerIdNew != ownerIdMapOld) {
                if(caso.AceitoPor__c != null && usuariosDoGrupo.containsKey(ownerIdMapOld)) {
                    caso.addError('Este caso já está em execução por um usuário');
                }else if(caso.AceitoPor__c == null && !(mapUsers.containsKey(ownerIdNew) && usuariosDoGrupo.get(ownerIdMapOld).contains(UserInfo.getUserId())) && ownerIdNew.startsWith('005')) {
                    caso.addError('Você não pertence ao grupo solucionador atual');
                }else if(ownerIdNew.startsWith('005')) {
                    caso.AceitoPor__c = UserInfo.getUserId();
                    caso.Status = 'Em Execução'; 
                    caso.OwnerId =  ownerIdMapOld;
                }
            }
            // ACEITAR PELO CAMPO
            else if(mapCasosOld.get(caso.Id).AceitoPor__c == null && caso.AceitoPor__c != null) {
                if(!usuariosDoGrupo.get(ownerIdNew).contains(UserInfo.getUserId())) {
                    caso.AceitoPor__c.addError('Você não pertence ao grupo solucionador atual');
                }else{
                    caso.AceitoPor__c = UserInfo.getUserId();
                    caso.Status = 'Em Execução';
                }
            }else if(caso.AceitoPor__c != mapCasosOld.get(caso.Id).AceitoPor__c && caso.AceitoPor__c != null && mapCasosOld.get(caso.Id).AceitoPor__c != null) {
                caso.addError('Este caso já está em execução por um usuário');
            }
        }
    }
    
    public static void atribuirGrupoSolucionadorAnterior(List<Case> casos, Map<Id, Case> mapCasosOld) {
        for(Case caso : casos) {
            if(caso.GrupoSolucionador__c != mapCasosOld.get(caso.Id).GrupoSolucionador__c) {
				caso.GrupoSolucionadorAnterior__c = mapCasosOld.get(caso.Id).GrupoSolucionador__c;
                if(caso.TotalDirecionamentos__c == NULL)
                    caso.TotalDirecionamentos__c = 1;
                else
                    caso.TotalDirecionamentos__c++;
            }
        }
    }
    
    public static void validarRedefinicaoArvoreAssunto(List<Case> casos, Map<Id, Case> mapCasosOld) {
		Set<Id> queueIds = new Set<Id>();
        List<Group> grupos = [SELECT Id, Name FROM Group WHERE Name = 'Coordenadores Customer Care'];
        
        for(Group g : grupos) {
            queueIds.add(g.Id);
        }

		Map<Id, User> mapUsers = new Map<Id, User>([SELECT Id, Profile.Name, ProfileId FROM User WHERE Id = :UserInfo.getUserId()]);
        
        AllUsersFromQueue users = new AllUsersFromQueue();
        Map<Id, Set<Id>> usuariosDoGrupo = users.getUsers(null, queueIds);
        
        for(Case caso : casos) {
            Case casoOld = mapCasosOld.get(caso.Id);
            
            if(casoOld.Tipo__c != 'Atendimento' &&
               casoOld.Subtipo__c != 'Suporte' &&
               (casoOld.Tipo__c != caso.Tipo__c || casoOld.Subtipo__c != caso.Subtipo__c || casoOld.Detalhamento__c != caso.Detalhamento__c) &&
               usuariosDoGrupo.containsKey(grupos[0].Id) && 
               !usuariosDoGrupo.get(grupos[0].Id).contains(UserInfo.getUserId())) {
                caso.addError('Você não tem permissão para redefinir a árvore de assunto.');
            }
        }
    }
    
	@future
	public static void atribuirParaFila(Set<Id> idsCasos) {
        if(idsCasos.isEmpty())
            return;
        
		AssignmentRule AR = [select id from AssignmentRule where SobjectType = 'Case' and Active = true limit 1];
		Database.DMLOptions dmlOpts = new Database.DMLOptions();
		dmlOpts.assignmentRuleHeader.assignmentRuleId = AR.id;

		List<Case> casos = [SELECT Id, Status, CriadoFechado__c FROM Case WHERE Id IN :idsCasos];
		List<Case> casosUpdate = new List<Case>();

		for(Case caso :casos) {
			caso.setOptions(dmlOpts);
            if(caso.CriadoFechado__c && caso.Status != 'Closed') caso.Status = 'Closed'; caso.CriadoFechado__c = false;
			casosUpdate.add(caso);
		}

		TriggerHandler.bypass('CaseTriggerHandler');
		if(casosUpdate.size() > 0)
			update casos;
		TriggerHandler.clearBypass('CaseTriggerHandler');
	}

	public static void alterarEmAtuacao(List<Case> casos) {
        if(casos.isEmpty())
            return;
        
		List<String> tipos = new List<String>();
		List<String> subtipos = new List<String>();
		List<String> detalhamentos = new List<String>();
		List<String> detalhamentos2 = new List<String>();

		for(Case caso :casos) {
			tipos.add(caso.Tipo__c);
			subtipos.add(caso.Subtipo__c);
			detalhamentos.add(caso.Detalhamento__c);
			detalhamentos2.add(caso.Detalhamento2__c);
		}

		Map<string, Map<string, Map<string, Map<string, ParametrizacaoCasos__c>>>> mapParametrizacao = ParametrizacaoCasosDAO.mapearParametrizacoesByCampos(tipos, subtipos, detalhamentos, detalhamentos2);

		for(Case caso :casos) {
			if(!caso.Novo__c)
				continue;

			if(!mapParametrizacao.containsKey(caso.Tipo__c))
				continue;

			if(!mapParametrizacao.get(caso.Tipo__c).containsKey(caso.Subtipo__c))
				continue;

			if(!mapParametrizacao.get(caso.Tipo__c).get(caso.Subtipo__c).containsKey(caso.Detalhamento__c))
				continue;

			if(!mapParametrizacao.get(caso.Tipo__c).get(caso.Subtipo__c).get(caso.Detalhamento__c).containsKey(caso.Detalhamento2__c))
				continue;

			if(!mapParametrizacao.get(caso.Tipo__c).get(caso.Subtipo__c).get(caso.Detalhamento__c).get(caso.Detalhamento2__c).CasoAtuacao__c)
				continue;

			caso.EmAtuacao__c = true;
		}
	}

	public static void validarStatusAguardandoCliente(List<Case> casos, Map<Id, Case> mapCasosOld) {
        if(casos.isEmpty())
            return;
        
		BusinessHours bh = [SELECT Id, Name, IsActive, IsDefault FROM BusinessHours WHERE IsDefault = true];
		List<SLACaso__c> slasCasos = new List<SLACaso__c>();
		Set<Id> idsCasos = new Set<Id>();

		for(Case caso :casos) {
			idsCasos.add(caso.Id);
		}

		Map<Id, List<SLACaso__c>> mapSLAS = SLACasoDAO.getSLAsbyCasesIds(idsCasos);

		for(Case caso :casos) {
			if(caso.Novo__c) {
				if(caso.Status == 'Aguardando Cliente' && caso.Status != mapCasosOld.get(caso.Id).Status) {

					SLACaso__c ultimoSLA = mapSLAS.get(caso.Id) [0];
					ultimoSLA.ClosedDate__c = System.now();
					ultimoSLA.SLAUtilizadoCodigo__c = BusinessHours.diff(bh.Id, ultimoSLA.DataAbertura__c, ultimoSLA.ClosedDate__c) /1000 /60;
					ultimoSLA.FechadoAguardandoCliente__c = true;

					slasCasos.add(ultimoSLA);
				} else if(mapCasosOld.get(caso.Id).Status == 'Aguardando Cliente' && caso.Status != 'Aguardando Cliente') {
					SLACaso__c ultimoSLA = mapSLAS.get(caso.Id) [0];

					SLACaso__c slaNovoCaso = new SLACaso__c();
					slaNovoCaso.Name = ultimoSLA.Name;
					slaNovoCaso.Caso__c = caso.Id;
					slaNovoCaso.GrupoSolucionador__c = ultimoSLA.GrupoSolucionador__c;
					slaNovoCaso.SLA__c = (ultimoSLA.SLA__c - ultimoSLA.SLAUtilizado__c) < 0 ? 0 :ultimoSLA.SLA__c - ultimoSLA.SLAUtilizado__c;

					slasCasos.add(slaNovoCaso);
				}
			}
		}

		if(slasCasos.size() > 0)
			upsert slasCasos;
	}

	public static void validarStatusCaso(List<Case> casos, Map<Id, Case> mapCasosOld) {
        if(casos.isEmpty())
            return;
        
		List<SLACaso__c> slasCasos = new List<SLACaso__c>();
		Set<Id> idsCasos = new Set<Id>();

		for(Case caso :casos) {
			idsCasos.add(caso.Id);
		}

		Map<Id, List<SLACaso__c>> mapSLAS = SLACasoDAO.getSLAsbyCasesIds(idsCasos);

		for(Case caso :casos) {
			if(caso.Novo__c) {
				if(caso.Status == 'Escalado' || caso.Status == 'Escalated')
					caso.addError('Casos do fluxo novo não podem utilizar esse status');

				if(Trigger.isInsert) {
					if(caso.Status == 'Cancelado')
						caso.addError('Casos não podem ser abertos com esse status');
					if(caso.Status == 'Em Execução' || caso.Status == 'In progress')
						caso.addError('Não é possível criar um caso com esse status, primeiro crie como "Novo" e aceite o caso');
				}

                /*
				if((caso.Status == 'Em Execução' || caso.Status == 'In progress') && caso.AceitoPor__c == null) {
					if(CaseAcceptClass.validateOneCase(caso)) {
						caso.AceitoPor__c = UserInfo.getUserId();
					} else {
						caso.addError('Você não pertence ao grupo solucionador desse caso para poder aceita-lo');
					}
				}

				if(caso.Status == 'Aguardando Cliente') {
					if(CaseAcceptClass.validateOneCase(caso)) {
						caso.AceitoPor__c = UserInfo.getUserId();
					} else {
						caso.addError('Você não pertence ao grupo solucionador desse caso para poder aceita-lo');
					}
				}*/
			} else {
				if(Trigger.isUpdate && caso.GrupoSolucionador__c != mapCasosOld.get(caso.Id).GrupoSolucionador__c) {
					caso.AceitoPor__c = null;
				}
			}
		}
	}

	public static void validarCamposObrigatorios(List<Case> casos) {
        if(casos.isEmpty())
            return;
        
		Map<String, GrupoSolucionador__c> mapGruposAtuais = GrupoSolucionadorDAO.buscarGruposAtuais(casos);

		for(Case caso :casos) {
			if(caso.Novo__c && (String.isEmpty(caso.Origin) || !caso.Origin.contains('Email'))) {
				if((caso.EnviandoAoProxGrupo__c || Trigger.isInsert)) {

					Decimal ordem = caso.OrdemGrupoSolucionador__c;
					String key = montarKeyCaso(caso) + '_' + String.valueOf(ordem);

					if(mapGruposAtuais.containsKey(key)) {
						GrupoSolucionador__c grupoAtual = mapGruposAtuais.get(key);

						if(grupoAtual.CamposObrigatorios__c != null) {
							String camposEmBranco = '', camposObrigatorios = grupoAtual.CamposObrigatorios__c;

							String jsonString = JSON.serialize(caso);
							Map<String, Object> casoUntyped = (Map<String, Object>) JSON.deserializeUntyped(jsonString);

							for(String campo : camposObrigatorios.split(';')) {
								if(!casoUntyped.containsKey(campo)) {
									camposEmBranco += Schema.getGlobalDescribe().get('Case').getDescribe().fields.getMap().get(campo).getDescribe().getLabel() + ', ';
								}
							}

							if(String.isNotEmpty(camposEmBranco)) {
								caso.addError('Campos obrigatórios em branco (' + camposEmBranco.substring(0, camposEmBranco.length() -2) + ')');
							}
						}
					} else {
						string tipo = (caso.Tipo__c == null ? '' :caso.Tipo__c);
						string subtipo = (caso.Subtipo__c == null ? '' :caso.Subtipo__c);
						string detalhamento = (caso.Detalhamento__c == null ? '' :caso.Detalhamento__c);
						string detalhamento2 = (caso.Detalhamento2__c == null ? '' :caso.Detalhamento2__c);
					}
				}
			}
		}
	}

	public static void criarSLAs(List<Case> casos, Map<Id, Case> mapOld) {
        if(casos.isEmpty())
            return;
        
		BusinessHours bh = [SELECT Id, Name, IsActive, IsDefault FROM BusinessHours WHERE IsDefault = true];
		Set<Id> idsCasos = new Set<Id>();
		Set<String> gruposSolucionadores = new Set<String>();
		Set<String> tipos = new Set<String>();
		Set<String> subtipos = new Set<String>();
		Set<String> detalhamentos = new Set<String>();
		Set<String> detalhamentos2 = new Set<String>();

		for(Case caso :casos) {
			idsCasos.add(caso.Id);
			tipos.add(caso.Tipo__c);
			subtipos.add(caso.Subtipo__c);
			detalhamentos.add(caso.Detalhamento__c);
			detalhamentos2.add(caso.Detalhamento2__c);
		}

		List<GrupoSolucionador__c> gruposAtuais = [SELECT Id, IdentificadorOrdem__c, IdentificadorGrupo__c, CamposObrigatorios__c, GrupoSolucionador__c, MinutosSLA__c, ParametrizacaoCasos__c, Ordem__c
												   FROM GrupoSolucionador__c
												   WHERE ParametrizacaoCasos__r.Tipo__c IN :tipos
												   AND ParametrizacaoCasos__r.Subtipo__c IN :subtipos
												   AND ParametrizacaoCasos__r.Detalhamento__c IN :detalhamentos
												   AND ParametrizacaoCasos__r.Detalhamento2__c IN :detalhamentos2];

		Map<String, GrupoSolucionador__c> mapGrupos = new Map<String, GrupoSolucionador__c>();

		for(GrupoSolucionador__c grupo :gruposAtuais) {
			mapGrupos.put(grupo.IdentificadorOrdem__c, grupo);
		}

		Map<Id, SLACaso__c> mapUltimoSLAdoCaso = new Map<Id, SLACaso__c>();
		List<SLACaso__c> slasCasos = [SELECT Id, Caso__c, ClosedDate__c, DataAbertura__c, GrupoSolucionador__c, SLA__c, SLAUtilizado__c FROM SLACaso__c WHERE Caso__c IN :idsCasos ORDER BY CreatedDate DESC];

		for(SLACaso__c sla :slasCasos) {
			if(!mapUltimoSLAdoCaso.containsKey(sla.Caso__c)) {
				mapUltimoSLAdoCaso.put(sla.Caso__c, sla);
			}
		}

		List<SLACaso__c> slas = new List<SLACaso__c>();

		for(Case caso :casos) {
			if(!caso.Novo__c)
				continue;

			String identificadorCaso = montarKeyCaso(caso) + '_' + caso.OrdemGrupoSolucionador__c;

			if(!mapGrupos.containsKey(identificadorCaso))
				continue;

			if(mapOld == null || (caso.GrupoSolucionador__c != mapOld.get(caso.Id).GrupoSolucionador__c) && (caso.OrdemGrupoSolucionador__c > mapOld.get(caso.Id).OrdemGrupoSolucionador__c)) {
				SLACaso__c slaNovoCaso = new SLACaso__c();
				slaNovoCaso.Name = 'SLA ' + caso.GrupoSolucionador__c;
				slaNovoCaso.Caso__c = caso.Id;
				slaNovoCaso.GrupoSolucionador__c = mapGrupos.get(identificadorCaso).Id;
				slaNovoCaso.SLA__c = mapGrupos.get(identificadorCaso).MinutosSLA__c;

				if(caso.Status == 'Aguardando Cliente') {
					slaNovoCaso.ClosedDate__c = System.now();
					slaNovoCaso.SLAUtilizadoCodigo__c = 0;
				}

				slas.add(slaNovoCaso);
				if(mapUltimoSLAdoCaso.containsKey(caso.Id)) {
					SLACaso__c slaAntigoCaso = mapUltimoSLAdoCaso.get(caso.Id);
					slaAntigoCaso.ClosedDate__c = System.now();
					slaAntigoCaso.SLAUtilizadoCodigo__c = BusinessHours.diff(bh.Id, slaAntigoCaso.DataAbertura__c, slaAntigoCaso.ClosedDate__c) /1000 /60;

					slas.add(slaAntigoCaso);
				}
			} else if(caso.IsClosed && mapUltimoSLAdoCaso.containsKey(caso.Id)) {
				SLACaso__c slaAntigoCaso = mapUltimoSLAdoCaso.get(caso.Id);
				slaAntigoCaso.ClosedDate__c = System.now();
				slaAntigoCaso.SLAUtilizadoCodigo__c = BusinessHours.diff(bh.Id, slaAntigoCaso.DataAbertura__c, slaAntigoCaso.ClosedDate__c) /1000 /60;

				slas.add(slaAntigoCaso);
			}
		}

		if(!slas.isEmpty())
			upsert slas;
	}

	public static void popularCampos(List<Case> casos) {
        if(casos.isEmpty())
            return;
        
		Map<String, GrupoSolucionador__c> mapGruposAtuais = GrupoSolucionadorDAO.buscarGruposAtuais(casos);

		Set<id> accsIds = new Set<id>();

		for(Case caso :casos) {
			if(caso.AccountId != null)
				accsIds.add(caso.AccountId);
		}

		List<Account> accs = AccountDAO.buscaContas(accsIds);
		Map<Id, Account> mapAccs = new Map<Id, Account>();

		for(Account acc :accs) {
			mapAccs.put(acc.Id, acc);
		}

		for(Case caso :casos) {
			if(Trigger.isInsert) {
				if(caso.Status == 'Closed'){
					caso.Status = 'Novo';
					caso.CriadoFechado__c = true;
				}
				caso.Novo__c = true;
				if(!String.isEmpty(caso.Origin) && caso.Origin.contains('Email')) {
					caso.Tipo__c = 'Atendimento';
					caso.Subtipo__c = 'Suporte';
					caso.Detalhamento__c = null;
					caso.Detalhamento2__c = null;
					caso.BR_Grupo_Solucionador__c = null;
					caso.OwnerEmailToCaseId__c = caso.OwnerId;
				}
				else if (!String.isEmpty(caso.Origin) && caso.Origin.contains('LGPD')){
					// atendimento do chamado INC5771683
					caso.Tipo__c = 'Cadastro';
					caso.Subtipo__c = 'LGPD';
					caso.Detalhamento__c = 'Formulário LGPD';
					caso.Detalhamento2__c = null;
					caso.BR_Grupo_Solucionador__c = null;
					caso.OwnerEmailToCaseId__c = caso.OwnerId;
				}
			}

			if(mapAccs.containsKey(caso.AccountId) && !String.isEmpty(mapAccs.get(caso.AccountId).Marca__c)) {
				caso.Marca__c = mapAccs.get(caso.AccountId).Marca__c;
			}

			switch on caso.Marca__c {
				when 'Atitude', 'COC', 'Dom Bosco', 'NAME' {
					caso.LinhaNegocio__c = 'K12';
				}
				when 'ELT', 'HED' {
					caso.LinhaNegocio__c = 'EDU';
				}
				when 'Skill', 'Wizard', 'Yázigi', 'SMARTZ' {
					caso.LinhaNegocio__c = 'FRA';
				}
			}

			if(caso.GrupoSolucionador__c == null) {
				Decimal ordem = caso.OrdemGrupoSolucionador__c;
				String key = montarKeyCaso(caso) + '_' + String.valueOf(ordem);

				GrupoSolucionador__c grupoAtual;

				if(mapGruposAtuais.containsKey(key)) {
					grupoAtual = mapGruposAtuais.get(key);
					caso.GrupoSolucionador__c = grupoAtual.GrupoSolucionador__c;
                    caso.GrupoSolucionadorAnterior__c = grupoAtual.GrupoSolucionador__c;
					caso.OrdemGrupoSolucionador__c = grupoAtual.Ordem__c;
				}
			}

			if(Trigger.isInsert && caso.GrupoSolucionadorAbertura__c == null) {
				caso.GrupoSolucionadorAbertura__c = caso.GrupoSolucionador__c;
			}
            
            if(Trigger.isInsert && caso.GrupoSolucionador__c != null) {
				if(caso.TotalDirecionamentos__c == NULL)
                    caso.TotalDirecionamentos__c = 1;
                else
                    caso.TotalDirecionamentos__c++;
			}
		}
	}

	@future
	public static void tratarCasosAbertosFechado(Set<Id> idsCasos) {
		
        if(idsCasos.isEmpty())
            return;

		List<Case> casos = [SELECT Id, Status FROM Case WHERE Id IN :idsCasos];
		List<CaseMilestone> CMs = [SELECT Id, CaseId, CompletionDate FROM CaseMilestone WHERE CaseId IN :idsCasos AND CompletionDate = null];

		if(casos != null && CMs != null){

			for(CaseMilestone cm : CMs){
				cm.CompletionDate = System.now();
			}
			
			for(Case caso : casos){
				caso.Status = 'Closed';
				caso.QuantidadeMarcoSLA__c = 1;
			}

			update CMs;

			TriggerHandler.bypass('CaseTriggerHandler');
			if(casos.size() > 0)
				update casos;
			TriggerHandler.clearBypass('CaseTriggerHandler');
		}
	}


	public static void validarUsuarioDaFilaAtual(List<Case> casos, Map<Id, Case> mapOld) {
        if(casos.isEmpty())
            return;
        
		Set<Id> ownerIds = new Set<Id>();

		for(Case caso : mapOld.values()) {
			ownerIds.add(caso.OwnerId);
		}

		Map<Id, User> mapUsers = new Map<Id, User>([SELECT Id, Profile.Name, ProfileId FROM User WHERE Id = :UserInfo.getUserId()]);

		AllUsersFromQueue users = new AllUsersFromQueue();
		Map<Id, Set<Id>> usuariosDoGrupo = users.getUsers(null, OwnerIds);

		for(Case caso :casos) {
			if(caso.Novo__c) {
				if(!mapUsers.get(UserInfo.getUserId()).Profile.Name.contains('Inteligência & MKT') &&
                   !mapUsers.get(UserInfo.getUserId()).Profile.Name.contains('Sucesso do Cliente') &&
                   !mapUsers.get(UserInfo.getUserId()).Profile.Name.contains('Admin')) {
					if(caso.GrupoSolucionador__c != mapOld.get(caso.Id).GrupoSolucionador__c) {
						if(usuariosDoGrupo.containsKey(caso.OwnerId) && !usuariosDoGrupo.get(caso.OwnerId).contains(UserInfo.getUserId())) {
							caso.addError('Você não pertence à este grupo solucionador');
						}
					}
				}
			}
		}
	}

	private static String montarKeyCaso(Case caso) {
		String tipo = caso.Tipo__c != null ? caso.Tipo__c :'';
		String subtipo = caso.Subtipo__c != null ? caso.Subtipo__c :'';
		String detalhamento = caso.Detalhamento__c != null ? caso.Detalhamento__c :'';
		String detalhamento2 = caso.Detalhamento2__c != null ? caso.Detalhamento2__c :'';

		String key = tipo.trim() + '_' + subtipo.trim() + '_' + detalhamento.trim() + '_' + detalhamento2.trim();

		return key;
	}

	public static Case criarCaso(String description, String accountId) {
		Case caso = new Case();
		caso.Subject = 'Cadastrar Cliente no SAP';
		caso.Description = description;
		caso.Tipo__c = 'Cadastro';
		caso.Subtipo__c = 'Novo Cadastro';
        caso.Detalhamento__c = '';
        caso.GrupoSolucionador__c = 'Cadastro / Gestão de Contratos';
		caso.accountId = accountId;
		// caso.BR_CEP__c = '123';
		// caso.OrdemGrupoSolucionador__c = 0;
		// caso.GrupoSolucionador__c = 'Backoffice Comercial';
		insert caso;
        return caso;
	}
}