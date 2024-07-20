trigger AuditoriaUpdateLastAuditOnAccount on Auditoria__c (before update) {
    
    Set<id> listIdsAccount = new Set<id>();
    List<Account> listAccount = new List<Account>();
    
    for(Auditoria__c aud : trigger.new){
        if(aud.BR_UpdateAccount__c) { 
            listIdsAccount.add(aud.BR_account__c); 
            aud.BR_UpdateAccount__c = false;
        }
    }
    
    for(Account acc : AccountDAO.buscaContas(listIdsAccount)) {
        acc.BR_Last_Audit__c = System.today();
        listAccount.add(acc);
    }
    
    if(listAccount.size()> 0) 
        update listAccount;
}