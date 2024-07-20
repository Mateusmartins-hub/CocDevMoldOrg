public with sharing class ProdutoComDescontoController {
    /*
Pontos a serem melhorados.
Ponto1. É desconhecido como se faz a passagem do Id entre formulários que atenda os requisitos abaixo.
Quando a tela é aberta pelo botão Novo, o Id do contato deve ser passado.
Quando é uma edição do registro, o Id do registro deve ser passado.
//Quando a tela é aberta diretamente pelo objeto, nenhum Id deve ser passado.
*/
    
    private final Produtos_com_desconto__c pcd;
    String oldProdAdq;
    Boolean oldAtivo, newRegister;
    ApexPages.standardController pagred = null;
    
    public ProdutoComDescontoController(ApexPages.StandardController Controller) {
        pagred = Controller;
        
        Id id = ApexPages.currentPage().getParameters().get('id');
        //Ponto1 - Inicio
        if(id==null){
            newRegister = true;
            pcd = new Produtos_com_desconto__c();  
            String retUrl = ApexPages.currentPage().getParameters().get('retURL');
            if (Test.isRunningTest()){
                retUrl = '1234567891011127';
            }
            if(retUrl.length() > 14){
                retUrl=retUrl.substring(1, 16);
            }
            system.debug('retUrl&&'+retUrl);
            System.debug(retUrl);
            try{
                pcd.Professor__c = retUrl;
            }catch (Exception e){
                System.debug(e);
            }
            
        }else{
            newRegister = false;
            pcd = [Select Id, ISBN__c, Professor__c, Titulo__c, Pedido_Site__c, Data_do_pedido__c, 
                   Produto_Adquirido__c, Autor__c, Desconto__c, Ativo__c, Contabiliza__c
                   From Produtos_com_desconto__c Where Id=:Id];  
        }
        //Ponto1 - Fim    
        oldProdAdq = pcd.Produto_Adquirido__c;  
        oldAtivo = pcd.Ativo__c;
    }
    
    public Produtos_com_desconto__c getpcd() {
        return pcd;
    }
    
    public PageReference save() {
        Integer i;
        String Msg = '';
        
        //Devido restrições de integração. Somente desconto 75 está habilitado para edição.
        if (pcd.Desconto__c <> 75){
            Msg+='Operação permitida somente para desconto 75.<br/> ';
        }
        /*
        if(Msg == ''){
            
            Contact ctt = [Select BR_CPF__c From Contact Where Id = :pcd.Professor__c];
            if(ctt.BR_CPF__c == Null){
                Msg+='CPF não cadastrado para este contato.<br/> ';
            }
            
            Product2 prd = [Select BR_Product_Code__c  From Product2 Where Id = :pcd.Titulo__c];
            if(prd.BR_Product_Code__c == Null || prd.BR_Product_Code__c == ''){
                Msg+='ISBN não cadastrado para o produto.<br/> ';
            } 
            
            vendaespecial_consulta A = new vendaespecial_consulta();
            A.ISBN = prd.BR_Product_Code__c;
            A.CPF = ctt.BR_CPF__c;
            A.Campanha = String.valueOf(pcd.Desconto__c);
            
            //Chamar a integração se apenas for uma inclusão de registro.
            if (newRegister){
                vendaespecial_consulta.Status_Pedido B = A.parseJSONResponse();
                System.debug('Consulta Status: ' + B.status);
                If(B.status =='INVALIDO'){
                    for (i=0;i<B.Data.Size();i++){
                        if(B.Data[i].Valido == '0'){
                            Msg+=B.Data[i].Mensagem + '.<br/> ';  
                        }
                    }
                }        
            }
            
            //Chamar a integração se o campo Produto adquirido for alterado de sim para não.
            If(oldProdAdq == 'Sim' && pcd.Produto_Adquirido__c == 'Não'){
                vendaespecial_consulta.Status_Pedido C = A.Altera_Produto_Adquirido();
                System.debug('Consulta Adquirido: ' + C.status);
                If(C.status =='Unmodified'){
                    for (i=0;i<C.Data.Size();i++){
                        Msg+=C.Data[i].Mensagem + '.<br/> ';  
                    }
                }  
            }
            
            //Chamar a integração se o campo ativo for alterado de true para false.
            if(oldAtivo == true && pcd.Ativo__c == false){
                vendaespecial_consulta.Status_Pedido D = A.Alterar_Ativo();
                System.debug('Consulta Ativo: ' + D.status);
                If(D.status =='Unmodified'){
                    for (i=0;i<D.Data.Size();i++){
                        Msg+=D.Data[i].Mensagem + '.<br/> ';  
                    }
                }
            }
        }
        if(Msg == ''){
            try{
                upsert pcd;
            }catch (DMLException e){
                ApexPages.addMessages(e);
                Return Null;
            }
            return (new ApexPages.StandardController(pcd)).view();
        }else{
            ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.ERROR,Msg);
            ApexPages.addMessage(myMsg);
            Return Null;  
        }
        */
        Return Null;
        
    }
    
    public PageReference cancel() {
        return pagred.cancel();
    }
}