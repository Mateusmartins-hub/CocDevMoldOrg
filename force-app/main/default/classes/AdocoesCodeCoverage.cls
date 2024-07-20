@isTest
public class AdocoesCodeCoverage{
    static testMethod void myUnitTest() {
        
        Product2 Prd = new Product2(Name = 'Teste Prd');
        prd.IsActive = true;
        insert prd;
        
        Course_Structure_Discipline__c Crs = new Course_Structure_Discipline__c(name = 'Teste Curso');
        Crs.BR_Active_indicator__c = true;
        Crs.Type__c = 'CURSO';
        insert Crs;
        
        Course_Structure_Discipline__c dcp = new Course_Structure_Discipline__c(name = 'Teste Disciplina');
        dcp.BR_Active_indicator__c = true;
        dcp.Type__c = 'DISCIPLINA';
        insert dcp;
        
        RecordType accRT = [select id,Name from RecordType where SobjectType='Account' and DeveloperName='University' Limit 1];
        Account acc = new Account(name = 'Teste University Acc', recordTypeId=accRT.id);
        insert acc;
        
        RecordType accRT2 = [select id,Name from RecordType where SobjectType='Account' and DeveloperName='School' Limit 1];
        Account acc2 = new Account(name = 'Teste Academic Acc', recordTypeId=accRT2.id);
        insert acc2;
        
        Contact ctt = new Contact();
        ctt.AccountId = acc2.id;
        ctt.LastName = 'LastName';
        insert ctt;
        
        Account_Contact__c accCtt = new Account_Contact__c(Account__c=acc.Id,Contact__c=ctt.Id);
		accCtt.Email__c = 'teste@teste.com';
		accCtt.CPF__c = '50373666403';
        insert accCtt;
        	

		RecordType adoRT = [select id,Name from RecordType where SobjectType='Adocoes_Cs__c' and Name='Adoção Idiomas - Pearson' Limit 1];
		List<String> lstTipoAdo = new List<String>();
		lstTipoAdo.add(adoRT.Id);
		Adocoes_Cs__c Ado = new Adocoes_Cs__c();
		Ado.RecordTypeId = adoRT.Id;
      	Ado.adocao__c = Prd.Id;
       	Ado.AdoRec__c = 'Adota';
       	Ado.Ano__c = string.valueof(System.Today().year());
       	Ado.Contabiliza__c = true;
       	Ado.Curso__c = Crs.Id;
       	Ado.Disciplina__c = dcp.Id;
       	Ado.Expectativa_de_Compra__c = 10;
       	Ado.Institui_o__c = acc.Id;
       	Ado.Interno_Univ__c = true;
       	Ado.N_mero_de_Alunos__c = 80;
       	Ado.Per_odo_do_Curso__c = 'Anual';
       	Ado.Prof_Contato__c = ctt.Id;
       
        insert Ado;
        update Ado;
        
        ApexPages.StandardController sc = new ApexPages.StandardController(acc);
        ApexPages.currentPage().getParameters().put('id', acc.Id);
        AdocoesClonarLoteController aclc = new AdocoesClonarLoteController(sc);
		
        aclc.getadc();
        aclc.getAnoBase();
        aclc.getAnoClone();
        aclc.selAnoBase = string.valueof(System.Today().year());
        aclc.selAnoClone = string.valueof(System.Today().year());
        
        List<selectOption> lstTipo = aclc.getTipo();
        aclc.selTipo = lstTipoAdo;
        aclc.clonarLote();  
        aclc.cancel();
    }
}