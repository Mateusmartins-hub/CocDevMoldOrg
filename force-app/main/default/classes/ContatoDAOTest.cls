@IsTest
public class ContatoDAOTest {
    @isTest static void testar() {
        Contact ctc = TestHelper.createContact();
        Insert ctc;       
        
        ContatoDAO.getListContactById(ctc.Id);
        ContatoDAO.buscaContato(ctc.Id);
        ContatoDAO.getEmailListContactById(ctc.Id);
        ContatoDAO.buscaEmail(ctc.Id);
    }
}