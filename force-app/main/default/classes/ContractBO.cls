public class ContractBO {
    
    public static void ativacaoContrato(List<Contract> contratos) {
        try {
            List<Opportunity> oportunidadesUpdate = new List<Opportunity>();
            List<Case> casosInsert = new List<Case>();
            List<Task> tarefasInsert = new List<Task>();
            
            Set<Id> oppsIds = new Set<Id>();
            for(Contract cont : contratos) {
                if(cont.BR_Oportunidade_do_contrato__c != null)
                    oppsIds.add(cont.BR_Oportunidade_do_contrato__c);
            }
            
            Map<Id, Opportunity> mapOportunidades = new Map<Id, Opportunity>([SELECT Id, StageName FROM Opportunity WHERE Id IN: oppsIds]);
            
            for(Contract contrato : contratos) {
                if(contrato.BR_Status_de_aprova_o_do_contrato__c  == 'Aprovado' && contrato.Status == 'Activated') {
                    if(mapOportunidades.containsKey(contrato.BR_Oportunidade_do_contrato__c)) {
                        mapOportunidades.get(contrato.BR_Oportunidade_do_contrato__c).StageName = 'Contrato Finalizado'; 
                        oportunidadesUpdate.add(mapOportunidades.get(contrato.BR_Oportunidade_do_contrato__c));
                    }
                }else if(contrato.BR_RecebidoConferido__c && contrato.BR_Status_de_aprova_o_do_contrato__c	== 'Aguardando finalização do processo') {
                    System.debug('Passou aqui: '+ contrato.BR_RecebidoConferido__c);
                    //Criar Casos K12
                    Case casoConsultoriaInterna = criarCasoConsultoriaInterna(contrato);               
                    Case casoPedagogia = criarCasoPedagogia(contrato);
                    Case casoCTE = criarCasoCTE(contrato);
                    Task tarefa = criarTarefa(contrato); 
                    
                    casosInsert.add(casoConsultoriaInterna);                   
                    casosInsert.add(casoPedagogia);
                    casosInsert.add(casoCTE);                  
                    tarefasInsert.add(tarefa);
                }
            }
            
            if(oportunidadesUpdate.size() > 0)
                update oportunidadesUpdate;
            
            if(casosInsert.size() > 0)
                insert casosInsert;
            
            if(tarefasInsert.size() > 0)
                insert tarefasInsert;
            
        }catch(Exception e) {
            throw e;
        }
    }
    
    private static Task criarTarefa(Contract contrato) {
        Task tarefa = new Task();
        
        tarefa.RecordtypeId =  Schema.SObjectType.Task.getRecordTypeInfosByName().get('Tarefa Padrão').getRecordTypeId();
        tarefa.OwnerId = UserInfo.getUserId();
        tarefa.WhatId = contrato.Id; 
        //tarefa.OwnerId = UserDAO.getUserByName(AtribuicaoSupervisaoCasos__c.getInstance().NomeUsuario__c).Id;
        tarefa.Subject = 'Cadastro';
        tarefa.Priority = 'Normal';
        tarefa.ActivityDate = System.today() + 2;
        tarefa.Description = 'Favor cadastrar condições comerciais conforme análise do contrato';
        System.debug('Nova Tarefe: '+ tarefa);
        return tarefa;
    }
    
    private static Case criarCasoConsultoriaInterna(Contract contrato) {
        Case caso = new Case();
        
        //caso.BusinessHoursId = '01md0000000Ckil';
        caso.AccountId = contrato.AccountId;
        caso.BR_Oportunidade__c = contrato.BR_Oportunidade_do_contrato__c;
        caso.Description = 'Favor fazer o primeiro contato de Boas Vindas com o nosso novo Parceiro.';
        caso.Reason = 'Solicitação';
        caso.RecordTypeId = [SELECT Id FROM RecordType WHERE Name = 'Padrão' AND sObjectType = 'Case'].Id;
        //caso.Resumo__c = 'Novo Parceiro - Cadastro no Passaporte';
        caso.Status = 'Novo';
        caso.Subject = 'Novo Parceiro - Boas Vindas';
        caso.Tipo__c = 'Serviço COC';
        caso.Subtipo__c = 'Atendimento';
        caso.Detalhamento__c = 'Atendimento';
        caso.Detalhamento2__c = '';
        caso.OrdemGrupoSolucionador__c = 0;
        caso.GrupoSolucionador__c = 'Consultoria Interna';
        
        system.debug('Novo Caso Consultoria Interna: ' + caso);
        return caso;
    }
    
    
    private static Case criarCasoPedagogia(Contract contrato) {
        Case caso = new Case();
        
        //caso.BusinessHoursId = '01md0000000Ckil';
        caso.AccountId = contrato.AccountId;
        caso.BR_Oportunidade__c = contrato.BR_Oportunidade_do_contrato__c;
        caso.Description = 'Favor entrar em contato com o parceiro para agendar a implantação.';
        caso.Reason = 'Solicitação';
        caso.RecordTypeId = [SELECT Id FROM RecordType WHERE Name = 'Padrão' AND sObjectType = 'Case'].Id;
        //caso.Resumo__c = 'Implantação Pedagógica.';
        caso.Status = 'Novo';
        caso.Subject = 'Novo Parceiro - Implantação Pedagógica';
        caso.Tipo__c = 'Serviço COC';
        caso.Subtipo__c = 'Atendimento';
        caso.Detalhamento__c = 'Atendimento';
        caso.Detalhamento2__c = '';
        caso.OrdemGrupoSolucionador__c = 0;
        caso.GrupoSolucionador__c = 'Consultoria Pedagógica';
        system.debug('Novo Caso Consultoria Pedagogica: ' + caso);
        return caso;
    }
    private static Case criarCasoCTE(Contract contrato) {
        Case caso = new Case();
        
        //caso.BusinessHoursId = '01md0000000Ckil';
        caso.AccountId = contrato.AccountId;
        caso.BR_Oportunidade__c = contrato.BR_Oportunidade_do_contrato__c;
        caso.Description = 'Favor cadastrar o Parceiro no Passaporte. Após cadastro, direcionar o Caso à fila do Customer Care com as informações cadastradas.';
        caso.Reason = 'Solicitação';
        caso.RecordTypeId = [SELECT Id FROM RecordType WHERE Name = 'Padrão' AND sObjectType = 'Case'].Id;
        //caso.Resumo__c = 'Cadastro no Passaporte.';
        caso.Status = 'Novo';
        caso.Subject = 'Novo Parceiro - Cadastro no Passaporte';
        caso.Tipo__c = 'Serviço COC';
        caso.Subtipo__c = 'Atendimento';
        caso.Detalhamento__c = 'Atendimento';
        caso.Detalhamento2__c = 'Cadastro de Escola Parceira';
        caso.OrdemGrupoSolucionador__c = 0;
        caso.GrupoSolucionador__c = 'CTE - Suporte e Operação';
        system.debug('Novo Caso CTE: ' + caso);
        return caso;
    }
    
    public static void validacaoContratoCF(List<Contract> contratos, Map<Id, Contract> contratosOld ){
        
        
        String uProfileId = UserInfo.getProfileId();
        Profile profile = [select Name from profile where id =: uProfileId limit 1];
        System.debug('Profile NAME IS '+ profile.Name);
        
        Set<Id> OwnerIds = new Set<Id>();
        
        for(Contract contrato : contratos) {
            
            System.debug('Contract NAME IS '+ contrato.Name);
            
            if(contrato.Status == 'Contrato Cadastrado' && (profile.Name != 'Brazil Global' && profile.Name != 'System Administrator' )){
                
                contrato.addError('Não é possível editar Contrato CF no Status Contrato Cadastrado. Somente usuários com o perfil Brazil Global e Administrador podem editar um contrato neste Status.');
            }
            
            if(contrato.SAP_Contrato_cadastrado__c == true && (
                contrato.Status == 'Informações do Contrato' || 
                contrato.Status == 'Validação Cadastro'      || 
                contrato.Status ==  'Em assinatura')){
                    
                contrato.addError('Atenção! Estando nas Fases Informações do Contrato, Validação Cadastro e Em assinatura, o campo checkbox "Contrato Cadastrado" não poderá ser selecionado.');
            }
            
            if(contrato.Status == 'Contrato Assinado' && contrato.SAP_Contrato_cadastrado__c == True){
                
                contrato.Status =  'Contrato Cadastrado';
            }
            
            if(contrato.Status == 'Contrato Cadastrado' && contrato.SAP_Contrato_cadastrado__c == False){
                
                contrato.Status =  'Contrato Assinado';
            }
            
            Contract oldContract = contratosOld.get(contrato.Id);
            
            System.debug('OwnerId old is '+oldContract.OwnerId);
            System.debug('OwnerId new is '+contrato.OwnerId);
            
            
            if(contrato.OwnerId != oldContract.OwnerId){
                ownerIds.add(contrato.OwnerId);
            }
            
        }
        
        Map<Id, User> ownerMap = new Map<Id, User>([Select id, Profile.Name from User where id IN :ownerIds]);
        for(Contract contrato : contratos) {
            if(contrato.Status == 'Informações do Contrato'){
                if(ownerMap.containsKey(contrato.OwnerId)){
                    if(ownerMap.get(contrato.OwnerId).Profile.Name == 'Financeiro'){
                        contrato.Status = 'Validação Cadastro';
                    }
                }                
            }else if(contrato.Status == 'Validação Cadastro'){
                if(ownerMap.containsKey(contrato.OwnerId)){
                    if(ownerMap.get(contrato.OwnerId).Profile.Name != 'Financeiro'){
                        contrato.Status = 'Informações do Contrato';
                    }
                }  
            }            
        }
       
  	}
}