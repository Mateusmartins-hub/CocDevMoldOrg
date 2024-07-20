@isTest
public class ReabrirCasoControllerTest {

    @isTest
    static void shouldReopenCase() {

        User user = new User();
        user.Username = 'test.reabrirCaso@test.com';
        user.Email = 'test.reabrirCaso@test.com';
        user.FirstName = 'Test';
        user.LastName = 'Reabrir Caso';
        user.Alias       = 'NLast34';
		user.ProfileId = [SELECT Id FROM Profile WHERE Name = 'Pearson Brasil Perfil' LIMIT 1].Id;
        user.TimeZoneSidKey    = 'GMT';
        user.LocaleSidKey    = 'en_Us';
        user.LanguageLocaleKey = 'en_Us';
        user.EmailEncodingKey  = 'ISO-8859-1';
        insert user;
        
        Account conta = new Account();
        conta.Name = 'Conta Teste';
        insert conta;
        
        Case caso = new Case();
        caso.AccountId = conta.Id;
        caso.Subject = 'test';
        caso.Description = 'test';
        insert caso;

        Case casoInserido = [SELECT Id, Status, ReabertoEmail__c FROM Case WHERE Id =: caso.Id];
        System.assertNotEquals('Reaberto', casoInserido.Status);
        System.assertNotEquals(true, casoInserido.ReabertoEmail__c);
        
        System.runAs(user){
            ApexPages.currentPage().getParameters().put('id', caso.Id);
            ReabrirCasoController con = new ReabrirCasoController();
            con.reabrirCaso();
        }

        Case casoReaberto = [SELECT Id, Status, ReabertoEmail__c FROM Case WHERE Id =: caso.Id];
        System.assertEquals('Reaberto', casoReaberto.Status);
        System.assertEquals(true, casoReaberto.ReabertoEmail__c);
        
    }
}