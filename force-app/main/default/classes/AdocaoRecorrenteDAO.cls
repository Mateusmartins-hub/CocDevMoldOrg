public class AdocaoRecorrenteDAO { 

	public AdocaoRecorrenteDAO() {}

	public static final AdocaoRecorrenteDAO instance = new AdocaoRecorrenteDAO();

	public static AdocaoRecorrenteDAO getInstance()
	{
		return instance;
	}
     
    public Database.QueryLocator listarQuery(String query) {
    	
        return Database.getQueryLocator(query); 
    }

}