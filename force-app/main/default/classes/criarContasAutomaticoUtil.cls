public class criarContasAutomaticoUtil{
    public static boolean UpContas(List<SolicitacaoCadastroCliente__c> dadosCadastrados){
      Boolean retorno = false;
        for(SolicitacaoCadastroCliente__c dadosContas: dadosCadastrados){
            if(dadosContas.BR_Conta__c == null){
                retorno = false;
            }else{
                retorno = true;
            }
        }
    	return retorno;
    }
    
    public static boolean Mudanca(List<SolicitacaoCadastroCliente__c> dadosCadastrados, map<ID,SolicitacaoCadastroCliente__c> mapaOld){
         Boolean retorno = false;
        for(SolicitacaoCadastroCliente__c dadosContas: dadosCadastrados){
            if((dadosContas.BR_Status__c == 'Enviado para Integração' && dadosContas.BR_Status__c != mapaOld.get(dadosContas.Id).Br_Status__c)||dadosContas.Integrar__c){
                retorno = true;
            }
        }
        system.debug(retorno);
        return retorno;
    }
    
    public static void CriarContas(List<SolicitacaoCadastroCliente__c> dadosCadastrados){
        List<Account> accts = new List<Account>();
        Map<id,Account> mapa = new map<id,Account>();
        for(SolicitacaoCadastroCliente__c dadosContas: dadosCadastrados){
            //insert account datas
            Account acct = new Account();
            acct.RecordTypeId = dadosContas.TipoRegistroConta__c;
            if(dadosContas.BR_RazaoSocial__c == null){
				acct.Name = dadosContas.BR_Name__c;
            }else{
                acct.Name = dadosContas.BR_RazaoSocial__c;
            }
            acct.BR_Account_email__c = dadosContas.BR_email__c;
            acct.BR_CPF__c = dadosContas.BR_CPF__c;
            acct.BR_cnpj__c = dadosContas.BR_CNPJ__c;
            acct.Phone = dadosContas.BR_Phone__c;
            acct.Marca__c = dadosContas.Unidade__c;	
            //insert address
            acct.BR_Main_City__c =  dadosContas.BR_Main_City__c;
            acct.BR_Main_State__c = dadosContas.BR_Main_State__c;
            acct.BR_Main_District__c = dadosContas.BR_Bairro__c;
            acct.BR_Main_Address__c = dadosContas.BR_Main_Address__c; 
            acct.BR_Main_Nbr__c = dadosContas.BR_Main_Nbr__c;
            acct.BR_Main_Complement__c = dadosContas.BR_Main_Complement__c;
            acct.BR_Bairro__c = dadosContas.BR_Bairro__c;
            acct.BR_Main_Zip_code__c = dadosContas.BR_Main_Zip_code__c;
            //insert account in the list of accounts and create Accounts
            if(mapa.containsKey(acct.Id)){
                mapa.remove(acct.Id);
                mapa.put(acct.Id,acct);
            }else{
                mapa.put(acct.Id,acct);
            }
        }
        accts = mapa.values();
        insert accts;
            for(SolicitacaoCadastroCliente__c dadosContas: dadosCadastrados){
                dadosContas.BR_Status__c = 'Cliente Integrado';
                for(Account acc: accts){
                    if(acc.BR_CPF__c == dadosContas.BR_CPF__c && acc.BR_cnpj__c == '' ){
                        dadosContas.BR_Conta__c = acc.id;
                        
                    }else if(acc.BR_cnpj__c == dadosContas.BR_CNPJ__c && acc.BR_CPF__c == '' ){
                        dadosContas.BR_Conta__c = acc.id;
                        
                    }else if(acc.BR_cnpj__c == dadosContas.BR_CNPJ__c || acc.BR_CPF__c == dadosContas.BR_CPF__c){
                        dadosContas.BR_Conta__c = acc.id;
                        
                    }
                    
                }
            }
    }

    public static void AtualizarContas(List<SolicitacaoCadastroCliente__c> dadosCadastrados){
        List<Account> accts = new List<Account>();
        Map<id,Account> mapa = new map<id,Account>();
        for (SolicitacaoCadastroCliente__c dadosContas : dadosCadastrados){
            Account acct = new Account();
            dadosContas.BR_Status__c = 'Cliente Integrado';
            acct.Id = dadosContas.BR_Conta__c;
            acct.RecordTypeId = dadosContas.TipoRegistroConta__c;
            if(dadosContas.BR_RazaoSocial__c == null){
				acct.Name = dadosContas.BR_Name__c;
            }else{
                acct.Name = dadosContas.BR_RazaoSocial__c;
            }
            acct.BR_Account_email__c = dadosContas.BR_email__c;
            acct.BR_CPF__c = dadosContas.BR_CPF__c;
            acct.BR_cnpj__c = dadosContas.BR_CNPJ__c;
            acct.Phone = dadosContas.BR_Phone__c;
            acct.Marca__c = dadosContas.Unidade__c;	
            //insert address
            acct.BR_Main_City__c =  dadosContas.BR_Main_City__c;
            acct.BR_Main_State__c = dadosContas.BR_Main_State__c;
            acct.BR_Main_District__c = dadosContas.BR_Bairro__c;
            acct.BR_Main_Address__c = dadosContas.BR_Main_Address__c; 
            acct.BR_Main_Nbr__c = dadosContas.BR_Main_Nbr__c;
            acct.BR_Main_Complement__c = dadosContas.BR_Main_Complement__c;
            acct.BR_Bairro__c = dadosContas.BR_Bairro__c;
            acct.BR_Main_Zip_code__c = dadosContas.BR_Main_Zip_code__c;
            if(mapa.containsKey(acct.Id)){
                mapa.remove(acct.Id);
                mapa.put(acct.Id,acct);
            }else{
                mapa.put(acct.Id,acct);
            }
        }
        accts = mapa.values();
        update accts;
    }
    
    public static void Arti(List<SolicitacaoCadastroCliente__c> dadosCadastrados){
        List<String> cnpjs = new List<String>();
        List<String> cpfs = new List<string>();
        for(SolicitacaoCadastroCliente__c solicitacao : dadosCadastrados){        
            cnpjs.add(solicitacao.BR_CNPJ__c);
            cpfs.add(solicitacao.BR_CPF__c);
        }
		List<Account> CNPJContas = [SELECT id,name,BR_cnpj__c FROM Account where BR_cnpj__c = :cnpjs AND BR_cnpj__c != ''];
        List<Account> CPFContas = [SELECT id,name,BR_CPF__c FROM Account where  BR_CPF__c = :cpfs AND BR_CPF__c != ''];
    	system.debug(CNPJContas);
        system.debug(CPFContas);
        for(SolicitacaoCadastroCliente__c sol: dadosCadastrados){
            if(CNPJContas.size() > 0 && sol.Tipo_de_Pessoa__c == 'Pessoa Jurídica'){
                for(Account acc: CNPJContas){
                    sol.BR_Conta__c = acc.id;
                }
            }else if(CPFContas.size() > 0 && sol.Tipo_de_Pessoa__c == 'Pessoa Física'){
             	for(Account acc: CPFContas){
                    sol.BR_Conta__c = acc.id;
                }
            }
        }
    }
}