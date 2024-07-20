public class AmostraFisicaDataRequest {
	
    public String VTWEG;
	public String VKORG;
	public String VKBUR;
	public String VDATU;
	public List<TG_CONDITIONS> TG_CONDITIONS;
	public List<TG_BAPISDITM> TG_BAPISDITM;
	public String SERIES;
	public String RG;
	public String RAZAO_SOCIAL;
	public String PYMT_METH;
	public String PF_RECEBEDOR;
	public String PF_EMISSOR;
	public String PAIS;
	public String OBS;
	public String NUMERO;
	public String NOME_FANTASIA;
	public String NFNUM;
	public String KVGR2;
	public String KVGR1;
	public String KOSTL;
	public String INCO2;
	public String INCO1;
	public String FRETE;
	public String FONE;
	public String ESTADO;
	public String ENTREGA;
	public String ENDERECO;
	public String EMAIL;
	public String DZTERM;
	public String DTA_CADASTRO;
	public String COND_PAGTO;
	public String COMPLEMENTO;
	public String COMPLEM;
	public String CNPJ_CPF_RECEBEDOR;
	public String CNPJ_CPF_EMISSOR;
	public String CIDADE;
	public String CEP;
	public String BSTKD;
	public String BSTDK1;
	public String BAIRRO;
	public String AUART;
    
	public class TG_BAPISDITM {
		public String USAGE_IND;
		public String TARGET_QTY;
		public String STORE_LOC;
		public String PURCH_DATE;
		public String PLANT;
		public String MATERIAL;
		public String INCOTERMS2;
		public String INCOTERMS1;
		public String BILL_DATE;
	}

	public class TG_CONDITIONS {
        
	}
	
	public static AmostraFisicaDataRequest parse(String json) {
		return (AmostraFisicaDataRequest) System.JSON.deserialize(json, AmostraFisicaDataRequest.class);
	}
    
    public static String unparse(AmostraFisicaDataRequest req) {
        return (String)System.JSON.serialize(req);
    }
    
    public static AmostraFisicaDataRequest makeDataRequest(Opportunity op, AmostraFisica__c af) {
		AmostraFisicaDataRequest r = new AmostraFisicaDataRequest();
        
        r.VTWEG = '1';
        r.VKORG = 'OVE7';
        r.VKBUR = 'EV01';
        r.VDATU = DateTime.Now().Format('yyyyMMdd');
        r.SERIES = '';
        r.RG = isEmpty(op.Account.BR_tax_registration_number__c);
        r.RAZAO_SOCIAL = isEmpty(op.Account.BR_RazaoSocial__c);
        r.PYMT_METH = '';
        r.PF_RECEBEDOR = '';
        r.PF_EMISSOR = 'X';
        r.PAIS = 'BR';
        r.OBS = 'AOS CUIDADOS: ' + isEmpty(op.BR_Contact__r.Account.Name);
        r.NUMERO = isEmpty(op.Account.BR_Main_Nbr__c);
        r.NOME_FANTASIA = isEmpty(op.Account.Name);
        r.NFNUM = '';
        r.KVGR2 = DateTime.Now().Format('yyyyMMdd');
        r.KVGR1 = '7';
        r.KOSTL = op.CreatedBy.CentroCusto_SAP__c;
        r.INCO2 = isEmpty(op.Account.BR_Main_State__c) + '/' + isEmpty(op.Account.BR_Main_City__c);
        r.INCO1 = 'CIF';
        r.FRETE = '0';
        r.FONE = isEmpty(String.valueOf(op.Account.BR_Area_code__c)) + isEmpty(removeSpecialChars(op.Account.Phone));
        r.ESTADO = isEmpty(op.Account.BR_Main_State__c);
        r.ENTREGA = buildAddress(op);
        r.ENDERECO = isEmpty(op.Account.BR_Main_Address__c);
        r.EMAIL = isEmpty(op.Account.BR_Account_email__c);
        r.DZTERM = 'Z000';
        r.DTA_CADASTRO = op.CreatedDate == null ? '' : op.CreatedDate.format('yyyyMMdd');
        r.COND_PAGTO = 'Z000';
        r.COMPLEMENTO = isEmpty(op.Account.BR_Main_Complement__c);
        r.COMPLEM = '0';
        r.CNPJ_CPF_RECEBEDOR = '';
        r.CNPJ_CPF_EMISSOR = removeSpecialChars(op.Account.BR_CNPJ_CPF__c);
        r.CIDADE = isEmpty(op.Account.BR_Main_City__c);
        r.CEP = isEmpty(op.Account.BR_Main_Zip_code__c);
        r.BSTKD = isEmpty(op.Id);
        r.BSTDK1 = DateTime.Now().Format('yyyyMMdd');
        r.BAIRRO = isEmpty(op.Account.BR_Main_District__c);
        r.AUART = 'ZEXE';
        
        r.TG_BAPISDITM = buildItems(af);
        
        return r;
	}
    
    private static List<TG_BAPISDITM> buildItems(AmostraFisica__c af) {
        List<TG_BAPISDITM> items = new List<TG_BAPISDITM>();
        
        for(ItemAmostraFisica__c item : AmostraFisicaDAO.getAmostrasFisicasItensById(new Set<Id> {af.Id}).get(af.Id)) {
            TG_BAPISDITM i = new TG_BAPISDITM();
            
            i.MATERIAL = item.Produto__r.BR_Product_Code__c == null ? '' : item.Produto__r.BR_Product_Code__c.leftPad(18, '0');
            i.TARGET_QTY = String.valueOf(item.Quantidade__c);
            i.PURCH_DATE = af.CreatedDate == null ? '' : af.CreatedDate.format('yyyyMMdd');
            i.PLANT = 'PE21';
            i.BILL_DATE = '';
            i.USAGE_IND = '001';
            i.STORE_LOC = '';
            i.INCOTERMS1 = '';
            i.INCOTERMS2 = '';
            
            items.add(i);
        }
        
        return items;        
    }
    
    private static String buildAddress(Opportunity op) {
        String endereco = isEmpty(op.Account.BR_Main_Address__c) + ' ';
        endereco += isEmpty(op.Account.BR_Main_Nbr__c) + ' ';
        endereco += isEmpty(op.Account.BR_Main_Complement__c) + ' ';
        endereco += isEmpty(op.Account.BR_Main_District__c) + ' ';
        endereco += isEmpty(op.Account.BR_Main_City__c) + '-';
        endereco += isEmpty(op.Account.BR_Main_State__c) + ' ';
        endereco += isEmpty(op.Account.BR_Main_Zip_code__c) + ' ';
        
        return endereco;
    }
    
    private static String isEmpty(String valor) {
        return String.isBlank(valor) ? '' : valor;
    }
    
    private static string removeSpecialChars(String texto) {  
        if(String.IsBlank(texto))
            return texto;
        
        return texto.replaceAll('[|,|.|/|\\,||"||:|~|!|@|#|$|%|^|&|*|_|-|-|+|=|<|>|?|\\(|\\)|\\{|\\}|\\;|\\\'"]', '');
    } 
}