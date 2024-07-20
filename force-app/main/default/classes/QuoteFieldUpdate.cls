public class QuoteFieldUpdate {
    public static final Id RECORD_TYPE_COTACAO_SETOR_PUBLICO = Schema.SObjectType.Quote.getRecordTypeInfosByDeveloperName().get('SetorPublico').getRecordTypeId();
    public static final Id RECORD_TYPE_COTACAO_EXPANSAO_SKILL_ED = Schema.SObjectType.Quote.getRecordTypeInfosByDeveloperName().get('ExpansaoSkillEd').getRecordTypeId();
    public static final Id RECORD_TYPE_OPP_VENDAS_SETOR_PRIVADO = Schema.SObjectType.Opportunity.getRecordTypeInfosByDeveloperName().get('OportunidadeDeVendasSetorPrivado').getRecordTypeId();

    public static void updateManagerField(List<Quote> lstQuotes) {
        List<String> usersToUpdate = new List<String>();
        for (Quote qt : lstQuotes) {
            usersToUpdate.add(qt.CreatedById);
        }

        List<User> lstUsers = UserDAO.getListUserByIdsUsers(usersToUpdate);
        Map<Id, Id> setUsersId = new Map<Id, Id>();
        for (User usr : lstUsers) {
            setUsersId.put(usr.Id, usr.ManagerId);
        }

        List<Quote> quotesToUpdate = new List<Quote>();
        for (Quote qt : lstQuotes) {
            if (setUsersId.containsKey(qt.CreatedById)) {
                Quote newQuote = qt.clone(true, true);
                newQuote.Approver_1__c = setUsersId.get(qt.CreatedById);
                quotesToUpdate.add(newQuote);
            }	
        }

        update quotesToUpdate;
    }

    public static void syncOppAfterApproval(Map<Id, Quote> mapOldQuotes,  List<Quote> lstQuotes) {        
        List<Quote> quotesToUpdate = new List<Quote>(); 
        for (Quote qt : lstQuotes) { 
            if (qt.Aprovacao_interna_aceita__c && !mapOldQuotes.get(qt.Id).Aprovacao_interna_aceita__c && qt.RecordTypeId != RECORD_TYPE_COTACAO_SETOR_PUBLICO) {
                quotesToUpdate.add(qt);                
            }
        }
		
        for (Quote qt : quotesToUpdate) {
            if (!Test.isRunningTest()) syncOpp(qt.OpportunityId, qt.Id);
        }   
    }

    @future
    public static void syncOpp(Id oppId, Id quoteId) {
        Opportunity opp = [SELECT RecordType.Name, RecordTypeId, CotacaoGerada__c, AmostraFisicaEnviada__c, StageName, Probability, AccountId, SyncedQuoteId FROM opportunity WHERE Id = :oppId];
        /* Account acc = [SELECT Phone From Account WHERE Id = :opp.AccountId LIMIT 1];
if (acc.Phone == null) {
acc.Phone = '1';
update acc;
} */
        if(opp.RecordTypeId != RECORD_TYPE_OPP_VENDAS_SETOR_PRIVADO ){
            opp.StageName = 'Elaborando Contrato'; 
        }
            opp.CotacaoGerada__c = true; 
            opp.AmostraFisicaEnviada__c = true;
            opp.Probability = 91;
            opp.SyncedQuoteId = quoteId; update opp;
            
            Quote qt = [SELECT Id, Status FROM Quote WHERE Id =: quoteId]; qt.Status = 'Sincronizado com a oportunidade';
            update qt;
        
    }
    
    public static void updateNameField(List<Quote> lstQuotes) {
        String RecordTypeIdGuarda_chuva =  Schema.SObjectType.Quote.getRecordTypeInfosByDeveloperName().get('Guarda_Chuva').getRecordTypeId();
        String RecordTypeIdFranquias =  Schema.SObjectType.Quote.getRecordTypeInfosByDeveloperName().get('Franquias').getRecordTypeId();
        
        Set<Id> opsIds = new Set<Id>();
        for(Quote qt : lstQuotes) {
            opsIds.add(qt.OpportunityId);
        }
        Map<Id, Opportunity> mapOpp = new Map<Id, Opportunity>([SELECT Id, Name FROM Opportunity WHERE Id IN: opsIds]);
		String name = '';
        for(Quote qt : lstQuotes) {
            if(qt.RecordTypeId != RecordTypeIdGuarda_chuva && qt.RecordTypeId != RecordTypeIdFranquias){
                name = 'COT - ' + mapOpp.get(qt.OpportunityId).Name + ' - ' + qt.QuoteNumber;
            }else{
                name = qt.Name;
            }
            qt.Name = name;
        }
    }

    public static void updatePrizeField(List<Quote> lstQuotes) {
        VencimentoCotacao__c venc = VencimentoCotacao__c.getOrgDefaults();

        for (Quote qt : lstQuotes) {
            qt.ExpirationDate = System.today().addDays(Integer.valueOf(venc.Dias__c));
        }
    }

    public static void updateContratoFinalizado(Map<Id, Quote> mapOldQuotes, List<Quote> lstQuotes) {
        List<Quote> approvedQuotes = new List<Quote>();
        List<String> opps = new List<String>();
        for (Quote qt : lstQuotes) {
            if (qt.Aprovacao_interna_aceita__c && !mapOldQuotes.get(qt.Id).Aprovacao_interna_aceita__c && qt.RecordTypeId == RECORD_TYPE_COTACAO_SETOR_PUBLICO) {
                approvedQuotes.add(qt); opps.add(qt.OpportunityId);
            }
        }

        List<Quote> quotesToUpdate = new List<Quote>();
        Map<Id, Id> quoteMap = new Map<Id, Id>();
        for (Quote qt : approvedQuotes) {
            Quote qtClone = qt.clone(true); qtClone.Status = 'Sincronizado com a oportunidade';
            quotesToUpdate.add(qtClone); quoteMap.put(qtClone.OpportunityId, qtClone.Id);
        }
		
        if(approvedQuotes.size() > 0) {
            update quotesToUpdate; syncQuote(quoteMap);
        }
    }

    @future
    public static void syncQuote(Map< Id, Id > mOppIdtoQuoteId) {
        List <Opportunity> lOppsToUpdate = [SELECT Id,SyncedQuoteId, CotacaoGerada__c, StageName FROM Opportunity WHERE Id in:mOppIdToQuoteId.keySet()];
        for (Opportunity opp : lOppsToUpdate) {
            opp.SyncedQuoteId = mOppIdToQuoteId.get(opp.Id); opp.CotacaoGerada__c = true;
            opp.BR_Modalidade_licitacao__c = 'Concorrência pública'; opp.StageName = 'Contrato finalizado';
        }
        
        update lOppsToUpdate;
    }
    
    public static void updateRecordType(List<Quote> lstQuotes) {
        List<Quote> quotes = new List<Quote>();
        List<String> opps = new List<String>();
        
        for (Quote qt : lstQuotes) {
            opps.add(qt.OpportunityId);
        }
        
        Map<Id, Opportunity> mapOpps;
        mapOpps = new Map<Id, Opportunity>(OpportunityDAO.getListOppById(opps));
        
        List<Pricebook2> pricebooks = [SELECT Id 
                                       FROM Pricebook2 
                                       WHERE Name = 'Expansão Skill.Ed.'];
        
        for (Quote qt : lstQuotes) {
            if (mapOpps.containsKey(qt.OpportunityId) && mapOpps.get(qt.OpportunityId).RecordTypeId == OpportunityStagesCheck.RECORD_TYPE_OPORTUNIDADE_SETOR_PUBLICO) {
                qt.RecordTypeId = RECORD_TYPE_COTACAO_SETOR_PUBLICO;
            }else if (mapOpps.containsKey(qt.OpportunityId) && mapOpps.get(qt.OpportunityId).RecordTypeId == OpportunityStagesCheck.RECORD_TYPE_OPORTUNIDADE_FRANQUIA_SKILL_ED) {
                qt.RecordTypeId = RECORD_TYPE_COTACAO_EXPANSAO_SKILL_ED;
                if(pricebooks.size() > 0)
                    qt.Pricebook2Id = pricebooks[0].Id;                
            }
        }
    }
    
    public static void createProducts(List<Quote> lstQuotes) {
        List<QuoteLineItem> quoteLineItems = new List<QuoteLineItem>();
        
        Map<Id, List<PricebookEntry>> mapPricebooksEntrys = new Map<Id, List<PricebookEntry>>();
        
        for(PricebookEntry pbE : [SELECT Id, Product2Id, UnitPrice FROM PricebookEntry WHERE Pricebook2.Name = 'Expansão Skill.Ed.']) {
            if(!mapPricebooksEntrys.containsKey(RECORD_TYPE_COTACAO_EXPANSAO_SKILL_ED))
                mapPricebooksEntrys.put(RECORD_TYPE_COTACAO_EXPANSAO_SKILL_ED, new List<PricebookEntry>());
            
            mapPricebooksEntrys.get(RECORD_TYPE_COTACAO_EXPANSAO_SKILL_ED).add(pbE);
        }
        
        for (Quote qt : lstQuotes) {
            if (qt.RecordTypeId == RECORD_TYPE_COTACAO_EXPANSAO_SKILL_ED) {
                if(mapPricebooksEntrys.containsKey(RECORD_TYPE_COTACAO_EXPANSAO_SKILL_ED)) {
                    for(PricebookEntry pbE : mapPricebooksEntrys.get(RECORD_TYPE_COTACAO_EXPANSAO_SKILL_ED)) {
                        QuoteLineItem i = new QuoteLineItem();
                        
                        i.QuoteId = qt.Id;
                        i.PricebookEntryId = pbE.Id;
                        i.Product2Id = pbE.Product2Id;
                        i.Quantity = 1;
                        i.UnitPrice = pbE.UnitPrice;
                        
                        quoteLineItems.add(i);
                    }
                }
            }
        }
        if(quoteLineItems.size() > 0)
        	insert quoteLineItems;
        
    }
    
    public static void updateQuotesAccordingToCommercialPolicies(List<Quote> lstNewQuotes) {
        String RecordTypeIdGuarda_chuva =  Schema.SObjectType.Quote.getRecordTypeInfosByDeveloperName().get('Guarda_Chuva').getRecordTypeId();
        
       
        Quote_Rules__mdt[] quoteRules = [SELECT Marca__c,Cluster__c, Faturamento__c,
                                            X1_Ano__c, X2_Ano__c, X3_Ano__c, X4_Ano__c, X5_Ano__c
                                    FROM Quote_Rules__mdt
                                    WHERE Marca__c IN ('Dom Bosco N/NE', 'Dom Bosco S/SE/CO', 'COC')
                                ORDER BY Faturamento__c desc];

        Quote_Rules__mdt[] quoteRulesMentes = [SELECT Qtd_Alunos__c, X1_Ano__c, X2_Ano__c, X3_Ano__c
                                                FROM Quote_Rules__mdt
                                                WHERE Marca__c = 'Mentes'
                                            ORDER BY Qtd_Alunos__c desc];
            
        Quote_Rules__mdt[] quoteRulesIdiomas = [SELECT Qtd_Alunos__c, X1_Ano__c, X2_Ano__c, X3_Ano__c
                                                FROM Quote_Rules__mdt
                                                WHERE Marca__c = 'Idiomas'
                                            ORDER BY Qtd_Alunos__c desc];
    
        for( Quote q : lstNewQuotes ){
            if(recordTypeIdGuarda_chuva == q.RecordTypeId){
                System.debug('RECORTYPE DO QUOTE CORRETO GUARDA CHUVA '+q.RecordTypeId);                
                q = updateCommercialConditionsAndCluster(quoteRules,quoteRulesMentes,quoteRulesIdiomas,q);
            }                    
        }
                
    }

    public static Quote updateCommercialConditionsAndCluster(Quote_Rules__mdt[] quoteRules, Quote_Rules__mdt[] quoteRulesMentes, Quote_Rules__mdt[] quoteRulesIdiomas, Quote q) {
        String brand = '';
        if(q.Sistema_de_ensino__c == 'Dom Bosco'){
            brand = q.Sistema_de_ensino__c +' '+ q.Regiao_do_pais__c;
        }else{
            brand = q.Sistema_de_ensino__c;
        }
        
        System.debug('QuoteRules:  '+quoteRules);
        System.debug('QuoteRulesMentes:  '+quoteRulesMentes);
        System.debug('QuoteRulesIdiomas:  '+quoteRulesIdiomas);
        System.debug('brand:  '+brand);
        
        // Calcula Sistemas_Condicao_comercial__c e Novo Cluster
        q.Resumo_Novo_cluster__c = '';
        q.Sistemas_Condicao_comercial__c = 'Ok';
        if(brand != ''){
            for(Quote_Rules__mdt quoteRuleItem : quoteRules){
                // Valor liquido da Quote é maior ou igual ao faturamento das faixas configuradas no metadado?
                // Se sim, É porque encontrou a faixa de valor no metadado e Deve aplicar as regras associadas a aquela faixa
                system.debug('BRAND/SISTEM DE ENSINO = '+brand  +' e quoteRuleItem.Marca__c -> ' +quoteRuleItem.Marca__c);
                if(quoteRuleItem.Marca__c == brand && q.Resumo_Valor_total_liquido__c >= quoteRuleItem.Faturamento__c){
                    q.Resumo_Novo_cluster__c = quoteRuleItem.Cluster__c;
                    //Call function to set condição comercial?
                    if(q.Sistemas_Desconto_Ano_1__c > quoteRuleItem.X1_Ano__c ||
                       q.Sistemas_Desconto_Ano_2__c > quoteRuleItem.X2_Ano__c ||
                       q.Sistemas_Desconto_Ano_3__c > quoteRuleItem.X3_Ano__c ||
                       q.Sistemas_Desconto_Ano_4__c > quoteRuleItem.X4_Ano__c ||
                       q.Sistemas_Desconto_Ano_5__c > quoteRuleItem.X5_Ano__c){
                           q.Sistemas_Condicao_comercial__c = 'Necessita Aprovação';	       
                       }
                    break;
                }
            }
        }
        
        // Calcula Mentes_Condicao_comercial__c e Idiomas_Condicao_comercial__c 
        q.Mentes_Condicao_comercial__c = 'Ok';
        q.Idiomas_Condicao_comercial__c = 'Ok';
        
        for(Quote_Rules__mdt quoteRuleItem : quoteRulesMentes){
            if(q.Mentes_Numero_de_alunos__c >= quoteRuleItem.Qtd_Alunos__c){
                if(q.Mentes_Desconto_Ano_1__c > quoteRuleItem.X1_Ano__c ||
                   q.Mentes_Desconto_Ano_2__c > quoteRuleItem.X2_Ano__c ||
                   q.Mentes_Desconto_Ano_3__c > quoteRuleItem.X3_Ano__c){
                       q.Mentes_Condicao_comercial__c = 'Necessita Aprovação';       
                   }	
                break;
            }
        }
        
        for(Quote_Rules__mdt quoteRuleItem : quoteRulesIdiomas){
            if(q.Idiomas_Numero_de_alunos__c >= quoteRuleItem.Qtd_Alunos__c){
                if(q.Idiomas_Desconto_Ano_1__c > quoteRuleItem.X1_Ano__c ||
                   q.Idiomas_Desconto_Ano_2__c > quoteRuleItem.X2_Ano__c ||
                   q.Idiomas_Desconto_Ano_3__c > quoteRuleItem.X3_Ano__c){
                       q.Idiomas_Condicao_comercial__c = 'Necessita Aprovação';       
                   }
                break;
            }
        }
        
        return q;
        
    }
        
}