@isTest
public class AuditoriaUpdateLastAuditOnAccountTest {
	@isTest
    static  void myUnitTest() {
    
        
       	 Account B = new Account(
            BR_Account_Id_SSA__c = 'I66662',
            BR_Birthdate__c = '18/08/1990',
            BR_cnpj__c = '02.469.555/0001-02',
            BR_Integrate_to_SAP__c = false,
            BR_Integrate_to_SSA__c = true,
            BR_Integration_Status_SSA__c = 'Integrado ERP',
            BR_Integration_Status_SAP__c = '',
            BR_Main_Address__c = 'Rua Nelson Francisco  ',
            BR_Main_City__c = 'São Paulo',
            BR_Main_Complement__c = 'ap666',
            BR_Main_Country__c = 'BR',
            BR_Main_District__c = 'Limão',
            BR_Main_Nbr__c = '666',
            BR_Main_State__c = 'SP',
            BR_Main_Zip_code__c = '05790-140',
            BR_Account_email__c = 'robinson.mioshi@pearson.com',
            BR_Area_code__c = 11.0,
            Phone = '9999-9999',
            BR_Company_Name__c  = 'Empresa X LTDA',
            Name = 'Empresa X LTDA',
            RecordTypeID = RecordTypeUtil.getInstance().getRecordTypePorNome('Account', 'Pessoa Física').getRecordTypeId()
            //IBGE_Code__c = IBGE.ID
        );
 		insert B;
        
        Auditoria__c audi1 = new Auditoria__c(
            CurrencyIsoCode = 'BRL',
            BR_UpdateAccount__c = true,
            BR_account__c = B.id
        );
        insert audi1;
      
        audi1.BR_UpdateAccount__c = true;
        update audi1;         
  
    }   
}