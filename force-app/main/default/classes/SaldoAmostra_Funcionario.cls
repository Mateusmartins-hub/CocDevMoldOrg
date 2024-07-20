public class SaldoAmostra_Funcionario {

    public static void validarRegistroExitente(List<SaldoParaAmostras__c> saldosAmostras) {
        Set<Id> funcionariosIds = new Set<Id>();
        for(SaldoParaAmostras__c s : saldosAmostras) {
            funcionariosIds.add(s.Funcionario__c);
        }
        
        List<SaldoParaAmostras__c> saldosAmostrasExistentes = [SELECT Id, Saldo__c, Funcionario__c FROM SaldoParaAmostras__c WHERE Funcionario__c IN: funcionariosIds];
        Map<Id, List<SaldoParaAmostras__c>> mapSaldosPorUsuario = new Map<Id, List<SaldoParaAmostras__c>>();
        
        for(SaldoParaAmostras__c s : saldosAmostrasExistentes) {
            if(!mapSaldosPorUsuario.containsKey(s.Funcionario__c))
                mapSaldosPorUsuario.put(s.Funcionario__c, new List<SaldoParaAmostras__c>());
            
            mapSaldosPorUsuario.get(s.Funcionario__c).add(s);
        }
        
        for(SaldoParaAmostras__c s : saldosAmostras) {
            if(!mapSaldosPorUsuario.containsKey(s.Funcionario__c))
                continue;
            
            for(SaldoParaAmostras__c ss : mapSaldosPorUsuario.get(s.Funcionario__c)) {
                if(ss.Id == s.Id)
                    continue;
                
                s.addError('Já existe um registro de saldo para esse funcionário');
            }
        }
        
    }
    
    public static void validarHierarquiaUsuario(List<SaldoParaAmostras__c> saldosAmostras) {
        Set<Id> funcionariosIds = new Set<Id>();
        for(SaldoParaAmostras__c s : saldosAmostras) {
            funcionariosIds.add(s.Funcionario__c);
        }
        
        Map<Id, User> mapUsuarios = new Map<Id, User>([SELECT Id, ManagerId FROM User WHERE Id IN: funcionariosIds]);
        
        Id admId = [SELECT Id FROM Profile WHERE (UserType = 'Standard' AND PermissionsPrivacyDataAccess = true) ORDER BY CreatedDate ASC LIMIT 1][0].Id;
        Id brazilGlobalId = [SELECT Id FROM Profile WHERE Name = 'Brazil Global'][0].Id;
        
        for(SaldoParaAmostras__c s : saldosAmostras) {
            if(s.AtualizandoPelaTrigger__c)
                continue;
            
            if(mapUsuarios.get(s.Funcionario__c).ManagerId == UserInfo.getUserId())
                continue;
            
            if(UserInfo.getProfileId() == admId || UserInfo.getProfileId() == brazilGlobalId)
                continue;
            
            s.addError('Você só poderá editar os saldos de usuários abaixo de você na hierarquia.');
        }
    }
    
    public static void atualizarProprietario(List<SaldoParaAmostras__c> saldosAmostras) {
        for(SaldoParaAmostras__c s : saldosAmostras) {
            s.OwnerId = s.Funcionario__c;
        }
    }
    
    public static void compartilharManager(List<SaldoParaAmostras__c> saldosAmostras) {
        Set<Id> funcionariosIds = new Set<Id>();
        List<SaldoParaAmostras__Share> shares = new List<SaldoParaAmostras__Share>();
        
        for(SaldoParaAmostras__c s : saldosAmostras) {
            funcionariosIds.add(s.Funcionario__c);
        }
        
        Map<Id, User> mapFuncionarios = new Map<Id, User>([SELECT Id, ManagerId, Manager.IsActive FROM User WHERE Id IN: funcionariosIds]);
        
        for(SaldoParaAmostras__c s : saldosAmostras) {
            User user = mapFuncionarios.get(s.Funcionario__c);
            if(user.Manager.IsActive) {
                SaldoParaAmostras__Share share = new SaldoParaAmostras__Share();
                share.AccessLevel = 'Edit';
                share.ParentId = s.Id;
                share.UserOrGroupId = user.ManagerId;
                shares.add(share);
            }
        }
        
        if(!shares.isEmpty())
            insert shares;
    }
}