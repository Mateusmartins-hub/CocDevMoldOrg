@isTest
public with sharing class TaskTriggerTest {

    @isTest
    public static void testOne() {
		 Map<Id, Lead> mapLead = New Map<Id, Lead>();
        Lead l = new Lead();
        l.LastName = 'Test';
        l.Company = 'Test';
        l.CPF__c = '99276049045';
        l.TipoPessoa__c = 'Física';
        l.DataNascimento__c = Date.today();
        insert l;


        Task t = new Task();
        t.WhoId = l.Id;
        l.cnpj__c = '28.826.127/0001-83';
        t.Rua__c = 'Jose de A. R. Jose';
        insert t;

        t.Rua__c = 'Joao Carlos';
        t.Estado__c = 'MG';
        t.NomeDaEscola__c = 'João Simões';
        t.JaEParceiroPearson__c = true;
        t.cnpj__c = '56.027.062/0001-41';
        t.Cidade__c = 'Campinas';
        update t;

        Lead lNovo = [select Street,State,NomeEscola__c,ParceiroPearson__c,CNPJ__c,City,TrabalhaComMaterialDeIngles__c from Lead where Id = :l.Id];
        /*System.assert(lNovo.Street == 'Joao Carlos');
        System.assert(lNovo.State == 'MG');
        System.assert(lNovo.NomeEscola__c == 'João Simões');
        System.assert(lNovo.ParceiroPearson__c == true);
        System.assert(lNovo.CNPJ__c == '56.027.062/0001-41');
        System.assert(lNovo.City == 'Campinas');*/
        list<lead> lstLead = new list<lead>();
        lstLead.add(l);
       	mapLead.put(l.Id, l);
        LeadTask.insereTarefa(lstLead, mapLead);
    }

}