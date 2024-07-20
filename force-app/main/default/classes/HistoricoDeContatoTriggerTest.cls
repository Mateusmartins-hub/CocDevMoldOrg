@isTest
public with sharing class HistoricoDeContatoTriggerTest {

    @isTest
    public static void testOne() {

        Lead l = new Lead();
        l.LastName = 'Test';
        l.Company = 'Test';
        l.CPF__c = '99276049045';
        l.TipoPessoa__c = 'Física';
        l.DataNascimento__c = Date.today();
        insert l;

        HistoricoDeContato__c h = new HistoricoDeContato__c();
        h.Lead__c = l.Id;
        insert h;
       
        Lead lNovo = [select LigacaoRealizada__c from Lead where Id = :l.Id];
        //System.assert(lNovo.LigacaoRealizada__c == true);
    }

}