@RestResource(urlMapping='/ProcessoHybrisCaso/*')
global without sharing class RestHybris {
    @HttpPost
    global static retornoInsertCaso insertCaso(ParamInsertCaso pedido) {
        try {
            pedido.conta.cpfCnpj = formatCpfCnpj(pedido.conta.cpfCnpj);
            
            List<Account> clientes = getCliente(pedido.conta.cpfCnpj);
            
            Case caso = new Case();
            caso.Origin = 'Hybris';
            
            caso.MarcaAtendimento__c = pedido.marca;
            caso.BR_NumeroPedido__c = pedido.num;
            caso.StatusDevolucao__c = pedido.status;
            caso.MotivoDevolucao__c = pedido.motivoCaso;
            caso.ValorTotalPedido__c = pedido.valorTotal;
            caso.valorTotalADevolver__c = pedido.valorTotalADevolver;
            
            //1: Devolução, 2: Troca de materiais, 3: Checklist 
            String tParam = RestContext.request.params.get('t');
            
            if(tParam != '1' && tParam != '2' && tParam != '3')
                throw new CustomException('Tipo de requisição inválido, valores válidos: 1 (Devolução), 2 (Troca de Materiais) e 3 (Checklist)');
            
            Integer tipoReq = Integer.valueOf(tParam);
            String tipoReqText = tipoReq == 1 ? 'Devolução de Pedido' : tipoReq == 2 ? 'Divergência no pedido' : tipoReq == 3 ? 'Divergência no pedido' : null;
            
            if(clientes.size() > 0) {
                caso.AccountId = clientes[0].Id;
                caso.Subject = tipoReqText + ' ' + clientes[0].Name;
                caso.Description = tipoReqText;
                
                if(tipoReq == 1) {
                    caso.Tipo__c = 'Logística';
                    caso.Subtipo__c = 'Devolução K12 / EDU';
                    caso.Detalhamento__c = 'Escolas';
                }else if(tipoReq == 2) {
                    caso.Tipo__c = 'Logística';
                    caso.Subtipo__c = 'Divergência no pedido';
                    caso.Detalhamento__c = 'Material avariado';
                }else if(tipoReq == 3) {
                    caso.Tipo__c = 'Logística';
                    caso.Subtipo__c = 'Divergência no pedido';
                    caso.Detalhamento__c = 'Falta ou sobra de material';
                }
            }else{
                caso.Subject = 'Novo Cadastro & ' + tipoReqText + ' ' + pedido.conta.razaoSocial;
                caso.Description = 'Novo Cadastro & ' + tipoReqText;
                caso.Tipo__c = 'Cadastro';
                caso.Subtipo__c = 'Novo Cadastro';
                
                if(tipoReq == 1)
                    caso.Detalhamento__c = 'Devoluções';
                else if(tipoReq == 2)
                    caso.Detalhamento__c = 'Material avariado';
                else if(tipoReq == 3)
                    caso.Detalhamento__c = 'Falta ou sobra de material';
                
                caso.InformacoesContaACriar__c = getInfoConta(pedido);
            }
            
            insert caso;
            caso = [SELECT Id, Status, CaseNumber FROM Case WHERE id = :caso.Id];
            
            getInfoOVs(pedido, caso.Id);
            
            retornoInsertCaso t = new retornoInsertCaso();
            t.status = true;
            t.message = 'Caso criado com sucesso!';
            t.numCaso = caso.CaseNumber;
            
            return t;
        } catch(Exception e) {
            retornoInsertCaso t = new retornoInsertCaso();
            t.status = false;
            t.message = e.getMessage() + ' ' + e.getStackTraceString();
            
            return t;
        }
    }
    
    @HttpGet
    global static retornoAcompanhamentoCaso getCasoDevolucaoStatus() {
        try {
            retornoAcompanhamentoCaso t = new retornoAcompanhamentoCaso();
            
            RestRequest req = RestContext.request;
            
            String caseNumber = req.requestURI.substring(req.requestURI.lastIndexOf('/')+1);
            List<Case> caso = [SELECT Id, Status, StatusDevolucao__c, CaseNumber, (SELECT Id, BR_Caso__c, BR_Cod_Item__c, NumOV__c, Name, 
                                                                                   BR_Qtd_Comprada__c, BR_Qtd_Informada__c, BR_Qtd_Recebida__c, QuantidadeAvariada__c, BR_Valor_Unitario__c, BR_Descri_o_do_Defeito__c , Observacoes__c
                                                                                   FROM Materiais__r)
                               FROM Case WHERE CaseNumber = :caseNumber AND Origin = 'Hybris'];
            if(caso.isEmpty()) {
                throw new CustomException('Caso não encontrado com o número ' + caseNumber);
            }else{ 
                t.status = caso[0].StatusDevolucao__c;
                t.message = 'Caso recuperado com sucesso!';
                t.produtos = getInfoProds(caso[0]);
            }
            
            return t;
        } catch(Exception e) {
            retornoAcompanhamentoCaso t = new retornoAcompanhamentoCaso();
            t.status = 'Erro';
            t.message = e.getMessage() + ' ' + e.getStackTraceString();
            
            return t;
        }
    }
    
    @HttpPut
    global static retornoUpdateStatusCase updateStatusCase(ParamUpdateStatusCaso pedido) {
        try {
            retornoUpdateStatusCase t = new retornoUpdateStatusCase();
            
            RestRequest req = RestContext.request;
            
            String caseNumber = req.requestURI.substring(req.requestURI.lastIndexOf('/')+1);
            List<Case> caso = [SELECT Id, Status, StatusDevolucao__c, CaseNumber FROM Case WHERE CaseNumber = :caseNumber];
            if(caso.isEmpty()) {
                throw new CustomException('Caso não encontrado com o número ' + caseNumber);
            }else{
                caso[0].StatusDevolucao__c = pedido.status;
                update caso[0];
                
                t.numCaso = caso[0].CaseNumber;
                t.status = true;
                t.message = 'Caso atualizado para o status ' + pedido.status + '!';
            }
            
            return t;
        } catch(Exception e) {
            retornoUpdateStatusCase t = new retornoUpdateStatusCase();
            t.status = false;
            if(e.getMessage().contains('INVALID_OR_NULL_FOR_RESTRICTED_PICKLIST'))
                t.message = 'Status de devolução inexistente ou incorreto.';
            else
                t.message = e.getMessage() + ' ' + e.getStackTraceString();
            
            return t;
        }
    }
    
    private static string formatCpfCnpj(String texto) {  
        if(String.IsBlank(texto))
            return texto;
        else{
            texto = texto.replaceAll('[|,|.|/|\\,||"||:|~|!|@|#|$|%|^|&|*|_|-|-|+|=|<|>|?|\\(|\\)|\\{|\\}|\\;|\\\'"]', '');
            
            if(texto.length() == 11) {
                texto = texto.substring(0, 3) + '.' + texto.substring(3, 6) + '.' + texto.substring(6, 9) + '-' + texto.substring(9, 11);
            }else if(texto.length() == 14) {
                texto = texto.substring(0, 2) + '.' + texto.substring(2, 5) + '.' + texto.substring(5, 8) + '/' + texto.substring(8, 12) + '-' + texto.substring(12, 14);
            }
            
            return texto;
        } 
    }
    
    public static List<Account> getCliente(String cpfCnpj) {
        return [SELECT Id, Name, BR_CNPJ_CPF__c FROM Account WHERE BR_CNPJ_CPF__c =: cpfCnpj ORDER BY CreatedDate ASC];
    }
    
    public static String getInfoConta(ParamInsertCaso pedido) {
        return 'Razão Social: ' + pedido.conta.razaoSocial + '\nNome Fantasia: ' + pedido.conta.nomeFantasia + '\nCPF: ' + pedido.conta.cpfCnpj + '\nCidade: ' + pedido.conta.cidade + '\nUF: ' + pedido.conta.UF;
    }
    
    public static void getInfoOVs(ParamInsertCaso pedido, Id casoId) {
        List<Materiais__c> mats = new List<Materiais__c>();
        
        for(OVHybris ov : pedido.ovs) {
            for(ProductHybris p : ov.prods){
                Materiais__c m = new Materiais__c();
                
                m.BR_Caso__c = casoId;
                m.BR_Cod_Item__c = p.sku;
                m.DataNF__c = p.dataNf;
                m.NumeroNF__c = p.numNF;
                m.NumOV__c = String.valueOf(ov.num);
                m.Name = p.nome;
                m.BR_Qtd_Comprada__c = p.qtComprada;
                m.BR_Qtd_Informada__c = p.qtInformada;
                m.BR_Qtd_Recebida__c = p.qtRecebida;
                m.QuantidadeAvariada__c = p.qtAvariada;
                m.BR_Valor_Unitario__c = p.valorUnit;
                m.BR_Descri_o_do_Defeito__c = p.defeito;
                
                mats.add(m);
            }
        }
        
        insert mats;
    }
    
    public static List<dadosRetornoAcompanhamentoCaso> getInfoProds(Case caso) {
        List<dadosRetornoAcompanhamentoCaso> prods = new List<dadosRetornoAcompanhamentoCaso>();
        
        for(Materiais__c m : caso.Materiais__r) {
            dadosRetornoAcompanhamentoCaso prod = new dadosRetornoAcompanhamentoCaso();
            
            prod.nome = m.Name;
            prod.sku = isEmpty(m.BR_Cod_Item__c);
            prod.descDefeito = isEmpty(m.BR_Descri_o_do_Defeito__c);
            prod.obervacoes = isEmpty(m.Observacoes__c);
            prod.qtRecebida = m.BR_Qtd_Recebida__c;
            prod.qtAvariada = m.QuantidadeAvariada__c;
            
            prods.add(prod);
        }
        
        return prods;
    }
    
    @TestVisible
    private static String isEmpty(String r) {
        return r == null ? '' : r;
    }
    
    global class ParamUpdateStatusCaso {
        public String status;
    }
    
    global class ParamInsertCaso {
        public String num;
        public String marca;
        public String status;
        public String motivoCaso;
        public Decimal valorTotal;
        public Decimal valorTotalADevolver;
        public ContaHybris conta;
        public List<OVHybris> ovs;
        
        public ParamInsertCaso() {
            this.ovs = new List<OVHybris>();
        }
    }
    
    global class ContaHybris { 
        public String cpfCnpj;
        public String razaoSocial;
        public String nomeFantasia;
        public String cidade;
        public String UF;
    }
    
    global class OVHybris {
        public Integer num;
        public String tipo;
        public List<ProductHybris> prods;
        
        public OVHybris() {
            this.prods = new List<ProductHybris>();
        }
    }
    
    global class ProductHybris {
        public String nome;
        public String sku;
        public String numNF;
        public String defeito;
        public Date dataNF;
        public Decimal qtComprada;
        public Decimal qtInformada;
        public Decimal qtRecebida;
        public Decimal qtAvariada;
        public Decimal valorUnit;
    }
    
    global class retornoInsertCaso {
        public Boolean status;
        public String numCaso;
        public String message;
    }
    
    global class retornoUpdateStatusCase {
        public Boolean status;
        public String numCaso;
        public String message;
    }
    
    global class retornoAcompanhamentoCaso {
        public String status;
        public String message;
        public List<dadosRetornoAcompanhamentoCaso> produtos;
        
        public retornoAcompanhamentoCaso() {
            this.produtos = new List<dadosRetornoAcompanhamentoCaso>();
        }
    }
    
    global class dadosRetornoAcompanhamentoCaso {
        public String nome;
        public String sku;
        public String descDefeito;
        public String obervacoes;
        public Decimal qtRecebida;
        public Decimal qtAvariada;
    }
    
    public class CustomException extends Exception {}
}