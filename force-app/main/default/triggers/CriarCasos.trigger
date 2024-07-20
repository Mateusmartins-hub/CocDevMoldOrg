trigger CriarCasos on Contract (before update) {
    List<Case> cases = new List<Case>();
    for (Contract sContract: Trigger.New) {
        if ((sContract.BR_Status_de_aprova_o_do_contrato__c == 'Aguardando criação do contrato') && (!sContract.BR_Casos_etapa_2_criados__c)) {
            Case c = new Case();
            Case c2 = new Case();
            RecordType casoRT = [select id,Name from RecordType where SobjectType='Case' and DeveloperName='CasosK12' Limit 1];
            Group fila1 = [SELECT Id FROM Group WHERE DeveloperName = 'Gestao_Contratos' and Type = 'Queue'];
            Group fila2 = [SELECT Id FROM Group WHERE DeveloperName = 'Credito_e_Cobranca' and Type = 'Queue'];
            
            c.Subject = 'Análise de cadastro para novo contrato';
            c.Type = 'Cadastro';
            c.BR_Contrato__c = sContract.Id ;
            c.RecordTypeId = casoRT.id;    
            c.BR_Grupo_Solucionador__c = 'Gestao de Contratos';
            //c.Subtipo__c = 'Solicitação de cadastro';
            c.OwnerId = fila1.Id;
            c.AccountId = sContract.AccountId;
            c.Motivo__c = 'Solicitação';
            c.Origin = 'Contrato';
            c.Description = 'Caso criado automaticamente através da solicitação de Contrato para que seja analisada a necessidade de criação/Alteração de cadastro.';
            
            cases.add(c);

            c2.Subject = 'Análise de Crédito para novo contrato';
            c2.Type = 'Crédito e Cobrança';
            c2.BR_Contrato__c = sContract.Id ;
            c2.RecordTypeId = casoRT.id;
            c2.BR_Grupo_Solucionador__c = 'Crédito e Cobrança';
            //c2.Subtipo__c = 'Análise de Crédito';
            c2.Detalhamento_del__c = 'Envio de Documentação';
            c2.OwnerId = fila2.Id;
            c2.AccountId = sContract.AccountId;
            c2.Motivo__c = 'Solicitação';
            c2.Origin = 'Contrato';
            c2.Description = 'Caso criado automaticamente através da solicitação de Contrato para que seja realizada a Análise de Crédito';
            cases.add(c2);
            
            sContract.BR_Casos_etapa_2_criados__c = true;
        }
        insert cases;    
    }
}