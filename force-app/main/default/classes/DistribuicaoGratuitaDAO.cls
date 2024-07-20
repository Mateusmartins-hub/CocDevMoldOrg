public with sharing class DistribuicaoGratuitaDAO {
    private static final DistribuicaoGratuitaDAO instance = new DistribuicaoGratuitaDAO();
    private DistribuicaoGratuitaDAO() {
    }

    public static DistribuicaoGratuitaDAO getInstance(){
        return instance;
    }

    public List<BR_DistribuicaoGratuita__c> getDistribuicaoGratuitaByListId(List<String> lstIdsDistribuicaoGratuita){
        return [SELECT Id, BR_Instituicao__c, BR_Oportunidade__c, BR_AosCuidados__c, RecordTypeId, BR_Email__c, BR_FormaEnvio__c, BR_CentroCusto__c,
                       BR_Logradouro__c, BR_Cidade__c, BR_CEP__c, BR_Estado__c, BR_Pais__c, BR_TipoEndereco__c, BR_ValidaDistribuicaoGratuita__c,  BR_Aos_Cuidados_de_Account_Contact__c,
                        BR_DataAprovacao__c,
                            (SELECT Id, BR_Curso__c, BR_Disciplina__c, BR_DistribuicaoGratuita__c, BR_DistribuicaoGratuita__r.BR_Oportunidade__r.BR_ValidaDistribuicaoGratuita__c, BR_FormaEnvio__c, BR_Enviado__c, BR_GerarLink__c, BR_Link__c, 
                                    BR_NAlunos__c, BR_ProdutoDistribuicaoGratuita__c, BR_Quantidade__c, BR_UltimaDataEnvio__c,
                                    BR_Curso__r.Name, BR_Disciplina__r.Name, BR_ProdutoDistribuicaoGratuita__r.Name, BR_ItemRetirado__c, BR_Produto_Adicional__c
                               FROM ProdutosDistribuicaoGratuita__r)
                  FROM BR_DistribuicaoGratuita__c
                 WHERE Id IN: lstIdsDistribuicaoGratuita];
    }

   public BR_DistribuicaoGratuita__c buscaRespostaAdocaoDistribuicao(string distribuicaoId){
        
        BR_DistribuicaoGratuita__c  distribuicaoGratuita = new BR_DistribuicaoGratuita__c();
        distribuicaoGratuita = [ SELECT Id, BR_RespondeuAdocao__c 
                                   FROM BR_DistribuicaoGratuita__c 
                                  Where Id =: distribuicaoId ];
        
        return distribuicaoGratuita;
    } 

    public BR_DistribuicaoGratuita__c buscaOportunidadeDistribuicao(string distribuicaoId){
        
        BR_DistribuicaoGratuita__c  distribuicaoGratuita = new BR_DistribuicaoGratuita__c();
        distribuicaoGratuita = [ SELECT BR_Oportunidade__c 
                                   FROM BR_DistribuicaoGratuita__c 
                                  Where Id =: distribuicaoId ];
        
        return distribuicaoGratuita;
    } 
    
    public list<BR_DistribuicaoGratuita__c> buscaOppDistribuicao(list<string> lDistribuicaoId){
        
        list<BR_DistribuicaoGratuita__c>  lDistGrat = new list<BR_DistribuicaoGratuita__c>();
        
        lDistGrat = [ SELECT BR_Oportunidade__c , BR_Aos_Cuidados_de_Account_Contact__c, BR_Instituicao__c, BR_Email__c 
                                   FROM BR_DistribuicaoGratuita__c 
                                  Where Id =: lDistribuicaoId ];
        
        return lDistGrat;
    } 

    public List<BR_DistribuicaoGratuita__c> buscarDistruibuicaoGratuita(Id idOportunidade)
    {
      Id tipoRegistro = RecordTypeUtil.getInstance().getRecordTypePorNome('BR_DistribuicaoGratuita__c', 'Amostra Física').getRecordTypeId();
      List<BR_DistribuicaoGratuita__c> lstDistruibuicaoGratuita = [SELECT Id, CreatedDate, BR_Oportunidade__c,BR_TipoEndereco__c, BR_FormaEnvio__c, RecordTypeId
                                                                     FROM BR_DistribuicaoGratuita__c
                                                                    WHERE BR_Oportunidade__c =: idOportunidade
                                                                      AND RecordTypeId =: tipoRegistro];
      return lstDistruibuicaoGratuita;                                                                      
    }

    public List<BR_ProdutoDistribuicaoGratuita__c> buscarProdutosDistruibuicao(Set<Id> idsDistribuicao)
    {
      List<BR_ProdutoDistribuicaoGratuita__c> lstProdutos = [SELECT Id, BR_Quantidade__c, BR_ProdutoDistribuicaoGratuita__r.BR_Product_Code__c, BR_DistribuicaoGratuita__c
                                                               FROM BR_ProdutoDistribuicaoGratuita__c
                                                              WHERE BR_DistribuicaoGratuita__c =: idsDistribuicao];
      return lstProdutos;                                                              
    } 

   public List<BR_DistribuicaoGratuita__c> listaDistruibuicaoPorOpp(String oppId)
    {
      List<BR_DistribuicaoGratuita__c> lstDistruibuicaoGratuita = [SELECT Id, BR_RespondeuAdocao__c, BR_DetalheEnvio__c
                                                               FROM BR_DistribuicaoGratuita__c
                                                              WHERE BR_Oportunidade__c =: oppId];
      return lstDistruibuicaoGratuita;                                                              
    } 

  public List<BR_ProdutoDistribuicaoGratuita__c> buscarProdDist(list<String> lProdId, string DistrId)
    {
      List<BR_ProdutoDistribuicaoGratuita__c> lstProdutos = [SELECT Id, BR_EnviarPesquisa__c, BR_URL__c
                                                               FROM BR_ProdutoDistribuicaoGratuita__c
                                                              WHERE BR_DistribuicaoGratuita__c =: DistrId
                                                                and BR_ProdutoDistribuicaoGratuita__c =: lProdId ];
      return lstProdutos;                                                              
    } 

    public List<BR_DistribuicaoGratuita__c> obterDistribuicaoGratuitaPorIdOportunidade(Id idOportunidade){
        return [SELECT Id, BR_Instituicao__c, BR_Oportunidade__c, BR_AosCuidados__c, BR_Aos_Cuidados_de_Account_Contact__c, RecordTypeId,
                    BR_Aos_Cuidados_de_Account_Contact__r.Account__r.BR_Account_Id_SAP__c, BR_TipoOrdemVenda__c, BR_AprovadorNivel1__c,
                    BR_AprovadorNivel2__c, BR_CodigoOrganizacaoVenda__c, BR_CodigoCanalDistribuicao__c, BR_CodigoSetorAtividade__c,
                    BR_CentroCusto__c, BR_Email__c, BR_FormaEnvio__c, BR_IntegradoSucesso__c, BR_Integrar__c,
                    (SELECT Id, Name, BR_DistribuicaoGratuita__c, BR_Email__c, BR_FormaEnvio__c, BR_ISBN__c, BR_PrecoCusto__c, BR_Quantidade__c
                        FROM ProdutosDistribuicaoGratuita__r)
                FROM BR_DistribuicaoGratuita__c
                WHERE  BR_Integrar__c = true
                AND BR_Oportunidade__c =: idOportunidade];
    }

    public List<BR_DistribuicaoGratuita__c> getDistribuicaoGratuitaByOppId(Id oppId){
    	return [SELECT Id, BR_TipoEndereco__c FROM BR_DistribuicaoGratuita__c WHERE	BR_Oportunidade__c =: oppId];
    }

    public Database.QueryLocator buscarDistribuicaoErroIntegracao(){

        return Database.getQueryLocator( 'SELECT Id, BR_Oportunidade__c, BR_IntegradoSucesso__c,BR_Integrar__c, ' +
                ' BR_ErroIntegracao__c,BR_TipoOrdemVenda__c,BR_CodigoOrganizacaoVenda__c,BR_CodigoCanalDistribuicao__c,' +
                ' BR_CodigoSetorAtividade__c,BR_Aos_Cuidados_de_Account_Contact__r.Account__r.BR_Account_Id_SAP__c,BR_CentroCusto__c, Name,' +
                '(SELECT Id, Name, BR_DistribuicaoGratuita__c, BR_Email__c, BR_FormaEnvio__c, BR_ISBN__c, BR_PrecoCusto__c, BR_Quantidade__c FROM ProdutosDistribuicaoGratuita__r) ' +
                ' FROM BR_DistribuicaoGratuita__c ' +
                ' WHERE  BR_ErroIntegracao__c = true ' +
                ' AND BR_Integrar__c = true' );
    }

    public List<BR_DistribuicaoGratuita__c> obterDistribuicaoGratuitaPorSetId(Set<Id> idsDG){
        return [SELECT Id, BR_Instituicao__c, BR_Oportunidade__c, BR_AosCuidados__c, BR_Aos_Cuidados_de_Account_Contact__c, RecordTypeId,
                BR_Aos_Cuidados_de_Account_Contact__r.Account__r.BR_Account_Id_SAP__c, BR_TipoOrdemVenda__c, BR_AprovadorNivel1__c,
                BR_AprovadorNivel2__c, BR_CodigoOrganizacaoVenda__c, BR_CodigoCanalDistribuicao__c, BR_CodigoSetorAtividade__c,
                BR_CentroCusto__c, BR_Email__c, BR_FormaEnvio__c, BR_IntegradoSucesso__c, BR_Integrar__c,BR_Centro__c, Name,
                (SELECT Id, Name, BR_DistribuicaoGratuita__c, BR_Email__c, BR_FormaEnvio__c, BR_ISBN__c, BR_PrecoCusto__c, BR_Quantidade__c
                        FROM ProdutosDistribuicaoGratuita__r)
                FROM BR_DistribuicaoGratuita__c
                WHERE  BR_Integrar__c = true
        AND Id IN:idsDG];
    }
    
}