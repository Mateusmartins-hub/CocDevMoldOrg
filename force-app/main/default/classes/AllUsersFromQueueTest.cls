@isTest
public class AllUsersFromQueueTest {

    @isTest
    static void TestOne() {       
        Account conta = new Account();
        conta.Name = 'Conta Teste';
        insert conta;
        
        Case caso = new Case();
        caso.AccountId = conta.Id;
        caso.Subject = 'test';
        caso.Description = 'test';
        insert caso;
        
        AllUsersFromQueue users = new AllUsersFromQueue();
        Map<Id, Set<Id>> usuariosDoGrupo = users.getUsers(null, new Set<Id> {caso.OwnerId});
        
        AllUsersFromQueue.isUserOnQueue(caso.OwnerId);
    }
}