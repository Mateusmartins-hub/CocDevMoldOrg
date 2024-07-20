@isTest(SeeAllData=false)
private class ContatosCompromissoTest {

    static testMethod void ContatosCompromissoPage() {
    	Account conta = new Account();
    	conta.RecordTypeId = RecordTypeUtil.getInstance().getRecordTypePorNome('Account', 'Pessoa Física').getRecordTypeId();
		conta.Name = 'Teste Validação';
		conta.BR_Approval_status__c = 'Em elaboração';
		conta.BR_Funcao__c = 'Professor';
		conta.BR_Gender__c = 'MASCULINO';
		conta.BR_Birthdate__c = '11/01/1988';
		conta.BR_LinhaDeNegocio__c = 'Educação Básica';
		conta.Phone = '011959430222';
		conta.BR_Account_email__c = 'teste@validacao.com';
		conta.BR_Bairro__c = 'Teste';
		conta.BR_ShippingAddressComplement__c = 'N/A';
    	conta.BR_CPF__c = '030.363.876-17';
    	conta.Phone = '0000-0000';
    	insert conta;
    	
    	Contact contato = new Contact();
		contato.LastName = 'Contato Teste';
		contato.BR_CPF__c = '43335427823';
		contato.Phone = '01197877788';
		contato.Email = 'teste@validacao.com';
		contato.Fun_o__c = 'Coordenador Pedagógico';
		contato.AccountId = conta.Id;
    	contato.BR_CPF__c = '030.363.876-17';
    	contato.Phone = '0000-0000';
    	insert contato;
    	
    	Account_Contact__c ac = new Account_Contact__c(Account__c=conta.Id, Contact__c=contato.Id);
    	ac.CPF__c = '030.363.876-17';
    	ac.Email__c = 'teste@teste.com';
    	ac.Telefone_1__c = '0000-0000';
    	insert ac;
    	
        Test.startTest();
        
        Pagereference pg = Page.ContatosCompromisso;
		Test.setCurrentPage( pg );
        
        List<Account_Contact__c> result = [SELECT Id, Name, Contact__c, Contact__r.Name, Account__c FROM Account_Contact__c
    				WHERE BR_Inactive__c = false limit 1];
        
        ApexPages.currentPage().getParameters().put( 'accountId', result[0].Account__c );
        ApexPages.currentPage().getParameters().put( 'eventId', createEventTest( result[0].Account__c ) );
        
        ContatosCompromissoController contatos = new ContatosCompromissoController();
        contatos.execute();

        contatos.compromissos.nameQuery = '';
        contatos.pesquisar();

        contatos.compromissos.nameQuery = 'test';
        contatos.pesquisar();

        contatos.salvar();
        contatos.voltar();
        
        Boolean hasNext = contatos.compromissos.hasNext;
        Boolean hasPrevious = contatos.compromissos.hasPrevious;
        Integer pageNumber = contatos.compromissos.pageNumber;
        contatos.compromissos.first();
        contatos.compromissos.last();
        contatos.compromissos.previous();
        contatos.compromissos.next();
        
        Test.stopTest();
    }
    
    private static String createEventTest( String accountId ) {
    	Event event = new Event();
		event.BR_Create_Audit__c = true;
		event.BR_Source_Visit__c = 'Planejamento';
		event.BR_Tipo_da_Visita__c = 'Divulgação';
		event.BR_Visita_Realizada__c = true;
		event.Description = 'Teste';
		event.StartDateTime = Datetime.now();
		event.EndDateTime = Datetime.now();
		event.WhatId = accountId;
		
		insert event;
		return event.Id;
    }
}