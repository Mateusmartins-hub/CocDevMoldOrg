public class VTEX {
    
    public String jsonString_Instituicao {get;set;}
    public VTEX()
    {
        jsonString_Instituicao = gerar_json_instituicao();
        System.debug('JSON=' + jsonString_Instituicao);
    } 
    public static String gerar_json_instituicao() {
        if (ApexPages.currentPage().getParameters().get('keyID') == '67b24cd52a1c3ec11151240c163cd918')  {
            if (ApexPages.currentPage().getParameters().get('linha') == 'U') {
                LIST<Account> a = [SELECT ID,Name,BR_Main_City__c,BR_Main_State__c FROM  Account WHERE RecordTypeId IN ('012d0000000gdJFAAY')  AND (NAME <> '--') AND (BR_Main_State__c =:  ApexPages.currentPage().getParameters().get('uf')) AND (BR_Main_City__c LIKE: '%' + ApexPages.currentPage().getParameters().get('cidade') + '%') ORDER BY NAME ASC  LIMIT 6000];
                return JSON.serializePretty(a);
            } else {
                LIST<Account> a = [SELECT ID,Name,BR_Main_City__c,BR_Main_State__c FROM  Account WHERE RecordTypeId IN ('012d0000000gdJZAAY')  AND (NAME <> '--') AND (BR_Main_State__c =:  ApexPages.currentPage().getParameters().get('uf')) AND (BR_Main_City__c LIKE: '%' + ApexPages.currentPage().getParameters().get('cidade') + '%') ORDER BY NAME ASC  LIMIT 6000]; 
                return JSON.serializePretty(a);
            }
        }   
        return '[]';
    }
    
    public class InstituicaoAtualizado
    {
        public string ID {get;set;}
        public string Nome {get;set; }
    }
    
}