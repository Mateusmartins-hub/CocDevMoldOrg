public with sharing class AdocoesBO {
    private static final AdocoesBO instance = new AdocoesBO();  
    private AdocoesBO(){}
   
    public static AdocoesBO getInstance(){
        return instance;
    }

    public static final String TP_REG_ADOCAO_ADOCAOPEARSON = 'Ado_o_Pearson';
    public static final String TP_REG_ADOCAO_ADOCAOIDIOMASPEARSON = 'AdocaoIdiomasPearson';
    
    public void calculaQuadrante(List<Adocoes_Cs__c> lstAdo){
        String Quadrante = '';
        integer totalAlunosEscola = 0;
        integer qAluno = 0;
        integer qPerc = 60;
        integer Perc = 0;
        
        List<AggregateResult> lstSUM = new List<AggregateResult>();
        Id RecTypeAdoIdiomasPearson   = RecordTypeMemory.getRecType('Adocoes_Cs__c', 'AdocaoIdiomasPearson');
        Id RecTypeAccSch              = RecordTypeMemory.getRecType('Account', 'School');
        Id RecTypeAccInstIdio         = RecordTypeMemory.getRecType('Account', 'Languages'); 
        
        for(Adocoes_Cs__c Ado: lstAdo){
            //CÁLCULO SÓ DEVE SER REALIZADO PARA ADOÇÕES IDIOMAS PEARSON
            If(Ado.RecordTypeId == RecTypeAdoIdiomasPearson ){
                 
                List<Account_Segmentation__c> lstSize = AccountSegmentationDAO.queryQuadrante(String.valueOf(Ado.Institui_o__c), Ado.Ano__c);
                
                //VERIFICA SE HÁ DADOS DE ALUNOS CADASTRADOS PARA O ANO DA ADOÇÃO   
                if (lstSize.size() == 0){
                    Ado.adderror('Não foi cadastrado a quantidade de alunos para o ano ' + Ado.Ano__c + '. Por favor realize o cadastro antes de prosseguir.');
                }else{
                    for(Account_Segmentation__c accSeg: lstSize){
                
                        lstSUM = [SELECT SUM(N_mero_de_Alunos__c) QtdAlunos
                                    FROM Adocoes_Cs__c
                                    WHERE Institui_o__c =: Ado.Institui_o__c and RecordTypeId =: RecTypeAdoIdiomasPearson];
                            
                        for( AggregateResult ar : lstSUM){
                 
                            Account acc = AccountDAO.buscaConta(String.valueOf(Ado.Institui_o__c));
                    
                            if(acc.RecordTypeId == RecTypeAccSch){
                                qAluno = 400; 
                                totalAlunosEscola = Integer.valueOf(accSeg.Total_of_students_EI__c) + Integer.valueOf(accSeg.Total_of_students_EF__c) + Integer.valueOf(accSeg.Total_of_students_EM__c);
                            }
                            if(acc.RecordTypeId==RecTypeAccInstIdio){
                                qAluno = 200;
                                totalAlunosEscola = Integer.valueOf(accSeg.BR_Total_Adults_Idiomas__c) + Integer.valueOf(accSeg.Total_Alunos_Idiomas__c);
                            }   
                            
                            //NÃO É POSSÍVEL REALIZAR O CÁLCULO DE QUADRANTES COM TOTAL DE ALUNOS DA ESCOLA IGUAL A 0
                            if(totalAlunosEscola == 0){
                                Ado.adderror('Não é possível realizar o cálculo de quadrantes. O total de alunos para o ano ' +  + Ado.Ano__c + ' é igual a 0.');
                                return; 
                            }
                                            
                            Perc = (Integer.valueOf(ar.get('QtdAlunos')) * 100) / totalAlunosEscola;
                            if (totalAlunosEscola >= qAluno){
                                if(Perc >= qPerc){
                                    Quadrante = 'I';
                                }else{
                                    Quadrante ='II';
                                }
                            }else if(Perc >= qPerc){
                                Quadrante = 'III';
                            }else{
                                Quadrante = 'IV';
                            }
                            accSeg.Quadrante_Idiomas__c = Quadrante;    
                        }
                        update accSeg;  
                    }
                }
            }
        }
    } 
    
    /*
     * Devido a limitação do usuário guest em buscar a info de usuários
     * este método será chamado para atualizar o owner, sempre que o usuário for 'Confirma Adoção Usuário convidado do site' 
    */
    public void atualizaOwner(List<Opportunity> lstOportunity){
        
        system.debug('atualizaOwner');
        
        List<String> lstOppId = new List<String>();
        for(Opportunity opp : lstOportunity){
            lstOppId.add(opp.Id);
        }
        
        List<Adocoes_Cs__c> lstAdo = AdocoesDAO.getInstance().getAdocoesByLstOpportunityId(lstOppId);
        
        try{
            for(Adocoes_Cs__C ado : lstAdo){                
                ado.OwnerId = ado.BR_OportunidadeRelacionada__r.OwnerId;                
            }
            update lstAdo;
        } catch(Exception err){
            System.debug('JK erro ao atualizar' + err.getMessage());
        }
		/*
        for(Opportunity opp : lstOportunity){
            
            List<String> lstOppId = new List<String>{opp.Id};
                
            // pego todas as adoções 
            List<Adocoes_Cs__c> lstAdo = AdocoesDAO.getInstance().getAdocoesByLstOpportunityId(lstOppId);
            
            try{
                for(Adocoes_Cs__C ado : lstAdo){
                    ado.OwnerId = opp.OwnerId;
                    update ado;
                }
            } catch(Exception err){
                System.debug('JK erro ao atualizar' + err.getMessage());
            }
            
        }
        */
    }

    /*
    ID 17 E ID 19
    */
    public void criarAdocoesAPartirDeOportunidade(List<Opportunity> lstOportunity, Map<Id, Opportunity> mapOldValues){
        Set<String> setOppsParaCriarAdocaoPearson = new Set<String>();
        Set<String> setOppsParaCriarAdocaoIdiomaPearson = new Set<String>();
        Set<String> setOppsToDeleteAdocaoAntesCriarAdocao = new Set<String>();

        Map<String, String> mapTpRegistroOppAdocao = new Map<String, String>{AdocoesBO.TP_REG_ADOCAO_ADOCAOIDIOMASPEARSON => 'Oportunidade_de_Negocio_Pearson_English_EDU', 
                                                                             AdocoesBO.TP_REG_ADOCAO_ADOCAOPEARSON => 'Sample_Order_University'};
        Map<String, String> mapRecTypeValidToOpp = new Map<String, String>();
        
        for(RecordType rcType : RecordTypeDAO.getInstance().getRecordTypeByObjectAndDeveloperName(new List<String>{'Opportunity'}, mapTpRegistroOppAdocao.values())){
            mapRecTypeValidToOpp.put(rcType.Id, rcType.DeveloperName);
            system.debug('jk ' + rcType.Id + ' - ' + rcType.DeveloperName);
        }  

        System.Debug('Map: ' + mapRecTypeValidToOpp);
        boolean criaAdocao = false;
        for(Opportunity oppCheck : lstOportunity){
            
            Boolean isToDeleteAdocaoRelacionada = (mapOldValues != null && mapOldValues.get(oppCheck.Id) != null);
            if(mapRecTypeValidToOpp.containsKey(oppCheck.RecordTypeId)){
                //ADOCAO PERSON => ID 19
                if(mapRecTypeValidToOpp.get(oppCheck.RecordTypeId) == mapTpRegistroOppAdocao.get(AdocoesBO.TP_REG_ADOCAO_ADOCAOPEARSON) && oppCheck.StageName == 'Adotado'){
                    Opportunity mOpp = mapOldValues.get(oppCheck.Id);
                    if(mOpp != null){
                        if(oppCheck.StageName != mOpp.StageName ){
                            criaAdocao = true;
                            setOppsParaCriarAdocaoPearson.add(oppCheck.Id);
                            if(isToDeleteAdocaoRelacionada){
                                setOppsToDeleteAdocaoAntesCriarAdocao.add(oppCheck.Id);
                            }
                        }
                    }
                }
                //ID 17
                else if(mapRecTypeValidToOpp.get(oppCheck.RecordTypeId)  == mapTpRegistroOppAdocao.get(AdocoesBO.TP_REG_ADOCAO_ADOCAOIDIOMASPEARSON) && 
                                (oppCheck.StageName == 'Adoção Realizada' || oppCheck.StageName == 'Contrato Fechado')){
                    criaAdocao = true;
                    setOppsParaCriarAdocaoIdiomaPearson.add(oppCheck.Id);
                    if(isToDeleteAdocaoRelacionada){
                        setOppsToDeleteAdocaoAntesCriarAdocao.add(oppCheck.Id);
                    }
                }
            }
        }
        System.Debug('Depois FOR: ' + setOppsToDeleteAdocaoAntesCriarAdocao.isEmpty() + ' ' + setOppsParaCriarAdocaoPearson.isEmpty());
        
        if(criaAdocao){
            Savepoint sp = Database.setSavepoint();
            try{
                //VERIFICA REGISTROS DE ADOCAO PARA EXCLUSAO
                List<Adocoes_Cs__c> lstOppsToDelete = AdocoesDAO.getInstance().getAdocoesByLstOpportunityId(new List<String>(setOppsToDeleteAdocaoAntesCriarAdocao));
                List<OpportunityLineItem> lstOppLineItemAdocaoPearson = new List<OpportunityLineItem>();
                List<OpportunityLineItem> lstOppLineItemAdocaoIdiomaPearson = new List<OpportunityLineItem>();
                List<Adocoes_Cs__c> lstAdocoesPearsonCriar = new List<Adocoes_Cs__c>();
                List<Adocoes_Cs__c> lstAdocoesIdiomasPearsonCriar = new List<Adocoes_Cs__c>();
                
                // Adoção Sample_Order_University
                system.debug('vazio setOppsToDeleteAdocaoAntesCriarAdocao ' + setOppsToDeleteAdocaoAntesCriarAdocao);
                system.debug('vazio setOppsParaCriarAdocaoPearson ' + setOppsParaCriarAdocaoPearson);
                if(!setOppsParaCriarAdocaoPearson.isEmpty()){
                //LISTA DE ITENS DA OPORTUNIDADE PARA CRIAR ADOCOES
                    system.debug('setOppsParaCriarAdocaoPearson ' + setOppsParaCriarAdocaoPearson);
                    //lstOppLineItemAdocaoPearson = OpportunityLineItemDAO.getListOliByIdsOpp(new List<String>(setOppsParaCriarAdocaoPearson));
                    lstOppLineItemAdocaoPearson = AdocaoOut.getListOliByIdsOpp(setOppsParaCriarAdocaoPearson);
                    system.debug('nina lstOppLineItemAdocaoPearson ' + lstOppLineItemAdocaoPearson);
                    system.debug('nina lstOppsToDelete ' + lstOppsToDelete);
                    
                    lstAdocoesPearsonCriar = getInstance().criarInstanciaAdocaoPearsonFromOpportunityLineItem(lstOppLineItemAdocaoPearson);
                    
                    system.debug('lstAdocoesPearsonCriar ' + lstAdocoesPearsonCriar);
                    
    
                }else{ 
                    if (!setOppsParaCriarAdocaoIdiomaPearson.isEmpty()){
                        // Adoção Oportunidade_de_Negocio_Pearson_English_EDU
                        //LISTA DE ITENS DA OPORTUNIDADE PARA CRIAR ADOCOES
                        system.debug('setOppsParaCriarAdocaoIdiomaPearson ' + setOppsParaCriarAdocaoIdiomaPearson);
                        
                        lstOppLineItemAdocaoIdiomaPearson = AdocaoOut.getListOliByIdsOpp(setOppsParaCriarAdocaoIdiomaPearson);
                        lstAdocoesIdiomasPearsonCriar = getInstance().criarInstanciaAdocaoAcaoIdiomaPearsonFromOpportunityLineItem(lstOppLineItemAdocaoIdiomaPearson);
                    
                    
                    system.debug('lstAdocoesIdiomasPearsonCriar ' +lstAdocoesIdiomasPearsonCriar);
                    
                    }
                }
                //EXCLUE ADOCAO
                
                system.debug('JK lista de OPs para deleção : ' + lstOppsToDelete.size());
                Boolean hasError = false;
                hasError = AdocaoOut.exclui(lstOppsToDelete);
                                
                System.Debug('Tem erro: ' + hasError);
                if(!hasError){
                    if(!lstAdocoesPearsonCriar.isEmpty()){
                        //INCLUI NOVAS ADOCOES
                        system.debug('teste nina');
                        hasError = AdocaoOut.atualiza(lstAdocoesPearsonCriar, setOppsParaCriarAdocaoPearson);
             
                    }else if(!lstAdocoesIdiomasPearsonCriar.isEmpty()){
                        //INCLUI NOVAS ADOCOES
                        hasError = AdocaoOut.atualiza(lstAdocoesIdiomasPearsonCriar, setOppsParaCriarAdocaoIdiomaPearson);
                        
                        system.debug('JK developer name ' + lstAdocoesIdiomasPearsonCriar[0].RecordTypeId);
                 
                    } 
                }
            }
            catch(Exception err){
                
                System.Debug('Mensagem Erro: ' + err.getMessage());
                
                Database.rollback(sp);
                for(String idOpp : setOppsParaCriarAdocaoIdiomaPearson){
                    LogErroProcessamentoService.getInstance().registrarNovaInstanciaLogErroParaOportunidadeAdocao(idOpp, 'Erro ao executar processo de criação de Adoção para oportunidade Status Adotado.', err.getMessage());
                }

                //for(String idOpp : setOppsParaCriarAdocaoIdiomaPearson){
                //    LogErroProcessamentoService.getInstance().registrarNovaInstanciaLogErroParaOportunidadeAdocao(idOpp, 'Erro ao executar processo de criação de Adoção para oportunidade Status Adoção Realizada ou Contrato Fechado.', err.getMessage());
                //}
                

            }
          //  LogErroProcessamentoService.getInstance().comitarRegistrosDBLogErro();
        }
    }

    private List<Adocoes_Cs__c> criarInstanciaAdocaoPearsonFromOpportunityLineItem(List<OpportunityLineItem> lstOppLineItem){
        Map<String, String> mapRecTypeValidToAdocao = new Map<String, String>();
        for(RecordType rcType : RecordTypeDAO.getInstance().getRecordTypeByObjectAndDeveloperName(new List<String>{'Adocoes_Cs__c'}, new List<String>{AdocoesBO.TP_REG_ADOCAO_ADOCAOPEARSON})){
            mapRecTypeValidToAdocao.put(rcType.DeveloperName, rcType.Id);
        }
        List<Adocoes_Cs__c> lstAdocoes = new List<Adocoes_Cs__c>();
        for(OpportunityLineItem oppLineItem : lstOppLineItem){
            system.debug('BR_StatusProduto__c ' + oppLineItem.BR_StatusProduto__c);
            if(oppLineItem.BR_StatusProduto__c) {
                Adocoes_Cs__c adocao = new Adocoes_Cs__c();
                adocao.BR_OportunidadeRelacionada__c = oppLineItem.OpportunityId;
                adocao.Institui_o__c = oppLineItem.Opportunity.AccountId;
                adocao.Interno_Univ__c = oppLineItem.BR_AtendimentoInternoUniversitario__c;
                adocao.Prof_Contato__c = oppLineItem.Opportunity.BR_Contact__c;
                adocao.Curso__c = oppLineItem.BR_Curso__c;
                adocao.Disciplina__c = oppLineItem.BR_Disciplina__c;
                adocao.Adocao__c = oppLineItem.PricebookEntry.Product2Id;
                adocao.Ano__c = oppLineItem.BR_Ano__c;
               adocao.Per_odo_do_Curso__c = oppLineItem.BR_PeriodoCurso__c;
                adocao.Semestre__c = oppLineItem.BR_Semestre__c;
                adocao.N_mero_de_Alunos__c = oppLineItem.N_Alunos__c;
                adocao.Expectativa_de_Compra__c = oppLineItem.BR_TotalAlunosInstituicao__c;
                adocao.RecordTypeId = mapRecTypeValidToAdocao.get(AdocoesBO.TP_REG_ADOCAO_ADOCAOPEARSON);
                setarProprietarioAdocaoPearson(adocao,oppLineItem.Opportunity.AccountId);
                lstAdocoes.add(adocao);
            }
        }
        return lstAdocoes;
    }

    private List<Adocoes_Cs__c> criarInstanciaAdocaoAcaoIdiomaPearsonFromOpportunityLineItem(List<OpportunityLineItem> lstOppLineItem){
        Map<String, String> mapRecTypeValidToAdocao = new Map<String, String>();
        for(RecordType rcType : RecordTypeDAO.getInstance().getRecordTypeByObjectAndDeveloperName(new List<String>{'Adocoes_Cs__c'}, new List<String>{AdocoesBO.TP_REG_ADOCAO_ADOCAOIDIOMASPEARSON})){
            mapRecTypeValidToAdocao.put(rcType.DeveloperName, rcType.Id);
        }
        List<Adocoes_Cs__c> lstAdocoes = new List<Adocoes_Cs__c>();
        for(OpportunityLineItem oppLineItem : lstOppLineItem){
            Adocoes_Cs__c adocao = new Adocoes_Cs__c();
            adocao.BR_OportunidadeRelacionada__c = oppLineItem.OpportunityId;
            adocao.Institui_o__c = oppLineItem.Opportunity.AccountId;
            adocao.Prof_Contato__c = oppLineItem.Opportunity.BR_Contact__c;
            adocao.BR_Segmento__c = oppLineItem.BR_Segmento__c;
            adocao.Adocao__c = oppLineItem.PricebookEntry.Product2Id;
          adocao.Ano__c = oppLineItem.Opportunity.BR_Ano__c;
          //adocao.BR_PrevisaoCompra__c = oppLineItem.Opportunity.BR_PrevisaoCompra__c;
       adocao.Per_odo_do_Curso__c = oppLineItem.Opportunity.Semestre__c;
           adocao.Semestre__c = oppLineItem.Opportunity.Semestre__c;
            adocao.N_mero_de_Alunos__c = oppLineItem.Quantity;
          adocao.Compra_atrav_s_de_distribuidor__c =  oppLineItem.Opportunity.BR_Distribuidor__c;
      //  adocao.Distribuidor__c= oppLineItem.Opportunity.BR_Distribuidor__c;
           //adocao.BR_Segmento__c = oppLineItem.Product2.BR_segmento__c ;
        adocao.Data_de_Envio__c =  oppLineItem.Opportunity.BR_PrevisaoCompra__c;
            adocao.RecordTypeId = mapRecTypeValidToAdocao.get(AdocoesBO.TP_REG_ADOCAO_ADOCAOIDIOMASPEARSON);

            lstAdocoes.add(adocao);
            system.debug('valor ' + oppLineItem.Opportunity.BR_Distribuidor__c );
        }
        return lstAdocoes;
    }

    public void setarProprietarioAdocaoPearson(Adocoes_Cs__c adocao, String accountId){
        List<AccountTeamMember> membros = AccountTeamMemberDAO.getMemberTeamListByAccountIdAndRole(accountId, 'Inside Sales HED');
        if (membros.size()>0){
            System.debug('AccountID oppLineItem: ' + accountId);
            System.debug('Lista de Membros da conta: ' + JSON.serialize(AccountTeamMemberDAO.getMemberTeamListByAccountId(accountId)));
            System.debug('Perfil Inside Sales HED: ' + membros.get(0).UserId);
            adocao.OwnerId = membros.get(0).UserId;
        }
    }
}