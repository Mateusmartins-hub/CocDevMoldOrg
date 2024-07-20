public class CadastroClienteListaController {
    
    public class ClientItem {
        public String Id {get; set;}
        public String Codigo {get; set;}        
        public String ContaId {get; set;}
        public String ContaName {get; set;}
        public String RazaoSocial {get; set;}
        public String Nome {get; set;}
        public String TipoPessoa {get; set;}
        public DateTime DataCriacao {get; set;}
        public String Status {get; set;}
        public String SolicitanteName {get; set;}
        public String SolicitanteId {get; set;}
    }
    
    public list<ClientItem> listRegister {get; set;}
    
    public CadastroClienteListaController(){
        
        listRegister = new list<ClientItem>();
        
        list<SolicitacaoCadastroCliente__c> listCadCli = new list<SolicitacaoCadastroCliente__c>();
        
        listCadCli = [select id, Name, BR_Conta__c,BR_Conta__r.Name, BR_RazaoSocial__c,BR_Name__c, Tipo_de_Pessoa__c,
                      createdbyid, createdby.Name, CreatedDate, BR_Status__c
                      	from SolicitacaoCadastroCliente__c order by id desc limit 1000];
        
        
        
        for (SolicitacaoCadastroCliente__c item : listCadCli){
            ClientItem client = new ClientItem();
            client.Id = item.Id;
            client.ContaId = item.BR_Conta__c;
            client.ContaName = item.BR_Conta__r.Name;
            client.Codigo = item.Name; 
            if (item.Tipo_de_Pessoa__c == 'Pessoa Jurídica')
                client.Nome = item.BR_RazaoSocial__c;
            else
                client.Nome = item.BR_Name__c;
            
            client.TipoPessoa = item.Tipo_de_Pessoa__c;
            client.Status = item.BR_Status__c;
            client.DataCriacao = item.CreatedDate;
            client.SolicitanteName = item.createdby.Name;
            client.SolicitanteId = item.createdbyid;
            
            listRegister.add(client);
        }
    }
    
    // solicita o cadastro de nova solicitacao
    public PageReference newRequest(){
        PageReference pageRef = new PageReference('/apex/CadastroCliente');
        return pageRef;
    }   
    
}