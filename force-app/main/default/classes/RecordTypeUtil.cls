/**
* Classe responsável por fornecer informações dos record types dos objetos.
* @author Felipe Jesus Silva. 
*/
public class RecordTypeUtil 
{
	//map que armazena os tipos de registro por objeto
	private Map<String, List<Schema.RecordtypeInfo>> mapRecordTypesPorObjeto;
	
	//armazena os tipos de registro por id
	private Map<Id, Schema.RecordtypeInfo> mapRecordTypePorId;
	
	//armazena os tipos de registros por nome (nome do objeto + nome do tipo de registro)
	private Map<String, Schema.RecordtypeInfo> mapRecordTypePorNome;
	
	public static final RecordTypeUtil instance = new RecordTypeUtil();
	
	private RecordTypeUtil()
	{	
		this.mapRecordTypesPorObjeto = new Map<String, List<Schema.RecordtypeInfo>>();
		this.mapRecordTypePorId = new Map<Id, Schema.RecordtypeInfo>();		
		this.mapRecordTypePorNome = new Map<String, Schema.RecordtypeInfo>();
	}
	
	public static RecordTypeUtil getInstance()
	{
 		return instance;
	}
	
	public Schema.RecordtypeInfo getRecordTypePorNome(String nomeObjeto, String nomeTipoRegistro)
	{
		Schema.RecordtypeInfo recordType = null;
				
		if(!this.mapRecordTypesPorObjeto.containsKey(nomeObjeto))
		{
			this.armazenarRecordTypes(nomeObjeto);	
		}
		
		recordType = this.mapRecordTypePorNome.get(nomeObjeto + nomeTipoRegistro);
		
		return recordType;
	}
	
	public List<Schema.RecordtypeInfo> getRecordTypesPorNome(String nomeObjeto, List<String> lstNomesTipoRegistro)
	{
		Schema.RecordtypeInfo recordType = null;
		List<Schema.RecordtypeInfo> lstRecordTypes = new List<Schema.RecordtypeInfo>();
				
		if(!this.mapRecordTypesPorObjeto.containsKey(nomeObjeto))
		{
			this.armazenarRecordTypes(nomeObjeto);	
		}
		
		for(String nomeTipoRegistro : lstNomesTipoRegistro)
		{
			recordType = this.mapRecordTypePorNome.get(nomeObjeto + nomeTipoRegistro);	
			
			lstRecordTypes.add(recordType);
		}
			
		return lstRecordTypes;
	}
		
	public List<Schema.RecordtypeInfo> getTodosRecordTypes(String nomeObjeto)
	{
		List<Schema.RecordtypeInfo> lstRecordTypes = null;
			
		if(!this.mapRecordTypesPorObjeto.containsKey(nomeObjeto))
		{
			this.armazenarRecordTypes(nomeObjeto);	
		}
		
		lstRecordTypes = this.mapRecordTypesPorObjeto.get(nomeObjeto);
		
		return lstRecordTypes;
	}
	
	public Schema.RecordtypeInfo getRecordTypePorId(String nomeObjeto, Id idRecordType)
	{
		Schema.RecordtypeInfo recordType = null;
				
		if(!this.mapRecordTypesPorObjeto.containsKey(nomeObjeto))
		{
			this.armazenarRecordTypes(nomeObjeto);	
		}
		
		recordType = this.mapRecordTypePorId.get(idRecordType);
			
		return recordType;
	}
	
	private void armazenarRecordTypes(String nomeObjeto)
	{		
		Schema.DescribeSObjectResult describe = getDescribe(nomeObjeto);
		
		this.mapRecordTypesPorObjeto.put(describe.getName(), describe.getRecordTypeInfos());
		
		this.mapRecordTypePorId.putAll(describe.getRecordTypeInfosById());
		
		for(Schema.RecordtypeInfo recordTypeInfo : describe.getRecordTypeInfos())
		{
			//adiciona no map todos os record types desse objeto mapeado por nome (a concatenação do nome do objeto + o nome do recortype é feita para
			//garantir a unicidade da chave, pois pode existir para objetos diferentes, record types com o mesmo nome)*/			
			this.mapRecordTypePorNome.put(describe.getName() + recordTypeInfo.getName(), recordTypeInfo);
		}		
	}
	
	private static Schema.DescribeSObjectResult getDescribe(String nomeObjeto)
	{
		Type tipo = Type.forName(nomeObjeto);		
		SObject sObj = (SObject) tipo.newInstance();	
		Schema.SobjectType tipoSObj = sObj.getSObjectType();
		Schema.DescribeSObjectResult describe = tipoSObj.getDescribe();
		
		return describe;
	}
	
}