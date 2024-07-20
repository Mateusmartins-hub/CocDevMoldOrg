@IsTest
public class PesquisaSatisfacaoCasoControllerTest {
    @TestSetup
    static void makeData() {
        GrupoSolucionador__c gs = TestHelper.createGrupoSolucionador();
        insert gs;
        
        Account acc = TestHelper.createAccount();
        insert acc;
        
        Case cs = new Case();
        cs.Subject = 'Pesquisa de satisfação';
        cs.Tipo__c = 'Contrato';
        cs.Subtipo__c = 'Distrato';
        cs.AreaDonaProcesso__c = 'Financeiro';
        cs.AccountId = acc.Id;
        insert cs;
    }
    
    @IsTest
    static void saveRateTest() {
        Case cs = [SELECT Id FROM Case LIMIT 1];
        PesquisaSatisfacaoCasoController.saveRate(cs.Id, 5);
    }
}