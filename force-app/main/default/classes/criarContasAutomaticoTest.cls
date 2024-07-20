@isTest
public class criarContasAutomaticoTest {
    @isTest
    static void criarContasAutomaticoTest() {
        SolicitacaoCadastroCliente__c Scc = new SolicitacaoCadastroCliente__c(
            BR_RazaoSocial__c = 'Teste',
            BR_email__c = 'teste@gmail.com ',
            BR_CPF__c = '433.116.320-28',
            BR_CNPJ__c = '80.576.042/0001-04',
            BR_Phone__c = '(92)98635-6949',
            BR_Status__c = 'Rejeitado',
            Unidade__c = 'COC',
            BR_Main_City__c = 'Teste city',
            BR_Main_State__c = 'CE',
            BR_Bairro__c = 'Bairro teste',
            BR_Main_Address__c = 'rua teste', 
            BR_Main_Nbr__c = '0000',
            BR_Main_Complement__c = 'do lado do teste ',
            BR_Main_Zip_code__c = '48907-250'
        );
        	insert Scc;
        	Scc.TipoRegistroConta__c = '0125f000001BNLQAA4';
            Scc.BR_Status__c = 'Enviado para Integração';
        	update Scc;
    }

    @isTest
    static void atualizarContasAutomaticoPFisicaNDupTest(){
        SolicitacaoCadastroCliente__c Scc = new SolicitacaoCadastroCliente__c(
            BR_RazaoSocial__c = 'Teste',
            BR_email__c = 'teste@gmail.com ',
            BR_CPF__c = '433.116.320-28',
            Tipo_de_Pessoa__c = 'Pessoa Física',
            BR_Phone__c = '(92)98635-6949',
            BR_Status__c = 'Rejeitado',
            Unidade__c = 'COC',
            BR_Main_City__c = 'Teste city',
            BR_Main_State__c = 'CE',
            BR_Bairro__c = 'Bairro teste',
            BR_Main_Address__c = 'rua teste', 
            BR_Main_Nbr__c = '0000',
            BR_Main_Complement__c = 'do lado do teste ',
            BR_Main_Zip_code__c = '48907-250'
        );
        insert Scc;
		
        Account acc = new Account(Name='Teste', BR_CPF__c='433.116.320-28');
        insert acc;
        
        Scc.TipoRegistroConta__c = '0125f000001BNLQAA4';
        Scc.BR_Status__c = 'Enviado para Integração';
        Scc.BR_Conta__c = acc.id;
        update Scc;

        scc.BR_CPF__c = '362.108.580-74';

        update Scc;
        
    }
    
}