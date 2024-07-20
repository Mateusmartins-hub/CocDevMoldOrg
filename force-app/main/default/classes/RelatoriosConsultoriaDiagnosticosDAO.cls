public with sharing class RelatoriosConsultoriaDiagnosticosDAO 
{
	private static final RelatoriosConsultoriaDiagnosticosDAO instance = new RelatoriosConsultoriaDiagnosticosDAO();

	private RelatoriosConsultoriaDiagnosticosDAO() 
	{	
	}

	public static RelatoriosConsultoriaDiagnosticosDAO getInstance()
	{
		return instance;
	}

	public List<BR_ConfiguracaoRelConsult__c> buscarConfiguracao()
	{
		return [SELECT Id, BR_APIPerformance__c, BR_Campo__c, BR_PesoQuestao__c, BR_TipoRegistro__c
				  FROM BR_ConfiguracaoRelConsult__c];
	}

	public List<BR_Procedimento_Visita__c> getRelatoriosConsultoria(String consultoriaId){
		return [SELECT Id,
				RecordType.DeveloperName,
				RecordType.Name,
				BR_FR_Procedimento_Franquias_Visita__c,
				BR_NumeroAlunos__c,
				BR_NumeroAlunosTurma__c,
				BR_Retencao__c,
				BR_Frequencia__c,
				BR_ProfessorPossuiNumeroLimiteTurmas__c,
				BR_ProfessoresPreparamAulas__c,
				BR_TimePedagogicoPossuiCertificacaoUC__c,
				BR_CoordenadorPedagogicoTreinaEquipe__c,
				BR_EntregaRGM__c,
				BR_RealizaAnaliseRGM__c,
				BR_Quantidade_Turmas__c,
				BR_AlunoTurmaAlinhadoMetaFranqueadora__c,
				BR_Rematricula__c,
				BR_Status1__c,
				BR_Status2__c,
				BR_Status3__c,
				BR_Status4__c,
				BR_EntregaTarefas__c,
				BR_MarcaConta__c,
				BR_TimePedagogicoDevidamenteCapacitado__c,
				BR_Status5__c,
				BR_ModalidadeExperienciaQuePossui__c,
				BR_Comentarios__c,
				BR_PercepcaoCoordenadorConsultor__c,
				BR_PontosDesenvolvimento__c,
				BR_Marca__c,
				BR_Livros__c,
				BR_TurmaObservada__c,
				BR_AlunosPresentes__c,
				BR_Modalidade__c,
				BR_MetodologiaAplicadaCorretamente__c,
				BR_ProfessorComoMediadorArticulador__c,
				BR_ProfessorEstimulouParticipacaoAtiva__c,
				BR_AtencaoEspecialAlunosBaixoDesempenho__c,
				BR_FormaAgrupamentoParaInteracao__c,
				BR_AtividadesDeramOportunidadeFala__c,
				BR_EngajamentoAlunosAula__c,
				Plano_de_aula_conhecimento_metodologia__c,
				BR_InstrucoesClarasModeling__c,
				BR_PlanosAulaTeachersGuide__c,
				BR_NivelAlunosRespeitado__c,
				BR_ObjetivosAulaAluno__c,
				BR_RelacionamentoProfessorAluno__c,
				BR_ProfessorPontual__c,
				BR_AtividadesPlanejadasForamExecutadas__c,
				BR_ExplicacaoPreparacaoParaHomework__c,
				BR_CursosBlendedAtendimentoViaSkype__c,
				BR_PreparadaParaModalidadesOferecidas__c,
				BR_Assunto__c,
				BR_Duracao__c,
				BR_Publico__c,
				BR_Outros__c,
				BR_QtdPublico__c,
				BR_Quantidade_de_Turmas_do_coordenador__c,
				BR_AssertividadeCoordenadorFeedback__c,
				BR_AssertividadeCoordenadorPlanosAcao__c,
				BR_DataDaAplicacao__c,
				BR_Nivel__c,
				CursoK12__c,
				BR_ModulosK12__c,
				BR_DificuldadesEncontradas__c,
				BR_Comentarios_1__c,
				BR_TipoDeAtendimento__c,
				BR_Material__c,
				BR_Segmento__c,
                BR_CursoFormacaoNivelI__c,
                BR_ModulosAtitudeNivelI__c,
                BR_ModulosDomBoscoNivelI__c,
                BR_ModulosNAMENivelI__c,
                BR_CursoFormacaoNivel_II__c,
                BR_ModulosNivel_II__c,
                BR_CursoFormacaoNivel_III__c,
                BR_ModulosNivel_III__c,
				BR_ModulosCOCNivelI__c,
				BR_ModulosNivel_IV__c,
				BR_CursoFormacaoNivel_IV__c,
				BR_CoordenacaoPropostaPedagogica__c,
				BR_ProfessoresEIPropostaPedagogica__c,
				BR_ProfessoresEFIPropostaPedagogica__c,
				BR_ProfessoresEFIIPropostaPedagogica__c,
				BR_EscolaPlanejamentoParaProfessores__c,
				BR_AvaliacaoDesempenhoProfessores__c,
				BR_CoordenacaoMateriais__c,
				BR_ProfessoresEIMateriais__c,
				BR_ProfessoresEFIMateriais__c,
				BR_ProfessoresEFIIMateriais__c,
				BR_CoordenacaoAtividadesProfessores__c,
				BR_ObservcaoSalaAula__c,
				BR_RotatividadeProfessores__c
				FROM BR_Procedimento_Visita__c
				WHERE BR_FR_Procedimento_Franquias_Visita__c =: consultoriaId];
	}
}