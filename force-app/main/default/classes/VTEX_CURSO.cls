public class VTEX_CURSO {

  public String jsonString_Curso {get;set;}

    public VTEX_CURSO()
    {
        jsonString_Curso = gerar_json_curso();
        System.debug('JSON=' + jsonString_Curso);
    } 


    public static  String gerar_json_curso() {
        
        List<CursoAtualizado> CursoSimples = New List<CursoAtualizado>();
       
        if (ApexPages.currentPage().getParameters().get('keyID') == '120f029fef154dcec18489c4e3d4db38')  {
        LIST<Course_Structure_Discipline__c> Curso = [select ID,Name from Course_Structure_Discipline__c where  (Type__c  = 'CURSO') and (BR_Categoria__c  = 'GRADUAÇÃO')  AND (Name LIKE: '%' + ApexPages.currentPage().getParameters().get('fragmento') + '%')  order by Name ASC  LIMIT 1000];
        system.debug(Curso.size());

        if (Curso.size() >0) {            
            for (Course_Structure_Discipline__c Cada_Curso: Curso) {
                // system.debug('Curso =' + Cada_Curso.Name); 
                CursoAtualizado b = New CursoAtualizado();
                b.Nome =htmlEncode(Cada_Curso.Name);
                b.ID = Cada_Curso.ID;
                CursoSimples.Add(b);
            }   
            return JSON.serializePretty(CursoSimples);
        }    
    else {
            return '[]';
        }
        } else {
            return '[]';
        }    
    }
    
    public class CursoAtualizado
    {
        public string ID {get;set;}
        public string Nome { get;set; }
    }
    
    public static String htmlEncode (String s) {  
    
        Map<String, String> htmlEncodingMap = new Map<String, String>();
        htmlEncodingMap.put('<', '&lt;');
        htmlEncodingMap.put('>', '&gt;');
        htmlEncodingMap.put('"', '&amp;quot;');
        htmlEncodingMap.put('&', '&amp;');
    
        for (String token : htmlEncodingMap.keySet()) {
            s = s.replace(token, htmlEncodingMap.get(token));
        }
    
        return s;
    }

    
}