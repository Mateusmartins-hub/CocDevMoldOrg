global with sharing class ProductsResource {
    global class ProductInfo {
        webservice String name;
        webservice String code;
        webservice Boolean isActive;
        webservice String description;
        webservice String family;
        webservice String isbn;
        webservice String segmento;
        webservice String idSegmento;
        webservice String disciplina;
        webservice String editora;
        webservice String prodComRestricao;
        webservice String idSerieAno;
        webservice String course;
        webservice Boolean digitalProduct;
        webservice String authorName;
        webservice Boolean sampleUseExclusive;
        webservice Date prodCreatedDate;
        webservice String linhaNegocio;
        webservice String tipoProd;
        webservice String origem;
        webservice String nivel;
        webservice String complemento;
        webservice String flagBloqueado;
        webservice String colecaoDescription;
        webservice String segmentoDescription;
        webservice String serieAnoDescription;
        webservice String productTypeDetail;
        webservice String originDescription;
        webservice Double destionIntegracao;
        webservice Boolean salesUseExclusive;
        webservice String serieAno;
        webservice String businessLine;
        webservice String serie;
        webservice Double qtdeMaxima;
        webservice Double qtdeMinima;
        webservice String titulo;
        webservice String link;
        webservice Double precoCusto;
    }
    
    webservice static String insertProducts(List<ProductInfo> prods) {
        try{
        List<Product2> prodsInsert = new List<Product2>();
        
        for(ProductInfo p : prods) {
            Product2 prod = new Product2();
            
            prod.Name = p.name;
            prod.BR_Product_Code__c = p.code;
            prod.isActive = p.isActive == null ? false : p.isActive;
            prod.Description = p.description;
            prod.Family = p.family;
            prod.BR_ISBN__c = p.isbn;
            prod.BR_segmento__c = p.segmento;
            prod.ID_Segmento__c = p.idSegmento;
            prod.BR_Disciplina__c = p.disciplina;
            prod.BR_editora__c = p.editora;
            prod.BR_Produto_com_restricao__c = p.prodComRestricao;
            prod.BR_ID_Serie_Ano__c = p.idSerieAno;
            prod.BR_Course__c = p.course;
            prod.BR_Digital_Product__c = p.digitalProduct == null ? false : p.digitalProduct;
            prod.BR_Author_name__c = p.authorName;
            prod.Sample_use_exclusive__c = p.sampleUseExclusive == null ? false : p.sampleUseExclusive;
            prod.Br_Product_Created_Date__c = p.prodCreatedDate;
            prod.BR_Linha_Negocio__c = p.linhaNegocio;
            prod.BR_Tipo_Produto__c = p.tipoProd;
            prod.BR_Origem__c = p.origem;
            prod.BR_Nivel__c = p.nivel;
            prod.BR_Complemento__c = p.complemento;
            prod.BR_Flag_Bloqueado__c = p.flagBloqueado;
            prod.BR_Colecao_Description__c = p.colecaoDescription;
            prod.BR_Segmento_Description__c = p.segmentoDescription;
            prod.BR_Serie_Ano_Description__c = p.serieAnoDescription;
            prod.Sales_use_exclusive__c = p.salesUseExclusive == null ? false : p.salesUseExclusive;
            prod.BR_Serie_Ano__c = p.serieAno;
            prod.BR_serie__c = p.serie;
            prod.Qtde_M_xima__c = p.qtdeMaxima;
            prod.Qtde_Minima__c = p.qtdeMinima;
            prod.BR_Titulo__c = p.titulo;
            prod.BR_Link__c = p.link;
            prod.BR_PrecoCusto__c = p.precoCusto;
            
            prodsInsert.add(prod);
        }
        
        List<Database.UpsertResult> upsertResults = Database.upsert(prodsInsert, Product2.BR_Product_Code__c.getDescribe().getSObjectField(), false);
        
        String erros = '';
        for (Database.UpsertResult r : upsertResults) {
            if (!r.isSuccess()) {
                for (Database.Error e : r.getErrors()) { 
                    erros+=e.getMessage();
                }
            }
        }
        
        if(!String.isEmpty(erros))
            return erros;
        else
            return 'OK';
        }catch(Exception e){
            throw e;
        }
    }
}