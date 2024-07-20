public class AdocoesClonarLoteController{
    
    private final Adocoes_Cs__c adc;
    private Id accId;
    public String selAnoBase{get{return selAnoBase;}set{this.selAnoBase=value;}}
    public String selAnoClone{get{return selAnoClone;}set{this.selAnoClone=value;}}
    public List<String> selTipo{get{return selTipo;}set{this.selTipo=value;}}
    
    public AdocoesClonarLoteController(ApexPages.StandardController controller) {
    	accId = ApexPages.currentPage().getParameters().get('id');
        List<Adocoes_Cs__c> adc = [SELECT Id
               						FROM Adocoes_Cs__c
               						WHERE Institui_o__c = :accId];
        }
    
    public Adocoes_Cs__c getadc() {
		return adc;
	}
 
    public List<selectOption> getAnoBase() {
        Id AccId = ApexPages.currentPage().getParameters().get('id');
        String bkpAno = '';
        
        List<selectOption> options = new List<selectOption>();
        options.add(new selectOption('', '- Selecionar -'));
        for (Adocoes_Cs__c Ado : [SELECT Ano__c 
                                  FROM Adocoes_Cs__c 
                                  WHERE Institui_o__c = :AccId ORDER BY Ano__c ASC]) { 
            if (bkpAno <> Ado.Ano__c){
            	options.add(new selectOption(Ado.Ano__c, Ado.Ano__c));                              
            }
        	bkpAno = Ado.Ano__c;
		}
        return options;
    }
    
    public List<selectOption> getAnoClone() {
        Integer currentYear = System.Today().year();
        string sCurrentYear=string.valueof(currentYear);
        string sNextYear=string.valueof(currentYear + 1);
        
        List<selectOption> options = new List<selectOption>();
        options.add(new selectOption(sCurrentYear, sCurrentYear));
        options.add(new selectOption(sNextYear, sNextYear));

        return options;
    }
    
    public List<selectOption> getTipo(){
    	List<selectOption> options = new List<selectOption>();
    	for(RecordType RT : [SELECT Id, Name 
    							FROM RecordType 
    							WHERE SobjectType = 'Adocoes_Cs__c' AND IsActive = true 
    							ORDER BY Name ASC NULLS FIRST]){
    		
    		options.add(new selectOption(RT.Id, RT.Name));  
    	}
    	
    	return options;    									
    }
    
    public PageReference clonarLote() {
        
        List<Adocoes_Cs__c> listAdo = new List<Adocoes_Cs__c>();
        
        for (Adocoes_Cs__c Ado:[SELECT adocao__c,AdoRec__c,Contabiliza__c,Curso__c,Disciplina__c,Expectativa_de_Compra__c,
                                	Institui_o__c,Interno_Univ__c,N_mero_de_Alunos__c,OwnerId,Per_odo_do_Curso__c,
                                	Product_Competitor__c,Prof_Contato__c,RecordTypeId,Semestre__c
               					   FROM Adocoes_Cs__c
               					   WHERE Institui_o__c = :accId and Ano__c = :selAnoBase and (adocao__r.IsActive = true or Product_Competitor__r.Id <> Null) 
               						  and Curso__r.BR_Active_indicator__c = true and Disciplina__r.BR_Active_indicator__c = true and RecordTypeID = :selTipo]){
                                       
        	Adocoes_Cs__c newAdo = new Adocoes_Cs__c();
            newAdo.adocao__c = Ado.adocao__c;
            newAdo.AdoRec__c = Ado.AdoRec__c;
            newAdo.Ano__c = selAnoClone;
            newAdo.Contabiliza__c = Ado.Contabiliza__c;
            newAdo.Curso__c = Ado.Curso__c;
            newAdo.Disciplina__c = Ado.Disciplina__c;
            newAdo.Expectativa_de_Compra__c = Ado.Expectativa_de_Compra__c;
            newAdo.Institui_o__c = Ado.Institui_o__c;
            newAdo.Interno_Univ__c = Ado.Interno_Univ__c;
            newAdo.N_mero_de_Alunos__c = Ado.N_mero_de_Alunos__c;
            //newAdo.OwnerId = Ado.OwnerId;
            newAdo.Per_odo_do_Curso__c = Ado.Per_odo_do_Curso__c;
            newAdo.Product_Competitor__c = Ado.Product_Competitor__c;
            newAdo.Prof_Contato__c = Ado.Prof_Contato__c;
            newAdo.RecordTypeId = Ado.RecordTypeId;
            newAdo.Semestre__c = Ado.Semestre__c;
            
            listAdo.add(newAdo);
            //insert newAdo;
        }  
        
        insert  listAdo;
        return new PageReference('/' + accId);
    }
    
    public PageReference cancel() {
		return new PageReference('/' + accId);
	}
}