public class SaldoAmostra_Saldo {

    public static void validarSaldoUsuarioEAtualizarSaldoRestante(List<SaldoParaAmostras__c> saldosAmostras, Map<Id, SaldoParaAmostras__c> mapOld) {
        Set<Id> funcionariosIds = new Set<Id>();
        Set<Id> managerIds = new Set<Id>();
        
        for(SaldoParaAmostras__c s : saldosAmostras) {
            funcionariosIds.add(s.Funcionario__c);
        }
        
        Map<Id, User> mapFuncionarios = new Map<Id, User>([SELECT Id, ManagerId FROM User WHERE Id IN: funcionariosIds]);
                
        for(User u : mapFuncionarios.values()) {
            managerIds.add(u.ManagerId);
        }
        
        Map<Id, SaldoParaAmostras__c> mapManagerSaldos = new Map<Id, SaldoParaAmostras__c>();
        
        for(SaldoParaAmostras__c saldo : [SELECT Id, Saldo__c, Funcionario__c FROM SaldoParaAmostras__c WHERE Funcionario__c IN: managerIds]) {
            mapManagerSaldos.put(saldo.Funcionario__c, saldo);
        }
        
        Boolean atualizarPai = false;
        
        Id admId = [SELECT Id FROM Profile WHERE (UserType = 'Standard' AND PermissionsPrivacyDataAccess = true) ORDER BY CreatedDate ASC LIMIT 1][0].Id;
        Id brazilGlobalId = [SELECT Id FROM Profile WHERE Name = 'Brazil Global'][0].Id;
        
        for(SaldoParaAmostras__c s : saldosAmostras) {
            Double saldoOld = (mapOld != null && mapOld.containsKey(s.Id)) ? mapOld.get(s.Id).Saldo__c : 0;
            SaldoParaAmostras__c saldoManager = mapManagerSaldos.get(mapFuncionarios.get(s.Funcionario__c).ManagerId); 
            
            if(saldoManager == null) {
                if(UserInfo.getProfileId() != admId && UserInfo.getProfileId() != brazilGlobalId && !s.AtualizandoPelaTrigger__c)
                    s.addError('Não há um registro de saldo para o usuário logado.');
            }else{
                if(s.Saldo__c > saldoOld) {
                    Double diff = s.Saldo__c - saldoOld;
                    if(saldoManager.Saldo__c >= diff) {
                        saldoManager.Saldo__c -= diff;
                        saldoManager.AtualizandoPelaTrigger__c = true;
                        atualizarPai = true;
                    }else{
                        s.addError('Saldo maior que o permitido para o usuário logado.');
                    }
                }else if(s.Saldo__c < saldoOld){
                    Double diff = saldoOld - s.Saldo__c;
                    
                    saldoManager.Saldo__c += diff;
                    saldoManager.AtualizandoPelaTrigger__c = true;
                    atualizarPai = true;
                }   
            }
        }
        if(atualizarPai)
            update mapManagerSaldos.values();
    }
    
    public static void retornarSaldo(List<SaldoParaAmostras__c> saldosAmostras) {
        Set<Id> funcionariosIds = new Set<Id>();
        Set<Id> managerIds = new Set<Id>();
        
        for(SaldoParaAmostras__c s : saldosAmostras) {
            funcionariosIds.add(s.Funcionario__c);
        }
        
        Map<Id, User> mapFuncionarios = new Map<Id, User>([SELECT Id, ManagerId FROM User WHERE Id IN: funcionariosIds]);
                
        for(User u : mapFuncionarios.values()) {
            managerIds.add(u.ManagerId);
        }
        
        Map<Id, SaldoParaAmostras__c> mapManagerSaldos = new Map<Id, SaldoParaAmostras__c>();
        
        for(SaldoParaAmostras__c saldo : [SELECT Id, Saldo__c, Funcionario__c FROM SaldoParaAmostras__c WHERE Funcionario__c IN: managerIds]) {
            mapManagerSaldos.put(saldo.Funcionario__c, saldo);
        }
        
        Boolean atualizarPai = false;
        
        for(SaldoParaAmostras__c s : saldosAmostras) {
            SaldoParaAmostras__c saldoManager = mapManagerSaldos.get(mapFuncionarios.get(s.Funcionario__c).ManagerId); 
            
            if(saldoManager == null) {
                
            }else{
                saldoManager.Saldo__c += s.Saldo__c;
                saldoManager.AtualizandoPelaTrigger__c = true;
                atualizarPai = true; 
            }
        }
        
        if(atualizarPai)
            update mapManagerSaldos.values();
        
    }
}