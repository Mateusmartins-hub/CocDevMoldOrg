public class Formulario {
    @AuraEnabled
    public string IdFormulario { get; set; }
    @AuraEnabled
    public string Titulo { get; set; }
    @AuraEnabled
    public List<PerguntaResposta> Perguntas { get; set; }
}