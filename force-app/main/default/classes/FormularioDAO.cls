public class FormularioDAO { 
      
    public static Formulario__c BuscaFormularioPerguntaVisitaExpansaoPedagogica(string tipo, string destinatario, string objetivoVisita)
    {
        List<Formulario__c> form = BuscaFormularioPerguntaVisita(tipo, destinatario, objetivoVisita);

        if (string.isNotBlank(objetivoVisita) && form.isEmpty())
            form = BuscaFormularioPerguntaVisita(tipo, destinatario, '');

        return !form.isEmpty() ? form[0] : null;
    }

    private static List<Formulario__c> BuscaFormularioPerguntaVisita(string tipo, string destinatario, string objetivoVisita)
    {
        return [SELECT Id, Name, Titulo__c, SistemaEnsino__c, Tipo__c, Destinatario__c, Produto__c
                FROM Formulario__c
                WHERE RecordType.Name = 'Pergunta'
                AND Tipo__c = :tipo
                AND Destinatario__c =: destinatario
                AND ObjetivoVisita__c =: objetivoVisita];
    } 

    public static Formulario__c BuscaFormularioPorId(Id idFormulario)
    {
        return [SELECT Id, Name, Titulo__c, SistemaEnsino__c, Tipo__c, Destinatario__c, Produto__c, ObjetivoVisita__c
                FROM Formulario__c
                WHERE Id =: idFormulario];
    }
    
    public static List<Formulario__c> BuscarRespostasVisita(string sistemaEnsino, string tipo, string destinatario, Id parentId)
    {
        return [SELECT Id, SistemaEnsino__c, Tipo__c, Destinatario__c, Conta__c, Lead__c, Oportunidade__c
                FROM Formulario__c
                WHERE Recordtype.Name = 'Resposta'
                AND SistemaEnsino__c = :sistemaEnsino
                AND Tipo__c = :tipo
                AND Destinatario__c =: destinatario
                AND (Conta__c =: parentId 
                     OR Lead__c =: parentId
                     OR Oportunidade__c =: parentId)]; 
    }

    public static List<Formulario__c> BuscarRespostasAmostraVirtual(string sistemaEnsino, Id parentId, Id produtoId)
    {
        return [SELECT Id, Conta__c, Lead__c, Oportunidade__c, SistemaEnsino__c, Produto__c
                FROM Formulario__c
                WHERE Recordtype.Name = 'Resposta'
                AND SistemaEnsino__c = :sistemaEnsino
                AND Produto__c = :produtoId
                AND (Conta__c =: parentId 
                     OR Lead__c =: parentId
                     OR Oportunidade__c =: parentId)]; 
    }
    
    public static List<PerguntaFormulario__c> BuscarPerguntasPorFormulario(Id formularioId)
    {
        return [SELECT Id, Obrigatorio__c, OpcoesResposta__c, Pergunta__c, TipoResposta__c
                FROM PerguntaFormulario__c
                WHERE Formulario__c = :formularioId
                ORDER BY CreatedDate];
    }
    
}