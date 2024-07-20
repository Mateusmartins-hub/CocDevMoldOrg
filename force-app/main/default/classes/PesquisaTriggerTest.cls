@isTest
public with sharing class PesquisaTriggerTest {
@isTest
    public static void testValidaSegmento() {

    try{        
            
            Id RecTypeAcc = RecordTypeUtil.getInstance().getRecordTypePorNome('Account', 'Pessoa Jurídica').getRecordTypeId();
            Account acc = new Account();
            acc.RecordTypeId = RecTypeAcc;
            acc.Name = 'Nome';
            acc.BR_cnpj__c = '23.724.500/0001-71';
            acc.BR_Account_email__c = 'l@a.com';
            insert acc;

            Id RecTypePesquisa = RecordTypeUtil.getInstance().getRecordTypePorNome('BR_Pesquisa__c', 'Pesquisa de Mercado').getRecordTypeId();
            BR_Pesquisa__c p = new BR_Pesquisa__c();
            p.NumeroDeAlunosPorSegmento__c = 'EI;EF1;EF2;EM;PV';
            p.BR_Conta__c = acc.Id;
            insert p;
            //System.AssertEquals('EI;EF1;EF2;EM;PV', 'sd');
        }catch(Exception e){
            Boolean expectedExceptionThrown =  e.getMessage().contains('Quantidade de Alunos') ? true : false;
            System.AssertEquals(expectedExceptionThrown, true);
        }

    }

    @isTest
    public static void testUpdatePesquisa() {

    try{        
            
            Id RecTypeAcc = RecordTypeUtil.getInstance().getRecordTypePorNome('Account', 'Pessoa Jurídica').getRecordTypeId();
            Account acc = new Account();
            acc.RecordTypeId = RecTypeAcc;
            acc.Name = 'Nome';
            acc.BR_cnpj__c = '23.724.500/0001-71';
            acc.BR_Account_email__c = 'l@a.com';
            insert acc;

            Id RecTypePesquisa = RecordTypeUtil.getInstance().getRecordTypePorNome('BR_Pesquisa__c', 'Pesquisa de Mercado').getRecordTypeId();
            BR_Pesquisa__c p = new BR_Pesquisa__c();
            p.BR_Conta__c = acc.Id;
            insert p;


            update p;


        }catch(Exception e){
            Boolean expectedExceptionThrown =  e.getMessage().contains('Quantidade de Alunos') ? true : false;
            System.AssertEquals(expectedExceptionThrown, true);
        }

    }
}