public class VTEX_DISCIPLINA {
    
    public String jsonString_Disciplina {get;set;}
    
    public VTEX_DISCIPLINA()
    {
        jsonString_Disciplina = gerar_json_Disciplina();
        System.debug('JSON=' + jsonString_Disciplina);
    } 
    
    
    public static  String gerar_json_Disciplina() {
        
        List<DisciplinaAtualizado> DisciplinaSimples = New List<DisciplinaAtualizado>();
        
        if (ApexPages.currentPage().getParameters().get('keyID') == '698dc19d489c4e4db73e28a713eab07b')  {
            LIST<Course_Structure_Discipline__c> DISCIPLINA = [select ID,Name from Course_Structure_Discipline__c where  (Type__c  = 'DISCIPLINA')  AND (Name LIKE: '%' + ApexPages.currentPage().getParameters().get('fragmento') + '%')  order by Name ASC  LIMIT 1000];
            system.debug(DISCIPLINA.size());
            
            if (DISCIPLINA.size() >0) {            
                for (Course_Structure_Discipline__c Cada_DISCIPLINA: DISCIPLINA) {
                    // system.debug('DISCIPLINA =' + Cada_DISCIPLINA.Name); 
                    DisciplinaAtualizado b = New DisciplinaAtualizado();
                    b.Nome = Cada_DISCIPLINA.Name;
                    b.ID = Cada_DISCIPLINA.ID;
                    DisciplinaSimples.Add(b);
                }   
                return JSON.serializePretty(DisciplinaSimples);
            }    
            else {
                return '[]';
            }
        } else {
            return '[]';
        }
        
    }
    
    public class DisciplinaAtualizado
    {
        public string ID {get;set;}
        public string Nome { get;set; }
    }
    
}