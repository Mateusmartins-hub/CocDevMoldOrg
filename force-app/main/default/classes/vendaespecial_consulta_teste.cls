@isTest
public class vendaespecial_consulta_teste {
    @isTest static void teste1() {
        
        vendaespecial_consulta A = new vendaespecial_consulta();
        A.ISBN = '123456789';    //'9780074504093';
        A.CPF= '17817062803';
        A.Pedido_Site = 'aaaa';
        A.Campanha = 'okok';
        
        // Teste HTTP com dados de "Find"
        Test.startTest();
        
        Test.setMock(HttpCalloutMock.class,new vendaespecial_Find_Mock());
        vendaespecial_consulta.Status_Pedido B = A.parseJSONResponse();
        Test.stopTest();
        
        
        
        // OK
        //System.assertEquals(B.status,'OK');
        //System.assertEquals(B.Data.Size(),8);
        
        // Inválido
        System.assertEquals(B.status,'INVALIDO');
        System.assertEquals(B.Data.Size(),8);
        System.assertEquals(B.Data[0].Mensagem,'Livro não disponível no catálogo');
        System.assertEquals(B.Data[0].Codigo,'1');
        System.assertEquals(B.Data[1].Mensagem,'Livro não disponível para venda no Ecommerce');
        System.assertEquals(B.Data[2].Mensagem,'Livro não tem estoque para internet');
        System.assertEquals(B.Data[3].Mensagem,'Livro não está contido na campanha -364 - VENDA ESPECIAL 75%');
        System.assertEquals(B.Data[3].Valido,'0');       
        System.assertEquals(B.Data[4].Valido,'1');       
        System.assertEquals(B.Data[6].Valido,'1');   
        
        vendaespecial_consulta.Datum D = new vendaespecial_consulta.Datum();
        D.codigo = '1';   
        D.mensagem = '2';
        D.valido = '3';
        D.variavel = '4';
        
    } 
    
    @isTest static void teste2() {
        try {
            vendaespecial_consulta A = new vendaespecial_consulta();
            vendaespecial_consulta.Status_Pedido C = A.parseJSONResponse();
        }catch(Exception e){
            
        }
    }
    
    @isTest static void teste3() {
        try {
            vendaespecial_consulta A = new vendaespecial_consulta();
            vendaespecial_consulta.Status_Pedido C = A.Altera_Produto_Adquirido();
        }catch(Exception e){
            
        }
    }
    
    @isTest static void teste4() {
        try {
            vendaespecial_consulta A = new vendaespecial_consulta();
            vendaespecial_consulta.Status_Pedido C = A.Alterar_Ativo();
        }catch(Exception e){
            
        }
    }
    
    @isTest static void teste5() {
        vendaespecial_consulta A = new vendaespecial_consulta();
        A.CPF_apenas_numero('601.420.103-32');
    }
}