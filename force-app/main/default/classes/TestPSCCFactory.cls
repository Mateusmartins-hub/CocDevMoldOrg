@isTest
public without sharing class TestPSCCFactory {
    public static Account criarConta(){
        RecordType rt = [SELECT id FROM RecordType WHERE Name = 'Pessoa Física' AND SobjectType = 'Account' LIMIT 1];
        Account conta = new Account();
        conta.recordTypeId = rt.id;
        conta.currencyIsoCode = 'BRL';
        conta.name = 'Teste';
        insert conta;
        return conta;
    }
    public static Contact criarContato(Account conta){
        Contact contato = new Contact();
        contato.currencyIsoCode = 'BRL';
        contato.accountId = conta.id;
        contato.LastName = 'Teste';
        contato.Email = 'teste@mail.com.br';
        insert contato;
        return contato;
    }
    public static Case criarCaso(Account conta, Contact contato){
        RecordType rt = [SELECT id FROM RecordType WHERE Name = 'Padrão' AND SobjectType = 'Case' LIMIT 1];
        Case caso = new Case();
        caso.RecordTypeId = rt.id;
        caso.currencyIsoCode = 'BRL';
        caso.Subject = 'Teste';
        caso.AccountId = conta.id;
        caso.ContactId = contato.id;
        insert caso;
        return caso;
    }
    public static Avalia_o__c criarAvaliacao(Case caso, Boolean flag){
        Avalia_o__c avaliacao = new Avalia_o__c();
        avaliacao.currencyIsoCode = 'BRL';
        avaliacao.flag__c = flag;
        avaliacao.caso__c = caso.id;
        insert avaliacao;
        return avaliacao;
    }
}