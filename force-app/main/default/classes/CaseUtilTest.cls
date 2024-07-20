@isTest
public class CaseUtilTest {
	@isTest
    static void Contagem(){
        Account acct = new Account(
            Name='TestAccount',
            BR_Account_email__c = 'Teste@gmail.com',
            BR_cnpj__c = '17.078.284/0001-31'
        );
        insert acct;
        Contact cct = new Contact(
            LastName = 'TestCont',
            AccountId=acct.Id
        );
        insert cct;
        Case teste = new Case(
            ContactId = cct.id,
            Description = 'Teste',
            Resumo_inf__c = 'É um teste',
            Subject = 'É realmente um teste',
            MarcaAtendimento__c = 'COC',
            Origin = 'Chat',
            Status = 'Novo',
            Tipo__c = 'Atendimento',
            Type = 'Atendimento',
            Subtipo__c= 'Suporte',
            TipoSolicitacao__c = 'Solicitação',
            Tipo_de_Solicita_o__c = 'Instabilidade',
            ContarReabertura__c = 0
        );
        	insert teste;
        	teste.Status = 'Fechado';
        	update teste;
        	teste.ReabertoEmail__c = true;
        	teste.Status = 'Reaberto';
        	Update teste;
    }
}