public class FormularioParaExemplaresController 
{
    public Formulario__c Formulario { get; set; }
    public List<PerguntaResposta> PerguntaRespostas { get; set; }
    public string Erro { get; set; }
    public boolean ExibePerguntas { get; set; }
    public string UrlAmostra { get; set; }
    public string ContaId { get; set; }
    public string LeadId { get; set; }
    public string OportunidadeId { get; set; }
    public string TextoAgradecimento { get; set; }
    
    public FormularioParaExemplaresController()
    {
        Id idFormulario = Apexpages.currentPage().getParameters().get('id');
        Id idAmostra = Apexpages.currentPage().getParameters().get('av');
        
        ContaId = Apexpages.currentPage().getParameters().get('ac');
        LeadId = Apexpages.currentPage().getParameters().get('ld');
        OportunidadeId = Apexpages.currentPage().getParameters().get('op');
        
        string parentId;
        if (!string.IsBlank(ContaId))
            parentId = ContaId;
        else if (!string.IsBlank(OportunidadeId))
            parentId = OportunidadeId;
        else if (!string.IsBlank(LeadId))
            parentId = LeadId;
        
        Formulario = FormularioDAO.BuscaFormularioPorId(idFormulario);
        
        List<Formulario__c> respostas;
        if (Formulario.Tipo__c == 'Amostra virtual')
        {
            Product2 prod = [SELECT Id, LinkAmostra__c
                             FROM Product2
                             WHERE Id =: idAmostra
                             AND RecordType.DeveloperName =: 'AmostraVirtual'];
            
            Formulario.Produto__c = prod.Id;
            
            UrlAmostra = prod.LinkAmostra__c.startsWith('http://') ? prod.LinkAmostra__c : ('http://' + prod.LinkAmostra__c);
                
            respostas = FormularioDAO.BuscarRespostasAmostraVirtual(Formulario.SistemaEnsino__c, parentId, prod.Id);

            TextoAgradecimento = 'Obrigado pelo interesse, segue o link para acessar nossa amostra virtual';
        }
        else
        {
            respostas = FormularioDAO.BuscarRespostasVisita(Formulario.SistemaEnsino__c, Formulario.Tipo__c, Formulario.Destinatario__c, parentId);
        
            TextoAgradecimento = 'Obrigado por responder o formulário';
        }
           
        ExibePerguntas = respostas.isEmpty();
        
        BuscarPerguntas();
    }
    
    public Pagereference Salvar()
    {
        if (Formulario_FormularioDigital.ValidaFormulario(PerguntaRespostas))
        {
            ExibePerguntas = false;
            Formulario_FormularioDigital.SalvaRespostas(PerguntaRespostas, Formulario, ContaId, OportunidadeId, LeadId);
            Erro = null;
        }
        else {
            Erro = 'Corrija os erros para poder continuar';
        }
        
        return null;
    }

    private void BuscarPerguntas()
    {
        List<PerguntaFormulario__c> perguntas = FormularioDAO.BuscarPerguntasPorFormulario(Formulario.Id);
        
        PerguntaRespostas = new List<PerguntaResposta>();
        
        for (PerguntaFormulario__c pergunta : perguntas)
        {
            PerguntaResposta pergResp = new PerguntaResposta(pergunta);

            pergResp.OpcoesResposta = new List<SelectOption>();

            if (pergResp.TipoResposta == 'Lista de opções única')
                pergResp.OpcoesResposta.add(new SelectOption('', '-- Selecione --'));

            if (pergResp.TipoResposta == 'Lista de opções única' || 
                pergResp.TipoResposta == 'Lista de opções múltipla')
            {
                for (string valor : pergResp.Opcoes)
                    pergResp.OpcoesResposta.add(new SelectOption(valor, valor));
            }
            
            PerguntaRespostas.add(pergResp);
        }
    }
}