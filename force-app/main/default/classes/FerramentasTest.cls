@isTest
private class FerramentasTest {
        static testMethod void myUnitTest() {
        	String cpf = Ferramentas.CPF_template('32860077812');
        	String teste = Ferramentas.NumeroApenas(cpf);
        	String cpf1 = Ferramentas.CPF_template('328600');
        	String sim = Ferramentas.trocar_sim_nao('True');
        	String nao = Ferramentas.trocar_sim_nao('False');
        	String id = Ferramentas.Conta_do_Contato('TEstes');
        	
        	Ferramentas.Endereco endereco = new Ferramentas.Endereco();
        	endereco.Logradouro = 'Sinimbu';
        	endereco.Numero = '148';
        	endereco.Complemento = 'Ap 43';
        	endereco.Bairro = 'Liberdade';
        	endereco.Cidade = 'São Paulo';
        	endereco.UF = 'SP';
        	endereco.CEP = '01507-010';
        	endereco.Pais ='Brasil';
        	
        }
}