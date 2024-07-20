public class PerguntaResposta {
    @AuraEnabled
    public Id IdPergunta { get; set; }
    @AuraEnabled
    public string Pergunta { get; set; }
    @AuraEnabled
    public string TipoResposta { get; set; }
    @AuraEnabled
    public boolean Obrigatorio { get; set; }
    @AuraEnabled
    public string Resposta { get; set; }
    @AuraEnabled
    public string[] Respostas { get; set; }
    @AuraEnabled
    public string[] Opcoes { get; set; }
    @AuraEnabled
    public string Erro { get; set; }
    @AuraEnabled
    public string Tip { get; set; }
    
    public List<SelectOption> OpcoesResposta { get; set; }

    public PerguntaResposta()
    { }

    public PerguntaResposta(PerguntaFormulario__c perguntaFormulario)
    {
        IdPergunta = perguntaFormulario.Id;
        Pergunta = perguntaFormulario.Pergunta__c;
        TipoResposta = perguntaFormulario.TipoResposta__c;
        Obrigatorio = perguntaFormulario.Obrigatorio__c;
        Respostas = new string[]{};
            
        Opcoes = new string[]{};
        
        if ((perguntaFormulario.TipoResposta__c == 'Lista de opções única' || 
             perguntaFormulario.TipoResposta__c == 'Lista de opções múltipla') &&
            string.isNotBlank(perguntaFormulario.OpcoesResposta__c))
        {
            Opcoes.addAll(perguntaFormulario.OpcoesResposta__c.split(';'));
        }
        
        if (perguntaFormulario.TipoResposta__c == 'Numérico')
            Tip = 'Apenas números';
        
        if (perguntaFormulario.TipoResposta__c == 'Lista de opções múltipla')
            Tip = 'Utilize o CTRL para selecionar mais de uma opção';
    }
}