public without sharing class OpportunityDAO { 
     
    public static List<Opportunity> getListOppById(List<String> aListIdsOpp, Set<String> aIdsRecType){
        return [ SELECT Id, BR_rep__r.Business_Line__c, BR_Account_Segmentation__c, OwnerId
                  FROM Opportunity 
                 WHERE Id =: aListIdsOpp 
                   AND RecordTypeId =: aIdsRecType ];
    }
    
    public static List<Opportunity> getListOppById(List<String> aListIdsOpp){
            return [ SELECT Id, BR_Account_Segmentation__c,BR_Desconto_1_ano__c, BR_Desconto_2_ano__c, BR_Desconto_3_ano__c, Probability, ForecastCategory,
                        BR_Desconto_4_ano__c, BR_Desconto_5_ano__c, BR_Ano_Inicio_do_contrato__c, BR_Vigencia_do_contrato_anos__c, Pricebook2.Name, 
                        BR_Imprimir_Proposta_Comercial_K12__c, RecordTypeId, Account.Name, AccountId, Name,  RecordType.Name, Account.BillingPostalCode,
                        Cod_Local_do_Estoque__c, Account.BillingStreet, Account.BillingCity, Account.BillingCountry, BR_DataRecebimentoNotificacao__c, 
                        Account.BillingState, Account.BR_Main_Address__c, Account.BR_Main_Nbr__c, Account.BR_Main_Complement__c, BR_Account_Contact__c,
                        Account.BR_Main_District__c, Account.BR_Main_City__c, Account.BR_Main_Country__c, Account.BR_Main_Zip_code__c, 
                        Account.BR_Main_State__c, BR_ValidaDistribuicaoGratuita__c, RecordType.DeveloperName, CasoOportunidadeDistribuicaoGratuita__c 
                    FROM Opportunity Where Id =: aListIdsOpp ];
    } 

    public static Opportunity buscaProdutoEmailOportunidade(string OportunidadeId){
        Opportunity  Oportunidade = new Opportunity();
        Oportunidade = [ SELECT BR_ProdutosEnvioEmail__c FROM Opportunity Where Id =: OportunidadeId ];
        return Oportunidade;
    } 

    public static Database.QueryLocator listarQuery(String query) {
    	
        return Database.getQueryLocator(query); 
    }

    public static Opportunity buscaOportunidade(string OportunidadeId){
        return [SELECT Id, BR_Account_Segmentation__c,BR_Desconto_1_ano__c, BR_Desconto_2_ano__c, BR_Desconto_3_ano__c, BR_DataRecebimentoNotificacao__c, Description,
                BR_AdocaoRecorrenteEnviada__c, CreatedBy.CentroCusto_SAP__c, CreatedDate, 
                Account.Phone, Account.BR_Main_City__c, Account.BR_Main_State__c,
                Account.BR_tax_registration_number__c, Account.BR_CNPJ_CPF__c, Account.BR_RazaoSocial__c,
                Account.BR_Main_District__c, Account.BR_Main_Complement__c, Account.BR_Main_Nbr__c, BR_Shipping_Address__c,
                Account.BR_Area_code__c, BR_shipping_type__c, Account.BR_Main_Zip_code__c, Account.BR_Main_Address__c, BR_Contact__r.Account.Name, 
                BR_Desconto_4_ano__c, BR_Desconto_5_ano__c, BR_Ano_Inicio_do_contrato__c, BR_Vigencia_do_contrato_anos__c, StageName, 
                Pricebook2.Name, BR_Imprimir_Proposta_Comercial_K12__c, RecordTypeId, RecordType.DeveloperName, BR_PrevisaoCompra__c,
                Account.Name, AccountId, Name, BR_RespondeuAdocao__c, BR_AdocaoRecorrente__c, BR_ConfirmarAdocao__c, BR_Ano__c, MarcaFranquias__c,
                Account.BillingStreet, Account.BillingCity, Account.BillingCountry, Account.BillingPostalCode, Account.BillingState,
                BR_ValidaDistribuicaoGratuita__c, BR_Account_Contact__c, BR_Account_Contact__r.Contact__c, BR_Compras_atraves_de__c,
                Account.BR_Account_email__c, Account.SistemaEnsino__c, Probability, OwnerId, Owner.Email, Owner.Name, BR_Account_Contact__r.Contact__r.Email,BR_MotivoRecusa__c,
                (SELECT Id, Name, Data1__c, Data2__c, Data3__c, EnviadoPor__c, DataConfirmada__c, HoraInicialSugerida__c, HoraFinalSugerida__c, HoraInicialConfirmada__c, HoraFinalConfirmada__c, TipoVisita__c FROM SugestoesVisitas__r ORDER BY CreatedDate DESC LIMIT 1)
                FROM Opportunity 
                WHERE Id =: OportunidadeId ];
    } 

    public static List<Opportunity> getOpportunitiesByEventIdAndRecordType(List<Id> evtIdRelated, Id oppRecordType) {
        return [SELECT Id FROM Opportunity WHERE Id IN :evtIdRelated AND RecordTypeId = :oppRecordType];
    }

    public static List<Opportunity> BuscarOportunidades(Set<id> idsOportunidade)
    {
        return  [SELECT Id, BR_Account_Segmentation__c,BR_Desconto_1_ano__c, BR_Desconto_2_ano__c, BR_Desconto_3_ano__c,
                        BR_Desconto_4_ano__c, BR_Desconto_5_ano__c, BR_Ano_Inicio_do_contrato__c, BR_Vigencia_do_contrato_anos__c,
                        Pricebook2.Name, BR_Imprimir_Proposta_Comercial_K12__c, BR_DataRecebimentoNotificacao__c, Probability,
                        Account.Name, AccountId, Name, StageName, RecordTypeId, Account.BillingState, Account.BillingPostalCode,
                        Account.BillingStreet, Account.BillingCity, Account.BillingCountry, BR_Account_Contact__r.Contact__c,
                        BR_ValidaDistribuicaoGratuita__c, BR_Account_Contact__c, RecordType.DeveloperName, Description,
                        BR_Account_Contact__r.Contact__r.Email, BR_AdocaoRecorrenteEnviada__c, BR_RespondeuAdocao__c,
                        BR_AdocaoRecorrente__c, Account.BR_Account_email__c, CreatedBy.CentroCusto_SAP__c, CreatedDate, 
                        Account.Phone, Account.BR_Main_City__c, Account.BR_Main_State__c, BR_Contact__r.Account.Name, 
                        Account.BR_tax_registration_number__c, Account.BR_CNPJ_CPF__c, Account.BR_RazaoSocial__c,
                        Account.BR_Main_District__c, Account.BR_Main_Complement__c, Account.BR_Main_Nbr__c, BR_Shipping_Address__c,
                        Account.BR_Area_code__c, BR_shipping_type__c, Account.BR_Main_Zip_code__c, Account.BR_Main_Address__c
                FROM Opportunity
                WHERE id IN: idsOportunidade];
    }
}