public with sharing class AmostraVirtualBO {
	
	private static final AmostraVirtualBO instance = new AmostraVirtualBO();
  
    private AmostraVirtualBO(){}
   
    public static AmostraVirtualBO getInstance(){
        return instance;
    }
    
    public void gerarLink(List<Amostra_Virtual__c> lstAV){
    	// Validar alterada para 1 anos (360 dia) - Robinson Mioshi
    	String sData = DateTime.now().addDays( 360 ).format( 'yyyyMMdd' );
    	String sLink = 'https://amostras.bv3.digitalpages.com.br/user_session/authenticated_token?token={0}&isbn={1}&cpf={2}&date={3}&type=1&html5=true';
    	
    	for(Amostra_Virtual__c av: lstAV){
    		List<Contact> lCPF = ContatoDAO.getListContactById(av.Individuo__c);

			if(lCPF[0].BR_CPF__c == null || lCPF[0].BR_CPF__c == ''){
				av.adderror('CPF inválido para este professor!');
			}else if(av.ISBN__c == null || av.ISBN__c == ''){
				av.adderror('ISBN não cadastrado para este produto!');
			}else{    		
	    		String sCPF = trataCPF(lCPF[0].BR_CPF__c);
	    		String sISBN = av.ISBN__c;
	    		String sMD5 = calcularMD5( sISBN, sData, sCPF);
				
				sLink = sLink.replace('{0}', sMD5);
				sLink = sLink.replace('{1}', sISBN);
				sLink = sLink.replace('{2}', sCPF);
				sLink = sLink.replace('{3}', sData);
			    	
    			av.Link__c = sLink;
			}
    	}
    }
    
    private String calcularMD5(String ISBN, String Data, String CPF ){
		String TOKEN = '94e310985841949d9c';
		
		return EncodingUtil.convertToHex( Crypto.generateDigest( 'MD5', Blob.valueOf( 
		  ISBN + CPF + Data + TOKEN)));
	}
	
	private string trataCPF(String CPF){
		CPF = CPF.replace('.','');
		CPF = CPF.replace('-','');
		return CPF;
	}
}