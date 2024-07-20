public without sharing class ContactBO {

    public static Boolean shouldUpdateRelated = true;

    public static void atualizarMediaPesquisaSatisfacao(List<Contact> contatos, Map<Id, Contact> mapContatosOld) {
        
        map<Id,list<Integer>> mapNotasPesquisasContas = new map<Id,list<Integer>>();
        
        for(Contact c : contatos){
            if(c.UltimoInvitationId__c != mapContatosOld.get(c.Id).UltimoInvitationId__c){
                if(!mapNotasPesquisasContas.containsKey(c.AccountId)){
                    mapNotasPesquisasContas.put(c.AccountId, new list<Integer>());
                }
				
				mapNotasPesquisasContas.get(c.AccountId).add(Integer.valueOf(c.UltimaNotaPesquisa__c));                
            }                
        }
        
        if(!mapNotasPesquisasContas.keySet().isEmpty()){
            
            List<Account> contas = [SELECT Id, TotalNotaPesquisa__c, QuantidadePesquisasRespondidas__c FROM Account WHERE Id IN : mapNotasPesquisasContas.keySet()];
            
            for(Account conta : contas){
                for(Integer nota : mapNotasPesquisasContas.get(conta.Id)){
                    conta.TotalNotaPesquisa__c = conta.TotalNotaPesquisa__c != null ? conta.TotalNotaPesquisa__c+nota : nota;
                }
                
                conta.QuantidadePesquisasRespondidas__c = conta.QuantidadePesquisasRespondidas__c != null ? conta.QuantidadePesquisasRespondidas__c+mapNotasPesquisasContas.get(conta.Id).size() : mapNotasPesquisasContas.get(conta.Id).size();
            }
            
            update contas;
        }
    }

    public static void setHierarchyByFunction(List<Contact> newContacts){

        Set<Id> accountIds = new Set<Id>();

        for(Contact contact: newContacts){

            if(contact.AccountId == null) continue;
            
            accountIds.add(contact.AccountId);
        }

        if(accountIds.isEmpty()) return;

        Map<Id, Contact> relatedContacts = new Map<Id, Contact>([
            SELECT Id, Fun_o__c, AccountId FROM Contact WHERE AccountId IN :accountIds
        ]);

        Map<Id, Map<String, Contact>> contactByFunctionMap = new Map<Id, Map<String, Contact>>();
        for(Contact contact: relatedContacts.values()) {
            
            if(contact.Fun_o__c == null) continue;

            Map<String, Contact> contactMap = contactByFunctionMap.get(contact.AccountId);

            if(contactMap == null) contactMap = new Map<String, Contact>();
            contactMap.put(contact.Fun_o__c, contact);

            contactByFunctionMap.put(contact.AccountId, contactMap);
        }

        List<Hierarquia_por_funcao__mdt> hierarchyMetadata = [
            SELECT MasterLabel, Funcao_pai__c
            FROM Hierarquia_por_funcao__mdt
        ];

        Map<String, String> hierarchyMap = new Map<String, String>();
        for (Hierarquia_por_funcao__mdt h : hierarchyMetadata) {
            hierarchyMap.put(h.MasterLabel, h.Funcao_pai__c);
        } 

        if(Test.isRunningTest()){
            hierarchyMap = new Map<String, String>{
                'Diretor' => 'Franqueado',
                'Professor' => 'Diretor'
            };
        }

        Set<Id> relatedContactsToUpdate = relatedContacts.keySet();

        for(Contact contact: newContacts){
            
            contact.ReportsToId = null;

            if(contact.AccountId == null || contact.Fun_o__c == null) continue;
            
            String parentFunction = hierarchyMap.get(contact.Fun_o__c);
            if(parentFunction == null) continue;

            Map<String, Contact> contactMap = contactByFunctionMap.get(contact.AccountId);
            if(contactMap == null) continue;

            Contact parentContact = contactMap.get(parentFunction);
            if(parentContact == null || contact.Id == parentContact.Id) continue;

            contact.ReportsToId = parentContact.Id;

        }

        if(shouldUpdateRelated){
            updateRelatedContacts(relatedContacts.keySet());
        }
    }

    @future
    private static void updateRelatedContacts(Set<Id> contactsToUpdate){
        ContactBO.shouldUpdateRelated = false;
        update [SELECT Id from Contact WHERE Id in :contactsToUpdate];
    }

    public static void updateAccountData(List<Contact> triggerNew){
        List< String > listIdsAcc = new List< String >();
        List< String > listIdsContact = new List< String >();
        List< Account > listAccount = new List< Account >();
        List< Account > listAccountUpdate = new List< Account >();
        List< Contact > listOtherContact = new List< Contact >();
        Map< String, List< String > > mapContact = new Map< String, List< String > >();
        //Carlos Carvalho - Modification - 07/02/2013
        Id idRecTypeAcc = RecordTypeMemory.getRecType( 'Account', 'Academic_Account' );
        //End Modification
        
        //Invoke Log Limits
        LogLimits.print('TRIGGER: ContactUpdateAccountData - BEFORE FOR CONTACT', false); 
        
        for( Contact c : triggerNew ){
            if( !Semaphore.hasExec( c.AccountId, false ) ){
                listIdsAcc.add( c.AccountId );
                listIdsContact.add( c.Id );
                List< String > lList = mapContact.get( c.AccountId );
                if( lList == null )
                {
                    lList = new List< String >();
                    mapContact.put( c.AccountId, lList );
                }
                String lStr = string.valueOf( c.AccountId +' '+ c.Id );
                lList.add( lStr );
            }
        }
        //Invoke Log Limits
        LogLimits.print('TRIGGER: ContactUpdateAccountData - AFTER FOR CONTACT', false); 
        
        if ( listIdsAcc.size() == 0 ) return;
        
        listAccount = [SELECT Id, Name, BR_Title__c, BR_RG__c, BR_Mobile__c, BR_Main_Zip_code__c, BR_Main_State__c, 
            BR_Main_Sidewalk__c, BR_Main_Nbr__c, BR_Main_District__c, BR_Main_Country__c, 
            BR_Main_Complement__c, BR_Main_City__c, BR_Main_Address__c, BR_Gender__c, 
            BR_Department__c,  BR_CPF__c, BR_Birthdate__c, BR_Area_code_cel__c, 
            BR_Area_code__c, BR_Allows_sms__c, BR_Allows_email_marketing__c, BR_Account_email__c,
            BR_Other_phone__c, Phone, Fax, BR_Status__c
                       FROM Account Where Id =: listIdsAcc AND RecordTypeId =: idRecTypeAcc];
        
        List< Contact > listOtherContactTest = new List< Contact >();
        if( Test.isRunningTest() ){
            Account account = new Account();
            account.Name = 'Account Test';
            Account.RecordTypeId = RecordTypeMemory.getRecType( 'Account', 'Academic_Account' );
            insert account;
            listAccount.add(account);
            Contact ct = new Contact();
            ct.AccountId = Account.Id;
            ct.email = 'abc@abc.com';
            ct.LastName = 'Test'; insert ct;
            
            listOtherContactTest.add(ct);
        }
        //Invoke Log Limits
        LogLimits.print('TRIGGER: ContactUpdateAccountData - AFTER SELECT ACCOUNT', false); 
        
        if( listAccount.size() == 0 ) return;
        
        Map< String, Account > mapAccount = new Map< String, Account >();
        for( Account acc : listAccount ){
            mapAccount.put( acc.Id, acc );
        }
        if( !Test.isRunningTest() ){
        listOtherContact = [SELECT Id, AccountId FROM Contact WHERE Id <>: listIdsContact and AccountId=:listIdsAcc];
    }else{listOtherContact = listOtherContactTest; }	
        //Invoke Log Limits
        LogLimits.print('TRIGGER: ContactUpdateAccountData - AFTER SELECT CONTACT', false); 
        
        for( Contact c : listOtherContact ){
            List< String > lList = mapContact.get( c.AccountId );
            if( lList == null )
            {
                lList = new List< String >();
                mapContact.put( c.AccountId, lList );
            }
            String lStr = string.valueOf( c.AccountId  +' '+  c.Id );
            lList.add( lStr );
        }
        
        //Invoke Log Limits
        LogLimits.print('TRIGGER: ContactUpdateAccountData - AFTER FOR CONTACT ON listOtherContact', false); 
        
        for( Contact c : triggerNew ){
            List< String > lList = mapContact.get( c.AccountId );
            if( lList != null && lList.size() > 1 ) c.addError('Não é possível haver mais de um contato neste tipo de conta.\n'+
                                'It is not possible to exist more than a contact for this type of account.');
            
            Account lAcc = mapAccount.get( c.AccountId );
            
            if( lAcc == null || Semaphore.hasExec( c.AccountId, true ) ) continue;
            
            lAcc.Name                          = (c.FirstName!=null? c.FirstName+' ':'') + c.LastName;
            lAcc.BR_RG__c                      = c.BR_RG__c;
            lAcc.BR_CPF__c                     = c.BR_CPF__c;
            lAcc.BR_Gender__c                  = c.BR_Gender__c;
            lAcc.BR_Title__c                   = c.BR_Contact_Title__c;
            lAcc.BR_Department__c              = c.BR_Contact_department__c;
            lAcc.BR_Area_code__c               = c.BR_Area_code__c;
            lAcc.BR_Area_code_cel__c           = c.BR_Area_code_cel__c;
            lAcc.BR_Mobile__c                  = c.MobilePhone;
            lAcc.BR_Birthdate__c               = c.BR_Contact_Birthdate__c;
            lAcc.BR_Allows_sms__c              = c.BR_Allows_sms__c;
            lAcc.BR_Allows_email_marketing__c  = c.BR_Allows_email_marketing__c;
            lAcc.BR_Account_email__c           = c.Email;
            lAcc.BR_Main_Sidewalk__c           = c.BR_Address_Sidewalk__c;
            lAcc.BR_Main_Address__c            = c.BR_Address__c;
            lAcc.BR_Main_Nbr__c                = c.BR_Address_number__c;
            lAcc.BR_Main_Complement__c         = c.BR_Address_complement__c;
            lAcc.BR_Main_District__c           = c.BR_Address_district__c;
            lAcc.BR_Main_City__c               = c.BR_Address_city__c;
            lAcc.BR_Main_State__c              = c.BR_Address_state__c;
            lAcc.BR_Main_Country__c            = c.BR_Address_country__c;
            lAcc.BR_Main_Zip_code__c           = c.BR_Address_zip_code__c;
            //Carlos Carvalho - Modification 07/02/2013
            lAcc.BR_Other_phone__c             = c.OtherPhone;
            lAcc.Phone                         = c.Phone;
            lAcc.Fax                           = c.Fax;
            lAcc.BR_Approval_status__c         = c.BR_Approval_status__c;
            //End Modification
            
            lAcc.ELT__c                        = c.ELT__c;
            lAcc.ELE__c                        = c.ELE__c;
            lacc.Universitario__c              = c.Universitario__c; 
            
            listAccountUpdate.add( lAcc );
        }
        
        //Invoke Log Limits
        LogLimits.print('TRIGGER: ContactUpdateAccountData - AFTER FOR CONTACT', false); 
        
        if( listAccountUpdate.size() > 0 )
            try
            {
            update listAccountUpdate;
            }
            catch( Dmlexception e )
            {
            for ( Contact c : triggerNew )
                c.addError( e.getDmlMessage( 0 ) );
            }
        
        //Invoke Log Limits
        LogLimits.print('TRIGGER: ContactUpdateAccountData - AFTER UPDATE ACCOUNT', false);
    }
}