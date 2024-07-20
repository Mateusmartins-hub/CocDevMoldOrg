/**
 *
 * Class Venda_Especial_Job - 04/09/2014 - Robinson Mioshi
 * 
 */
global  class Venda_Especial_Job{
    @future (callout=true)
    public static  void LevarItemParaEcommerce(String Cod_Cortesia) {    
        /* ---- Instanciar o LevarItemParaEcommerce 
        Venda_Especial_Job A = new Venda_Especial_Job();
        A.LevarItemParaEcommerce(); 
        
        Alterado para:
        Venda_Especial_Job.LevarItemParaEcommerce();
        */
        String ISBN;
        String CPF;   
        String QueryString;
        //------- Preparar os dados para envio ao Ecommerce ----------
        system.debug('Cod_Cortesia=' + Cod_Cortesia);
        If (Cod_Cortesia == NULL) {
            QueryString = 'SELECT Ativo__c,CreatedById,CreatedDate,Data_do_pedido__c,Desconto__c,Id,ISBN__c,Name,Pedido_Site__c,Produto_Adquirido__c,Professor__c,Titulo__c FROM Produtos_com_desconto__c  WHERE (Integrado__c = false) and (Ativo__c = true) LIMIT 1';
        	// List<Produtos_com_desconto__c> Cortesia = new List<Produtos_com_desconto__c>([SELECT Ativo__c,CreatedById,CreatedDate,Data_do_pedido__c,Desconto__c,Id,ISBN__c,LastViewedDate,Name,Pedido_Site__c,Produto_Adquirido__c,Professor__c,Titulo__c FROM Produtos_com_desconto__c  WHERE (Integrado__c = false) and (Ativo__c = true) LIMIT 1 ]); 
        } else {
            QueryString = 'SELECT Ativo__c,CreatedById,CreatedDate,Data_do_pedido__c,Desconto__c,Id,ISBN__c,Name,Pedido_Site__c,Produto_Adquirido__c,Professor__c,Titulo__c FROM Produtos_com_desconto__c  WHERE (Integrado__c = false) and (Ativo__c = true) and (ID=: Cod_Cortesia) LIMIT 1 ';
            // List<Produtos_com_desconto__c> Cortesia = new List<Produtos_com_desconto__c>([SELECT Ativo__c,CreatedById,CreatedDate,Data_do_pedido__c,Desconto__c,Id,ISBN__c,LastViewedDate,Name,Pedido_Site__c,Produto_Adquirido__c,Professor__c,Titulo__c FROM Produtos_com_desconto__c  WHERE (Integrado__c = false) and (Ativo__c = true) and (ID=: Cod_Cortesia) LIMIT 1 ]); 
        }    
        
        system.debug('QuerySring =' + QueryString);
        List<Produtos_com_desconto__c> Cortesia = Database.query(QueryString);
        
        system.debug ('Cortesia.size =' + Cortesia.size());
        
        
        List<Venda_Especial_Basico> Cortesia_Basico = new List<Venda_Especial_Basico>();

        if (Cortesia.size()> 0) {
            //  Cada item adicionado na cortesia irá para Ecommerce
            for (Produtos_com_desconto__c b: Cortesia) {
                // ISBN do Produto
                system.debug('b.Titulo__c = ' + b.Titulo__c);
                Product2 Produto = [SELECT BR_ISBN__c FROM Product2 WHERE Id =: b.Titulo__c];
                // CPF do Professor
                system.debug('b.Professor__c = ' + b.Professor__c);
                Contact  Professor = [SELECT BR_CPF__c FROM Contact WHERE Id =: b.Professor__c];        
                //------- Remover caracteres especiais --------------
                CPF = Professor.BR_CPF__c.replace('.','');
                CPF = CPF.replace('-','');
                ISBN = Produto.BR_ISBN__c;
                //------- Enviar os dados para Ecommerce ------------
                system.debug('CPF:' + CPF);
                system.debug('ISBN:' + ISBN );        
                String retorno;
                String body;
                 //--------------------------------------------------------------------------
                HTTPExterno portal = new HTTPExterno();
                //getContent(String url,String metodo,String head,String body )
                body = 'ISBN='+ ISBN+ '&CPF=' + CPF+ '&cod_campanha=' + String.valueof(b.Desconto__c);
                system.debug(body);
                retorno = portal.getContent(Constants.VENDAESPECIAL_ESB_URL + '/Add','POST', 'application/x-www-form-urlencoded',body);
                system.debug( retorno);
                //--------------------------------------------------------------------------
                retorno = retorno.replace('<?xml version="1.0" encoding="utf-8"?>', '');  
                retorno = retorno.replace('<string xmlns="http://tempuri.org/">', '');    
                retorno = retorno.replace('</string>', '');    
                system.debug('retorno = ' + retorno);
                
                JSONParser parser = JSON.createParser(retorno);
                Status_Pedido inv = new Status_Pedido();
                while (parser.nextToken() != null) {
                    if (parser.getCurrentToken() == JSONToken.START_OBJECT) {
                        inv = (Status_Pedido)parser.readValueAs(Status_Pedido.class);
                    }
                }
                system.debug('Retorno de gravacao:' + inv.status);
                
                if (inv.status != 'Unmodified') {
                    // Jogar as informações para Lista de Venda_Especial_Basico            
                    Venda_Especial_Basico c = new Venda_Especial_Basico();
                    c.ID_Professor = b.Professor__c;
                    c.ID_Titulo = b.Titulo__c;
                    c.ID = b.ID;
                    Cortesia_Basico.add(c);
                }    
            }
            
            if (Cortesia_Basico.size()>0) {
                //  Aqui se faz se marca os itens que já foram integrados
                for (Venda_Especial_Basico CadaCortesia: Cortesia_Basico) {
                    try {
                        Produtos_com_desconto__c Cortesia_Original = new Produtos_com_desconto__c();
                        Cortesia_Original.Titulo__c = CadaCortesia.ID_Titulo;
                        Cortesia_Original.Professor__c = CadaCortesia.ID_Professor;
                        Cortesia_Original.ID = CadaCortesia.ID;
                        Cortesia_Original.Integrado__c = true;
                        update Cortesia_Original;
                     } catch(DmlException e) {
                         system.debug('Problema de atualização de ' + CadaCortesia.ID );
                     }     
                }
            }    
        }    
    }   
    
    @future (callout=true)
    public  static void ConsultarCortesiaNoEcommerce() {  
    /*
    Exemplo de instancia 
    Venda_Especial_Job A = new Venda_Especial_Job();
    A.ConsultarCortesiaNoEcommerce();   
    
    Alterado para:
    Venda_Especial_Job.ConsultarCortesiaNoEcommerce();
    
    System.schedule('Process Amostra at 10 Hours','0 10 * * * ?',new Venda_Especial_Job.ConsultarCortesiaNoEcommerce());
	System.schedule('Process Amostra at 20 Hours','0 20 * * * ?',new Venda_Especial_Job.ConsultarCortesiaNoEcommerce());
	System.schedule('Process Amostra at 30 Hours','0 30 * * * ?',new Venda_Especial_Job.ConsultarCortesiaNoEcommerce());
	System.schedule('Process Amostra at 40 Hours','0 40 * * * ?',new Venda_Especial_Job.ConsultarCortesiaNoEcommerce());
	System.schedule('Process Amostra at 50 Hours','0 50 * * * ?',new Venda_Especial_Job.ConsultarCortesiaNoEcommerce());
	System.schedule('Process Amostra at 00 Hours','0 00 * * * ?',new Venda_Especial_Job.ConsultarCortesiaNoEcommerce());
    */
        
    String retorno;
    String body;
    //--------------------------------------------------------------------------
    HTTPExterno portal = new HTTPExterno();
    body = '';
    system.debug(body);
    retorno = portal.getContent(Constants.VENDAESPECIAL_ESB_URL + '/Get_Status_window','POST', 'application/x-www-form-urlencoded',body);
    system.debug( retorno);
    //--------------------------------------------------------------------------
    retorno = retorno.replace('<?xml version="1.0" encoding="utf-8"?>', '');  
    retorno = retorno.replace('<string xmlns="http://tempuri.org/">', '');    
    retorno = retorno.replace('</string>', '');    
    system.debug('retorno = ' + retorno);
    //--------------------------------------------------------------------------
    JSONParser parser = JSON.createParser(retorno);
        
        Venda_Especial_Retorno inv = new Venda_Especial_Retorno();
        
        while (parser.nextToken() != null) {
            if (parser.getCurrentToken() == JSONToken.START_OBJECT) {
                inv = (Venda_Especial_Retorno)parser.readValueAs(Venda_Especial_Retorno.class);
            }
        }
        /*
        {"Status":null,
        "Data":[{
        "CPF":"17817062803",
        "ISBN":"9788587918918",
        "Cod_Campanha":"364",
        "Adquirido":"True",
        "PedidoSite":"1122503",
        "Numero_Pedido":"",
        "Numero_NF":"",
        "Forma_pagamento":""}
        ]}
        */
        
        // Verica se tem algo 
        if (inv.Data.size() > 0) {
            //  Gravar e altera status
            integer i;
            for (i=0;i<inv.Data.Size();i++) {   
                system.debug('DATA:' + inv.Data[i]);
                // ISBN do Produto
                Product2 Produto = [SELECT ID FROM Product2 WHERE BR_ISBN__c =: inv.Data[i].ISBN];
                // CPF do Professor
                
                Contact  Professor = [SELECT ID FROM Contact WHERE BR_CPF__c =: Ferramentas.CPF_template(inv.Data[i].CPF)]; 
                system.debug('Produto ID:' + Produto.ID);
                system.debug('Professor ID:' + Professor.ID);
                system.debug('Cod_Campanha ID:' + inv.Data[i].Cod_Campanha);
                
                try {
                // Procurar esta cortesia o ID 
                Produtos_com_desconto__c Cortesia_Desconto_Escontrado = [SELECT ID FROM Produtos_com_desconto__c WHERE (Professor__c =: Professor.ID) and (Titulo__c =: Produto.ID) and (Desconto__c =: integer.valueof(inv.Data[i].Cod_Campanha))]; 
                system.debug('===>' + Cortesia_Desconto_Escontrado)  ; 
                if (Cortesia_Desconto_Escontrado != NULL) {

                    system.debug ('Cortesia_Desconto_Econtrado:' + Cortesia_Desconto_Escontrado.ID );
                    
                    //Produtos_com_desconto__c Cortesia_Desconto_Item = new Produtos_com_desconto__c();
                    //Cortesia_Desconto_Item.Produto_Adquirido__c = trocar_sim_nao(inv.Data[i].Adquirido);
                    //Cortesia_Desconto_Item.Pedido_Site__c = inv.Data[i].PedidoSite;
                    //Cortesia_Desconto_Item.Desconto__c = inv.Data[i].Cod_Campanha;
                    //Cortesia_Desconto_Item.Desconto__c = inv.Data[i].Numero_Pedido;
                    //Cortesia_Desconto_Item.Desconto__c = inv.Data[i].Numero_SAP;
                   
                    if (Cortesia_Desconto_Escontrado.ID != NULL) {
                        //  Realizar a atualização 75%
                        Cortesia_Desconto_Escontrado.Pedido_Site__c = inv.Data[i].PedidoSite;
                        Cortesia_Desconto_Escontrado.Produto_Adquirido__c =Ferramentas.trocar_sim_nao(inv.Data[i].Adquirido);
                        system.debug('inv.Data[i].Adquirido) =' + Ferramentas.trocar_sim_nao(inv.Data[i].Adquirido));
                        Cortesia_Desconto_Escontrado.Numero_Pedido__c = inv.Data[i].Numero_Pedido;
                        Cortesia_Desconto_Escontrado.Numero_SAP__c = inv.Data[i].Numero_SAP;
                        try { 
                            update Cortesia_Desconto_Escontrado;
                        } catch (DmlException e) {
                            system.debug('Erro - Update item de 75%');
                        }    
                    } else{
                        if ((Produto.ID != NULL) && (Professor.ID != NULL)) {
                            // Realizar o inserter de 40% e 50%
                            Cortesia_Desconto_Escontrado.Titulo__c = Produto.ID;
                            Cortesia_Desconto_Escontrado.Professor__c = Professor.ID ;
                            
                            Cortesia_Desconto_Escontrado.Pedido_Site__c = inv.Data[i].PedidoSite;
                            Cortesia_Desconto_Escontrado.Produto_Adquirido__c = 'Sim';
                            Cortesia_Desconto_Escontrado.Numero_Pedido__c = inv.Data[i].Numero_Pedido;
                            Cortesia_Desconto_Escontrado.Numero_SAP__c = inv.Data[i].Numero_SAP;
                            Cortesia_Desconto_Escontrado.Pedido_Site__c = inv.Data[i].PedidoSite;
                            try { 
                                // upsert Cortesia_Desconto_Escontrado Pedido_Site__c;
                                insert Cortesia_Desconto_Escontrado;
                            } catch (DmlException e) {
                                system.debug('Erro - Insert item de 40% ou 50%');
                            }
                        }
                    }
              }   
              // Aqui  
              } catch (Exception e) {
                    system.debug('Cortesia nao encontrado');
              }
            }
                
        }    
    }
  
    public class Status_Pedido {
        public String status {get;set;}
        public List<Datum> Data {get;set;}
   }
     
    public class Venda_Especial_Basico {
        public String ID_Professor;
        public String ID_Titulo;
        public String ID;
    }
        
    public class  Venda_Especial_Retorno {
        public String status {get;set;}
        public List<Datum> Data {get;set;}
    
        public Venda_Especial_Retorno () {
        }
    }
    
    public class Datum {
        public String CPF;
        public String ISBN;
        public String Cod_Campanha;
        public String Adquirido;
        public String PedidoSite;
        public String Numero_Pedido;
        public String Numero_SAP;
        public String Forma_Pagamento;
    }
   
}