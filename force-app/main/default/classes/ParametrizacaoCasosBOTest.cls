@isTest
public class ParametrizacaoCasosBOTest {

    @isTest
    static void testOne() {
        ParametrizacaoCasos__c p = new ParametrizacaoCasos__c();
        p.RecordTypeId = Schema.SObjectType.ParametrizacaoCasos__c.getRecordTypeInfosByDeveloperName().get('Customizado').getRecordTypeId();
        p.Tipo__c = 'Cadastro';
        p.Subtipo__c = 'Novo Cadastro';
        p.Detalhamento__c = 'Devoluções';
        p.TipoRegistroCaso__c = 'Devoluções';
        p.GrupoSolucionador1__c = 'Customer Care';
        insert p;
        update p;
        
        try{
            ParametrizacaoCasos__c p2 = new ParametrizacaoCasos__c();
            p2.RecordTypeId = Schema.SObjectType.ParametrizacaoCasos__c.getRecordTypeInfosByDeveloperName().get('Customizado').getRecordTypeId();
            p2.Tipo__c = 'Cadastro';
            p2.Subtipo__c = 'Novo Cadastro';
            p2.Detalhamento__c = 'Devoluções';
            p2.TipoRegistroCaso__c = 'Devoluções';
            p2.GrupoSolucionador1__c = 'Customer Care';
            insert p2;            
        }catch(Exception ex){
            system.debug(ex.getMessage());
        }
    }
}