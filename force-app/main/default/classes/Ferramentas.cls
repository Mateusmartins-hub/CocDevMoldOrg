/**
 *
 * Class Ferramentas  - 03/09/2014 - Robinson Mioshi
 * 
 */
global  class Ferramentas {
	
    global static  String NumeroApenas(String Texto) {   
        Texto = Texto.replaceAll('[^\\w\\*]', '');
        return Texto;
    }    
    
    global static  String CPF_template(String CPF_numero) { 
        if ((CPF_numero.length() == 11) ) {
            return CPF_numero.substring(0, 3) + '.' + CPF_numero.substring(3,6)+ '.' +  CPF_numero.substring(6, 9) + '-' + CPF_numero.substring(9,11);
        } else {
            return '0';
        }
    } 
    
    global static string trocar_sim_nao(String a) { 
        if (a == 'True') {
            return 'Sim';
        } else {
        	return 'Não';            
        }   
    } 
    
    global static String Conta_do_Contato (String Contato_ID) {
        //SELECT AccountId,Id FROM Contact WHERE Id = '0031100000CU7aI'
        /*
        List<Contact> Contato =  [SELECT AccountID FROM Contact WHERE ID=: Contato_ID]; 
        if (Contato.Size() == 1) {
            return Contato[0].AccountID;
        } else {
            return 0;
        }
		*/
        return '0';
        
    }
    
    //  Trazer os dados da Conta (ID)
    
    

    //  Trazer os Conta relacionado ao Contado (ID do Contato)
    
    public class Endereco {
        public String Logradouro;
        public String Numero;
        public String Complemento;
        public String Bairro;
        public String Cidade;
        public String UF;
        public String CEP;
        public String Pais;
    }
    
    public class Cliente {
        public String Nome_RazaoSocial;
        public String CPF_CNPJ;
        public String RG_IE;
        public String Email;
        public String Telefone;
    }    

    
    
}