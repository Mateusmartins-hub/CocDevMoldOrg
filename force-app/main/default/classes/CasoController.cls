public class CasoController {
    
    @AuraEnabled
    public static Boolean isClassic() {
        return UserInfo.getUiThemeDisplayed() != 'Theme4d';
    }
    
    @AuraEnabled
    public static Id getRecordTypeIdPadrao() {
        return Schema.SObjectType.Case.getRecordTypeInfosByDeveloperName().get('Padrao').getRecordTypeId();
    }
    
    @AuraEnabled
    public static Boolean verificaUsuarioGrupo (String idCaso) {
        try{
            String inteligenciaMKT = '%Inteligência & MKT%';
            String sucessoCliente = '%Sucesso do Cliente%';
            String Adm = '%Administrador do sistema%';
            String Adm2 = '%System Administrator%';
            Map<Id, Profile> perfisIds =  new Map<Id, Profile>([SELECT Id FROM Profile WHERE Name LIKE: inteligenciaMKT OR Name LIKE: sucessoCliente OR Name LIKE: Adm OR NAME LIKE: Adm2]);
            
            if(perfisIds.containsKey(UserInfo.getProfileId()))
                return true;
            
            return CaseAcceptClass.validateOneCase([SELECT Id, OwnerId FROM Case WHERE Id =: idCaso]);
        }catch(Exception e){ 
            throw e;
        }
    }  
    
    @AuraEnabled
    public static Boolean retornarFila (String idCaso) {
        try{
            String inteligenciaMKT = '%Inteligência & MKT%';
            String sucessoCliente = '%Sucesso do Cliente%';
            String Adm = '%Administrador do sistema%';
            String Adm2 = '%System Administrator%';
            Map<Id, Profile> perfisIds =  new Map<Id, Profile>([SELECT Id FROM Profile WHERE Name LIKE: inteligenciaMKT OR Name LIKE: sucessoCliente OR Name LIKE: Adm OR NAME LIKE: Adm2]);
            List<GroupMember> membros = [SELECT Id, UserOrGroupId FROM GroupMember WHERE Group.DeveloperName =: 'Coordenadores_Customer_Care'];
            Map<Id, GroupMember> mapMembros = new Map<Id, GroupMember>();
            for(GroupMember gm : membros) {
                mapMembros.put(gm.UserOrGroupId, gm);
            }
            
            if(!perfisIds.containsKey(UserInfo.getProfileId()) && !mapMembros.containsKey(UserInfo.getUserId()))
                return false;
            
            Case caso = [SELECT Id FROM Case WHERE Id =: idCaso];
            caso.AceitoPor__c = null;
            caso.Status = 'Novo';
            update caso;
            
            return true;
        }catch(Exception e){ 
            throw e;
        }
    }     
    
    @AuraEnabled
    public static String aceitarCaso (String idCaso) {
        try{
            return CaseAcceptClass.accept(new List<Id> {idCaso});
        }catch(Exception e){
            throw e;
        }
    }
    
    @AuraEnabled
    public static Case deleteCase (Case caso) {
        delete caso;
        return caso;
    }
    
    @AuraEnabled
    public static void enviarEmailPesquisa(String de, String para, String texto, String casoId, Boolean sendPesquisa, String motivoNaoEnvio) {                
        if (sendPesquisa) {
            EmailTemplate et = [SELECT Id, Body, HtmlValue FROM EmailTemplate WHERE DeveloperName = 'EncerramentoCasoPesquisa' LIMIT 1];
            
            Case caso = [SELECT Id, Description, CaseNumber FROM Case WHERE Id =: casoId];
            if(caso != null) {
                String textoCorpo = et.HtmlValue;
                
                Site externalSite = [SELECT Id FROM Site WHERE Name = 'PesquisaSatisfacaoCasos'];
                SiteDetail siteDetail = [SELECT SecureURL FROM SiteDetail WHERE DurableId = :externalSite.Id];
                
                textoCorpo = textoCorpo.replace('{Email}', para);                
                textoCorpo = textoCorpo.replace('{NumCaso}', caso.CaseNumber);
                textoCorpo = textoCorpo.replace('{PesquisaURL}', siteDetail.SecureURL + '?recordId='+casoId);            
                
                Messaging.Singleemailmessage email = new Messaging.Singleemailmessage();
                email.setSubject('Seu caso foi fechado! ~ Pearson');
                email.setWhatId(casoId);
                email.toAddresses = new String[] { para };
                    email.setSaveAsActivity(false);
                email.setReplyTo(de);
                email.setHtmlBody(textoCorpo);
                
                Messaging.SingleEmailMessage[] emails =   new List<Messaging.SingleEmailMessage> {email};
                    
                    Messaging.sendEmail(emails);
            }
        }
   }
        
    
    @AuraEnabled
    public static void enviarEmailFechamento(String de, String para, String texto, String casoId) {                
        EmailTemplate et = [SELECT Id, Body, HtmlValue FROM EmailTemplate WHERE DeveloperName = 'EmailFechamentoTemplate' LIMIT 1];
        
        Case caso = [SELECT Id, Description, CaseNumber FROM Case WHERE Id =: casoId];
        if(caso != null) {
            String textoCorpo = et.HtmlValue;
            
            
            textoCorpo = textoCorpo.replace('{!Email}', para);
            textoCorpo = textoCorpo.replace('{!TextoFechamento}', texto);
            textoCorpo = textoCorpo.replace('{!DescricaoCaso}', caso.Description);
            textoCorpo = textoCorpo.replace('{!NumCaso}', caso.CaseNumber);
            
            
            Messaging.Singleemailmessage email = new Messaging.Singleemailmessage();
            email.setSubject('Seu caso foi fechado! ~ Pearson');
            email.setWhatId(casoId);
            email.toAddresses = new String[] { para };
                email.setSaveAsActivity(false);
            email.setReplyTo(de);
            email.setHtmlBody(textoCorpo);
            
            Messaging.SingleEmailMessage[] emails =   new List<Messaging.SingleEmailMessage> {email};
                
                Messaging.sendEmail(emails);
        }
    }
    
    
    @AuraEnabled
    public static List<String> carregarEmailsDe(Boolean ouvidoria, String marca, String lob) {
        Set<String> retorno = new Set<String>();
        
        List<DeParaEmail__mdt> deParaEmails = new List<DeParaEmail__mdt>();
        if(ouvidoria) {
            deParaEmails = [SELECT Id, MasterLabel, Marca__c, LinhaNegocio__c FROM DeParaEmail__mdt WHERE EmailOuvidoria__c = true AND Marca__c =: marca];
        }else{
            deParaEmails = [SELECT Id, MasterLabel, Marca__c, LinhaNegocio__c FROM DeParaEmail__mdt WHERE EmailOuvidoria__c = false AND Marca__c =: marca AND LinhaNegocio__c =: lob];
        }
        
        for(DeParaEmail__mdt dp : deParaEmails) {
            retorno.add(dp.MasterLabel);
        }
        
        return new List<String>(retorno);
    }
    
    @AuraEnabled
    public static List<String> buscarGruposDoUser(String idUsuario) {
        Set<String> setGrupos = new Set<String>();
        Set<String> setReturn = new Set<String>();
        
        List<GroupMember> gruposMembros = [SELECT Id, Group.Name FROM GroupMember WHERE UserOrGroupId =: idUsuario AND Group.Name LIKE 'LN: %'];
        
        for(GroupMember gm : gruposMembros) {
            setGrupos.add(gm.Group.Name.substring(4, gm.Group.Name.length() - 6));
        }
        
        List<DeParaGrupo__mdt> deParaGrupos = [SELECT Id, MasterLabel, GrupoSolucionador__c FROM DeParaGrupo__mdt WHERE MasterLabel IN: setGrupos];
        Map<String, DeParaGrupo__mdt> mapDeParaGrupos = new Map<String, DeParaGrupo__mdt>();
        
        for(DeParaGrupo__mdt dp : deParaGrupos) {
            mapDeParaGrupos.put(dp.MasterLabel, dp);
        }
        
        for(GroupMember gm : gruposMembros) {
            String grupoName = gm.Group.Name.substring(4, gm.Group.Name.length() - 6);
            
            if(!mapDeParaGrupos.containsKey(grupoName))
                continue;
            
            String grupoValor = mapDeParaGrupos.get(grupoName).GrupoSolucionador__c;
            setReturn.add(grupoValor);
        }
        
        return new List<String>(setReturn);
    }
    
    @AuraEnabled
    public static Boolean verificaUsuarioAtualFila(String grupoSolucionador) {
        Boolean retorno = true;
        
        Map<String, List<String>> mapGrupo = new Map<String, List<String>>();
        List<User> usuarios = [SELECT Id, Profile.Name, ProfileId FROM User];
        Map<Id, User> mapUsers = new Map<Id, User>();
        
        for(User u : usuarios) {
            mapUsers.put(u.Id, u);
        }
        
        List<GroupMember> grupos = [SELECT UserOrGroupId, Group.Name, GroupId FROM GroupMember WHERE Group.Name =: grupoSolucionador];
        
        for(GroupMember grupoMembro : grupos) {
            if(!mapGrupo.containsKey(grupoMembro.Group.Name))
                mapGrupo.put(grupoMembro.Group.Name, new List<String>());
            
            if(mapUsers.containsKey(grupoMembro.UserOrGroupId))
                mapGrupo.get(grupoMembro.Group.Name).add(mapUsers.get(grupoMembro.UserOrGroupId).ProfileId);
        }
        
        if(mapGrupo.containsKey(grupoSolucionador)) {
            if(!mapGrupo.get(grupoSolucionador).contains(UserInfo.getProfileId())) {
                if(!mapUsers.get(UserInfo.getUserId()).Profile.Name.contains('Inteligência & MKT') &&
                   !mapUsers.get(UserInfo.getUserId()).Profile.Name.contains('Sucesso do Cliente') &&
                   !mapUsers.get(UserInfo.getUserId()).Profile.Name.contains('Admin')) {
                       retorno = false;
                   }
            }
        }
        
        return retorno;
    }
    
    @AuraEnabled
    public static GrupoSolucionador__c buscarGrupoSolucionadorAtual(String grupoSolucionadorId) {
        return GrupoSolucionadorDAO.getGrupoSolucionadorById(grupoSolucionadorId);
    }
    
    @AuraEnabled
    public static void salvarInformacoes(String informacoes) {
        List<InformacaoObservador> listInfos = (List<InformacaoObservador>) JSON.deserialize(informacoes, List<InformacaoObservador>.class);
        List<InformacoesObservador__c> listInfosInsert = new List<InformacoesObservador__c>();
        
        for(InformacaoObservador info : listInfos) {
            InformacoesObservador__c infoInsert = new InformacoesObservador__c();
            
            infoInsert.Observador__c = info.observador;
            infoInsert.Informacao__c = info.informacao;
            infoInsert.Caso__c      = info.casoId;
            
            listInfosInsert.add(infoInsert);
        }
        
        insert listInfosInsert;
    }
    
    private class InformacaoObservador {
        public String observador {get;set;}
        public String informacao {get;set;}
        public Id casoId {get;set;}
    }
    
    @AuraEnabled
    public static String clonarCaso(String idCaso) {
        try{
            Case caso = CaseDAO.getCaseById(idCaso);
            String inteligenciaMKT = '%Inteligência & MKT%';
            String sucessoCliente = '%Sucesso do Cliente%';
            String Adm = '%Administrador do sistema%';
            String Adm2 = '%System Administrador%';
            Map<Id, Profile> perfisIds = new Map<Id, Profile>([SELECT Id FROM Profile WHERE Name LIKE :inteligenciaMKT OR Name LIKE :sucessoCliente OR Name LIKE :Adm OR Name LIKE :Adm2]);

            if(perfisIds.keySet().contains(UserInfo.getProfileId())) {
                Case casoClonado = caso.clone(false, true, false, false);

                if(caso.GrupoSolucionadorAbertura__c != null) {
                    casoClonado.GrupoSolucionador__c = caso.GrupoSolucionadorAbertura__c;
                    casoClonado.OrdemGrupoSolucionador__c = 0;
                } else {
                    GrupoSolucionador__c grupo = GrupoSolucionadorDAO.getGrupoSolucionadorByCampos(caso.Tipo__c, caso.Subtipo__c, caso.Detalhamento__c, caso.Detalhamento2__c, 1);
                    casoClonado.GrupoSolucionador__c = grupo.GrupoSolucionador__c;
                    casoClonado.OrdemGrupoSolucionador__c = grupo.Ordem__c;
                }

                casoClonado.Status = 'Novo';
                casoClonado.AceitoPor__c = null;

                insert casoClonado;

                return casoClonado.Id;
            } else {
                return 'SEMPERMISSAO';
            }

        } catch(Exception e) {
            throw e;
        }
    }
    
    @AuraEnabled
    public static String cancelarCaso (String idCaso) {
        try{
            Case caso = CaseDAO.getCaseById(idCaso);
            caso.Status = 'Cancelado';
            update caso;
            return 'CANCELADO';
        }catch(Exception e){
            throw e;
        }
    }
    
    @AuraEnabled
    public static void insertSolution(String idCaso, String idSolution) {
        if([SELECT Id FROM CaseSolution WHERE CaseId =: idCaso AND SolutionId =: idSolution].isEmpty()) {
            CaseSolution sol = new CaseSolution();
            sol.CaseId = idCaso;
            sol.SolutionId = idSolution;
            insert sol;
        }
    }
    
    @AuraEnabled
    public static String fecharCaso (String idCaso) {
        try{
            Case caso = CaseDAO.getCaseById(idCaso);
            
            if(caso.IsClosed)
                return 'JAESTAFECHADO';
            
            if(UserInfo.getUserId() != caso.AceitoPor__c)
                return 'CASONAOFOIACEITOPELOUSUARIO';
            
            if(caso.Status == 'Aguardando Cliente')
                return 'CASOAGUARDANDOCLIENTE';
            /*
String tipo = caso.Tipo__c, subtipo = caso.Subtipo__c, detalhamento = caso.Detalhamento__c, detalhamento2 = caso.Detalhamento2__c;
Integer ordemAtual = caso.OrdemGrupoSolucionador__c == null ? 0 : Integer.valueOf(caso.OrdemGrupoSolucionador__c);

List<GrupoSolucionador__c> proxGrupos = GrupoSolucionadorDAO.getNextGruposSolucionadoresByCampos(tipo, subtipo, detalhamento, detalhamento, ordemAtual);

if(proxGrupos != null)
return 'POSSUIGRUPONAFRENTE';
*/
               
            List<SLACaso__c> slas = [SELECT Id FROM SLACaso__c WHERE Caso__c = :caso.Id];
            if (slas.size() == 1)
                caso.FechadoNoPrimeiroGrupo__c = true;
            
            caso.Status = 'Closed';
            update caso;
            return 'FECHADO';
        }catch(Exception e){
            throw e;
        }
    }
    
    @AuraEnabled
    public static void criarComentario(String descComentario, String casoId) {
        CaseComment comment = new CaseComment();
        comment.ParentId = casoId;
        comment.IsPublished = true;
        comment.CommentBody = 'Comentário para o grupo: ' + descComentario;
        
        insert comment;
    }
    
    @AuraEnabled
    public static void retomarSLA(String casoId, String grupoSolucionadorId) {
        BusinessHours bh = [SELECT Id, Name, IsActive, IsDefault FROM BusinessHours WHERE IsDefault = true AND Name='Brazil'];
        GrupoSolucionador__c grupoParaRetornar = GrupoSolucionadorDAO.getGrupoSolucionadorById(grupoSolucionadorId);
        
        SLACaso__c SLAParaRetornar = SLACasoDAO.getSLAByCasoAndGrupoSolucionador(casoId, grupoSolucionadorId);
        
        Map<String, GrupoSolucionador__c> mapGrupos = new Map<String, GrupoSolucionador__c>();
        mapGrupos.put(grupoParaRetornar.IdentificadorGrupo__c, grupoParaRetornar);
        
        Map<Id, SLACaso__c> mapUltimoSLAdoCaso = new Map<Id, SLACaso__c>();
        SLACaso__c ultimoSLA = SLACasoDAO.getUltimoSLACaso(casoId);
        
        List<SLACaso__c> slasInsert = new List<SLACaso__c>();
        List<SLACaso__c> slasUpdate = new List<SLACaso__c>();
        
        if(SLAParaRetornar != null){
            SLACaso__c slaNovoCaso = new SLACaso__c();
            slaNovoCaso.Name = SLAParaRetornar.Name;
            slaNovoCaso.Caso__c = casoId;
            slaNovoCaso.GrupoSolucionador__c = grupoParaRetornar.Id;
            slaNovoCaso.SLA__c = (SLAParaRetornar.SLA__c - SLAParaRetornar.SLAUtilizado__c) < 0 ? 0 : SLAParaRetornar.SLA__c - SLAParaRetornar.SLAUtilizado__c;
            slaNovoCaso.SLARetomado__c = true;
            
            slasInsert.add(slaNovoCaso);            
        }        
        
        if(ultimoSLA != null){
            ultimoSLA.ClosedDate__c = System.now();
            ultimoSLA.SLAUtilizadoCodigo__c = BusinessHours.diff(bh.Id, ultimoSLA.ClosedDate__c, System.now()) / 1000 / 60;
            slasUpdate.add(ultimoSLA);            
        }
        
        if(slasUpdate.size() > 0)
            update slasUpdate;
        if(slasInsert.size() > 0)
            insert slasInsert;
    }
    
    @AuraEnabled
    public static Case getCase(String idCaso) {
        try{
            if(idCaso != null && idCaso.length() > 0 && String.isNotEmpty(idCaso)) {
                return CaseDAO.getCaseById(idCaso);
            }else{
                return new Case();
            }
        }catch(Exception e){
            throw e;
        }
    }
    
    @AuraEnabled
    public static List<SLACaso__c> getSLAs(Id casoId) {
        List<SLACaso__c> slas =[SELECT Id, IsDeleted, Name, CreatedDate,
                                CreatedById, LastModifiedDate, LastModifiedById, SystemModstamp,
                                LastActivityDate, Caso__c, Caso__r.GrupoSolucionador__c, ClosedDate__c, SLAUtilizado__c, GrupoSolucionador__c, GrupoSolucionador__r.Id, NomeGrupoSolucionador__c, SLA__c,
                                DataAbertura__c, SLAHoras__c, SLAUtilizadoHoras__c, SLARetomado__c, FarolSLA__c, SaldoSLAMinutos__c,
                                SaldoSLAHoras__c, SLAEstourado__c FROM SLACaso__c WHERE Caso__c =: casoId ORDER BY CreatedDate DESC];
        return slas;
    }
    
    @AuraEnabled
    public static List<EmailMessage> getEmails(Id casoId) {
        List<EmailMessage> emails = [SELECT Id, ParentId, ActivityId, CreatedById, CreatedDate, LastModifiedDate, LastModifiedById,
                                     TextBody, HtmlBody, Headers, Subject, FromName, FromAddress, ValidatedFromAddress,
                                     ToAddress, CcAddress, BccAddress, Incoming, HasAttachment, Status, MessageDate, IsDeleted, ReplyToEmailMessageId,
                                     IsExternallyVisible, MessageIdentifier, ThreadIdentifier, IsClientManaged, IsTracked, IsOpened,
                                     FirstOpenedDate, LastOpenedDate, IsBounced FROM EmailMessage WHERE ParentId =: casoId ORDER BY CreatedDate DESC LIMIT 5];
        return emails;
    }
    
    @AuraEnabled
    public static List<CaseComment> getComments(Id casoId) {
        List<CaseComment> comments = [SELECT Id, ParentId, IsPublished, CommentBody, CreatedById, CreatedDate, CreatedBy.Name,
                                      SystemModstamp, LastModifiedDate, LastModifiedById, IsDeleted
                                      FROM CaseComment WHERE ParentId =: casoId ORDER BY CreatedDate DESC];
        return comments;
    }
    
    @AuraEnabled
    public static List<BR_Notas_vinculadas__c> getNotes(Id casoId) {
        List<BR_Notas_vinculadas__c> notes = [SELECT Id, OwnerId, IsDeleted, Name, CreatedDate, CreatedById, LastModifiedDate, LastModifiedById, SystemModstamp, BR_Caso__c,
                                              BR_Data_da_Nota__c, BR_Frete__c, BR_Valor_Fundo_Nacional__c, BR_Valor_Fundo_Regional__c, BR_Valor_dos_Produtos__c
                                              FROM BR_Notas_vinculadas__c WHERE BR_Caso__c =: casoId ORDER BY CreatedDate DESC LIMIT 5];
        return notes;
    }
    
    @AuraEnabled
    public static List<Materiais__c> getMaterials(Id casoId) {
        List<Materiais__c> materiais = [SELECT Id, IsDeleted, Name, CreatedDate, CreatedById, LastModifiedDate, LastModifiedById, SystemModstamp,
                                        LastViewedDate, LastReferencedDate, BR_Caso__c, BR_Cod_Item__c, BR_Descri_o_do_Defeito__c, BR_Nota_Fiscal_Origem__c,
                                        BR_Qtd_Informada__c, BR_Qtd_Recebida__c, BR_Valor_Unitario__c, BR_Total_R_Qtd_Informada__c, BR_Total_RS_Qtd_Recebida__c,
                                        BR_Total_valor_Referencia__c, BR_Total_qtd_Referencia__c, BR_Qtd_Comprada__c, BR_Base_ICMS__c, BR_P_ICMS__c, BR_P_IPI__c, UniqueId__c
                                        FROM Materiais__c WHERE BR_Caso__c =: casoId ORDER BY CreatedDate DESC LIMIT 5];
        return materiais;
    }
    
    @AuraEnabled
    public static List<OpenActivity> getActivities(Id casoId) {
        try {
            Case caso = [SELECT Id, (SELECT Id, AccountId, WhoId, WhatId, Subject, IsTask, ActivityDate, OwnerId, Status, Priority,
                                     IsHighPriority, ActivityType, IsClosed, IsAllDayEvent, IsVisibleInSelfService, DurationInMinutes,
                                     Location, Description, IsDeleted, CreatedDate, CreatedById, LastModifiedDate, LastModifiedById,
                                     CallDurationInSeconds, CallType, CallDisposition, CallObject, ReminderDateTime, EndDateTime, StartDateTime,
                                     PrimaryWhoId, PrimaryAccountId, ActivitySubtype, AlternateDetailId, Produto__c, Quantidade_de_Alunos__c, Status_da_Visita__c,
                                     Start_Date_Time__c, Resposta__c, BR_Sistema_COC__c, BR_Sistema_Dom_Bosco__c,
                                     BR_Tem_Interesse__c, Motivo_do_nao_Interesse__c, Owner.Name,
                                     BR_Create_Audit__c, BR_Foi_atendido__c, BR_Source_Visit__c,
                                     BR_Tipo_da_Visita__c, BR_Visita_Realizada__c, BR_Justificativa__c, BR_Apoio_Prospec_o__c, BR_Apresenta_de_Tecnologias_Educacionais__c,
                                     BR_Atendimento_Remoto__c,
                                     BR_Cole_es_Especiais__c, BR_Diagn_stica__c, BR_Implantacao__c, BR_Lousa_Digital__c, BR_Materiais_Did_ticos__c, BR_Outro__c,
                                     BR_Outrocomentario__c, BR_Palestra__c, BR_Portais__c, Codigo__c, BR_Reuni_o_de_alinhamento_aprofundamento__c,
                                     BR_Roteiros_Digitais__c, BR_Solu_es_Pearson__c, BR_Treinamento_Capacita_o__c, BR_Motivo_Home_Office__c, BR_FinalCheckinDate__c,
                                     BR_FinalLocation__Latitude__s, BR_FinalLocation__Longitude__s, BR_FinalLocation__c, BR_InitialCheckinDate__c, BR_InitialLocation__Latitude__s,
                                     BR_InitialLocation__Longitude__s, BR_InitialLocation__c, BR_Proposta_Comercial__c, Br_Amostra_Entregue__c,
                                     Proposta_Tecnica__c, Sistema_NAME__c, BR_Evento_destinado_para_NAME__c, BR_Produtos_complementares__c, BR_fez_checkin__c,
                                     BR_Fez_ckeck_out__c, BR_Visita_de_Apresentacao__c, BR_Visita_de_Acompanhamento__c, BR_Visita_Comercial__c, BR_Visita_de_Renovacao__c,
                                     BR_Mensurar_satisfacao_do_cliente__c, BR_Reforcar_relacionamento__c, BR_Licitacao__c, BR_Reclamacao_do_cliente__c, BR_Oferecer_novos_produtos__c,
                                     BR_Aumentar_segmento_alunos__c, BR_Follow_up_de_acoes__c, BR_Inadimplencia__c, BR_Disseminar_melhores_praticas__c,
                                     BR_Modulo__c,
                                     BR_Tema__c, BR_Marca__c, Perfil__c, Antes_ou_pos__c, BR_Contato__c, BR_MarcaCompromisso__c,
                                     BR_SubtipoConsultoria__c, BR_TipoConsultoria__c, BR_Motivos__c, BR_PrevisaoPagamento__c, BR_StatusAtuacao__c, BR_Sistema_Atitude__c
                                     FROM OpenActivities ORDER BY LastModifiedDate DESC LIMIT 5)
                         FROM Case WHERE Id =: casoId];
            return caso.OpenActivities;
        }catch(Exception e) {
            return null;
        }
    }
    
    @AuraEnabled
    public static List<CaseSolution> getSolutions(Id casoId) {
        List<CaseSolution> solucoes = [SELECT Id, CaseId, SolutionId, Solution.SolutionName, Solution.SolutionNumber, Solution.Status, CreatedBy.Name, CreatedDate, SystemModstamp, IsDeleted
                                       FROM CaseSolution WHERE CaseId =: casoId ORDER BY CreatedDate DESC LIMIT 5];
        system.debug(UserInfo.getUiThemeDisplayed());
        system.debug(solucoes);
        return solucoes;
    }
    
    @AuraEnabled
    public static List<Attachment> getAttachments(Id casoId) {
        List<Attachment> anexos = [SELECT Id, IsDeleted, ParentId, Name, IsPrivate, ContentType, BodyLength, Body, OwnerId, CreatedDate,
                                   CreatedById, CreatedBy.Name, LastModifiedDate, LastModifiedById, SystemModstamp, Description
                                   FROM Attachment WHERE ParentId =: casoId ORDER BY CreatedDate DESC LIMIT 5];
        return anexos;
    }
    
    @AuraEnabled
    public static List<HistoricoCaso> getCaseHistories(Id casoId) {
        List<HistoricoCaso> histories = new List<HistoricoCaso>();
        
        SObjectType objToken = Schema.getGlobalDescribe().get('Case');
        DescribeSObjectResult objDef = objToken.getDescribe();
        Map<String, SObjectField> fields = objDef.fields.getMap();
        
        for(CaseHistory ch : [SELECT Id, IsDeleted, CaseId, CreatedById, CreatedDate, Field, OldValue, NewValue, CreatedBy.Name
                              FROM CaseHistory WHERE CaseId =: casoId ORDER BY CreatedDate DESC])
        {
            if((ch.Field == 'ownerAssignment' && String.ValueOf(ch.NewValue).startsWithIgnoreCase('00G')) || !fields.containsKey(ch.Field) || ch.OldValue instanceof Id || ch.NewValue instanceof Id)
                continue;
            
            HistoricoCaso hc = new HistoricoCaso(ch.CreatedDate, ch.CreatedBy.Name, fields.get(ch.Field).getDescribe().label, ch.OldValue, ch.NewValue);
            
            histories.add(hc);
        }
        return histories;
    }
    
    @AuraEnabled
    public static List<Approval> getCaseApproveHistories(Id casoId) {
        List<Approval> aprovacoes = [SELECT Id, IsDeleted, ParentId, OwnerId, CreatedDate, CreatedById, LastModifiedDate, CreatedBy.Name,
                                     LastModifiedById, Status, RequestComment, ApproveComment, SystemModstamp
                                     FROM Approval WHERE ParentId =: casoId ORDER BY CreatedDate DESC LIMIT 5];
        return aprovacoes;
    }
    
    @AuraEnabled
    public static User getUser(String idUser) {
        return [SELECT Id, Name FROM User WHERE Id =: idUser];
    }
    
    @AuraEnabled
    public static List<InformacoesObservador__c> getObservadores(String idCaso) {
        if(idCaso == null)
            return null;
        
        return [SELECT Id, Informacao__c, Observador__c, Observador__r.Name, CreatedBy.Name FROM InformacoesObservador__c WHERE Caso__c =: idCaso ORDER BY CreatedDate DESC];
    }
    
    @AuraEnabled
    public static Map<String, Map<String, Boolean>> getCamposCaso(String idCaso) {
        Map<String, Map<String, Boolean>> mapRetorno = new Map<String, Map<String, Boolean>>();
        
        if(idCaso != null && idCaso.length() > 0 && String.isNotEmpty(idCaso)) {
            Case caso = CaseDAO.getCaseById(idCaso);
            
            if(caso.GrupoSolucionador__c != null) {
                LayoutCaso__c layoutPorGrupo = LayoutCasoDAO.BuscarLayoutsPorGrupoSolucionador(caso.GrupoSolucionador__c);
                
                if(layoutPorGrupo != null) {
                    for(SessaoLayoutCaso__c sessao : layoutPorGrupo.SessoesLayoutCaso__r) {
                        mapRetorno.put(sessao.Name, new Map<String, Boolean>());
                        
                        if(sessao.CamposSessao__c != null && String.isNotBlank(sessao.CamposSessao__c))
                            for(String campo : sessao.CamposSessao__c.split(';'))
                            mapRetorno.get(sessao.Name).put(campo, false);
                    }
                }
                GrupoSolucionador__c grupoAtual = GrupoSolucionadorDAO.getGrupoSolucionadorByCampos(caso.Tipo__c, caso.Subtipo__c, caso.Detalhamento__c, caso.Detalhamento2__c, Integer.valueOf(caso.OrdemGrupoSolucionador__c));
                
                if(grupoAtual.CamposObrigatorios__c != null) {
                    for(String campo : grupoAtual.CamposObrigatorios__c.split(';')) {
                        String sessaoGrupoAtual = 'Informações do grupo solucionador atual';
                        if(!mapRetorno.containsKey(sessaoGrupoAtual))
                            mapRetorno.put(sessaoGrupoAtual, new Map<String, Boolean>());
                        
                        mapRetorno.get(sessaoGrupoAtual).put(campo, false);
                    }
                }
                
                List<GrupoSolucionador__c> gruposAnteriores = GrupoSolucionadorDAO.getPreviousGrupoSolucionadorByCampos(caso.Tipo__c, caso.Subtipo__c, caso.Detalhamento__c, caso.Detalhamento2__c, Integer.valueOf(caso.OrdemGrupoSolucionador__c));
                
                for(GrupoSolucionador__c grupo : gruposAnteriores) {
                    if(grupo.CamposObrigatorios__c != null) {
                        for(String campo : grupo.CamposObrigatorios__c.split(';')) {
                            String sessaoGrupoAnterior = 'Informações do grupo solucionador anterior';
                            if(!mapRetorno.containsKey(sessaoGrupoAnterior))
                                mapRetorno.put(sessaoGrupoAnterior, new Map<String, Boolean>());
                            
                            mapRetorno.get(sessaoGrupoAnterior).put(campo, true);
                        }
                    }
                }
            }else{
                LayoutCaso__c layoutPadrao = LayoutCasoDAO.BuscaLayoutPadrao();
                
                if(layoutPadrao != null) {
                    for(SessaoLayoutCaso__c sessao : layoutPadrao.SessoesLayoutCaso__r) {
                        mapRetorno.put(sessao.Name, new Map<String, Boolean>());
                        
                        if(sessao.CamposSessao__c != null && String.isNotBlank(sessao.CamposSessao__c))
                            for(String campo : sessao.CamposSessao__c.split(';'))
                            mapRetorno.get(sessao.Name).put(campo, false);
                    }
                }
            }
        }else{
            LayoutCaso__c layoutPadrao = LayoutCasoDAO.BuscaLayoutPadrao();
            
            if(layoutPadrao != null) {
                for(SessaoLayoutCaso__c sessao : layoutPadrao.SessoesLayoutCaso__r) {
                    mapRetorno.put(sessao.Name, new Map<String, Boolean>());
                    
                    if(sessao.CamposSessao__c != null && String.isNotBlank(sessao.CamposSessao__c))
                        for(String campo : sessao.CamposSessao__c.split(';'))
                        mapRetorno.get(sessao.Name).put(campo, false);
                }
            }
        }
        
        for(String sessao : mapRetorno.keySet()) {
            for(String campo : mapRetorno.get(sessao).keySet()) {
                
                if(campo == 'Tipo__c' && mapRetorno.get(sessao).get(campo) == false)
                    mapRetorno.get(sessao).put(campo, true);
                if(campo == 'Subtipo__c' && mapRetorno.get(sessao).get(campo) == false)
                    mapRetorno.get(sessao).put(campo, true);
                if(campo == 'Detalhamento__c' && mapRetorno.get(sessao).get(campo) == false)
                    mapRetorno.get(sessao).put(campo, true);
                if(campo == 'Detalhamento2__c' && mapRetorno.get(sessao).get(campo) == false)
                    mapRetorno.get(sessao).put(campo, true);
                if(campo == 'GrupoSolucionador__c' && mapRetorno.get(sessao).get(campo) == false)
                    mapRetorno.get(sessao).put(campo, true);
                if(campo == 'OrdemGrupoSolucionador__c' && mapRetorno.get(sessao).get(campo) == false)
                    mapRetorno.get(sessao).put(campo, true);
            }
        }
        
        return mapRetorno;
    }
    
    @AuraEnabled
    public static List<String> getCamposCasoDesativados(Id idCaso) {
        List<String> retorno = new List<String>();
        
        if(idCaso != null && String.isNotEmpty(idCaso)) {
            Case caso = CaseDAO.getCaseById(idCaso);
            
            if(caso.OrdemGrupoSolucionador__c != null && caso.OrdemGrupoSolucionador__c != 0) {
                List<GrupoSolucionador__c> gruposAnteriores = GrupoSolucionadorDAO.getPreviousGrupoSolucionadorByCampos(caso.Tipo__c, caso.Subtipo__c, caso.Detalhamento__c, caso.Detalhamento2__c, Integer.valueOf(caso.OrdemGrupoSolucionador__c));
                
                for(GrupoSolucionador__c grupo : gruposAnteriores) {
                    if(grupo.CamposObrigatorios__c != null) {
                        for(String s : grupo.CamposObrigatorios__c.split(';')) {
                            if(!retorno.contains(s))
                                retorno.add(s);
                        }
                    }
                }
            }
        }
        return retorno;
    }
    
    @AuraEnabled
    public static List<String> getTipos() {
        List<String> tipos = new List<String>();
        List<ParametrizacaoCasos__c> paramsCasos = [SELECT Id, Tipo__c
                                                    FROM ParametrizacaoCasos__c
                                                    WHERE Ativo__c = true];
        
        for(ParametrizacaoCasos__c param : paramsCasos) {
            if(!tipos.contains(param.Tipo__c)) {
                tipos.add(param.Tipo__c);
            }
        }
        
        tipos.sort();
        return tipos;
    }
    
    @AuraEnabled
    public static List<String> getSubtipos(String tipo) {
        List<String> subtipos = new List<String>();
        List<ParametrizacaoCasos__c> paramsCasos = [SELECT Id, Subtipo__c
                                                    FROM ParametrizacaoCasos__c
                                                    WHERE Tipo__c =: tipo
                                                    AND Ativo__c = true];
        
        for(ParametrizacaoCasos__c param : paramsCasos) {
            if(!subtipos.contains(param.Subtipo__c)) {
                subtipos.add(param.Subtipo__c);
            }
        }
        
        subtipos.sort();
        return subtipos;
    }
    
    @AuraEnabled
    public static List<String> getDetalhamentos(String tipo, String subtipo) {
        List<String> detalhamentos = new List<String>();
        
        List<ParametrizacaoCasos__c> paramsCasos = [SELECT Id, Detalhamento__c
                                                    FROM ParametrizacaoCasos__c
                                                    WHERE Tipo__c =: tipo
                                                    AND Subtipo__c =: subtipo
                                                    AND Ativo__c = true];
        
        for(ParametrizacaoCasos__c param : paramsCasos) {
            if(!detalhamentos.contains(param.Detalhamento__c)) {
                detalhamentos.add(param.Detalhamento__c);
            }
        }
        
        detalhamentos.sort();
        return detalhamentos;
    }
    
    @AuraEnabled
    public static List<String> getDetalhamentos2(String tipo, String subtipo, String detalhamento) {
        List<String> detalhamentos2 = new List<String>();
        List<ParametrizacaoCasos__c> paramsCasos = [SELECT Id, Detalhamento2__c
                                                    FROM ParametrizacaoCasos__c
                                                    WHERE Tipo__c =: tipo
                                                    AND Subtipo__c =: subtipo
                                                    AND Detalhamento__c =: detalhamento
                                                    AND Ativo__c = true];
        
        for(ParametrizacaoCasos__c param : paramsCasos) {
            if(!detalhamentos2.contains(param.Detalhamento2__c)) {
                detalhamentos2.add(param.Detalhamento2__c);
            }
        }
        
        detalhamentos2.sort();
        return detalhamentos2;
    }
    
    @AuraEnabled
    public static String convertIdToEighteen(String idConta) {
        return (String)Id.valueOf(idConta);
    }
    
    @AuraEnabled
    public static List<GrupoSolucionador__c> buscarProxGrupo(String tipo, String subtipo, String detalhamento, String detalhamento2, Decimal ordemAtual) {
        return GrupoSolucionadorDAO.getNextGruposSolucionadoresByCampos(tipo, subtipo, detalhamento, detalhamento2, Integer.valueOf(ordemAtual));
    }
    
    @AuraEnabled
    public static GrupoSolucionador__c buscarGrupo(String idGrupo) {
        return GrupoSolucionadorDAO.getGrupoSolucionadorById(idGrupo);
    }
    
    @AuraEnabled
    public static Boolean verificaUltimoGrupo(Id idCaso) {
        Case caso = CaseDAO.getCaseById(idCaso);
        
        system.debug('idCaso ' + idCaso);
        system.debug('caso ' + caso);
        
        return ((GrupoSolucionadorDAO.getNextGruposSolucionadoresByCampos(caso.Tipo__c, caso.Subtipo__c, caso.Detalhamento__c, caso.Detalhamento2__c, Integer.valueOf(caso.OrdemGrupoSolucionador__c))) == null);
    }
    
    @AuraEnabled
    public static List<String> getMotivosNaoEnvioPesquisa() {
        List<String> pickListValuesList= new List<String>();
        Schema.DescribeFieldResult fieldResult = Case.MotivoNaoEnvioPesquisaSatisfacao__c.getDescribe();
        List<Schema.PicklistEntry> ple = fieldResult.getPicklistValues();
        for( Schema.PicklistEntry pickListVal : ple){
            pickListValuesList.add(pickListVal.getLabel());
        }
        return pickListValuesList;
    }
    
    @AuraEnabled
    public static void enviarPesquisaMotivo(String recordId, Boolean sendPesquisa, String motivoNaoEnvio){
        String recipientEmail;
        String senderEmail = 'nao-responda@pearson.com';
        Case cs = [SELECT AccountId FROM Case WHERE Id =:recordId];
        Account acc = [SELECT BR_Account_email__c FROM Account WHERE ID = :cs.AccountId];
        
        if (acc.BR_Account_email__c == null) {
            Account_Contact__c ctc = ContactDAO.getAccountContact(cs.AccountId);
            recipientEmail = ctc.Email__c;
        } else {
            recipientEmail = acc.BR_Account_email__c;
        }
        
        String motivo;
        if (motivoNaoEnvio == null)
            motivo = '';
        else
            motivo = motivoNaoEnvio;
        
        enviarEmailPesquisa(senderEmail, recipientEmail, 'Caso fechado', recordId, sendPesquisa, motivo);
    }
    
    public class HistoricoCaso
    {
        public HistoricoCaso(DateTime dataCriacao, string criadoPor, string campo, object valorAntigo, object novoValor)
        {
            this.DataCriacao = dataCriacao;
            this.CriadoPor = criadoPor;
            this.Campo = campo;
            this.ValorAntigo = valorAntigo;
            this.NovoValor = novoValor;
        }
        
        @AuraEnabled
        public DateTime DataCriacao {get;set;}
        
        @AuraEnabled
        public string CriadoPor {get;set;}
        
        @AuraEnabled
        public string Campo {get;set;}
        
        @AuraEnabled
        public object ValorAntigo {get;set;}
        
        @AuraEnabled
        public object NovoValor {get;set;}
    }
    
    public class CustomException extends Exception {}
}