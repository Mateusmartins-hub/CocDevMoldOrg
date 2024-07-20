public with sharing class DistribuicaoGratuitaBO {
    private static final DistribuicaoGratuitaBO instance = new DistribuicaoGratuitaBO();
    private DistribuicaoGratuitaBO() {
    }
    
    public static DistribuicaoGratuitaBO getInstance(){
        return instance;
    }
    
    public static Boolean isProcessedByTrigger = false;
    
    private static final String TP_REGISTRO_AMOSTRA_FISICA = 'AmostraFisica';
    private static final String TP_REGISTRO_AMOSTRA_VIRTUAL = 'AmostraVirtual';
    private static final String TP_REGISTRO_DISTRIBUICAO_GRATUITA = 'DistribuicaoGratuita';
    
    private static final String TP_REGISTRO_PRD_AMOSTRAVIRTUAL = 'ProdutoAmostraVirtual';
    private static final String TP_REGISTRO_PRD_AMOSTRAFISICA = 'ProdutoAmostraFisica';
    private static final String TP_REGISTRO_PRD_DISTRIBUICAOGRATUITA = 'ProdutoDistribuicaoGratuita';
    private static final List<String> LST_TP_REGISTRO_VF_DISTRIBUICAOGRAT = new List<String>{DistribuicaoGratuitaBO.TP_REGISTRO_AMOSTRA_FISICA, 
        DistribuicaoGratuitaBO.TP_REGISTRO_AMOSTRA_VIRTUAL,
        TP_REGISTRO_DISTRIBUICAO_GRATUITA};
            
            public Map<String, RecordType> getRecordTypeVFDistribuicao(){
                Map<String, RecordType> mapRecTypeVF = new Map<String, RecordType>();
                for(RecordType rcType : RecordTypeDAO.getInstance().getRecordTypeByObjectAndDeveloperName(new List<String>{'BR_DistribuicaoGratuita__c'}, 
                                                                                                          DistribuicaoGratuitaBO.LST_TP_REGISTRO_VF_DISTRIBUICAOGRAT)){
                                                                                                              mapRecTypeVF.put(rcType.Id, rcType);
                                                                                                          }
                return mapRecTypeVF;
            }
    
    public Map<String, RecordType> getRecordTypeVFProdDistribuicao(Boolean keyIsTheID){
        Map<String, RecordType> mapRecTypeVF = new Map<String, RecordType>();
        for(RecordType rcType : RecordTypeDAO.getInstance().getRecordTypeByObjectAndDeveloperName(new List<String>{'BR_ProdutoDistribuicaoGratuita__c'}, 
                                                                                                  new List<String>{DistribuicaoGratuitaBO.TP_REGISTRO_PRD_AMOSTRAVIRTUAL,
                                                                                                      DistribuicaoGratuitaBO.TP_REGISTRO_PRD_AMOSTRAFISICA,
                                                                                                      DistribuicaoGratuitaBO.TP_REGISTRO_PRD_DISTRIBUICAOGRATUITA}))
        {
            if(keyIsTheID){
                mapRecTypeVF.put(rcType.Id, rcType);
            }
            else{
                mapRecTypeVF.put(rcType.DeveloperName, rcType);
            }
        }
        return mapRecTypeVF;
    }
    
    public Boolean isDistribuicaoAmostraFisica(String idRecordType){
        Map<String, RecordType> mapRCTypeDist = DistribuicaoGratuitaBO.getInstance().getRecordTypeVFDistribuicao();
        return (mapRCTypeDist != null && mapRCTypeDist.containsKey(idRecordType) ? 
                mapRCTypeDist.get(idRecordType).DeveloperName == DistribuicaoGratuitaBO.TP_REGISTRO_AMOSTRA_FISICA :
                false);
    }
    
    public String tipoDistribuicao(String idRecordType){
        
        String distribuicao = '';
        Map<String, RecordType> mapRCTypeDist = DistribuicaoGratuitaBO.getInstance().getRecordTypeVFDistribuicao();
        if(mapRCTypeDist != null && mapRCTypeDist.containsKey(idRecordType))
        {
            if(mapRCTypeDist.get(idRecordType).DeveloperName == DistribuicaoGratuitaBO.TP_REGISTRO_AMOSTRA_FISICA)
            	distribuicao = 'FISICA'; 
            else if(mapRCTypeDist.get(idRecordType).DeveloperName == DistribuicaoGratuitaBO.TP_REGISTRO_AMOSTRA_VIRTUAL)
            	distribuicao = 'VIRTUAL';
            else if(mapRCTypeDist.get(idRecordType).DeveloperName == DistribuicaoGratuitaBO.TP_REGISTRO_DISTRIBUICAO_GRATUITA)
            	distribuicao = 'DISTRIBUICAOGRATUITA';
        }
        return distribuicao;
    }
    
    public BR_DistribuicaoGratuita__c getDistribuicaoGratuitaById(String idDistribuicao){
        return DistribuicaoGratuitaDAO.getInstance().getDistribuicaoGratuitaByListId(new List<String>{idDistribuicao})[0];
    }
    
    public String saveDistribuicaoGratuita(BR_DistribuicaoGratuita__c distGratuita, List<ProdutoDistribuicaoGratuitaVF> lstProdutoDistribuicao, Boolean emailAgrupado){
        String errProcessamento = '';
        String idOpp = distGratuita.BR_Oportunidade__c;
        
        String tipoDistribuicao = tipoDistribuicao(distGratuita.RecordTypeId);
        
        Map<String, RecordType> mapRcTypeProdDist = DistribuicaoGratuitaBO.getInstance().getRecordTypeVFProdDistribuicao(false);
        Savepoint sp = Database.setSavePoint();
        
        try{
            Database.SaveResult svResult = null;
            svResult = (String.isBlank(distGratuita.Id) ? Database.insert(distGratuita, false) : Database.update(distGratuita, false));
            if(!svResult.isSuccess()){
                for(Database.Error errSvResult : svResult.getErrors()){
                    LogErroProcessamentoService.getInstance().registrarNovaInstanciaLogErroParaOportunidadeAdocao(idOpp, 'Erro ao criar/atualizar Distribuição Gratuita.', errSvResult.getMessage());
                    errProcessamento += '\nErro ao criar/atualizar Distr. Gratuita. Campo(s): ' + errSvResult.getFields() + '  ' + errSvResult.getStatusCode() + ' => ' + errSvResult.getMessage() + '>>> ' + distGratuita.Id + '>> ' + distGratuita;
                }
            }
            else{
                List<BR_ProdutoDistribuicaoGratuita__c> lstPrdDistGratuita = new List<BR_ProdutoDistribuicaoGratuita__c>();
                map<String,String> verificaProduto = new map<String,String>();
                List<BR_ProdutoDistribuicaoGratuita__c> lstPrdDistGratuitaExcluir = new List<BR_ProdutoDistribuicaoGratuita__c>();
                Map<String,String> linksPorTipo = new Map<String,String>();
                
                for(ProdutoDistribuicaoGratuitaVF prdDistGratuitaVF : lstProdutoDistribuicao){
                    
                    if(prdDistGratuitaVF.isSelected){
                        BR_ProdutoDistribuicaoGratuita__c prdDistGratuita = prdDistGratuitaVF.prodDistribuicaoGratuita;
                        
                        if(prdDistGratuitaVF.isNewRecord){
                            prdDistGratuita.BR_DistribuicaoGratuita__c = distGratuita.Id;
                        }
                        
                        if(tipoDistribuicao == 'VIRTUAL'){
                            
                            if (!emailAgrupado) {
                                String keyMap = prdDistGratuitaVF.cpfLink + '_' + prdDistGratuitaVF.isbn;
                                Map<String, String> mapDadosLink = DistribuicaoGratuitaBO.getInstance().gerarLinkDistribuicao(new List<String>{keyMap});
                                
                                prdDistGratuita.BR_Link__c = mapDadosLink.get(keyMap);
                                prdDistGratuita.BR_GerarLink__c = true;
                            }
                            prdDistGratuita.BR_Link__c = prdDistGratuitaVF.prodDistribuicaoGratuita.BR_Link__c;
                            prdDistGratuita.BR_Contato__c = distGratuita.BR_AosCuidados__c;
                            prdDistGratuita.RecordTypeId = mapRcTypeProdDist.get(DistribuicaoGratuitaBO.TP_REGISTRO_PRD_AMOSTRAVIRTUAL).Id;
                            prdDistGratuita.BR_Titulo__c = prdDistGratuitaVF.titulo;
                        }
                        else if(tipoDistribuicao == 'FISICA'){
                            prdDistGratuita.RecordTypeId = mapRcTypeProdDist.get(DistribuicaoGratuitaBO.TP_REGISTRO_PRD_AMOSTRAFISICA).Id;
                        }
                        else if(tipoDistribuicao == 'DISTRIBUICAOGRATUITA')
                        {
                            Product2 produto = new Product2();
                            produto = Product2DAO.getProduct2ById(prdDistGratuitaVF.idProduto);
                            prdDistGratuita.RecordTypeId = mapRcTypeProdDist.get(DistribuicaoGratuitaBO.TP_REGISTRO_PRD_DISTRIBUICAOGRATUITA).Id;
                            prdDistGratuita.BR_PrecoCusto__c = produto.BR_PrecoCusto__c;
                        }
                        
                        prdDistGratuita.BR_External_ID__c = distGratuita.Id + '_' + prdDistGratuita.BR_ProdutoDistribuicaoGratuita__c + '_' + prdDistGratuita.BR_Curso__c + '_' + prdDistGratuita.BR_Disciplina__c;
                        lstPrdDistGratuita.add(prdDistGratuita);
                        string extId = verificaProduto.get(prdDistGratuita.BR_External_ID__c);
                        if (extId == null){
                            verificaProduto.put(prdDistGratuita.BR_External_ID__c, 'chave');
                        }else{
                            errProcessamento = 'Produto Duplicado, não pode selecionar o mesmo produto 2 vezes'; 
                            return errProcessamento;
                        }
                    }
                    else{
                        if(String.isNotBlank(prdDistGratuitaVF.prodDistribuicaoGratuita.Id)){
                            lstPrdDistGratuitaExcluir.add(new BR_ProdutoDistribuicaoGratuita__c(Id = prdDistGratuitaVF.prodDistribuicaoGratuita.Id));
                        }
                    }
                }
                
                Decimal valorTotalProdutos = 0.0;
                String rangeAprovacao = '';
                String idAprovador1 = '';
                String idAprovador2 = '';
                
                for(BR_ProdutoDistribuicaoGratuita__c item : lstPrdDistGratuita)
                {
                    if(item.BR_PrecoCusto__c != null && item.BR_Quantidade__c != null)
                    {
                        valorTotalProdutos += item.BR_PrecoCusto__c * item.BR_Quantidade__c;
                    }
                }
                
                List<AlcadasAprovador__c> listaAprovador = AlcadasAprovadorDAO.getInstance().obterListaAlcadaAprovadorPorCentroCusto(distGratuita.BR_CentroCusto__c);
                if(!listaAprovador.isEmpty())
                {
                    for(AlcadasAprovador__c item: listaAprovador)
                    {
                        if(item.BR_ValorDe__c <= valorTotalProdutos && valorTotalProdutos <= item.BR_ValorAte__c)
                        {
                            idAprovador1 = item.Aprovador__c;
                            idAprovador2 = item.BR_Aprovador2__c;
                            rangeAprovacao = item.Id;
                            distGratuita.BR_RangeAprovacao__c = rangeAprovacao;
                            distGratuita.BR_AprovadorNivel1__c = idAprovador1;
                            distGratuita.BR_AprovadorNivel2__c = idAprovador2;
                            Database.update(distGratuita, false); 
                            break;
                        }
                    }
                }
                
                if(tipoDistribuicao == 'VIRTUAL' && emailAgrupado) {
                    Map<String,BR_ProdutoDistribuicaoGratuita__c> mapDistGrat = new Map<String, BR_ProdutoDistribuicaoGratuita__c>();
                    Set<BR_ProdutoDistribuicaoGratuita__c> produtosDistGrat = new Set<BR_ProdutoDistribuicaoGratuita__c>();
                    for(BR_ProdutoDistribuicaoGratuita__c item : lstPrdDistGratuita) {
                        if(item.BR_Link__c == null){
                            produtosDistGrat.add(item);
                        }
                        else if (!mapDistGrat.containsKey(item.BR_Link__c)){
                            mapDistGrat.put(item.BR_Link__c, item);
                            item.BR_GerarLink__c = true;
                            produtosDistGrat.add(item);
                            
                        }
                        else {
                            item.BR_GerarLink__c = false;
                            produtosDistGrat.add(item);
                        }
                    }
                    
                    lstPrdDistGratuita = new List<BR_ProdutoDistribuicaoGratuita__c>(produtosDistGrat);
                                        
                }                
                List<Database.UpsertResult> lstUpResult = Database.upsert(lstPrdDistGratuita, BR_ProdutoDistribuicaoGratuita__c.BR_External_ID__c, false);
                for(Database.UpsertResult upResult : lstUpResult){
                    if(!upResult.isSuccess()){
                        for(Database.Error errUpsResult : upResult.getErrors()){
                            LogErroProcessamentoService.getInstance().registrarNovaInstanciaLogErroParaOportunidadeAdocao(idOpp, 'Erro ao criar Produto Distribuição Gratuita.', errUpsResult.getMessage());
                            errProcessamento += '\nErro ao criar Prod. Distr. Gratuita: ' + errUpsResult.getFields() + ': ' + errUpsResult.getStatusCode() + ' ' + errUpsResult.getMessage();
                        }   
                    }
                }
                
                if(String.isBlank(errProcessamento)){
                    List<Database.DeleteResult> lstDelResult = Database.delete(lstPrdDistGratuitaExcluir, false);
                    for(Database.DeleteResult delResult : lstDelResult){
                        if(!delResult.isSuccess()){
                            for(Database.Error errDelResult : delResult.getErrors()){
                                LogErroProcessamentoService.getInstance().registrarNovaInstanciaLogErroParaOportunidadeAdocao(idOpp, 'Erro ao excluir Produto Distribuição Gratuita.', errDelResult.getMessage());
                                errProcessamento += '\nErro ao excluir Prod. Distr. Gratuita: ' + errDelResult.getFields() + ': ' + errDelResult.getStatusCode() + ' ' + errDelResult.getMessage();
                            }   
                        }
                    }
                }
            }
            
            if(String.isNotBlank(errProcessamento)){
                Database.rollback(sp);
            }
        }
        catch(Exception exc){
            Database.rollback(sp);
            errProcessamento = exc.getMessage();
            LogErroProcessamentoService.getInstance().registrarNovaInstanciaLogErroParaOportunidadeAdocao(idOpp, 'Erro ao criar Distribuição Gratuita e Produtos da Distribuição Gratuita.', errProcessamento);
        }
        LogErroProcessamentoService.getInstance().comitarRegistrosDBLogErro();
        return errProcessamento;
    }
    
    public void montaURLPesquisaAdocao(List<BR_ProdutoDistribuicaoGratuita__c> lstPrdDistGratuita){
        
        list<String> lProdDisGrat = new list<String>();  
        list<String> lProd = new list<String>();  
        
        for(BR_ProdutoDistribuicaoGratuita__c prdDistGrat : lstPrdDistGratuita ){
            lProdDisGrat.add(prdDistGrat.BR_DistribuicaoGratuita__c);
            lProd.add(prdDistGrat.BR_ProdutoDistribuicaoGratuita__c);
        }
        
        Map<String, Product2> mapProd = new Map<String, Product2>();
        for(Product2 produto : Product2DAO.listaProduto(lProd)){
            mapProd.put(produto.Id, produto);
        }
        
        Set<Id> lDisGratOpp = new Set<Id>();  
        Map<String, BR_DistribuicaoGratuita__c> mapDistGrat = new Map<String, BR_DistribuicaoGratuita__c>();
        
        for(BR_DistribuicaoGratuita__c distrGrat : DistribuicaoGratuitaDAO.getInstance().buscaOppDistribuicao(lProdDisGrat)){
            lDisGratOpp.Add(distrGrat.BR_Oportunidade__c);
            mapDistGrat.put(distrGrat.Id, distrGrat);
        }
        
        Map<String, Opportunity> mapOpp = new Map<String, Opportunity>();
        
        for (Opportunity opp : OpportunityDAO.BuscarOportunidades(lDisGratOpp)){
            mapOpp.put(opp.Id, opp);
        }
        
        for(BR_ProdutoDistribuicaoGratuita__c prdDistGrat : lstPrdDistGratuita ){
            BR_DistribuicaoGratuita__c mDistGrat;
            mDistGrat = mapDistGrat.get(prdDistGrat.BR_DistribuicaoGratuita__c);	
            prdDistGrat.BR_Aos_Cuidados_de__c = mDistGrat.BR_Aos_Cuidados_de_Account_Contact__c;  
            prdDistGrat.BR_Instituicao__c = mDistGrat.BR_Instituicao__c; 
            prdDistGrat.BR_Email__c = mDistGrat.BR_Email__c;
            Opportunity mOpp; 
            mOpp = mapOpp.get(mDistGrat.BR_Oportunidade__c);	
            Product2 mProd;
            mProd = mapProd.get(prdDistGrat.BR_ProdutoDistribuicaoGratuita__c);
            String URL = RespostaEmailBO.getInstance().validaPesquisaLivro(mOpp.Id, mProd.Name, mProd.BR_Product_Code__c, mDistGrat.Id );
            if(URL != null){
                prdDistGrat.BR_EnviarPesquisa__c = true; 
                prdDistGrat.BR_URL__c = 'http://pearsonlatam-br.force.com/PesquisaSatisfacaoLivro?RespEmail=' + URL;
            }
        }
    }
    
    public Map<String, String> gerarLinkDistribuicao(List<String> lstCPFISBN){
        Map<String, String> mapCPFISBN_Link = new Map<String, String>();
        String sData = DateTime.now().addDays( 360 ).format( 'yyyyMMdd' );
        String sLink = 'https://amostras.bv3.digitalpages.com.br/user_session/authenticated_token?token={0}&isbn={1}&cpf={2}&date={3}&type=1&html5=true';
        
        for(String dadoConjunto : lstCPFISBN){
            String[] arrTMP = dadoConjunto.split('_');
            String cpf = arrTMP[0].replace('.', '').replace('-', '');
            String isbn = arrTMP[1];
            String sMD5 = calcularMD5(isbn, sData, cpf);
            sLink = sLink.replace('{0}', sMD5);
            sLink = sLink.replace('{1}', isbn);
            sLink = sLink.replace('{2}', cpf);
            sLink = sLink.replace('{3}', sData);
            mapCPFISBN_Link.put(dadoConjunto, sLink);
        }
        return mapCPFISBN_Link;
    }
    
    private String calcularMD5(String ISBN, String Data, String CPF ){
        String TOKEN = '94e310985841949d9c';        
        return EncodingUtil.convertToHex( Crypto.generateDigest( 'MD5', Blob.valueOf(ISBN + CPF + Data + TOKEN)));
    }
    
    public void processaDadosDistribuicaoGratuitaRelacionada(List<BR_ProdutoDistribuicaoGratuita__c> lstPrdDistGratuita, Map<Id, BR_ProdutoDistribuicaoGratuita__c> mapOldValues, Boolean isDelete){
        Set<String> setDistGratuitaId = new Set<String>();
        if(isDelete){
            for(BR_ProdutoDistribuicaoGratuita__c oppLineItem : mapOldValues.values()){
                setDistGratuitaId.add(oppLineItem.BR_DistribuicaoGratuita__c);
            }
        }
        else{
            for(BR_ProdutoDistribuicaoGratuita__c oppLineItem : lstPrdDistGratuita){
                setDistGratuitaId.add(oppLineItem.BR_DistribuicaoGratuita__c);
            }
        }
        
        DistribuicaoGratuitaBO.getInstance().setDadosEmailToDistribuicaoGratuita(new List<String>(setDistGratuitaId));
    }
    
    public void setDadosEmailToDistribuicaoGratuita(List<String> lstDistribuicaoGratuitaId){
        if(DistribuicaoGratuitaBO.isProcessedByTrigger) return;
        
        Map<String, String> mapDadosDistGratDadosEmail = new Map<String, String>();
        for(BR_DistribuicaoGratuita__c distGratuita : DistribuicaoGratuitaDAO.getInstance().getDistribuicaoGratuitaByListId(lstDistribuicaoGratuitaId)){
            for(BR_ProdutoDistribuicaoGratuita__c prdDistGratuita : distGratuita.ProdutosDistribuicaoGratuita__r){
                String dadosTabela = mapDadosDistGratDadosEmail.get(distGratuita.Id);
                if(dadosTabela == null){
                    dadosTabela = '<table>';
                    dadosTabela += '<tr>';
                    dadosTabela += '<td><b>Livro</b></td>';
                    dadosTabela += '<td><b>Curso</b></td>';
                    dadosTabela += '<td><b>Disciplina</b></td>';
                    dadosTabela += '<td><b>Núm. Alunos</b></td>';
                    dadosTabela += '</tr>';
                }
                dadosTabela += '<tr>';
                dadosTabela += '<td>' + prdDistGratuita.BR_ProdutoDistribuicaoGratuita__r.Name + '</td>';
                dadosTabela += '<td>' + (String.isNotBlank(prdDistGratuita.BR_Curso__r.Name) ? prdDistGratuita.BR_Curso__r.Name : '') + '</td>';
                dadosTabela += '<td>' + (String.isNotBlank(prdDistGratuita.BR_Disciplina__r.Name) ? prdDistGratuita.BR_Disciplina__r.Name : '') + '</td>';
                dadosTabela += '<td>' + prdDistGratuita.BR_NAlunos__c + '</td>';
                dadosTabela += '</tr>';
                mapDadosDistGratDadosEmail.put(distGratuita.Id, dadosTabela);
            }
        }
        
        List<BR_DistribuicaoGratuita__c> lsDistGratuitaToUpdate = new List<BR_DistribuicaoGratuita__c>();
        for(String distGratuitaId : mapDadosDistGratDadosEmail.keySet()){
            String dadosTabela = (mapDadosDistGratDadosEmail.containsKey(distGratuitaId) ? mapDadosDistGratDadosEmail.get(distGratuitaId) + '</table>' : '');
            BR_DistribuicaoGratuita__c distGratuitaToUpdate = new BR_DistribuicaoGratuita__c(Id = distGratuitaId);
            distGratuitaToUpdate.BR_ProdutosEnvioEmail__c = dadosTabela;
            
            BR_DistribuicaoGratuita__c  distribuicaoGratuita = DistribuicaoGratuitaDAO.getInstance().buscaOportunidadeDistribuicao(distGratuitaToUpdate.Id);
            
            Opportunity Oportunidade = OpportunityDAO.buscaProdutoEmailOportunidade(distribuicaoGratuita.BR_Oportunidade__c);
            if (Oportunidade != null){
                distGratuitaToUpdate.BR_ProdutosEnvioEmailOportunidade__c = Oportunidade.BR_ProdutosEnvioEmail__c; 
            }             
            lsDistGratuitaToUpdate.add(distGratuitaToUpdate);
        }
        
        update lsDistGratuitaToUpdate;
        DistribuicaoGratuitaBO.isProcessedByTrigger = true;
    }
    
    public Map<Id, List<BR_ProdutoDistribuicaoGratuita__c>> buscarProdutosDistribuicao(Id idOportunidade)
    {
        List<BR_DistribuicaoGratuita__c> lstDistruibuicaoGratuita = new List<BR_DistribuicaoGratuita__c>();
        Map<Id, BR_DistribuicaoGratuita__c> mapDistribuicao = new Map<Id, BR_DistribuicaoGratuita__c>();
        Set<Id> idsDistribuicao = new Set<Id>();
        List<BR_ProdutoDistribuicaoGratuita__c> lstProdutos = new List<BR_ProdutoDistribuicaoGratuita__c>();
        Map<Id, List<BR_ProdutoDistribuicaoGratuita__c>> mapProdutosDistribuicao = new Map<Id, List<BR_ProdutoDistribuicaoGratuita__c>>();
        lstDistruibuicaoGratuita = DistribuicaoGratuitaDAO.getInstance().buscarDistruibuicaoGratuita(idOportunidade);
        
        for(BR_DistribuicaoGratuita__c distribuicao : lstDistruibuicaoGratuita)
        {
            BR_DistribuicaoGratuita__c distGratuita = mapDistribuicao.get(distribuicao.BR_Oportunidade__c);
            
            if(distGratuita == null)
                mapDistribuicao.put(distribuicao.BR_Oportunidade__c, distribuicao);
            else if(distribuicao.CreatedDate > distGratuita.CreatedDate)
            	mapDistribuicao.put(distribuicao.BR_Oportunidade__c, distribuicao);
        }
        
        for(BR_DistribuicaoGratuita__c distribuicao : mapDistribuicao.values())
        {
            idsDistribuicao.add(distribuicao.Id);
        }
        
        List<BR_ProdutoDistribuicaoGratuita__c> listProdutos = new List<BR_ProdutoDistribuicaoGratuita__c>();
        for(BR_ProdutoDistribuicaoGratuita__c produtos : DistribuicaoGratuitaDAO.getInstance().buscarProdutosDistruibuicao(idsDistribuicao))
        { 
            listProdutos.add(produtos);
        }
        
        mapProdutosDistribuicao.put(idOportunidade, listProdutos);
        return mapProdutosDistribuicao;
    }
    
    public Database.QueryLocator buscarDistribuicaoErroIntegracao(){
        return DistribuicaoGratuitaDAO.getInstance().buscarDistribuicaoErroIntegracao();
    }
    
    public void integrarDistribuicaoOrdemVendaSAP(List<SObject> listaDG, Map<Id, SObject> mapDGAnteriores){
        List<BR_DistribuicaoGratuita__c> dgParaIntegrar = new List<BR_DistribuicaoGratuita__c>();
        Set<Id> idsDG= new Set<Id>();
        BR_DistribuicaoGratuita__c distrAnterior = null;
        Id idDG = RecordTypeUtil.getInstance().getRecordTypePorNome('BR_DistribuicaoGratuita__c',
                                                                    'Distribuição Gratuita').getRecordTypeId();
        for(BR_DistribuicaoGratuita__c distribuicao : (List<BR_DistribuicaoGratuita__c>)listaDG){
            distrAnterior = (BR_DistribuicaoGratuita__c)mapDGAnteriores.get(distribuicao.Id);
            if(distribuicao.BR_StatusProcessoAprovacao__c == 'APROVADO' && 
               distrAnterior.BR_StatusProcessoAprovacao__c != 'APROVADO' &&
               distribuicao.RecordTypeId == idDG){
                   idsDG.add(distribuicao.Id);
               }
        }
        if(!idsDG.isEmpty()){
            integrarDistribuicaoOrdemVenda(idsDG);
        }
    }
    
    @future(callout=true)
    private static void integrarDistribuicaoOrdemVenda(Set<Id> idsDg){
        List<BR_DistribuicaoGratuita__c> dgParaIntegrar = DistribuicaoGratuitaDAO.getInstance().obterDistribuicaoGratuitaPorSetId(idsDG);
        if(!dgParaIntegrar.isEmpty()){
            OpportunityBO.getInstance().integrarDistribuicaoOrdemVenda(dgParaIntegrar);
        }
    }
    
    public void alterarFaseDG(List<SObject> listaProdDG, Map<Id, SObject> mapProdDGAnteriores){
        Set<String> idsDgAtualizar = new Set<String>();
        List<BR_DistribuicaoGratuita__c> dgParaAtualizar = new List<BR_DistribuicaoGratuita__c>();
        BR_ProdutoDistribuicaoGratuita__c prodAnterior = null;
        
        for(BR_ProdutoDistribuicaoGratuita__c produto :(List<BR_ProdutoDistribuicaoGratuita__c>)listaProdDG){
            prodAnterior = (BR_ProdutoDistribuicaoGratuita__c)mapProdDGAnteriores.get(produto.Id);
            
            if(produto.BR_Enviado__c == true && prodAnterior.BR_Enviado__c != true){
                idsDgAtualizar.add(produto.BR_DistribuicaoGratuita__c);
            }
        }
        
        if(!idsDgAtualizar.isEmpty()) {
            
            List<String> listaIdDg = new List<String>();
            listaIdDg.addAll(idsDgAtualizar);
            dgParaAtualizar = DistribuicaoGratuitaDAO.getInstance().getDistribuicaoGratuitaByListId(listaIdDg);
            
            Map<Id,BR_DistribuicaoGratuita__c> mapOppDistrGrat = new Map<Id, BR_DistribuicaoGratuita__c>();
            
            Set<Id> idsOppParaAtualizar = new Set<Id>();
            Id idAmostraVirtual = RecordTypeUtil.getInstance().getRecordTypePorNome('BR_DistribuicaoGratuita__c',
                                                                                    'Amostra Virtual').getRecordTypeId();
            for (BR_DistribuicaoGratuita__c distrGrat:dgParaAtualizar) {
                if (distrGrat.RecordTypeId == idAmostraVirtual) {
                    mapOppDistrGrat.put(distrGrat.BR_Oportunidade__c, distrGrat);
                    idsOppParaAtualizar.add(distrGrat.BR_Oportunidade__c);
                }
            }
            
            if (!idsOppParaAtualizar.isEmpty()) { 
                List<Opportunity> lstOppParaAtualizar = OpportunityDAO.BuscarOportunidades(idsOppParaAtualizar);
                for (Opportunity opp:lstOppParaAtualizar) {
                    opp.StageName = 'Professor Avaliando';
                    opp.BR_DataRecebimentoNotificacao__c = mapOppDistrGrat.get(opp.Id).BR_DataAprovacao__c;
                }
                
                Database.update(lstOppParaAtualizar);
            }
        }
    }
    
    public void onChangeStage(List<SObject> listaDG, Map<Id, SObject> mapDGAnteriores){
        Set<String> idsCaso = new Set<String>();
        BR_DistribuicaoGratuita__c dgAnterior = null;
        
        for(BR_DistribuicaoGratuita__c distriGrat :(List<BR_DistribuicaoGratuita__c>)listaDG){
            dgAnterior = (BR_DistribuicaoGratuita__c)mapDGAnteriores.get(distriGrat.Id);
            
            if(distriGrat.BR_StatusProcessoAprovacao__c == 'APROVADO' && dgAnterior.BR_StatusProcessoAprovacao__c != 'APROVADO'){
                idsCaso.add(distriGrat.Caso__c);
            }
        }
        
        if(!idsCaso.isEmpty()){
            List<String> listIdCaso = new List<String>();
            listIdCaso.addAll(idsCaso);
            List<Case> listaCasos = CaseDAO.getInstance().buscaCasesPorListaId(listIdCaso);
            
            for(Case caso : listaCasos){
                caso.Possui_DG__c = true;
            }
            
            Database.update(listaCasos);
        }
    }
}