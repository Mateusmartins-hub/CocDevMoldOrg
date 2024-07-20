@isTest
private class AccountDAOTest {

    static testMethod void myUnitTest() {
        Account conta = new Account();
        conta.Name = 'Conta Teste';
        insert conta;
        
        List<String> lListStr = new List<String>();
        List<Account> listAcc = AccountDAO.getListAccountsByIdSAPIdSSA(lListStr, lListStr);
        AccountDAO.buscarContasErroIntegracao();
        AccountDAO.buscaConta(conta.Id);
        AccountDAO.buscaContas(new Set<id> { conta.Id });
    }
}