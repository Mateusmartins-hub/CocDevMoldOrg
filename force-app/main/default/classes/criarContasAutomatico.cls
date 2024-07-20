public class criarContasAutomatico{

    public static boolean validarContas(List<SolicitacaoCadastroCliente__c> dadosCadastrados, map<ID,SolicitacaoCadastroCliente__c> mapaOld){
        Boolean retorno = false;
        for(SolicitacaoCadastroCliente__c dadosContas: dadosCadastrados){
            if(dadosContas.BR_Status__c == 'Enviado para Integração' && dadosContas.BR_Status__c != mapaOld.get(dadosContas.Id).Br_Status__c){
                retorno = true;
            }
        }
    	return retorno;
    }
   
    public static boolean validarAtualizacaoContas(List<SolicitacaoCadastroCliente__c> dadosCadastrados, Map<Id, SolicitacaoCadastroCliente__c> mapaOld) {
        criarContasAutomatico cca = new criarContasAutomatico();
        Boolean retorno = false;
        for( SolicitacaoCadastroCliente__c dadosContas : dadosCadastrados) {
            if( dadosContas.BR_Status__c == 'Cliente Integrado' && !cca.ContaExistente(dadosCadastrados) ) {
                retorno = true;
            }
        }
        return retorno;
    }

    public boolean ContaExistente(List<SolicitacaoCadastroCliente__c> dados){
    	boolean retorno = true; 
        List<String> cnpjs = new List<String>();
        List<String> cpfs = new List<string>();
        for(SolicitacaoCadastroCliente__c solicitacao : dados){        
            cnpjs.add(solicitacao.BR_CNPJ__c);
            cpfs.add(solicitacao.BR_CPF__c);
        }
		List<Account> CNPJContas = [SELECT id,name,BR_cnpj__c FROM Account where BR_cnpj__c = :cnpjs AND BR_cnpj__c != ''];
        List<Account> CPFContas = [SELECT id,name,BR_CPF__c FROM Account where  BR_CPF__c = :cpfs AND BR_CPF__c != ''];        
        for(SolicitacaoCadastroCliente__c TipoConta : dados){
            if(CNPJContas.size() > 0 && TipoConta.Tipo_de_Pessoa__c == 'Pessoa Jurídica'){
                retorno = false;
            }else if(CPFContas.size() > 0 && TipoConta.Tipo_de_Pessoa__c == 'Pessoa Física'){
             	retorno = false;
            }
        }
    	return retorno;
    }
    
}