public class ItemAmostraFisica_SaldoAmostra {

    public static void validarEAtualizarSaldo(List<ItemAmostraFisica__c> itens){
        Set<Id> amostrasIds = new Set<Id>();
        Set<Id> funcionariosIds = new Set<Id>();
        
        for(ItemAmostraFisica__c i : itens) {
            amostrasIds.add(i.AmostraFisica__c);    
        }
        
        Map<Id, AmostraFisica__c> mapAmostras = new Map<Id, AmostraFisica__c>([SELECT Id, TipoFrete__c, Oportunidade__r.OwnerId FROM AmostraFisica__c WHERE Id IN: amostrasIds]);
        
        for(AmostraFisica__c a : mapAmostras.values()) {
            funcionariosIds.add(a.Oportunidade__r.OwnerId);
        }
        
        List<SaldoParaAmostras__c> listaSaldo = [SELECT Id, Saldo__c, Funcionario__c FROM SaldoParaAmostras__c WHERE Funcionario__c IN: funcionariosIds];
        Map<Id, SaldoParaAmostras__c> mapSaldos = new Map<Id, SaldoParaAmostras__c>();
        
        for(SaldoParaAmostras__c s : listaSaldo) {
            if(!mapSaldos.containsKey(s.Funcionario__c))
                mapSaldos.put(s.Funcionario__c, s);
        }
        
        List<SaldoParaAmostras__c> saldos = new List<SaldoParaAmostras__c>();
        
        for(ItemAmostraFisica__c i : itens) {
            Id ownerId;
            
            if(mapAmostras.containsKey(i.AmostraFisica__c))
                ownerId = mapAmostras.get(i.AmostraFisica__c).Oportunidade__r.OwnerId;
            
            SaldoParaAmostras__c saldo;
            
            if(mapSaldos.containsKey(ownerId))
                saldo = mapSaldos.get(ownerId);
            
            String tipoFrete = mapAmostras.get(i.AmostraFisica__c).TipoFrete__c;
            Double valorUnit = i.ValorUnitario__c == null ? 0 : i.ValorUnitario__c;
            Double valorTotalItem = i.Quantidade__c * valorUnit * (tipoFrete == 'Emergencial' ? 2 : 1);
            
            if(saldo == null) {
                i.AddError('Proprietário da oportunidade não contém um registro de saldo para envio de amostras.');
            } else if(valorTotalItem > saldo.Saldo__c){
                i.AddError('O saldo atual do proprietário da oportunidade é de ' + saldo.Saldo__c + '. O total das amostras é de ' + valorTotalItem + '.');
            }else{
                saldo.Saldo__c -= valorTotalItem;
                saldo.AtualizandoPelaTrigger__c = true;
                saldos.add(saldo);
            }
        }
        
        if(!saldos.isEmpty())
            update saldos;

    }
    
