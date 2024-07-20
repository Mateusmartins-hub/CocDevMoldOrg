@isTest
public class AdocaoRecorrenteDAOTest {
    
    @isTest
    static void testQuery(){
        String query = 'SELECT Id FROM Account LIMIT 1';
        AdocaoRecorrenteDAO.getInstance().listarQuery(query);
    }

}