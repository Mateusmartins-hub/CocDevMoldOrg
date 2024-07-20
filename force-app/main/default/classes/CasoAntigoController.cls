public with sharing class CasoAntigoController {

    @AuraEnabled
    public static Boolean isClassic() {
        return UserInfo.getUiThemeDisplayed() != 'Theme4d';
    }

    @AuraEnabled 
    public static Map<String, Map<String, Boolean>> getOldCaseFields() {
        Map<String, Map<String, Boolean>> mapRetorno = new Map<String, Map<String, Boolean>>();
        LayoutCaso__c layoutPorGrupo = LayoutCasoDAO.BuscarLayoutCasoAntigo();
        
        if(layoutPorGrupo != null) {
            for(SessaoLayoutCaso__c sessao : layoutPorGrupo.SessoesLayoutCaso__r) {
                mapRetorno.put(sessao.Name, new Map<String, Boolean>());
                
                if(sessao.CamposSessao__c != null && String.isNotBlank(sessao.CamposSessao__c))
                    for(String campo : sessao.CamposSessao__c.split(';'))
                    mapRetorno.get(sessao.Name).put(campo, false);
            }
        }
        
        return mapRetorno;
    }
    
    @AuraEnabled
    public static Boolean verificaUsuarioGrupo (String idCaso) {
        try{
            String customerCare = '%Customer Care%';
            String Adm = '%Administrador do sistema%';
            Map<Id, Profile> perfisIds =  new Map<Id, Profile>([SELECT Id FROM Profile WHERE Name LIKE: customerCare OR Name LIKE: Adm]);
            
            if(perfisIds.containsKey(UserInfo.getProfileId()))
                return true;
            
            return CaseAcceptClass.validateOneCase([SELECT Id, OwnerId FROM Case WHERE Id =: idCaso]);
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
            
            caso.Status = 'Closed';
            update caso;
            return 'FECHADO';
        }catch(Exception e){
            throw e;
        }
    }
    
    @AuraEnabled
    public static String cancelarCaso (String idCaso) {
       try{
           Case caso = CaseDAO.getCaseById(idCaso); 
           String customerCare = '%Customer Care%';
           Map<Id, Profile> perfisIds =  new Map<Id, Profile>([SELECT Id FROM Profile WHERE Name LIKE: customerCare]);
           
           if(perfisIds.keySet().contains(UserInfo.getProfileId())) {
               caso.Status = 'Cancelado';
               update caso;
               return 'CANCELADO';
           }else{
               return 'SEMPERMISSAO';
           }
        }catch(Exception e){
            throw e;
        }
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
                                LastActivityDate, Caso__c, ClosedDate__c, SLAUtilizado__c, GrupoSolucionador__c, GrupoSolucionador__r.Id, NomeGrupoSolucionador__c, SLA__c, 
                                DataAbertura__c, SLAHoras__c, SLAUtilizadoHoras__c, SLARetomado__c, FarolSLA__c, SaldoSLAMinutos__c,  
                                SaldoSLAHoras__c, SLAEstourado__c FROM SLACaso__c WHERE Caso__c =: casoId ORDER BY CreatedDate DESC LIMIT 5];
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
    public static void salvarInformacoes(String informacoes) {
        List<InformacaoObservador> listInfos = (List<InformacaoObservador>) JSON.deserialize(informacoes, List<InformacaoObservador>.class);
        List<InformacoesObservador__c> listInfosInsert = new List<InformacoesObservador__c>();
        
        for(InformacaoObservador info : listInfos) {
            InformacoesObservador__c infoInsert = new InformacoesObservador__c();
            
            infoInsert.Observador__c = info.observador;
            infoInsert.Informacao__c = info.informacao;
            infoInsert.Caso__c       = info.casoId;
            
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
    public static User getUser(String idUser) {
            return [SELECT Id, Name FROM User WHERE Id =: idUser];
    }
    
    @AuraEnabled 
    public static List<InformacoesObservador__c> getObservadores(String idCaso) {
        if(idCaso == null)
            return null; 
        
        return [SELECT Id, Informacao__c, Observador__c, Observador__r.Name, CreatedBy.Name FROM InformacoesObservador__c WHERE Caso__c =: idCaso ORDER BY CreatedDate DESC];
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
}