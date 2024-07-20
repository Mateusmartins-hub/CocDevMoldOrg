trigger TrgQuoteLineItem on QuoteLineItem (after insert, after update, after delete) {
    List<Quote> quoteListToUpdate = new List<Quote>();
    Set<Id> quotesIds = new Set<Id>();
    String RecordTypeIdGuarda_chuva =  Schema.SObjectType.Quote.getRecordTypeInfosByDeveloperName().get('Guarda_Chuva').getRecordTypeId();
     
    
    if (Trigger.isInsert || Trigger.isUpdate) {
        // Find all Quotes that must be updated on a insert or update
        for(QuoteLineItem lineItem : Trigger.New){
            quotesIds.add(lineItem.QuoteId);
        }

    }else if (Trigger.isDelete) {
        // Find all Quotes that must be updated on a deletion
        for(QuoteLineItem lineItem : Trigger.Old){
            quotesIds.add(lineItem.QuoteId);
        }

    }       
    
    // Returns all Quotes and related LineItems that were triggered 
    List<quote> lstQuotesWithLineItems = [SELECT Id, RecordTypeId, N_Alunos_Sistemas_EI__c, N_Alunos_Sistemas_EF1__c, N_Alunos_Sistemas_EF2__c, N_Alunos_Sistemas_EM__c,
                                                 N_Alunos_Sistemas_PV__c, N_Alunos_Mentes_EF1__c, N_Alunos_Mentes_EF2__c, N_Alunos_Idiomas_EI__c,
                                                 N_Alunos_Idiomas_EF1__c, N_Alunos_Idiomas_EF2__c, N_Alunos_Idiomas_EM__c, Idiomas_Valor_Bruto_Idiomas__c, 
                                          		 Mentes_Valor_Bruto__c, Idiomas_Numero_de_alunos__c, Mentes_Numero_de_alunos__c, Sistemas_Numero_de_alunos__c,
                                                 Sistemas_Valor_Bruto__c, Sistemas_Desconto_Ano_1__c, Sistemas_Desconto_Ano_2__c,Sistemas_Desconto_Ano_3__c, 
                                          		 Sistemas_Desconto_Ano_4__c, Sistemas_Desconto_Ano_5__c,Sistemas_Condicao_comercial__c,
                                          		 Resumo_Valor_total_liquido__c,Sistema_de_ensino__c,Regiao_do_pais__c,Resumo_Novo_cluster__c,
                                          		 Mentes_Condicao_comercial__c,Mentes_Desconto_Ano_1__c, Mentes_Desconto_Ano_2__c,Mentes_Desconto_Ano_3__c,
                                          		 Idiomas_Condicao_comercial__c,Idiomas_Desconto_Ano_1__c, Idiomas_Desconto_Ano_2__c,Idiomas_Desconto_Ano_3__c,
                                                (SELECT Id,Product2.RecordType.Name,Product2.Tipo__c,Product2.BR_segmento__c,Quantity,Subtotal,TotalPrice FROM QuoteLineItems)
                                          FROM Quote
                                          WHERE Id IN :quotesIds];

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
    
    for(Quote q : lstQuotesWithLineItems){
        if(recordTypeIdGuarda_chuva == q.RecordTypeId){
            System.debug('RECORTYPE DO QUOTE CORRETO GUARDA CHUVA '+q.RecordTypeId);                
        
            // Atualiza campos de condição comercial de Sistemas, Mentes e Idiomas e Identifica novo Cluster quando Sistema de ensino está selecionado
            q = QuoteFieldUpdate.updateCommercialConditionsAndCluster(quoteRules,quoteRulesMentes,quoteRulesIdiomas,q);
            
            List<QuoteLineItem> lstOfQuoteLineItems = q.QuoteLineItems;
            q.N_Alunos_Sistemas_EI__c = 0;
            q.N_Alunos_Sistemas_EF1__c = 0;
            q.N_Alunos_Sistemas_EF2__c = 0;
            q.N_Alunos_Sistemas_EM__c = 0;
            q.N_Alunos_Sistemas_PV__c = 0;
            q.N_Alunos_Mentes_EF1__c = 0;
            q.N_Alunos_Mentes_EF2__c = 0;
            q.N_Alunos_Idiomas_EI__c = 0;
            q.N_Alunos_Idiomas_EF1__c = 0;
            q.N_Alunos_Idiomas_EF2__c = 0;
            q.N_Alunos_Idiomas_EM__c = 0;
            q.Sistemas_Numero_de_alunos__c = 0;
            q.Mentes_Numero_de_alunos__c = 0;
            q.Idiomas_Numero_de_alunos__c = 0;
            q.Sistemas_Valor_Bruto__c = 0;
            q.Mentes_Valor_Bruto__c = 0;
            q.Idiomas_Valor_Bruto_Idiomas__c = 0;
            
            for(QuoteLineItem lineItem : lstOfQuoteLineItems){

                System.debug('lineItem.Product2.BR_segmento__c: ' + lineItem.Product2.BR_segmento__c);
                System.debug('lineItem.Product2.RecordType.Name: ' + lineItem.Product2.RecordType.Name);
                System.debug('lineItem.Product2.Tipo__c: ' + lineItem.Product2.Tipo__c);

                if(lineItem.Product2.Tipo__c == 'Principal'){
                    if( lineItem.Product2.RecordType.Name == 'COC' || lineItem.Product2.RecordType.Name == 'Dom Bosco' ){
                        q.Sistemas_Numero_de_alunos__c += lineItem.Quantity;
                        q.Sistemas_Valor_Bruto__c += lineItem.Subtotal;
                        if(lineItem.Product2.BR_segmento__c == 'EI'){
                            q.N_Alunos_Sistemas_EI__c += lineItem.Quantity;
                        }else if(lineItem.Product2.BR_segmento__c == 'EF1'){
                            q.N_Alunos_Sistemas_EF1__c += lineItem.Quantity;
                        }else if(lineItem.Product2.BR_segmento__c == 'EF2'){
                            q.N_Alunos_Sistemas_EF2__c += lineItem.Quantity;
                        }else if(lineItem.Product2.BR_segmento__c == 'EM'){
                            q.N_Alunos_Sistemas_EM__c += lineItem.Quantity;
                        }else if(lineItem.Product2.BR_segmento__c == 'PV'){
                            q.N_Alunos_Sistemas_PV__c += lineItem.Quantity;
                        }
                    }else if(lineItem.Product2.RecordType.Name == 'Mentes'){
                        System.debug('lineItem.Quantity Mentes ' + lineItem.Quantity);
                        q.Mentes_Numero_de_alunos__c += lineItem.Quantity;
                        q.Mentes_Valor_Bruto__c += lineItem.Subtotal;
                        if(lineItem.Product2.BR_segmento__c == 'EF1'){
                            q.N_Alunos_Mentes_EF1__c += lineItem.Quantity;
                        }else if(lineItem.Product2.BR_segmento__c == 'EF2'){
                            q.N_Alunos_Mentes_EF2__c += lineItem.Quantity; 
                        }
                    }else if(lineItem.Product2.RecordType.Name == 'Idiomas'){
                        System.debug('lineItem.Quantity Mentes ' + lineItem.Quantity);
                        q.Idiomas_Numero_de_alunos__c += lineItem.Quantity; 
                        q.Idiomas_Valor_Bruto_Idiomas__c += lineItem.Subtotal;
                        if(lineItem.Product2.BR_segmento__c == 'EI'){
                            q.N_Alunos_Idiomas_EI__c += lineItem.Quantity;
                        }else if(lineItem.Product2.BR_segmento__c == 'EF1'){
                            q.N_Alunos_Idiomas_EF1__c += lineItem.Quantity;
                        }else if(lineItem.Product2.BR_segmento__c == 'EF2'){
                            q.N_Alunos_Idiomas_EF2__c += lineItem.Quantity;
                        }else if(lineItem.Product2.BR_segmento__c == 'EM'){
                            q.N_Alunos_Idiomas_EM__c += lineItem.Quantity;
                        }
                    }
                }
            }            
            quoteListToUpdate.add(q);
        }
    }

    if (quoteListToUpdate.size() > 0) {
        update quoteListToUpdate;
    } 
  
}