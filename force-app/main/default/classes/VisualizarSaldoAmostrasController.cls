public class VisualizarSaldoAmostrasController {

    @AuraEnabled
    public static Usuario getUsuarioOwner(String amostraId) {
        Usuario u = new Usuario();
        
        AmostraFisica__c amostra = [SELECT Id, Oportunidade__c FROM AmostraFisica__c WHERE Id =: amostraId][0];
        Opportunity op = [SELECT Id, OwnerId FROM Opportunity WHERE Id =: amostra.Oportunidade__c][0];
        
        User owner = [SELECT Id, Name, ManagerId FROM User WHERE Id =: op.OwnerId][0];
        
        u.Nome = owner.Name;
        u.podeVisualizar = false;
        
        Id admId = [SELECT Id FROM Profile WHERE (UserType = 'Standard' AND PermissionsPrivacyDataAccess = true) ORDER BY CreatedDate ASC LIMIT 1][0].Id;
        Id brazilGlobalId = [SELECT Id FROM Profile WHERE Name = 'Brazil Global'][0].Id;
        
        if(UserInfo.getUserId() == owner.ManagerId || UserInfo.getProfileId() == admId || UserInfo.getProfileId() == brazilGlobalId) {
            u.podeVisualizar = true;
            List<SaldoParaAmostras__c> saldos = [SELECT Id, Saldo__c FROM SaldoParaAmostras__c WHERE Funcionario__c =: owner.Id];
            
            if(saldos.size() > 0) {
                u.Saldo = String.valueOf(saldos[0].Saldo__c);
            }
            else
                u.Saldo = '0.00';    
                
        }
                
        return u;
    }

    @AuraEnabled
    public static Usuario getUsuarioLogado(String amostraId) {
        Usuario u = new Usuario();
        
        User user = [SELECT Id, Name, ManagerId FROM User WHERE Id =: UserInfo.getUserId()][0];
        
        u.Nome = user.Name;        
        u.podeVisualizar = true;
        List<SaldoParaAmostras__c> saldos = [SELECT Id, Saldo__c FROM SaldoParaAmostras__c WHERE Funcionario__c =: user.Id];
        
        if(saldos.size() > 0) {
            u.Saldo = String.valueOf(saldos[0].Saldo__c);
        }
        else
            u.Saldo = '0.00';    
        
        return u;
    }
    
    public class Usuario {
        @AuraEnabled
        public String nome;
        @AuraEnabled
        public String saldo;
        @AuraEnabled
        public Boolean podeVisualizar;
    }
}