    public static void validarEAtualizarSaldo(List<ItemAmostraFisica__c> itens, Map<Id, ItemAmostraFisica__c> mapOld){
        Set<Id> amostrasIds = new Set<Id>();
        Set<Id> funcionariosIds = new Set<Id>();
        
        for(ItemAmostraFisica__c i : itens) {
            amostrasIds.add(i.AmostraFisica__c);    
        }
        
        Map<Id, AmostraFisica__c> mapAmostras = new Map<Id, AmostraFisica__c>([SELECT Id, TipoFrete__c, Oportunidade__r.OwnerId FROM AmostraFisica__c WHERE Id IN: amostrasIds]);
        
        for(AmostraFisica__c a : mapAmostras.values()) {
            funcionariosIds.add(a.Oportunidade__r.OwnerId);
        }
        
        List<SaldoParaAmostras__c> listaSaldo = [SELECT Id, Saldo__c, Funcionario__c FROM SaldoParaAmostras__c WHERE Funcionario__c IN: funcionariosIds];
        Map<Id, SaldoParaAmostras__c> mapSaldos = new Map<Id, SaldoParaAmostras__c>();
        
        for(SaldoParaAmostras__c s : listaSaldo) {
            if(!mapSaldos.containsKey(s.Funcionario__c))
                mapSaldos.put(s.Funcionario__c, s);
        }
        
        List<SaldoParaAmostras__c> saldos = new List<SaldoParaAmostras__c>();
            
        Boolean atualizarSaldos = false;
        
        for(ItemAmostraFisica__c i : itens) {
            Id ownerId;
            
            if(mapAmostras.containsKey(i.AmostraFisica__c))
                ownerId = mapAmostras.get(i.AmostraFisica__c).Oportunidade__r.OwnerId;
            
            SaldoParaAmostras__c saldo;
            
            if(mapSaldos.containsKey(ownerId))
                saldo = mapSaldos.get(ownerId);
            
            ItemAmostraFisica__c iOld = mapOld.get(i.Id);
            
            String tipoFrete = mapAmostras.get(i.AmostraFisica__c).TipoFrete__c;
            
            Double valorUnit = i.ValorUnitario__c == null ? 0 : i.ValorUnitario__c;
            Double valorTotalItem = i.Quantidade__c * valorUnit * (tipoFrete == 'Emergencial' ? 2 : 1);
            Double valorTotalItemOld = iOld.Quantidade__c * iOld.ValorUnitario__c * (tipoFrete == 'Emergencial' ? 2 : 1);
            
            if(saldo == null) {
                i.AddError('Proprietário da oportunidade não contém um registro de saldo para envio de amostras.');
            }else if(valorTotalItem > valorTotalItemOld) {
                Double diff = valorTotalItem - valorTotalItemOld;
                if(saldo.Saldo__c >= diff) {
                    saldo.Saldo__c -= diff;
                    saldo.AtualizandoPelaTrigger__c = true;
                    atualizarSaldos = true;
                }else{
                    i.AddError('O saldo atual do proprietário da oportunidade é de ' + saldo.Saldo__c + '. O total das amostras é de ' + valorTotalItem + '.');
                }
            }else if(valorTotalItem < valorTotalItemOld){
                Double diff = valorTotalItemOld - valorTotalItem;
                
                saldo.Saldo__c += diff;
                saldo.AtualizandoPelaTrigger__c = true;
                atualizarSaldos = true;
            }
            saldos.add(saldo);
        }
        
        if(!saldos.isEmpty() && atualizarSaldos)
            update saldos;

    }

    public static void retornarSaldo(List<ItemAmostraFisica__c> itens){
        Set<Id> amostrasIds = new Set<Id>();
        Set<Id> funcionariosIds = new Set<Id>();
        
        for(ItemAmostraFisica__c i : itens) {
            amostrasIds.add(i.AmostraFisica__c);    
        }
        
        Map<Id, AmostraFisica__c> mapAmostras = new Map<Id, AmostraFisica__c>([SELECT Id, TipoFrete__c, Oportunidade__r.OwnerId FROM AmostraFisica__c WHERE Id IN: amostrasIds]);
        
        for(AmostraFisica__c a : mapAmostras.values()) {
            funcionariosIds.add(a.Oportunidade__r.OwnerId);
        }
        
        List<SaldoParaAmostras__c> listaSaldo = [SELECT Id, Saldo__c, Funcionario__c FROM SaldoParaAmostras__c WHERE Funcionario__c IN: funcionariosIds];
        Map<Id, SaldoParaAmostras__c> mapSaldos = new Map<Id, SaldoParaAmostras__c>();
        
        for(SaldoParaAmostras__c s : listaSaldo) {
            if(!mapSaldos.containsKey(s.Funcionario__c))
                mapSaldos.put(s.Funcionario__c, s);
        }
        
        List<SaldoParaAmostras__c> saldos = new List<SaldoParaAmostras__c>();
        
        for(ItemAmostraFisica__c i : itens) {
            Id ownerId;
            
            if(mapAmostras.containsKey(i.AmostraFisica__c))
                ownerId = mapAmostras.get(i.AmostraFisica__c).Oportunidade__r.OwnerId;
            
            SaldoParaAmostras__c saldo;
            
            if(mapSaldos.containsKey(ownerId))
                saldo = mapSaldos.get(ownerId);
            
            String tipoFrete = mapAmostras.get(i.AmostraFisica__c).TipoFrete__c;
            Double valorTotalItem = i.Quantidade__c * i.ValorUnitario__c * (tipoFrete == 'Emergencial' ? 2 : 1);
            
            if(saldo == null) {
                i.AddError('Proprietário da oportunidade não contém um registro de saldo para envio de amostras.');
            }else{
                saldo.Saldo__c += valorTotalItem;
                saldo.AtualizandoPelaTrigger__c = true;
                saldos.add(saldo);
            }
        }
        
        if(!saldos.isEmpty())
            update saldos;

    }
}