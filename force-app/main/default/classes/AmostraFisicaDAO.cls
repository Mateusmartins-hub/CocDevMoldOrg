public class AmostraFisicaDAO {
    
    public static AmostraFisica__c getAmostraFisicaById(Id amostraId) {
        return [SELECT Id, TipoFrete__c, Oportunidade__r.Probability, Oportunidade__c, Oportunidade__r.Account.BR_Account_Id_SAP__c, CreatedDate, Oportunidade__r.BR_Shipping_Address__c, 
                (SELECT Id, Quantidade__c, ValorUnitario__c, ValorTotal__c, Produto__c, Produto__r.Name, AmostraFisica__c FROM ItensAmostraFisica__r) 
                FROM AmostraFisica__c
                WHERE Id =: amostraId][0];
    }

    public static List<AmostraFisica__c> getAmostrasFisicasById(Set<Id> amostrasIds) {
        return [SELECT Id, Oportunidade__c FROM AmostraFisica__c WHERE Id IN :amostrasIds];
    }
    
    public static Map<Id, List<ItemAmostraFisica__c>> getAmostrasFisicasItensById(Set<Id> amostrasIds) {
        Map<Id, List<ItemAmostraFisica__c>> mapRetorno = new Map<Id, List<ItemAmostraFisica__c>>();
        
        List<AmostraFisica__c> amostras = [SELECT Id, Oportunidade__c, (SELECT Id, Produto__c, Produto__r.BR_Product_Code__c, Quantidade__c, ValorUnitario__c, ValorTotal__c FROM ItensAmostraFisica__r) FROM AmostraFisica__c WHERE Id IN :amostrasIds];
       
        for(AmostraFisica__c a : amostras) {
            if(!mapRetorno.containsKey(a.Id))
                mapRetorno.put(a.Id, new List<ItemAmostraFisica__c>());
            
            mapRetorno.get(a.Id).addAll(a.ItensAmostraFisica__r);
        }
        
        return mapRetorno;
    }
}