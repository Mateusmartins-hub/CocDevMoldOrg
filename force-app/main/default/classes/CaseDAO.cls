public class CaseDAO { 
    
	private static final CaseDAO instance = new CaseDAO();
	private CaseDAO() {
	}

	public static CaseDAO getInstance(){
		return instance;
	}

	public List<Case> buscaCasesPorListaId(List<String> lstIdCaso){
		return [SELECT 	Id, 
						AccountId,
						Origem_Email__c,
						OwnerId,
						Account.BR_Account_Id_SAP__c,
						BR_Rua__c,
						BR_Numero__c,
						BR_Complemento__c,
						BR_CEP__c,
						BR_Bairro__c,
						BR_CidadeConta__c,
						BR_EstadoConta__c,
						CaseNumber,
						Detalhamento_del__c,
						BR_Detalhamento2__c,
						Subtipo__c,
						Type,
						RecordType.DeveloperName,
						Status,
						BR_IntegrarSAP__c,
						BR_NumeroOrdemVenda__c,
						Data_Emiss_o_NF__c,
						BR_NumeroNFe__c,
						contact.Email,
						ClosedDate,
						isClosed
				  FROM Case
				 WHERE Id IN: lstIdCaso];
	}

	public Case buscaCasesPorId(Id id){
		return [SELECT  Id,
						BR_Grupo_Solucionador__c,
						BR_NumeroMarco__c,
						Detalhamento_del__c,
						BR_Detalhamento2__c,
						Subtipo__c,
						Type,						 
						AccountId, 
						OwnerId,
						CaseNumber,
						BR_IntegrarSAP__c,
						//BR_MarcaSegmentoNegocio__c,
						BR_NumeroOrdemVenda__c,
						BR_NumeroNFe__c,
						Data_Emiss_o_NF__c,
						ClosedDate,
						Status,
						RecordType.DeveloperName
				  FROM Case
				 WHERE Id = :id];
	}

	public void atualizarCaso(Case caso)
	{
		Database.update(caso);
	}

	public List<String> getTypeList(){
		Set<String> typeSet = new Set<String>();
		for(Case caso : [SELECT Id,Type FROM Case WHERE Type <> '']){
			typeSet.add(caso.Type);
		}
		return new List<String>(typeSet);
	}

	public List<String> getSubtipoListByType(String tipo){
		Set<String> subtipoSet = new Set<String>();
		for(Case caso : [SELECT Subtipo__c FROM Case WHERE Type =: tipo AND Subtipo__c <> '']){
			subtipoSet.add(caso.Subtipo__c);
		}

		return new List<String>(subtipoSet);
	}

	public Case buscaTodosCamposCaseById(Id id){
		return [SELECT
				Id,
				BR_Sequencia_Grupo__c,
				Aprovador_Comercial__c,
				Aprovador_Financeiro__c,
				AreaDonaProcesso__c,
				AssetId,
				BR_Agencia__c,
				BR_Alcada1__c,
				BR_Alcada2__c,
				BR_Alcada3__c,
				BR_Alterar_caso_para_tipo__c,
				BR_Alterar_para_Demandas_Devolu_o__c,
				BR_AlunoUsuario__c,
				BR_AM_Data_Cadastro_SAP__c,
				BR_AM_Data_Cria_o_OV__c,
				BR_AM_Data_Cria_o_Pedido_Mannesoft__c,
				BR_AM_Data_do_Fornecimento__c,
				BR_AM_Data_Entrega__c,
				BR_AM_Kit_Segmento__c,
				BR_AM_Previs_o_de_Entrega__c,
				BR_AM_SAP__c,
				BR_AM_Solicita_o_Cadastro_SAP__c,
				BR_AM_Status_Amostras__c,
				BR_AM_Transportado__c,
				BR_AmbienteSecao__c,
				BR_Amostras_Entregas__c,
				BR_AnoDeConclusao__c,
				BR_area_impacto_retencao__c,
				BR_area_negocio__c,
				BR_area_origem__c,
				BR_AreaDoSite__c,
				BR_ArquivoAnexo__c,
				BR_AtividadeQuestaoExercicioLicao__c,
				BR_Bairro__c,
				BR_BorderoMannesoft__c,
				BR_Browser__c,
				BR_Campanha__c,
				BR_Causa_Tecnica__c,
				BR_CEP__c,
				BR_CidadeConta__c,
				BR_Codigo_do_Material__c,
				BR_CodigoDoMaterialISBN__c,
				BR_Combo__c,
				BR_Complemento__c,
				BR_CondicaoPagamento__c,
				BR_CondicaoPagamentoAtual__c,
				BR_ConfiguracaoDaMaquina__c,
				BR_ContaBanco__c,
				BR_Contrato__c,
				BR_CPF__c,
				BR_Credito_Solicitado__c,
				BR_Curso__c,
				BR_DataDaCompra__c,
				BR_DataDeNascimento__c,
				BR_DataDoDespachoDoPedido__c,
				BR_DataHorarioDoOcorrido__c,
				BR_DataOVNF__c,
				BR_DatasTreinamentoSugestoes3Datas__c,
				BR_Descricao_do_Material__c,
				BR_Detalhamento2__c,
				BR_Detalhamento2_Franquias__c,
				BR_detalhamento2p3__c,
				BR_Detalhamento_Franquia__c,
				BR_Detalhamento_Tecnico__c,
				BR_Detalhamento_Tecnico_EDU__c,
				BR_detalhamentop2__c,
				BR_detalhamentop3__c,
				BR_detalhamentop3_K12__c,
				BR_Devolvido_pela_Transportadora_porque__c,
				BR_DiaHora__c,
				BR_DisciplinaAulasVideo__c,
				BR_EmailContato__c,
				BR_EmailDoUsuario__c,
				BR_EnderecoCompleto__c,
				BR_Envio_para__c,
				BR_EstadoCivil__c,
				BR_EstadoConta__c,
				BR_EstimativaDeFaturamento__c,
				BR_EventoProvaCampanha__c,
				BR_EvidenciaBancaria__c,
				BR_ExercicioLicao__c,
				BR_Faturada__c,
				BR_Field1__c,
				BR_Foi_Resolvido__c,
				BR_Grupo_Solucionador__c,
				BR_ID_Usuario__c,
				BR_IDDoCurso__c,
				BR_Improcedente__c,
				BR_InformacaoASerAlteradaIncorreta__c,
				BR_InstituicaoBancaria__c,
				BR_Institution__c,
				BR_IntegracaoComQualProduto__c,
				BR_IntegracaoSAP__c,
				BR_IntegrarSAP__c,
				BR_ISBN__c,
				BR_Justificativa__c,
				BR_LoginDoUsuario__c,
				BR_LogIntegracao__c,
//				BR_MarcaSegmentoNegocio__c,
				BR_MateriaisRetirados__c,
				BR_Material_Didatico_Apresentado__c,
				BR_MaterialNomeEModalidade__c,
				BR_MateriaSetorTemas__c,
				BR_Modulo__c,
				BR_Motivo_da_devolu_o__c,
				BR_Motivos_Reclama_o__c,
				BR_N_mero_do_Pedido_Ecommerce__c,
				BR_N_NF_Devolu_o_Emitida_pelo_Franqueado__c,
				BR_N_Nota_Fiscal_do_Material_com_defeito__c,
				BR_NomeCompleto__c,
				BR_NomePalestrantePlantonista__c,
				BR_NomeTitularResponsavel__c,
				BR_Nota_Reclame_aqui__c,
				BR_NovaCondicaoPagamento__c,
				BR_NovoVencimento__c,
				BR_Numero__c,
				BR_Numero_da_Nota_Fiscal__c,
				BR_Numero_da_OV__c,
				BR_NumeroAlunos__c,
				BR_NumeroMarco__c,
				BR_NumeroNFe__c,
				BR_NumeroOrdemVenda__c,
				BR_NumeroPedido__c,
				BR_NumeroTask__c,
				BR_Objeto__c,
				BR_Oportunidade__c,
				BR_OrganizacaoVenda__c,
				BR_OVNF__c,
				BR_P_blico_da_apresenta_o__c,
				BR_PaginaLinkMaterial__c,
				BR_ParcelasPagas__c,
				BR_ParentescoComAluno__c,
				BR_Part__c,
				BR_PerfilOuTipoDeUsuario__c,
				BR_Peso__c,
				BR_Plataforma__c,
				BR_Prazo_inicial__c,
				BR_PresencialHangout__c,
				BR_PrevisaoChegada__c,
				BR_Primeira_Resposta_Realizada__c,
				BR_Produto__c,
				BR_Profissao__c,
				BR_Qtde_participantes_treinamento__c,
				BR_QualColocacao__c,
				BR_QualLabPlantao__c,
				BR_QualSerieTurma__c,
				BR_Quantidade__c,
				BR_QuantidadeInscritosProva__c,
				BR_QuantidadeLicencas__c,
				BR_QuantidadeMaterial__c,
				BR_QuantidadeVolumesCaixas__c,
				BR_Questao__c,
				BR_QuestionarioOuAulaDigital__c,
				BR_RG__c,
				BR_Rua__c,
				BR_Segmentos_avaliados__c,
				BR_Senhas_de_Degusta_o_Disponibilizadas__c,
				BR_SerieAno__c,
				BR_Servico__c,
				BR_SistemaHomologado__c,
				BR_SLA__c,
				BR_Status_aprovacao__c,
				BR_StatusFinanceiro__c,
				BR_StatusRetencao__c,
				BR_Subtipo__c,
				BR_subtipop2__c,
				BR_Subtipop3__c,
				BR_Sugest_o_2__c,
				BR_Sugest_o_3__c,
				BR_Tempo_para_a_apresenta_o__c,
				BR_Tipo_Cliente_EDU__c,
				BR_Tipo_de_cliente__c,
				BR_TipoFrete__c,
				BR_TipoPlantao__c,
				BR_TipoRelatorio__c,
				BR_TituloSegmentoLivro__c,
				BR_Total_Geral_R_Qtd_Informada__c,
				BR_Total_Geral_R_Qtd_Recebida__c,
				BR_Total_Geral_R_Qtd_Referencia__c,
				BR_Transportadora__c,
				BR_UnidadeEmFuncionamento__c,
				BR_UnidadeEstudou__c,
				BR_Universidade__c,
				BR_Valor__c,
				BR_Vencimento__c,
				BR_VendaDireta__c,
				BR_VerificadoSLADivulgacaoDoResProva__c,
				BR_VersaoSistemaOperacionalVersaoPlayer__c,
				BR_Voltaria_a_fazer_Negocio__c,
				BusinessHoursId,
				CaseNumber,
				Caso_aceito__c,
				CasoReaberto__c,
				ClosedDate,
				ContactId,
				ControleMarco__c,
				CreatedById,
				CreatedDate,
				Data_da_NF_do_Material_com_defeito__c,
				Data_Emiss_o_NF__c,
				DataHora_previstoSLA__c,
				Description,
				Detalhamento3_EDU__c,
				Detalhamento_del__c,
				DR_Sugest_o_1__c,
				EntitlementId,
				GrupoSolucionadorAnterior__c,
				IsClosed,
				IsClosedOnCreate,
				IsDeleted,
				IsEscalated,
				IsStopped,
				LastModifiedById,
				LastModifiedDate,
				Marca_contato_relacionado__c,
				MilestoneStatus,
				Motivo__c,
				MotivoReclamacao__c,
				N_mero_Remessa__c,
				Numero_Pedido_Mannesoft__c,
				Origem_Email__c,
				Origin,
				OwnerId,
				ParentId,
				Priority,
				ProductId,
				Qual_per_odo__c,
				ReaberturaExpirada__c,
				Reason,
				RecordTypeId,
//				Resumo__c,
				SLA_Resp1__c,
				SLA_Total__c,
				SlaExitDate,
				SlaStartDate,
				SLATotal__c,
				Status,
				Status_de_atuacao__c,
				StopStartDate,
				Subject,
				Subtipo__c,
				SuppliedCompany,
				SuppliedEmail,
				SuppliedName,
				SuppliedPhone,
				SystemModstamp,
				Tipo_de_Cliente__c,
				Tipo_de_Usu_rio__c,
				TipoDocDevolucao__c,
				Total_Consumido__c,
				Transportadora_n_o_cadastrada__c,
				Type,
				ValorReembolso__c
				FROM Case
				WHERE Id =: id];
	}

	public Case buscaCasoPorId(Id idCaso){
		List<Case> listCasos = new List<Case>();

		listCasos = [SELECT Id,
				CaseNumber,
				Oportunidade_PedidoAmostra__c,
				AccountId,
				Account.Name,
				Account.BR_Main_Address__c,
				Account.BR_Main_Nbr__c,
				Account.BR_Main_Complement__c,
				Account.BR_Main_District__c,
				Account.BR_Main_City__c,
				Account.BR_Main_Country__c,
				Account.BR_Main_Zip_code__c,
				Account.BR_Main_State__c,
				Possui_DG__c,
				ContactId
				FROM Case
				WHERE Id =: idCaso];

		if(listCasos.size() > 0){
			return listCasos.get(0);
		} else {
			return null;
		}
	}
    
    public static Case getCaseById(Id idCaso) {
        SObjectType objToken = Schema.getGlobalDescribe().get('Case');
        DescribeSObjectResult objDef = objToken.getDescribe();
        Map<String, SObjectField> fieldsCaso = objDef.fields.getMap(); 
        
        Set<String> fieldSet = fieldsCaso.keySet();
        
        List<string> campos = new List<string>();
        for(String s : fieldSet)
        {
            SObjectField fieldToken = fieldsCaso.get(s);
            DescribeFieldResult selectedField = fieldToken.getDescribe();
            string apiName = selectedField.getName();
            
            campos.add(apiName);
        }
        
        campos.add('AceitoPor__r.Name');
        campos.add('Account.BR_Account_email__c');
        
        String query = String.format('SELECT {0} FROM Case WHERE Id = :idCaso', new String[] { string.join(campos, ', ') });
        
        List<Case> casos = (List<Case>)Database.query(query);
        
        return !casos.isEmpty() ? casos[0] : null; 
    }
    
    public static List<Case> getCasesByIds(Set<Id> idsCasos) {
        SObjectType objToken = Schema.getGlobalDescribe().get('Case');
        DescribeSObjectResult objDef = objToken.getDescribe();
        Map<String, SObjectField> fieldsCaso = objDef.fields.getMap(); 
        
        Set<String> fieldSet = fieldsCaso.keySet();
        
        List<string> campos = new List<string>();
        for(String s : fieldSet)
        {
            SObjectField fieldToken = fieldsCaso.get(s);
            DescribeFieldResult selectedField = fieldToken.getDescribe();
            string apiName = selectedField.getName();
            
            campos.add(apiName);
        }
        
        campos.add('AceitoPor__r.Name');
        campos.add('AceitoPor__r.Email');
        
        String query = String.format('SELECT {0} FROM Case WHERE Id IN :idsCasos', new String[] { string.join(campos, ', ') });
        
        List<Case> casos = (List<Case>)Database.query(query);
        
        return casos; 
    } 
}