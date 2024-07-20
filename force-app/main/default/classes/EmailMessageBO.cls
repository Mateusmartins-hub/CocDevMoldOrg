public without sharing class EmailMessageBO {
    
    public static void validarCasoFechado(List<EmailMessage> listEmail) {
        Set<Id> setIdCasos = new Set<Id>();
        Map<Id, EmailMessage> mapIdEmailCase = new Map<Id, EmailMessage>();
        
        for(EmailMessage email : listEmail) {
            setIdCasos.add(email.ParentId);
            mapIdEmailCase.put(email.ParentId, email);
        }
        
        List<Case> listCasos = CaseDAO.getCasesByIds(setIdCasos);
        Map<Id, Case> mapCasos = new Map<Id, Case>();
        
        Map<Id, Case> mapIdEmailCaseCloned = new Map<Id, Case>();
        
        for(Case caso : listCasos) {
            mapCasos.put(caso.Id, caso);
        }
        
        List<Case> casesUpdate = new List<Case>();
        for(EmailMessage email : listEmail) {
            if(mapCasos.containsKey(email.ParentId)) {
                Case caso = mapCasos.get(email.ParentId);
                if(caso.IsClosed && email.Incoming) {
                   /* Case casoC = caso.clone(false, true, false, false);
                    casoC.Origin = 'Email'; 
                    casoC.Status = 'Novo'; 
                    casoC.AceitoPor__c = null;
                    casoC.GrupoSolucionador__c = null;
                    caso.BR_Grupo_Solucionador__c = null;
                    casoC.OrdemGrupoSolucionador__c = 0;
					Trecho de codigo acima foi comentado e o novo
					bloco abaixo, agora passa Reabrir casos atravez de respostas de email do usuário
					atendendo a INC5990945*/
                    caso.Status = 'Reaberto';
                    caso.ReabertoEmail__c = true;
                    casesUpdate.add(caso);
                    mapIdEmailCaseCloned.put(email.ParentId, caso);
                }
            }
        }
        
        if(casesUpdate.size() > 0) {
            TriggerHandler.byPass('CaseTriggerHandler');
            update casesUpdate;
            TriggerHandler.clearBypass('CaseTriggerHandler'); 
        }
        
        for(EmailMessage email : listEmail) {
            if(mapIdEmailCaseCloned.containsKey(email.ParentId))
                email.ParentId = mapIdEmailCaseCloned.get(email.ParentId).Id;
        }
    }
    
    public static void popularCamposCaso(List<EmailMessage> listEmail) {
        AssignmentRule AR = [select id from AssignmentRule where SobjectType = 'Case' and Active = true limit 1];
        Database.DMLOptions dmlOpts = new Database.DMLOptions();
        dmlOpts.assignmentRuleHeader.assignmentRuleId= AR.id;
        
        Set<Id> setIdCasos = new Set<Id>();
        Map<Id,Case> mapCasos = new Map<Id, Case>();
        
        for(EmailMessage email : listEmail){
            setIdCasos.add(email.ParentId);
        }
        
        List<Case> listCasos = CaseDAO.getCasesByIds(setIdCasos);
        Set<Id> paramsIds = new Set<Id>();
        
        for(Case caso : listCasos){
            mapCasos.put(caso.Id, caso); 
            paramsIds.add(caso.ParametrizacaoCasos__c);
        }
        
        Map<String, DeParaEmailToCase__mdt> mapEmailsToCase = EmailsOuvidoriaDAO.mapearDeParaEmailCamposCaso();
        Map<Id, ParametrizacaoCasos__c> mapParams = new Map<Id, ParametrizacaoCasos__c>([SELECT Id, 
                                                                                         GrupoSolucionador1__c,
                                                                                         GrupoSolucionador2__c,
                                                                                         GrupoSolucionador3__c,
                                                                                         GrupoSolucionador4__c,
                                                                                         GrupoSolucionador5__c,
                                                                                         GrupoSolucionador6__c,
                                                                                         GrupoSolucionador7__c,
                                                                                         GrupoSolucionador8__c,
                                                                                         GrupoSolucionador9__c,
                                                                                         GrupoSolucionador10__c,
                                                                                         GrupoSolucionador11__c,
                                                                                         GrupoSolucionador12__c,
                                                                                         GrupoSolucionador13__c,
                                                                                         GrupoSolucionador14__c,
                                                                                         GrupoSolucionador15__c,
                                                                                         GrupoSolucionador16__c,
                                                                                         GrupoSolucionador17__c,
                                                                                         GrupoSolucionador18__c,
                                                                                         GrupoSolucionador19__c,
                                                                                         GrupoSolucionador20__c 
                                                                                         FROM ParametrizacaoCasos__c
                                                                                         WHERE Id IN: paramsIds]);
        
        Map<Id, Case> mapCasesUpdate = new Map<Id, Case>();
        
        for(EmailMessage email : listEmail){
            if(mapCasos.containsKey(email.ParentId)) {
                Case caso = mapCasos.get(email.ParentId);
                
                List<String> enderecos = new List<String>();
                
                if(email.ToAddress != null)
                    enderecos.addAll(email.ToAddress.split(';'));
                
                if(email.BccAddress != null)
                    enderecos.addAll(email.BccAddress.split(';'));
                
                if(email.CcAddress != null)
                    enderecos.addAll(email.CcAddress.split(';'));
                
                for(String endereco : enderecos) {
                    endereco = endereco.trim();
                    
                    if(mapParams.containsKey(caso.ParametrizacaoCasos__c)) {
                        if (mapEmailsToCase.containsKey(endereco)) {
                            for(Integer i = 1; i <= 20; i++) {
                                String grupoSolucionador = (String) mapParams.get(caso.ParametrizacaoCasos__c).get('GrupoSolucionador' + i + '__c');
                                
                                if(grupoSolucionador == mapEmailsToCase.get(endereco).GrupoSolucionadorEmail__c) {
                                    caso.MarcaAtendimento__c = mapEmailsToCase.get(endereco).Marca__c;
                                    caso.OrdemGrupoSolucionador__c = i;
                                    caso.GrupoSolucionador__c = grupoSolucionador;
                                    
                                    if(grupoSolucionador == 'Ouvidoria')
                                        caso.CasoOuvidoria__c = true;
                                }
                            }
                            
                            caso.setOptions(dmlOpts);
                            
                            mapCasesUpdate.put(caso.Id, caso);
                        }
                    }
                }
            }
        }
        
        TriggerHandler.bypass('CaseTriggerHandler');
        if(!mapCasesUpdate.isEmpty())
            update mapCasesUpdate.values();
        TriggerHandler.clearBypass('CaseTriggerHandler');
    }
        
    public static void validarCasoAguardandoCliente(List<EmailMessage> listEmail) {
        Set<Id> setIdCasos = new Set<Id>();
        Map<Id, EmailMessage> mapIdEmailCase = new Map<Id, EmailMessage>();
        
        for(EmailMessage email : listEmail) {
            setIdCasos.add(email.ParentId);
            mapIdEmailCase.put(email.ParentId, email);
        }
        
        List<Case> listCasos = CaseDAO.getCasesByIds(setIdCasos);
        Map<Id, Case> mapCasos = new Map<Id, Case>();
        
        Map<Id, Case> mapIdEmailCaseCloned = new Map<Id, Case>();
        
        for(Case caso : listCasos) {
            mapCasos.put(caso.Id, caso);
        }
        
        List<Case> casesUpdate = new List<Case>();
        
        for(EmailMessage email : listEmail) {
            if(mapCasos.containsKey(email.ParentId)) {
                Case caso = mapCasos.get(email.ParentId);
                
                if(caso.Status == 'Aguardando Cliente' && email.Incoming) {
                    caso.Status = 'Em execução'; casesUpdate.add(caso);
                }
            }
        }
        
        if(casesUpdate.size() > 0) {
            enviarEmailResponsaveis(casesUpdate); update casesUpdate;
        }
    }
    
    public static void enviarEmailResponsaveis(List<Case> casos) {
        OrgWideEmailAddress owea = [SELECT Id FROM OrgWideEmailAddress WHERE Address = 'p2d.educacao@yopmail.com' LIMIT 1];
        List<Messaging.SingleEmailMessage> listaEmails = new List<Messaging.SingleEmailMessage>();
        
        for(Case caso : casos) {
            if(caso.AceitoPor__c != null) {
                Messaging.SingleEmailMessage m = Messaging.renderStoredEmailTemplate([SELECT Id FROM EmailTemplate WHERE DeveloperName =: 'RespostaAguardandoCliente'][0].Id, caso.AceitoPor__c, caso.Id);
                m.setSaveAsActivity(false); listaEmails.add(m);    
            }
        }
        
        Messaging.sendEmail(listaEmails);
    }
}