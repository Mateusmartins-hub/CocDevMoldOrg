public with sharing class EnvioEmailConsultoriaController {
    public String mensagem;
    public Id idProcedimentoFranquias;
    public FR_Procedimento_Franquias__c objProcedimentoFranquias;
    public Set<String> setEmail { get; set; }
    public String emailBody { get; set; }
    public Event compromisso;
    public string prezadoNome;
    private string assunto;
    public List<FR_Plano_de_Acao__c> listPlanosAcao = new List<FR_Plano_de_Acao__c>();
    public List<BR_Procedimento_Visita__c> listRelatorios = new List<BR_Procedimento_Visita__c  >();
    public List<BR_Procedimento_Visita__c> listRelatoriosCicloFormacao = new List<BR_Procedimento_Visita__c >();
    public List<BR_Procedimento_Visita__c> listRelatoriosConsultoriaPedagogica = new List<BR_Procedimento_Visita__c >();
    public List<BR_Procedimento_Visita__c> listRelatoriosDiagnostico = new List<BR_Procedimento_Visita__c   >();
    private String htmlBody;
    private Id emailTemplateId;
    private PlanoAcaoDAO planoAcaoDAO;
    private ProcedimentoFranquiasDAO procFranqDAO;
    private Boolean isEmailPedagogico;
    private List<String> listLabelsConPedFR;
    private List<String> listCamposConPedFR;

    private List<String> listLabelsFeedSessionFR;
    private List<String> listCamposFeedSessionFR;

    private List<String> listLabelsObsSalaAulaFR;
    private List<String> listCamposObsSalaAulaFR;

    private List<String> listLabelsTreinCap;
    private List<String> listCamposTreinCap;

    public EnvioEmailConsultoriaController() {

    }

    public String init(String id){
        mensagem='';
        popularCamposListaPorRecType();
        planoAcaoDAO = new PlanoAcaoDAO();
        procFranqDAO = new ProcedimentoFranquiasDAO();
        setEmail = new Set<String>();
        this.idProcedimentoFranquias = id;
        loadProcedimentoFranquias();
        if ('Pedagogico'.equals(this.objProcedimentoFranquias.RecordType.DeveloperName)) {
            isEmailPedagogico = true;
            mensagem = enviarEmailPedagogico();
        } else {
            isEmailPedagogico = false;
            mensagem = enviarEmail();
        }
        return mensagem;
    }

    public void loadProcedimentoFranquias(){
        this.objProcedimentoFranquias = ProcedimentoFranquiasDAO.getObjectByID(idProcedimentoFranquias);
    }

    public void loadContacts(Id id){
        List<Contact> contatos = ContatoDAO.getEmailListContactById(Id);
        for(Contact ct:contatos){
            setEmail.add(ct.Email);
            prezadoNome = ct.Name;
        }
    }

    public String loadCompromisso(Id id){
        List<Event> listCompromissos = EventDAO.getEventByConsultoriaId(id);
        Boolean visitaRealizada =  false;
        if(isEmailPedagogico){
            if(listCompromissos.size() > 0){
                compromisso = listCompromissos.get(0);
                return '';
            }
        } else {
            if (listCompromissos.size() > 0) {
                for (Event cmp : listCompromissos) {
                    if (cmp.BR_Visita_Realizada__c) {
                        compromisso = cmp;
                        visitaRealizada = true;
                        return '';
                    }
                }
            }
            if (!visitaRealizada) {
                return 'Não foi possível enviar o E-mail pois não há compromisso com visita realizada';
            }
        }
        return '';
    }

    public String loadRelatorios(Id id){
        listRelatorios = RelatoriosConsultoriaDiagnosticosDAO.getInstance().getRelatoriosConsultoria(id);
        if(listRelatorios.size()>0){
            return '';
        } else {
            return 'Nenhum relatório encontrado.';
        }
    }

    public void loadPlanosAcao(Id id){
        listPlanosAcao = planoAcaoDAO.getListByConsultoriaId(id);
    }

    private void generateBodyEmail(String emailTemplateName){
        EmailTemplate emailTemplate = EmailTemplateDAO.getInstance().getEmailTemplateByName(emailTemplateName);
        htmlBody = emailTemplate.HtmlValue;
        emailTemplateId = emailTemplate.Id;
    }

    private void changeValuesPedagogicoBodyEmail(){
        this.assunto = 'Consultoria N°'+this.objProcedimentoFranquias.Name+' - Relatório da Consultoria';
        htmlBody = htmlBody.replace('{Consultoria.ContatoNome}', this.prezadoNome);
        htmlBody = htmlBody.replace('{Consultoria.DataInicio}', this.compromisso.StartDateTime.format('dd/MM/yyyy'));
        htmlBody = this.compromisso.StartDateTime != null ? htmlBody.replace('{Consultoria.DataConsultoria}',this.compromisso.StartDateTime.format('dd/MM/yyyy')) : htmlBody.replace('{Consultoria.DataConsultoria}','Não se aplica');
        htmlBody = this.compromisso.Owner.Name != null ? htmlBody.replace('{Consultoria.Consultor}', this.compromisso.Owner.Name) : htmlBody.replace('{Consultoria.Consultor}', 'Não se aplica');
        htmlBody = this.compromisso.BR_TipoConsultoria__c != null ? htmlBody.replace('{Consultoria.Tipo}',this.compromisso.BR_TipoConsultoria__c) : htmlBody.replace('{Consultoria.Tipo}','Não se aplica');
        try {
            htmlBody = htmlBody.replace('{Consultoria.Subtipo}', this.compromisso.BR_SubtipoConsultoria__c);
        } catch (Exception ex){
            htmlBody = htmlBody.replace('{Consultoria.Subtipo}', '');
        }

        if(listRelatoriosCicloFormacao.size()>0){
            String strRelatorios = '';
            strRelatorios += '<tr><td colspan="2"><table style="table-layout: fixed;" border="1" width="100%"><tbody><tr><td colspan="13" align="center"><b>Relat&oacute;rio de Ciclo de Forma&ccedil;&atilde;o</b></td></tr><tr style="color:white;"><td style="text-align: center;" bgcolor="#00115e">Data da Aplicação</td><td style="text-align: center;" bgcolor="#00115e">Duração</td><td style="text-align: center;" bgcolor="#00115e">Público</td><td style="text-align: center;" bgcolor="#00115e">Curso Formação nível I</td><td style="text-align: center;" bgcolor="#00115e">{ModulosMarca}</td><td style="text-align: center;" bgcolor="#00115e">Curso Formação nível II</td><td style="text-align: center;" bgcolor="#00115e">Módulos nível II</td><td style="text-align: center;" bgcolor="#00115e">Curso Formação nível III</td><td style="text-align: center;" bgcolor="#00115e">Módulos nível III</td><td style="text-align: center;" bgcolor="#00115e">Curso Formação nível IV</td><td style="text-align: center;" bgcolor="#00115e">Módulos nível IV</td><td style="text-align: center;" bgcolor="#00115e">Dificuldades Encontradas</td><td style="text-align: center;" bgcolor="#00115e">Comentários</td></tr>';
            String dataAplicacao,duracao,publico,dificuldades,comentarios,
                   cursoFormacaoNivelI, modulosAtitudeNivelI, modulosDomBoscoNivelI, modulosNAMENivelI, cursoFormacaoNivel_II,
                   cursoFormacaoNivel_III, modulosCocNivelI, modulosNivelII, modulosNivelIII, modulosNivelIV,cursoFormacaoNivel_IV;
            for(BR_Procedimento_Visita__c relatorio : listRelatoriosCicloFormacao){
                dataAplicacao = relatorio.BR_DataDaAplicacao__c == null ? 'Não se aplica': String.valueOf(relatorio.BR_DataDaAplicacao__c);
                duracao= relatorio.BR_Duracao__c== null ? 'Não se aplica': String.valueOf(relatorio.BR_Duracao__c);
                publico= relatorio.BR_Publico__c== null ? 'Não se aplica': relatorio.BR_Publico__c;
                cursoFormacaoNivelI = relatorio.BR_CursoFormacaoNivelI__c== null ? 'Não se aplica': relatorio.BR_CursoFormacaoNivelI__c;
                modulosAtitudeNivelI = relatorio.BR_ModulosAtitudeNivelI__c== null ? 'Não se aplica': relatorio.BR_ModulosAtitudeNivelI__c;
                modulosCocNivelI = relatorio.BR_ModulosCOCNivelI__c == null ? 'Não se aplica' : relatorio.BR_ModulosCOCNivelI__c;
                modulosDomBoscoNivelI = relatorio.BR_ModulosDomBoscoNivelI__c== null ? 'Não se aplica': relatorio.BR_ModulosDomBoscoNivelI__c;
                modulosNAMENivelI = relatorio.BR_ModulosNAMENivelI__c== null ? 'Não se aplica': relatorio.BR_ModulosNAMENivelI__c;
                modulosNivelII = relatorio.BR_ModulosNivel_II__c == null ? 'Não se aplica' : relatorio.BR_ModulosNivel_II__c;
                modulosNivelIII = relatorio.BR_ModulosNivel_III__c == null? 'Não se aplica' : relatorio.BR_ModulosNivel_III__c;
                modulosNivelIV = relatorio.BR_ModulosNivel_IV__c == null ? 'Não se aplica' : relatorio.BR_ModulosNivel_IV__c;
                dificuldades = relatorio.BR_DificuldadesEncontradas__c   == null ? 'Não se aplica': relatorio.BR_DificuldadesEncontradas__c;
                comentarios= relatorio.BR_Comentarios_1__c== null ? 'Não se aplica': relatorio.BR_Comentarios_1__c;
                cursoFormacaoNivel_II = relatorio.BR_CursoFormacaoNivel_II__c == null ? 'Não se aplica': relatorio.BR_CursoFormacaoNivel_II__c;
                cursoFormacaoNivel_III = relatorio.BR_CursoFormacaoNivel_III__c == null ? 'Não se aplica': relatorio.BR_CursoFormacaoNivel_III__c;
                cursoFormacaoNivel_IV = relatorio.BR_CursoFormacaoNivel_IV__c == null ? 'Não se aplica': relatorio.BR_CursoFormacaoNivel_IV__c;

                strRelatorios+='<tr>';
                strRelatorios+='<td style="word-wrap: break-word; vertical-align: middle;">'+dataAplicacao+'</td>';
                strRelatorios+= '<td style="word-wrap: break-word; vertical-align: middle;">'+duracao+'</td>';
                strRelatorios+= '<td style="word-wrap: break-word; vertical-align: middle;">'+publico+'</td>';

                strRelatorios += '<td style="word-wrap: break-word; vertical-align: middle;">' + cursoFormacaoNivelI + '</td>';
                strRelatorios = strRelatorios.replace('{ModulosMarca}','Módulos nível I');

                if(!'Não se aplica'.equals(modulosAtitudeNivelI)){
                    strRelatorios += '<td style="word-wrap: break-word; vertical-align: middle;">' + modulosAtitudeNivelI + '</td>';
                }
                else if(!'Não se aplica'.equals(modulosCocNivelI)){
                    strRelatorios += '<td style="word-wrap: break-word; vertical-align: middle;">' + modulosCocNivelI + '</td>';
                }
                else if(!'Não se aplica'.equals(modulosDomBoscoNivelI)){
                    strRelatorios += '<td style="word-wrap: break-word; vertical-align: middle;">' + modulosDomBoscoNivelI + '</td>';
                }
                else if(!'Não se aplica'.equals(modulosNAMENivelI)){
                    strRelatorios += '<td style="word-wrap: break-word; vertical-align: middle;">' + modulosNAMENivelI + '</td>';
                } else {
                    strRelatorios += '<td style="word-wrap: break-word; vertical-align: middle;">' + 'Não se aplica' + '</td>';
                }

                strRelatorios += '<td style="word-wrap: break-word; vertical-align: middle;">' + cursoFormacaoNivel_II + '</td>';
                strRelatorios += '<td style="word-wrap: break-word; vertical-align: middle;">' + modulosNivelII + '</td>';
                strRelatorios += '<td style="word-wrap: break-word; vertical-align: middle;">' + cursoFormacaoNivel_III + '</td>';
                strRelatorios += '<td style="word-wrap: break-word; vertical-align: middle;">' + modulosNivelIII + '</td>';
                strRelatorios += '<td style="word-wrap: break-word; vertical-align: middle;">' + cursoFormacaoNivel_IV + '</td>';
                strRelatorios += '<td style="word-wrap: break-word; vertical-align: middle;">' + modulosNivelIV + '</td>';
                strRelatorios+= '<td style="word-wrap: break-word; vertical-align: middle;">'+dificuldades+'</td>';
                strRelatorios+= '<td style="word-wrap: break-word; vertical-align: middle;">'+comentarios+'</td>';
                strRelatorios+='</tr>';
            }
            strRelatorios+='</tbody></table></td></tr><td><br/></td></tr><td><br/></td></tr>';
            htmlBody = htmlBody.replace('<!--Inicio-RelatorioCicloFormacao--><!--Fim-RelatorioCicloFormacao-->',strRelatorios);
        }

        if(listRelatoriosConsultoriaPedagogica.size()>0){
            String strRelatorios = '';
            strRelatorios +='<tr><td colspan="2"><table style="table-layout: fixed;" border="1" width="100%"><tbody><tr><td colspan="8" align="center"><b>Relat&oacute;rio de Consultoria Pedag&oacute;gica</b></td></tr><tr style="color:white;"><td style="text-align: center;" bgcolor="#00115e">Data da Aplicação</td><td style="text-align: center;" bgcolor="#00115e">Tipo de Atendimento</td><td style="text-align: center;" bgcolor="#00115e">Material</td><td style="text-align: center;" bgcolor="#00115e">Segmento</td><td style="text-align: center;" bgcolor="#00115e">Público</td><td style="text-align: center;" bgcolor="#00115e">Quantidade Público</td><td style="text-align: center;" bgcolor="#00115e">Dificuldades Encontradas</td><td style="text-align: center;" bgcolor="#00115e">Comentários</td></tr>';
            String dataAplicacao, tipoAtendimento, material, segmento, publico, qtPublico, dificuldades, comentarios;
            for(BR_Procedimento_Visita__c relatorio : listRelatoriosConsultoriaPedagogica){
                dataAplicacao = relatorio.BR_DataDaAplicacao__c == null ? 'Não se aplica': String.valueOf(relatorio.BR_DataDaAplicacao__c);
                tipoAtendimento = relatorio.BR_TipoDeAtendimento__c == null ? 'Não se aplica': relatorio.BR_TipoDeAtendimento__c;
                material = relatorio.BR_Material__c == null ? 'Não se aplica': relatorio.BR_Material__c;
                segmento = relatorio.BR_Segmento__c == null ? 'Não se aplica': relatorio.BR_Segmento__c;
                publico = relatorio.BR_Publico__c == null ? 'Não se aplica': relatorio.BR_Publico__c;
                qtPublico = relatorio.BR_QtdPublico__c   == null ? 'Não se aplica': String.valueOf(relatorio.BR_QtdPublico__c);
                dificuldades= relatorio.BR_DificuldadesEncontradas__c == null ? 'Não se aplica': relatorio.BR_DificuldadesEncontradas__c;
                comentarios= relatorio.BR_Comentarios_1__c== null ? 'Não se aplica': relatorio.BR_Comentarios_1__c;

                strRelatorios+='<tr>';
                strRelatorios+= '<td style="word-wrap: break-word; vertical-align: middle;">'+dataAplicacao+'</td>';
                strRelatorios+= '<td style="word-wrap: break-word; vertical-align: middle;">'+tipoAtendimento+'</td>';
                strRelatorios+= '<td style="word-wrap: break-word; vertical-align: middle;">'+material+'</td>';
                strRelatorios+= '<td style="word-wrap: break-word; vertical-align: middle;">'+segmento+'</td>';
                strRelatorios+= '<td style="word-wrap: break-word; vertical-align: middle;">'+publico<+'/td>';
                strRelatorios+= '<td style="word-wrap: break-word; vertical-align: middle;">'+qtPublico+'</td>';
                strRelatorios+= '<td style="word-wrap: break-word; vertical-align: middle;">'+dificuldades+'</td>';
                strRelatorios+= '<td style="word-wrap: break-word; vertical-align: middle;">'+comentarios+'</td>';
                strRelatorios+='</tr>';

            }
            strRelatorios+='</tbody></table></td></tr><td><br/></td></tr><td><br/></td></tr>';
            htmlBody = htmlBody.replace('<!--Inicio-RelatorioConsultoriaPedagogica--><!--Fim-RelatorioConsultoriaPedagogica-->',strRelatorios);
        }


        if(listRelatoriosDiagnostico.size()>0){
            String strRelatorios='';
            strRelatorios +='<tr><td colspan="2"><table style="table-layout: fixed;" border="1" width="100%"><tbody><tr><td colspan="7" align="center"><b>Diagn&oacute;stico</td></b></tr>';
            String coorPropPedag, professoresEI, professoresEFI, professoresEFII, escolaPlanejamento, avaliacaoDesempenho, coordenacaoMateriais, professoresEIMat, professoresEFIMat, professoresEFIIMat, coordAtividadesProf, obsSalaAula, rotatividadeProf;
            for(BR_Procedimento_Visita__c relatorio : listRelatoriosDiagnostico){
                coorPropPedag = relatorio.BR_CoordenacaoPropostaPedagogica__c == null ? 'Não se aplica' : relatorio.BR_CoordenacaoPropostaPedagogica__c;
                professoresEI = relatorio.BR_ProfessoresEIPropostaPedagogica__c == null ? 'Não se aplica' : relatorio.BR_ProfessoresEIPropostaPedagogica__c;
                professoresEFI = relatorio.BR_ProfessoresEFIPropostaPedagogica__c == null ? 'Não se aplica' : relatorio.BR_ProfessoresEFIPropostaPedagogica__c;
                professoresEFII = relatorio.BR_ProfessoresEFIIPropostaPedagogica__c == null ? 'Não se aplica' : relatorio.BR_ProfessoresEFIIPropostaPedagogica__c;
                escolaPlanejamento = relatorio.BR_EscolaPlanejamentoParaProfessores__c == null ? 'Não se aplica' : relatorio.BR_EscolaPlanejamentoParaProfessores__c;
                avaliacaoDesempenho = relatorio.BR_AvaliacaoDesempenhoProfessores__c == null ? 'Não se aplica' : relatorio.BR_AvaliacaoDesempenhoProfessores__c;
                coordenacaoMateriais = relatorio.BR_CoordenacaoMateriais__c == null ? 'Não se aplica' : relatorio.BR_CoordenacaoMateriais__c;
                professoresEIMat = relatorio.BR_ProfessoresEIMateriais__c == null ? 'Não se aplica' : relatorio.BR_ProfessoresEIMateriais__c;
                professoresEFIMat = relatorio.BR_ProfessoresEFIMateriais__c == null ? 'Não se aplica' : relatorio.BR_ProfessoresEFIMateriais__c;
                professoresEFIIMat = relatorio.BR_ProfessoresEFIIMateriais__c == null ? 'Não se aplica' : relatorio.BR_ProfessoresEFIIMateriais__c;
                coordAtividadesProf = relatorio.BR_CoordenacaoAtividadesProfessores__c == null ? 'Não se aplica' : relatorio.BR_CoordenacaoAtividadesProfessores__c;
                obsSalaAula = relatorio.BR_ObservcaoSalaAula__c == null ? 'Não se aplica' : relatorio.BR_ObservcaoSalaAula__c;
                rotatividadeProf = relatorio.BR_RotatividadeProfessores__c == null ? 'Não se aplica' : relatorio.BR_RotatividadeProfessores__c;

                strRelatorios += '<tr><td colspan="7">'+coorPropPedag+'</td></tr>';
                strRelatorios += '<tr><td colspan="7">'+professoresEI+'</td></tr>';
                strRelatorios += '<tr><td colspan="7">'+professoresEFI+'</td></tr>';
                strRelatorios += '<tr><td colspan="7">'+professoresEFII+'</td></tr>';
                strRelatorios += '<tr><td colspan="7">'+escolaPlanejamento+'</td></tr>';
                strRelatorios += '<tr><td colspan="7">'+avaliacaoDesempenho+'</td></tr>';
                strRelatorios += '<tr><td colspan="7">'+coordenacaoMateriais+'</td></tr>';
                strRelatorios += '<tr><td colspan="7">'+professoresEIMat+'</td></tr>';
                strRelatorios += '<tr><td colspan="7">'+professoresEFIMat+'</td></tr>';
                strRelatorios += '<tr><td colspan="7">'+professoresEFIIMat+'</td></tr>';
                strRelatorios += '<tr><td colspan="7">'+coordAtividadesProf+'</td></tr>';
                strRelatorios += '<tr><td colspan="7">'+obsSalaAula+'</td></tr>';
                strRelatorios += '<tr><td colspan="7">'+rotatividadeProf+'</td></tr>';
                strRelatorios += '<tr><td><br/></td></tr>';
            }
            strRelatorios+='</tbody></table></td></tr><td><br/></td></tr><td><br/></td></tr>';
            htmlBody = htmlBody.replace('<!--Inicio-Diagnostico--><!--Fim-Diagnostico-->',strRelatorios);
        }


        Integer posInicial = this.htmlBody.indexOf('<tr><td style="word-wrap: break-word; vertical-align: middle;">{PAC.TipoProblema}');
        Integer posFinal = this.htmlBody.indexOf('PAC.FUP}</td></tr>') + 18;
        String padraoPlanosAcaoEmail = this.htmlBody.substring(posInicial, posFinal);

        String planosAcaoEmail = '';
        String partPlanosAcao;
        for(FR_Plano_de_Acao__c planoAcao : listPlanosAcao){
            partPlanosAcao = padraoPlanosAcaoEmail;

            partPlanosAcao = planoAcao.BR_TipoProblema__c != null ? partPlanosAcao.replace('{PAC.TipoProblema}', planoAcao.BR_TipoProblema__c): partPlanosAcao.replace('{PAC.TipoProblema}', 'Não se aplica');
            partPlanosAcao = planoAcao.BR_Status__c != null ? partPlanosAcao.replace('{PAC.Status}', planoAcao.BR_Status__c) : partPlanosAcao.replace('{PAC.Status}', 'Não se aplica');
            partPlanosAcao = planoAcao.BR_Subtipo__c != null ? partPlanosAcao.replace('{PAC.Subtipo}',planoAcao.BR_Subtipo__c) : partPlanosAcao.replace('{PAC.Subtipo}','Não se aplica');

            partPlanosAcao = planoAcao.BR_OQue__c != null ? partPlanosAcao.replace('{PAC.OQue}', planoAcao.BR_OQue__c) : partPlanosAcao.replace('{PAC.OQue}', 'Não se aplica');
            partPlanosAcao = planoAcao.BR_Como__c != null ? partPlanosAcao.replace('{PAC.Como}', planoAcao.BR_Como__c) : partPlanosAcao.replace('{PAC.Como}', 'Não se aplica');
            partPlanosAcao = planoAcao.BR_Quem__c != null ? partPlanosAcao.replace('{PAC.Quem}', planoAcao.BR_Quem__c) : partPlanosAcao.replace('{PAC.Quem}', 'Não se aplica');
            partPlanosAcao = planoAcao.BR_AteQuando__c != null ? partPlanosAcao.replace('{PAC.AteQuando}', planoAcao.BR_AteQuando__c.day()+'/'+planoAcao.BR_AteQuando__c.month()+'/'+planoAcao.BR_AteQuando__c.year()) : partPlanosAcao.replace('{PAC.AteQuando}','Não se aplica');
            partPlanosAcao = planoAcao.BR_FUP__c != null ? partPlanosAcao.replace('{PAC.FUP}', planoAcao.BR_FUP__c) : partPlanosAcao.replace('{PAC.FUP}', 'Não se aplica');

            partPlanosAcao += '<tr><td></br></td></tr>';
            planosAcaoEmail += partPlanosAcao;
        }

        htmlBody = htmlBody.replace(padraoPlanosAcaoEmail, planosAcaoEmail);
        htmlBody = htmlBody.replace('null','Não se aplica');
    }

    private void changeValuesBodyEmail(){
        this.assunto = 'Consultoria N°'+this.objProcedimentoFranquias.Name+' - Relatório da Consultoria';
        htmlBody = htmlBody.replace('{Consultoria.ContatoNome}', this.prezadoNome);
        htmlBody = htmlBody.replace('{Consultoria.DataInicio}', this.compromisso.StartDateTime.format('dd/MM/yyyy'));
        htmlBody = htmlBody.replace('{Consultoria.DataConsultoria}',this.compromisso.StartDateTime.format('dd/MM/yyyy'));
        htmlBody = htmlBody.replace('{Consultoria.Consultor}', this.compromisso.Owner.Name);
        htmlBody = htmlBody.replace('{Consultoria.Tipo}',this.compromisso.BR_TipoConsultoria__c);
        if(this.compromisso.BR_SubtipoConsultoria__c != null){
            htmlBody = htmlBody.replace('{Consultoria.Subtipo}', this.compromisso.BR_SubtipoConsultoria__c);
        }else{
            htmlBody = htmlBody.replace('{Consultoria.Subtipo}', '');
        }

        if('PedagogicoFR'.equals(compromisso.RecordType.DeveloperName)){

            String strRelatorios = '';
            strRelatorios += '<tr><tr><td align="center" colspan=2><b>Relatório da consultoria</b></td></tr>';
            strRelatorios +='<tr><td><br></td></tr>';
            strRelatorios += '<td colspan=2><table width="100%" style="table-layout: fixed;"><tbody><col></col><col></col><col></col><col></col>';
            for(BR_Procedimento_Visita__c relatorio : listRelatorios){
                if('ConsultoriaPedagogicaFR'.equals(relatorio.RecordType.DeveloperName)){

                    strRelatorios+='<tr><td align ="center" td colspan=4><b>'+relatorio.RecordType.Name+'</b></td></tr>';
                    Integer verificador = 1;
                    for(Integer c=0; c<listLabelsConPedFR.size(); c++){
                        try {
                            if(verificador == 2){
                                strRelatorios += '<td align="right"><b>'+listLabelsConPedFR.get(c)+'</b>&nbsp;&nbsp;&nbsp;&nbsp;</td><td>'+relatorio.get(listCamposConPedFR.get(c))+'</td></tr>';
                                verificador = 0;
                            } else {
                                strRelatorios +='<tr><td align="right"><b>'+listLabelsConPedFR.get(c)+'</b>&nbsp;&nbsp;&nbsp;&nbsp;</td><td>'+relatorio.get(listCamposConPedFR.get(c))+'</td>';
                            }
                            verificador++;
                        }
                        catch (Exception ex){

                        }
                    }
                    if(verificador == 2){
                        strRelatorios +='</tr>';
                    }
                    strRelatorios +='<tr><td><br></td></tr>';
                    strRelatorios +='<tr><td><br></td></tr>';
                    strRelatorios +='<tr><td><br></td></tr>';
                    strRelatorios +='<tr><td><br></td></tr>';
                }

                
                    if('TreinamentoCapacitacao'.equals(relatorio.RecordType.DeveloperName)){
                    strRelatorios+='<tr><td align ="center" td colspan=4><b>'+relatorio.RecordType.Name+'</b></td></tr>';
                    Integer verificador = 1;
                    for(Integer c=0; c<listLabelsTreinCap.size(); c++){
                        try {
                            if(verificador == 2){
                                strRelatorios += '<td align="right"><b>'+listLabelsTreinCap.get(c)+'</b>&nbsp;&nbsp;&nbsp;&nbsp;</td><td>'+relatorio.get(listCamposTreinCap.get(c))+'</td></tr>';
                                verificador = 0;
                            } else {
                                strRelatorios +='<tr><td align="right"><b>'+listLabelsTreinCap.get(c)+'</b>&nbsp;&nbsp;&nbsp;&nbsp;</td><td>'+relatorio.get(listCamposTreinCap.get(c))+'</td>';
                            }
                            verificador++;
                        }
                        catch (Exception ex){

                        }
                    }
                    if(verificador == 2){
                        strRelatorios +='</tr>';
                    }
                    strRelatorios +='<tr><td><br></td></tr>';
                    strRelatorios +='<tr><td><br></td></tr>';
                    strRelatorios +='<tr><td><br></td></tr>';
                    strRelatorios +='<tr><td><br></td></tr>';
                }
            }

            strRelatorios += '</tbody></table></td></tr>';
            htmlBody = htmlBody.replace('<!-- Inicio Relatorio --><!-- Fim Relatorio -->',strRelatorios);
        }

        Integer posInicial = this.htmlBody.indexOf('<tr><td align="left" style="word-wrap:break-word; vertical-align:middle">{Consultoria.Plano_de_Acao__c.Name}');
        Integer posFinal = this.htmlBody.indexOf('BR_Status__c}</td></tr>') + 23;
        String padraoPlanosAcaoEmail = this.htmlBody.substring(posInicial, posFinal);

        String planosAcaoEmail = '';
        String partPlanosAcao;
        for(FR_Plano_de_Acao__c planoAcao : listPlanosAcao){
            partPlanosAcao = padraoPlanosAcaoEmail;

            partPlanosAcao = partPlanosAcao.replace('{Consultoria.Plano_de_Acao__c.Name}', planoAcao.Name);

            if('ConsultoriaCampoFR'.equals(compromisso.RecordType.DeveloperName) && 'PlanodeAcaoID85'.equals(planoAcao.RecordType.DeveloperName)){

                partPlanosAcao = planoAcao.BR_TipoProblema__c != null ? partPlanosAcao.replace('{Consultoria.Plano_de_Acao__c.BR_Problema__c}', planoAcao.BR_TipoProblema__c): partPlanosAcao.replace('{Consultoria.Plano_de_Acao__c.BR_Problema__c}', '');

                partPlanosAcao = planoAcao.BR_AssociadoProblema__c != null ? partPlanosAcao.replace('{Consultoria.Plano_de_Acao__c.BR_OQue__c}', planoAcao.BR_AssociadoProblema__c) : partPlanosAcao.replace('{Consultoria.Plano_de_Acao__c.BR_OQue__c}', '');

            } else {
                partPlanosAcao = planoAcao.BR_Problema__c != null ? partPlanosAcao.replace('{Consultoria.Plano_de_Acao__c.BR_Problema__c}', planoAcao.BR_Problema__c) : partPlanosAcao.replace('{Consultoria.Plano_de_Acao__c.BR_Problema__c}', '');
                partPlanosAcao = planoAcao.BR_OQue__c != null ? partPlanosAcao.replace('{Consultoria.Plano_de_Acao__c.BR_OQue__c}', planoAcao.BR_OQue__c) : partPlanosAcao.replace('{Consultoria.Plano_de_Acao__c.BR_OQue__c}', '');
            }
            partPlanosAcao = planoAcao.BR_Como__c != null ? partPlanosAcao.replace('{Consultoria.Plano_de_Acao__c.BR_Como__c}', planoAcao.BR_Como__c) : partPlanosAcao.replace('{Consultoria.Plano_de_Acao__c.BR_Como__c}', '');
            partPlanosAcao = planoAcao.BR_Quem__c != null ? partPlanosAcao.replace('{Consultoria.Plano_de_Acao__c.BR_Quem__c}', planoAcao.BR_Quem__c) : partPlanosAcao.replace('{Consultoria.Plano_de_Acao__c.BR_Quem__c}', '');
            partPlanosAcao = planoAcao.BR_AteQuando__c != null ? partPlanosAcao.replace('{Consultoria.Plano_de_Acao__c.BR_AteQuando__c}', planoAcao.BR_AteQuando__c.day()+'/'+planoAcao.BR_AteQuando__c.month()+'/'+planoAcao.BR_AteQuando__c.year()) : partPlanosAcao.replace('{Consultoria.Plano_de_Acao__c.BR_AteQuando__c}','');
            partPlanosAcao = planoAcao.BR_Status__c != null ? partPlanosAcao.replace('{Consultoria.Plano_de_Acao__c.BR_Status__c}', planoAcao.BR_Status__c) : partPlanosAcao.replace('{Consultoria.Plano_de_Acao__c.BR_Status__c}', '');
            planosAcaoEmail += partPlanosAcao;
        }

        htmlBody = htmlBody.replace(padraoPlanosAcaoEmail, planosAcaoEmail);
        htmlBody = htmlBody.replace('null','');
    }

    public void separarRelatoriosPorTipoRegistro(){
        for(BR_Procedimento_Visita__c relatorio : listRelatorios){
            if('Diagnostico'.equals(relatorio.RecordType.DeveloperName) || 'Diagnostico_Escolas'.equals(relatorio.RecordType.DeveloperName))
            {
                listRelatoriosDiagnostico.add(relatorio);
            }

            else if('CicloFormacaoCOC'.equals(relatorio.RecordType.DeveloperName) || 'CicloFormacaoDOM'.equals(relatorio.RecordType.DeveloperName)
                    || 'CicloFormacaoNAME'.equals(relatorio.RecordType.DeveloperName))
            {
                listRelatoriosCicloFormacao.add(relatorio);
            }

            else if('ConsultoriaPedagogicaDOM'.equals(relatorio.RecordType.DeveloperName) || 'ConsultoriaPedagogicaFR'.equals(relatorio.RecordType.DeveloperName)
                    || 'ConsultoriaPedagogicaNAME'.equals(relatorio.RecordType.DeveloperName) || 'ConsultoriaPedagogicoCOC'.equals(relatorio.RecordType.DeveloperName))
            {
                listRelatoriosConsultoriaPedagogica.add(relatorio);
            }
        }
    }

    public String enviarEmailPedagogico(){

        mensagem='';
        loadCompromisso(this.objProcedimentoFranquias.Id);
        mensagem = loadRelatorios(this.objProcedimentoFranquias.Id);
        if(mensagem!=''){
            return mensagem ;
        }
        separarRelatoriosPorTipoRegistro();
        loadPlanosAcao(this.objProcedimentoFranquias.Id);
        loadContacts(this.compromisso.WhoId);
        if(this.prezadoNome == null){
            mensagem = 'Contato no compromisso não preenchido';
            return mensagem;
        }
        generateBodyEmail('Email Pedagogico');

        changeValuesPedagogicoBodyEmail();
        EmailUtil.getInstance().sendMail(setEmail, this.htmlBody, assunto);
        return mensagem;
    }

    public String enviarEmail() {
        mensagem='';
        mensagem = loadCompromisso(this.objProcedimentoFranquias.Id);
        if(mensagem != ''){
            return mensagem;
        }
        loadRelatorios(this.objProcedimentoFranquias.Id);
        loadPlanosAcao(this.objProcedimentoFranquias.Id);

        loadContacts(this.compromisso.BR_Contato__r.Id);
        if(this.prezadoNome == null){
            mensagem = 'Contato no compromisso não preenchido';
            return mensagem;
        }

        generateBodyEmail('Consultoria');

        changeValuesBodyEmail();
        EmailUtil.getInstance().sendMail(setEmail, this.htmlBody, assunto);
        return mensagem;
    }

    public void popularCamposListaPorRecType(){
        listLabelsConPedFR = new List<String>{'Número de Alunos', 'Realiza análise RGM', 'Quantidade de Turmas do Coordenador', 'Quantidade Turmas', 'Retenção', 'Aluno/Turma alinhado meta franqueadora', 'Frequência', 'Rematrícula', 'Coordenador possui nº limite de turma?', 'Status.1', 'Professores preparam as aulas?', 'Status.2', 'Time pedagógico possui certificação UC?', 'Status.3', 'Coordenador Pedagógico Treina equipe?', 'Status.4', 'Entrega RGM', '% Entrega de Tarefas', 'Marca da Conta', 'Status.5', 'Pedagógico e treinamentos Franqueadora?', 'Modalidade / Experiência que possui'};
        listCamposConPedFR = new List<String>{'BR_NumeroAlunos__c', 'BR_RealizaAnaliseRGM__c', 'BR_Quantidade_de_Turmas_do_coordenador__c', 'BR_Quantidade_Turmas__c', 'BR_Retencao__c', 'BR_AlunoTurmaAlinhadoMetaFranqueadora__c', 'BR_Frequencia__c', 'BR_Rematricula__c', 'BR_ProfessorPossuiNumeroLimiteTurmas__c', 'BR_Status1__c', 'BR_ProfessoresPreparamAulas__c', 'BR_Status2__c', 'BR_TimePedagogicoPossuiCertificacaoUC__c', 'BR_Status3__c', 'BR_CoordenadorPedagogicoTreinaEquipe__c', 'BR_Status4__c', 'BR_EntregaRGM__c', 'BR_EntregaTarefas__c', 'BR_MarcaConta__c', 'BR_Status5__c', 'BR_TimePedagogicoDevidamenteCapacitado__c', 'BR_ModalidadeExperienciaQuePossui__c'};

        listLabelsFeedSessionFR = new List<String>{'Marca da Conta', 'Percepção Coordenador e Consultor', 'Assertividade Coordenador Feedback', 'Pontos de Desenvolvimento', 'Assertividade Coordenador planos de ação'};
        listCamposFeedSessionFR = new List<String>{'BR_MarcaConta__c', 'BR_PercepcaoCoordenadorConsultor__c', 'BR_AssertividadeCoordenadorFeedback__c', 'BR_PontosDesenvolvimento__c', 'BR_AssertividadeCoordenadorPlanosAcao__c'};

        listLabelsObsSalaAulaFR = new List<String>{'Marca da Conta', 'Alunos Presentes', 'Livros', 'Modalidade', 'Turma Observada', 'Quantidade de Turmas do coordenador', 'Metodologia aplicada corretamente?', 'Atenção especial alunos baixo desempenho', 'Professor como mediador e articulador?', 'Forma de agrupamento para interação', 'Professor estimulou participação ativa?', '', 'Atividades deram oportunidade de fala?', 'Instruções claras (modeling)', 'Engajamento dos alunos na Aula', 'Planos de aula e teacher\'s guide', 'Plano de aula conhecimento metodologia?', 'Nível alunos respeitado?', 'Objetivos da aula e aluno', '', 'Relacionamento Professor/Aluno', 'Explicação e preparação para homework', 'Professor Pontual?', 'Cursos blended e atendimento via skype?', 'Atividades planejadas foram executadas?', 'Preparada para modalidades oferecidas?'};
        listCamposObsSalaAulaFR = new List<String>{'BR_MarcaConta__c', 'BR_AlunosPresentes__c', 'BR_Livros__c', 'BR_Modalidade__c', 'BR_TurmaObservada__c', 'BR_Quantidade_de_Turmas_do_coordenador__c', 'BR_MetodologiaAplicadaCorretamente__c', 'BR_AtencaoEspecialAlunosBaixoDesempenho__c', 'BR_ProfessorComoMediadorArticulador__c', 'BR_FormaAgrupamentoParaInteracao__c', 'BR_ProfessorEstimulouParticipacaoAtiva__c', '', 'BR_AtividadesDeramOportunidadeFala__c', 'BR_InstrucoesClarasModeling__c', 'BR_EngajamentoAlunosAula__c', 'BR_PlanosAulaTeachersGuide__c', 'Plano_de_aula_conhecimento_metodologia__c', 'BR_NivelAlunosRespeitado__c', 'BR_ObjetivosAulaAluno__c', '', 'BR_RelacionamentoProfessorAluno__c', 'BR_ExplicacaoPreparacaoParaHomework__c', 'BR_ProfessorPontual__c', 'BR_CursosBlendedAtendimentoViaSkype__c', 'BR_AtividadesPlanejadasForamExecutadas__c', 'BR_PreparadaParaModalidadesOferecidas__c'};

        listLabelsTreinCap = new List<String>{'Marca', 'Comentários', 'Assunto', 'Outros', 'Duração', 'Qtd Público', 'Público'};
        listCamposTreinCap = new List<String>{'BR_Marca__c', 'BR_Comentarios__c', 'BR_Assunto__c', 'BR_Outros__c', 'BR_Duracao__c', 'BR_QtdPublico__c', 'BR_Publico__c'};
    }
}