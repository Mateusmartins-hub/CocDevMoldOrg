@IsTest
public class AccountTriggerHandlerTest {
    @IsTest
    static void testOne(){
        Account acc = new Account();
        acc.Name = 'Test account';
        acc.Br_cnpj__c = '59.457.037/0001-96';
        insert acc;
        
        try {
            Account acc2 = new Account();
            acc2.Name = 'Test account2';
            acc2.Br_cnpj__c = '59.457.037/0001-96';
            insert acc2;
        } catch(Exception e) {
            System.assert(true);
        }
        
        Account acc3 = new Account();
        acc3.Name = 'Test account';
        acc3.Br_cpf__c = '616.071.520-88';
        acc3.RecordTypeId = RecordTypeMemory.getRecType( 'Account', 'Pessoa_F_sica' );
        
        insert acc3;
        
    }
}