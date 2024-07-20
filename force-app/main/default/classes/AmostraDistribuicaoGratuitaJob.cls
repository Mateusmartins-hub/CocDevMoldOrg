global with sharing class AmostraDistribuicaoGratuitaJob {
    
    public class TGBAPISDITM
    {
        public string MATERIAL { get; set; }
        public string TARGET_QTY { get; set; }
        public string PURCH_DATE { get; set; }
        public string BILL_DATE { get; set; }
        public string USAGE_IND { get; set; }
        public string PLANT { get; set; }
        public string STORE_LOC { get; set; }
        public string INCOTERMS1 { get; set; }
        public string INCOTERMS2 { get; set; }
    }
    
        public class Amostra_SAP
    {
        public string AUART { get; set; }
        public string VTWEG { get; set; }
        public string VKBUR { get; set; }
        public string BSTDK1 { get; set; }
        public string PF_EMISSOR { get; set; }
        public string CNPJ_CPF_EMISSOR { get; set; }
        public string PF_RECEBEDOR { get; set; }
        public string CNPJ_CPF_RECEBEDOR { get; set; }
        public string VDATU { get; set; }
        public string BSTKD { get; set; }
        public string OBS { get; set; }
        public string ENTREGA { get; set; }
        public string FRETE { get; set; }
        public string TIPO_EXPEDICAO { get; set; }
        public string PYMT_METH { get; set; }
        public string KVGR1 { get; set; }
        public string DZTERM { get; set; }
        public string KVGR2 { get; set; }
        public string COMPLEM { get; set; }
        public string VKORG { get; set; }
        public string NFNUM { get; set; }
        public string SERIES { get; set; }
        public string INCO1 { get; set; }
        public string INCO2 { get; set; }
        public string CIDADE { get; set; }
        public string ESTADO { get; set; }
        public string PAIS { get; set; }
        public string RAZAO_SOCIAL { get; set; }
        public string NOME_FANTASIA { get; set; }
        public string BAIRRO { get; set; }
        public string ENDERECO { get; set; }
        public string CEP { get; set; }
        public string DTA_CADASTRO { get; set; }
        public string RG { get; set; }
        public string FONE { get; set; }
        public string COMPLEMENTO { get; set; }
        public string NUMERO { get; set; }
        public string EMAIL { get; set; }
        public string COND_PAGTO { get; set; }
        public List<TGBAPISDITM> TG_BAPISDITM { get; set; }
        public List<object> TG_CONDITIONS { get; set; }
        public string KOSTL { get; set; }
    }
    
        public class Structure
    {
        public string TYPE { get; set; }
        public string ID { get; set; }
        public string NUMBER1 { get; set; }
        public string MESSAGE { get; set; }
        public string LOG_NO { get; set; }
        public string LOG_MSG_NO { get; set; }
        public string MESSAGE_V1 { get; set; }
        public string MESSAGE_V2 { get; set; }
        public string MESSAGE_V3 { get; set; }
        public string MESSAGE_V4 { get; set; }
        public string PARAMETER { get; set; }
        public string ROW { get; set; }
        public string SYSTEM1 { get; set; }
    }
    
    public class Amostra_Retorno
    {
        public string Name { get; set; }
        public List<Structure> Structures { get; set; }
    }
    
    /**
     * Resseta o status BR_ErroIntegracao__c no objeto BR_DistribuicaoGratuita__c 
     * para que ele possa ser enviado novamente a integração SAP. 
     */
    webservice static void reenviar_amostra_com_erro_button(Id idDistribuicao){

       
		BR_DistribuicaoGratuita__c dist = [select BR_ErroIntegracao__c, BR_Oportunidade__c from BR_DistribuicaoGratuita__c 
                                           where id =: idDistribuicao
                                          limit 1];
        
        system.debug('oportunidade ID ' + dist.BR_Oportunidade__c);
        
        Opportunity op = [select StageName from Opportunity where id =: dist.BR_Oportunidade__c limit 1];
        op.StageName = 'Amostra Física';
        
        if (!Test.isRunningTest())
        	update(op);
        
        dist.BR_ErroIntegracao__c = false;
        if (!Test.isRunningTest())
        	update(dist);
        
    }
    
    @future (callout=true)
    public static void integrar() {
    	Boolean deu_certo = false;  // Parametro usando apos retorno do SAP
       	String body;
       	String retorno; 
    	
    	Id tipoRegistro = RecordTypeMemory.getRecType('Opportunity', 'Oportunidade_de_Negocio_Pearson_English_EDU');
    	List<Integration_log__c> lstLog = New List<Integration_log__c>();
    	
    	List<BR_DistribuicaoGratuita__c> lstDistribuicao = [SELECT Id,
		    														BR_Oportunidade__r.Id,
		                                                            BR_Oportunidade__r.CreatedById,
		                                                            BR_Oportunidade__r.BR_Account_Contact__r.Contact__r.Name,
		                                                            BR_Oportunidade__r.BR_Account_Contact__r.Contact__r.BR_Address__c,
		                                                            BR_Oportunidade__r.BR_Account_Contact__r.Contact__r.BR_Address_number__c,
		                                                            BR_Oportunidade__r.BR_Account_Contact__r.Contact__r.BR_Address_complement__c,
		                                                            BR_Oportunidade__r.BR_Account_Contact__r.Contact__r.BR_Address_district__c,
		                                                            BR_Oportunidade__r.BR_Account_Contact__r.Contact__r.BR_Address_city__c,
		                                                            BR_Oportunidade__r.BR_Account_Contact__r.Contact__r.BR_Address_state__c,
		                                                            BR_Oportunidade__r.BR_Account_Contact__r.Contact__r.BR_Address_zip_code__c,
		                                                            BR_Oportunidade__r.BR_Account_Contact__r.Contact__r.BR_Address_country__c,
		                                                            BR_Oportunidade__r.BR_Account_Contact__r.Contact__r.BR_CPF__c,
		                                                            BR_Oportunidade__r.BR_Account_Contact__r.Contact__r.BR_RG__c,
		                                                            BR_Oportunidade__r.BR_Account_Contact__r.Contact__r.Email,
		                                                            BR_Oportunidade__r.BR_Account_Contact__r.Contact__r.BR_Area_code__c,
		                                                            BR_Oportunidade__r.BR_Account_Contact__r.Contact__r.Phone,
		                                                            
		                                                            BR_Oportunidade__r.Account.Name,
                                                                	BR_Oportunidade__r.Account.BR_Main_Address__c,
                                                                	BR_Oportunidade__r.Account.BR_Main_Nbr__c,
                                                                	BR_Oportunidade__r.Account.BR_Main_Complement__c,
                                                                	BR_Oportunidade__r.Account.BR_Main_District__c,
                                                                	BR_Oportunidade__r.Account.BR_Main_City__c,
                                                                	BR_Oportunidade__r.Account.BR_Main_State__c,
                                                                	BR_Oportunidade__r.Account.BR_Main_Zip_code__c,
                                                                	BR_Oportunidade__r.Account.BR_Main_Country__c,
                                                                	BR_Oportunidade__r.Account.BR_Account_email__c,
                                                                	BR_Oportunidade__r.Account.BR_CNPJ_CPF__c,
                                                                	BR_Oportunidade__r.Account.BR_tax_registration_number__c,
                                                                	BR_Oportunidade__r.Account.BR_Area_code__c,
                                                                	BR_Oportunidade__r.Account.Phone,
                                                                	BR_Oportunidade__r.Account.BR_RazaoSocial__c,
                                                                
		                                                            BR_Oportunidade__r.LastModifiedDate,
		                                                            BR_Oportunidade__r.CreatedDate,
		                                                            BR_Oportunidade__r.AccountID,
		                                                            CreatedDate,
		                                                            BR_TipoEndereco__c,
		                                                            BR_FormaEnvio__c
    														FROM BR_DistribuicaoGratuita__c
    														WHERE BR_Integrar__c = true and BR_IntegradoSucesso__c = false and BR_ErroIntegracao__c = false
    																and BR_Oportunidade__r.RecordTypeId =: tipoRegistro
    																and RecordType.DeveloperName = 'AmostraFisica' LIMIT 10];
    													
    	if(lstDistribuicao.size() > 0){
    		for(BR_DistribuicaoGratuita__c distribuicao : lstDistribuicao){
    			Amostra_SAP A = New Amostra_SAP();
                        
                if(distribuicao.BR_TipoEndereco__c == 'Residencial'){
                  	A.ENDERECO = distribuicao.BR_Oportunidade__r.BR_Account_Contact__r.Contact__r.BR_Address__c; 
	                A.NUMERO = distribuicao.BR_Oportunidade__r.BR_Account_Contact__r.Contact__r.BR_Address_number__c;
	                A.COMPLEMENTO = distribuicao.BR_Oportunidade__r.BR_Account_Contact__r.Contact__r.BR_Address_complement__c;
	                A.BAIRRO = distribuicao.BR_Oportunidade__r.BR_Account_Contact__r.Contact__r.BR_Address_district__c;
	                A.CIDADE = distribuicao.BR_Oportunidade__r.BR_Account_Contact__r.Contact__r.BR_Address_city__c;
	                A.ESTADO = distribuicao.BR_Oportunidade__r.BR_Account_Contact__r.Contact__r.BR_Address_state__c;
	                A.CEP = distribuicao.BR_Oportunidade__r.BR_Account_Contact__r.Contact__r.BR_Address_zip_code__c;
	                A.RAZAO_SOCIAL = distribuicao.BR_Oportunidade__r.BR_Account_Contact__r.Contact__r.Name;
	                A.NOME_FANTASIA = distribuicao.BR_Oportunidade__r.BR_Account_Contact__r.Contact__r.Name;
	                A.EMAIL = distribuicao.BR_Oportunidade__r.BR_Account_Contact__r.Contact__r.Email;
	                A.CNPJ_CPF_EMISSOR = NumeroApenas(distribuicao.BR_Oportunidade__r.BR_Account_Contact__r.Contact__r.BR_CPF__c);
	                A.RG = distribuicao.BR_Oportunidade__r.BR_Account_Contact__r.Contact__r.BR_RG__c;
	                A.FONE = distribuicao.BR_Oportunidade__r.BR_Account_Contact__r.Contact__r.BR_Area_code__c +   NumeroApenas(distribuicao.BR_Oportunidade__r.BR_Account_Contact__r.Contact__r.Phone);
                }
                        
                if(distribuicao.BR_TipoEndereco__c == 'Comercial'){
                	A.ENDERECO = distribuicao.BR_Oportunidade__r.Account.BR_Main_Address__c;  
	                A.NUMERO = distribuicao.BR_Oportunidade__r.Account.BR_Main_Nbr__c;
	                A.COMPLEMENTO = distribuicao.BR_Oportunidade__r.Account.BR_Main_Complement__c;
	                A.BAIRRO = distribuicao.BR_Oportunidade__r.Account.BR_Main_District__c;
	                A.CIDADE = distribuicao.BR_Oportunidade__r.Account.BR_Main_City__c;
	                A.ESTADO = distribuicao.BR_Oportunidade__r.Account.BR_Main_State__c;
	                A.CEP = distribuicao.BR_Oportunidade__r.Account.BR_Main_Zip_code__c; 
	                A.RAZAO_SOCIAL = distribuicao.BR_Oportunidade__r.Account.BR_RazaoSocial__c;
	                A.NOME_FANTASIA = distribuicao.BR_Oportunidade__r.Account.Name;
	                A.EMAIL = distribuicao.BR_Oportunidade__r.Account.BR_Account_email__c;
	                A.CNPJ_CPF_EMISSOR = NumeroApenas(distribuicao.BR_Oportunidade__r.Account.BR_CNPJ_CPF__c);
	                A.RG = distribuicao.BR_Oportunidade__r.Account.BR_tax_registration_number__c;
	                A.FONE = distribuicao.BR_Oportunidade__r.Account.BR_Area_code__c +   NumeroApenas(distribuicao.BR_Oportunidade__r.Account.Phone);
                }
                        
                A.PAIS = 'BR';
                A.ENTREGA = A.ENDERECO + ' ' + A.NUMERO + ' ' +  A.COMPLEMENTO + ' ' 
                + A.BAIRRO + ' ' + A.CIDADE + '-' +  A.ESTADO + ' ' + A.CEP;
                
                // Dados NF
                A.BSTKD =  String.valueOf(distribuicao.BR_Oportunidade__r.ID);
                A.FRETE = '0';
                A.OBS = 'TIPO DE ENTREGA:' + distribuicao.BR_FormaEnvio__c;
                A.TIPO_EXPEDICAO = TipoFreteSAP(distribuicao.BR_FormaEnvio__c);
                A.INCO2 = A.ESTADO + '/' + A.CIDADE;
                A.DTA_CADASTRO = distribuicao.BR_Oportunidade__r.CreatedDate.format('yyyyMMdd');
                
                // Fixo para amostra
                A.AUART = 'ZEXE';
                A.VTWEG = '1';
                A.VKBUR = 'EV01';
                A.BSTDK1 = DateTime.now().format('yyyyMMdd'); 
                A.PF_EMISSOR ='X';
                A.PF_RECEBEDOR ='';
                A.CNPJ_CPF_RECEBEDOR ='';
                A.VDATU = DateTime.now().format('yyyyMMdd');
                A.KOSTL = CentrodeCusto(distribuicao.BR_Oportunidade__r.CreatedById);
                        
                A.PYMT_METH = '';
                A.KVGR1 = '7';
                A.DZTERM = 'Z000';
                A.KVGR2 = DateTime.now().format('yyyyMMdd'); 
                A.COMPLEM = '0';
                A.VKORG ='OVE7';
                A.NFNUM = '';
                A.SERIES ='';
                A.INCO1 = 'CIF';
                A.COND_PAGTO = 'Z000';
                
                A.TG_BAPISDITM = New List<TGBAPISDITM>();
                Set<Id> distribuicaoId = new Set<Id>();
                distribuicaoId.add(distribuicao.Id);
                
                for(BR_ProdutoDistribuicaoGratuita__c produto : DistribuicaoGratuitaDAO.getInstance().buscarProdutosDistruibuicao(distribuicaoId)){        
                	TGBAPISDITM C = New TGBAPISDITM();
                    C.MATERIAL = '00000' + produto.BR_ProdutoDistribuicaoGratuita__r.BR_Product_Code__c;
                    C.TARGET_QTY = String.valueOf(Integer.valueOf(produto.BR_Quantidade__c));
                    // Fixos
                    C.PURCH_DATE = distribuicao.CreatedDate.format('yyyyMMdd');
                    C.PLANT = 'PE21';
                    C.BILL_DATE = '';
                    C.USAGE_IND = '001';
                    C.STORE_LOC = '';
                    C.INCOTERMS1 = '';
                    C.INCOTERMS2 = '';
                    A.TG_BAPISDITM.Add(C);
                }
				System.Debug(JSON.serialize(A)); 
				
				
				//Material(s)
                A.TG_CONDITIONS = New List<object>();
                String str_datarequest = JSON.serialize(A);
                str_datarequest = str_datarequest.replaceAll('&','e');
                System.debug('Data request:' + str_datarequest);
                
                str_datarequest =   EncodingUtil.urlEncode(str_datarequest, 'UTF-8');
                
                //  HTTP Envio para SAP
                if (Test.isRunningTest()){
                    retorno = '{"Status":"OK","Data":{"Exports":{"VG_COUNT_ERROS":"7","VG_VBELN":"0001039357"},"Tables":[{"Name":"TG_BAPISDITM","Structures":[{"ITM_NUMBER":"000010","HG_LV_ITEM":"000000","PO_ITM_NO":"","MATERIAL":"000009781408294239","ALT_TO_ITM":"000000","CUST_MAT22":"","BATCH":"","DLV_GROUP":"000","PART_DLV":"","REASON_REJ":"","BILL_BLOCK":"","BILL_DATE":"0000-00-00","PLANT":"PE21","STORE_LOC":"","TARGET_QTY":"1,000","TARGET_QU":"","T_UNIT_ISO":"","ITEM_CATEG":"","SHORT_TEXT":"","PRC_GROUP1":"","PRC_GROUP2":"","PRC_GROUP3":"","PRC_GROUP4":"","PRC_GROUP5":"","PROD_HIERA":"","MATL_GROUP":"","PURCH_NO_C":"","PURCH_DATE":"2019-10-02","PO_METHOD":"","REF_1":"","PURCH_NO_S":"","PO_DAT_S":"0000-00-00","PO_METH_S":"","REF_1_S":"","POITM_NO_S":"","PRICE_GRP":"","CUST_GROUP":"","SALES_DIST":"","PRICE_LIST":"","INCOTERMS1":"","INCOTERMS2":"","ORDCOMP_IN":"","BILL_SCHED":"","INVO_SCHED":"","MN_INVOICE":"","EX_RATE_FI":"0,00000","ADD_VAL_DY":"00","FIX_VAL_DY":"0000-00-00","PMNTTRMS":"","PYMT_METH":"","ACCNT_ASGN":"","EXCHG_RATE":"0,00000","PRICE_DATE":"0000-00-00","SERV_DATE":"0000-00-00","DUNN_KEY":"","DUNN_BLOCK":"","PROMOTION":"","PMTGAR_PRO":"","DOC_NUM_FI":"","DEPARTM_NO":"","REC_POINT":"","CSTCNDGRP1":"","CSTCNDGRP2":"","CSTCNDGRP3":"","CSTCNDGRP4":"","CSTCNDGRP5":"","DLV_TIME":"","SALES_UNIT":"","S_UNIT_ISO":"","TRG_QTY_NO":"0","TRGQTY_DEN":"0","RNDDLV_QTY":"0,000","MAXDEVAMNT":"0,000","MAXDEVPER":"0","MAXDEV_DAY":"0","USAGE_IND":"001","FIXED_QUAN":"","UNLMT_DLV":"","OVERDLVTOL":"0,0","UNDDLV_TOL":"0,0","DIVISION":"","SALQTYNUM":"0","SALQTYDEN":"0","GROSS_WGHT":"0,000","NET_WEIGHT":"0,000","UNTOF_WGHT":"","UNOF_WTISO":"","VOLUME":"0,000","VOLUNIT":"","VOLUNITISO":"","DLV_PRIO":"00","SHIP_POINT":"","ROUTE":"","CREATED_BY":"","TAX_CLASS1":"","TAX_CLASS2":"","TAX_CLASS3":"","TAX_CLASS4":"","TAX_CLASS5":"","TAX_CLASS6":"","TAX_CLASS7":"","TAX_CLASS8":"","TAX_CLASS9":"","MAT_PR_GRP":"","VAL_TYPE":"","FIXDAT_QTY":"","BOMEXPL_NO":"","RESANALKEY":"","REQMTS_TYP":"","NO_GR_POST":"","BUS_TRANST":"","OVERHD_KEY":"","CSTG_SHEET":"","MATFRGTGRP":"","PLDLVSHDIN":"","SEQ_NO":"","BIL_FORM":"","DLI_PROFIL":"","REV_TYPE":"","BEGDEM_PER":"","PR_REF_MAT":"","REFOBJTYPE":"","REFOBJKEY":"","REFLOGSYS":"","ORDER_PROB":"000","MAX_PL_DLV":"0","CFOP_CODE":"","TAXLAWICMS":"","TAXLAWIPI":"","SD_TAXCODE":"","ASSORT_MOD":"","COMP_QUANT":"0,000","TARGET_VAL":"0,000000000","CURRENCY":"","CURR_ISO":"","PROFIT_CTR":"","ORDERID":"","WBS_ELEM":"","DEPREC_PER":"0,00","REF_DOC":"","REF_DOC_IT":"000000","REF_DOC_CA":"","CUST_MAT35":"","EXCH_RATE_FI_V":"0,00000","EXCHG_RATE_V":"0,00000","ITEMGUID_ATP":"","VAL_CONTR":"","VAL_CON_I":"000000","CONFIG_ID":"","INST_ID":"","MAT_EXT":"","MAT_GUID":"","MAT_VERS":"","P_MAT_EXT":"","P_MAT_GUID":"","P_MAT_VERS":"","FUNC_AREA":"","ALTERN_BOM":"","FKK_CONACCT":"","EAN_UPC":"","PRODCAT":"","SHIP_TYPE":"13","S_PROC_IND":"","FUNC_AREA_LONG":"","BILL_REL":"","VW_UEPOS":"","CAMPAIGN":"00000000000000000000000000000000","DLVSCHDUSE":"","CFOP_LONG":"","SELECTION":"","MAT_ENTRD":"","LOG_SYSTEM_OWN":"","ITM_TYPE_USAGE":"","TAXLAWISS":"","MAT_ENTRD_EXTERNAL":"","MAT_ENTRD_GUID":"","MAT_ENTRD_VERSION":"","LOC_TAXCAT":"","LOC_ZEROVAT":"","LOC_ACTCODE":"","LOC_DISTTYPE":"","LOC_TXRELCLAS":"","CALC_MOTIVE":"","COMPREAS":"","FUND":"","FUNDS_CTR":"","CMMT_ITEM":"","GRANT_NBR":"","BUDGET_PERIOD":"","TAXLAWCOFINS":"","TAXLAWPIS":"","TREASURY_ACC_SYMBOL":"","BUSINESS_EVENT_TCODE":"","MODIFICATION_ALLOWED":"","CANCELLATION_ALLOWED":"","PAYMENT_METHODS":"","BUSINESS_PARTNER_NO":"","REPORTING_FREQ":"","SEPA_MANDATE_ID":"","REQ_SEGMENT":"","TP_SUBLEVL":"","TP_AGENCID":"","TP_ALTRAID":"","TP_BEGPER":"0000","TP_ENDPER":"0000","TP_AVTYPE":"","TP_MAIN_ACCT":"","TP_SUB_ACCT":"","TP_BETC":""},{"ITM_NUMBER":"000020","HG_LV_ITEM":"000000","PO_ITM_NO":"","MATERIAL":"000009780582432543","ALT_TO_ITM":"000000","CUST_MAT22":"","BATCH":"","DLV_GROUP":"000","PART_DLV":"","REASON_REJ":"","BILL_BLOCK":"","BILL_DATE":"0000-00-00","PLANT":"PE21","STORE_LOC":"","TARGET_QTY":"1,000","TARGET_QU":"","T_UNIT_ISO":"","ITEM_CATEG":"","SHORT_TEXT":"","PRC_GROUP1":"","PRC_GROUP2":"","PRC_GROUP3":"","PRC_GROUP4":"","PRC_GROUP5":"","PROD_HIERA":"","MATL_GROUP":"","PURCH_NO_C":"","PURCH_DATE":"2019-10-02","PO_METHOD":"","REF_1":"","PURCH_NO_S":"","PO_DAT_S":"0000-00-00","PO_METH_S":"","REF_1_S":"","POITM_NO_S":"","PRICE_GRP":"","CUST_GROUP":"","SALES_DIST":"","PRICE_LIST":"","INCOTERMS1":"","INCOTERMS2":"","ORDCOMP_IN":"","BILL_SCHED":"","INVO_SCHED":"","MN_INVOICE":"","EX_RATE_FI":"0,00000","ADD_VAL_DY":"00","FIX_VAL_DY":"0000-00-00","PMNTTRMS":"","PYMT_METH":"","ACCNT_ASGN":"","EXCHG_RATE":"0,00000","PRICE_DATE":"0000-00-00","SERV_DATE":"0000-00-00","DUNN_KEY":"","DUNN_BLOCK":"","PROMOTION":"","PMTGAR_PRO":"","DOC_NUM_FI":"","DEPARTM_NO":"","REC_POINT":"","CSTCNDGRP1":"","CSTCNDGRP2":"","CSTCNDGRP3":"","CSTCNDGRP4":"","CSTCNDGRP5":"","DLV_TIME":"","SALES_UNIT":"","S_UNIT_ISO":"","TRG_QTY_NO":"0","TRGQTY_DEN":"0","RNDDLV_QTY":"0,000","MAXDEVAMNT":"0,000","MAXDEVPER":"0","MAXDEV_DAY":"0","USAGE_IND":"001","FIXED_QUAN":"","UNLMT_DLV":"","OVERDLVTOL":"0,0","UNDDLV_TOL":"0,0","DIVISION":"","SALQTYNUM":"0","SALQTYDEN":"0","GROSS_WGHT":"0,000","NET_WEIGHT":"0,000","UNTOF_WGHT":"","UNOF_WTISO":"","VOLUME":"0,000","VOLUNIT":"","VOLUNITISO":"","DLV_PRIO":"00","SHIP_POINT":"","ROUTE":"","CREATED_BY":"","TAX_CLASS1":"","TAX_CLASS2":"","TAX_CLASS3":"","TAX_CLASS4":"","TAX_CLASS5":"","TAX_CLASS6":"","TAX_CLASS7":"","TAX_CLASS8":"","TAX_CLASS9":"","MAT_PR_GRP":"","VAL_TYPE":"","FIXDAT_QTY":"","BOMEXPL_NO":"","RESANALKEY":"","REQMTS_TYP":"","NO_GR_POST":"","BUS_TRANST":"","OVERHD_KEY":"","CSTG_SHEET":"","MATFRGTGRP":"","PLDLVSHDIN":"","SEQ_NO":"","BIL_FORM":"","DLI_PROFIL":"","REV_TYPE":"","BEGDEM_PER":"","PR_REF_MAT":"","REFOBJTYPE":"","REFOBJKEY":"","REFLOGSYS":"","ORDER_PROB":"000","MAX_PL_DLV":"0","CFOP_CODE":"","TAXLAWICMS":"","TAXLAWIPI":"","SD_TAXCODE":"","ASSORT_MOD":"","COMP_QUANT":"0,000","TARGET_VAL":"0,000000000","CURRENCY":"","CURR_ISO":"","PROFIT_CTR":"","ORDERID":"","WBS_ELEM":"","DEPREC_PER":"0,00","REF_DOC":"","REF_DOC_IT":"000000","REF_DOC_CA":"","CUST_MAT35":"","EXCH_RATE_FI_V":"0,00000","EXCHG_RATE_V":"0,00000","ITEMGUID_ATP":"","VAL_CONTR":"","VAL_CON_I":"000000","CONFIG_ID":"","INST_ID":"","MAT_EXT":"","MAT_GUID":"","MAT_VERS":"","P_MAT_EXT":"","P_MAT_GUID":"","P_MAT_VERS":"","FUNC_AREA":"","ALTERN_BOM":"","FKK_CONACCT":"","EAN_UPC":"","PRODCAT":"","SHIP_TYPE":"13","S_PROC_IND":"","FUNC_AREA_LONG":"","BILL_REL":"","VW_UEPOS":"","CAMPAIGN":"00000000000000000000000000000000","DLVSCHDUSE":"","CFOP_LONG":"","SELECTION":"","MAT_ENTRD":"","LOG_SYSTEM_OWN":"","ITM_TYPE_USAGE":"","TAXLAWISS":"","MAT_ENTRD_EXTERNAL":"","MAT_ENTRD_GUID":"","MAT_ENTRD_VERSION":"","LOC_TAXCAT":"","LOC_ZEROVAT":"","LOC_ACTCODE":"","LOC_DISTTYPE":"","LOC_TXRELCLAS":"","CALC_MOTIVE":"","COMPREAS":"","FUND":"","FUNDS_CTR":"","CMMT_ITEM":"","GRANT_NBR":"","BUDGET_PERIOD":"","TAXLAWCOFINS":"","TAXLAWPIS":"","TREASURY_ACC_SYMBOL":"","BUSINESS_EVENT_TCODE":"","MODIFICATION_ALLOWED":"","CANCELLATION_ALLOWED":"","PAYMENT_METHODS":"","BUSINESS_PARTNER_NO":"","REPORTING_FREQ":"","SEPA_MANDATE_ID":"","REQ_SEGMENT":"","TP_SUBLEVL":"","TP_AGENCID":"","TP_ALTRAID":"","TP_BEGPER":"0000","TP_ENDPER":"0000","TP_AVTYPE":"","TP_MAIN_ACCT":"","TP_SUB_ACCT":"","TP_BETC":""},{"ITM_NUMBER":"000030","HG_LV_ITEM":"000000","PO_ITM_NO":"","MATERIAL":"000009781292239996","ALT_TO_ITM":"000000","CUST_MAT22":"","BATCH":"","DLV_GROUP":"000","PART_DLV":"","REASON_REJ":"","BILL_BLOCK":"","BILL_DATE":"0000-00-00","PLANT":"PE21","STORE_LOC":"","TARGET_QTY":"1,000","TARGET_QU":"","T_UNIT_ISO":"","ITEM_CATEG":"","SHORT_TEXT":"","PRC_GROUP1":"","PRC_GROUP2":"","PRC_GROUP3":"","PRC_GROUP4":"","PRC_GROUP5":"","PROD_HIERA":"","MATL_GROUP":"","PURCH_NO_C":"","PURCH_DATE":"2019-10-02","PO_METHOD":"","REF_1":"","PURCH_NO_S":"","PO_DAT_S":"0000-00-00","PO_METH_S":"","REF_1_S":"","POITM_NO_S":"","PRICE_GRP":"","CUST_GROUP":"","SALES_DIST":"","PRICE_LIST":"","INCOTERMS1":"","INCOTERMS2":"","ORDCOMP_IN":"","BILL_SCHED":"","INVO_SCHED":"","MN_INVOICE":"","EX_RATE_FI":"0,00000","ADD_VAL_DY":"00","FIX_VAL_DY":"0000-00-00","PMNTTRMS":"","PYMT_METH":"","ACCNT_ASGN":"","EXCHG_RATE":"0,00000","PRICE_DATE":"0000-00-00","SERV_DATE":"0000-00-00","DUNN_KEY":"","DUNN_BLOCK":"","PROMOTION":"","PMTGAR_PRO":"","DOC_NUM_FI":"","DEPARTM_NO":"","REC_POINT":"","CSTCNDGRP1":"","CSTCNDGRP2":"","CSTCNDGRP3":"","CSTCNDGRP4":"","CSTCNDGRP5":"","DLV_TIME":"","SALES_UNIT":"","S_UNIT_ISO":"","TRG_QTY_NO":"0","TRGQTY_DEN":"0","RNDDLV_QTY":"0,000","MAXDEVAMNT":"0,000","MAXDEVPER":"0","MAXDEV_DAY":"0","USAGE_IND":"001","FIXED_QUAN":"","UNLMT_DLV":"","OVERDLVTOL":"0,0","UNDDLV_TOL":"0,0","DIVISION":"","SALQTYNUM":"0","SALQTYDEN":"0","GROSS_WGHT":"0,000","NET_WEIGHT":"0,000","UNTOF_WGHT":"","UNOF_WTISO":"","VOLUME":"0,000","VOLUNIT":"","VOLUNITISO":"","DLV_PRIO":"00","SHIP_POINT":"","ROUTE":"","CREATED_BY":"","TAX_CLASS1":"","TAX_CLASS2":"","TAX_CLASS3":"","TAX_CLASS4":"","TAX_CLASS5":"","TAX_CLASS6":"","TAX_CLASS7":"","TAX_CLASS8":"","TAX_CLASS9":"","MAT_PR_GRP":"","VAL_TYPE":"","FIXDAT_QTY":"","BOMEXPL_NO":"","RESANALKEY":"","REQMTS_TYP":"","NO_GR_POST":"","BUS_TRANST":"","OVERHD_KEY":"","CSTG_SHEET":"","MATFRGTGRP":"","PLDLVSHDIN":"","SEQ_NO":"","BIL_FORM":"","DLI_PROFIL":"","REV_TYPE":"","BEGDEM_PER":"","PR_REF_MAT":"","REFOBJTYPE":"","REFOBJKEY":"","REFLOGSYS":"","ORDER_PROB":"000","MAX_PL_DLV":"0","CFOP_CODE":"","TAXLAWICMS":"","TAXLAWIPI":"","SD_TAXCODE":"","ASSORT_MOD":"","COMP_QUANT":"0,000","TARGET_VAL":"0,000000000","CURRENCY":"","CURR_ISO":"","PROFIT_CTR":"","ORDERID":"","WBS_ELEM":"","DEPREC_PER":"0,00","REF_DOC":"","REF_DOC_IT":"000000","REF_DOC_CA":"","CUST_MAT35":"","EXCH_RATE_FI_V":"0,00000","EXCHG_RATE_V":"0,00000","ITEMGUID_ATP":"","VAL_CONTR":"","VAL_CON_I":"000000","CONFIG_ID":"","INST_ID":"","MAT_EXT":"","MAT_GUID":"","MAT_VERS":"","P_MAT_EXT":"","P_MAT_GUID":"","P_MAT_VERS":"","FUNC_AREA":"","ALTERN_BOM":"","FKK_CONACCT":"","EAN_UPC":"","PRODCAT":"","SHIP_TYPE":"13","S_PROC_IND":"","FUNC_AREA_LONG":"","BILL_REL":"","VW_UEPOS":"","CAMPAIGN":"00000000000000000000000000000000","DLVSCHDUSE":"","CFOP_LONG":"","SELECTION":"","MAT_ENTRD":"","LOG_SYSTEM_OWN":"","ITM_TYPE_USAGE":"","TAXLAWISS":"","MAT_ENTRD_EXTERNAL":"","MAT_ENTRD_GUID":"","MAT_ENTRD_VERSION":"","LOC_TAXCAT":"","LOC_ZEROVAT":"","LOC_ACTCODE":"","LOC_DISTTYPE":"","LOC_TXRELCLAS":"","CALC_MOTIVE":"","COMPREAS":"","FUND":"","FUNDS_CTR":"","CMMT_ITEM":"","GRANT_NBR":"","BUDGET_PERIOD":"","TAXLAWCOFINS":"","TAXLAWPIS":"","TREASURY_ACC_SYMBOL":"","BUSINESS_EVENT_TCODE":"","MODIFICATION_ALLOWED":"","CANCELLATION_ALLOWED":"","PAYMENT_METHODS":"","BUSINESS_PARTNER_NO":"","REPORTING_FREQ":"","SEPA_MANDATE_ID":"","REQ_SEGMENT":"","TP_SUBLEVL":"","TP_AGENCID":"","TP_ALTRAID":"","TP_BEGPER":"0000","TP_ENDPER":"0000","TP_AVTYPE":"","TP_MAIN_ACCT":"","TP_SUB_ACCT":"","TP_BETC":""},{"ITM_NUMBER":"000040","HG_LV_ITEM":"000000","PO_ITM_NO":"","MATERIAL":"000009781408264041","ALT_TO_ITM":"000000","CUST_MAT22":"","BATCH":"","DLV_GROUP":"000","PART_DLV":"","REASON_REJ":"","BILL_BLOCK":"","BILL_DATE":"0000-00-00","PLANT":"PE21","STORE_LOC":"","TARGET_QTY":"1,000","TARGET_QU":"","T_UNIT_ISO":"","ITEM_CATEG":"","SHORT_TEXT":"","PRC_GROUP1":"","PRC_GROUP2":"","PRC_GROUP3":"","PRC_GROUP4":"","PRC_GROUP5":"","PROD_HIERA":"","MATL_GROUP":"","PURCH_NO_C":"","PURCH_DATE":"2019-10-02","PO_METHOD":"","REF_1":"","PURCH_NO_S":"","PO_DAT_S":"0000-00-00","PO_METH_S":"","REF_1_S":"","POITM_NO_S":"","PRICE_GRP":"","CUST_GROUP":"","SALES_DIST":"","PRICE_LIST":"","INCOTERMS1":"","INCOTERMS2":"","ORDCOMP_IN":"","BILL_SCHED":"","INVO_SCHED":"","MN_INVOICE":"","EX_RATE_FI":"0,00000","ADD_VAL_DY":"00","FIX_VAL_DY":"0000-00-00","PMNTTRMS":"","PYMT_METH":"","ACCNT_ASGN":"","EXCHG_RATE":"0,00000","PRICE_DATE":"0000-00-00","SERV_DATE":"0000-00-00","DUNN_KEY":"","DUNN_BLOCK":"","PROMOTION":"","PMTGAR_PRO":"","DOC_NUM_FI":"","DEPARTM_NO":"","REC_POINT":"","CSTCNDGRP1":"","CSTCNDGRP2":"","CSTCNDGRP3":"","CSTCNDGRP4":"","CSTCNDGRP5":"","DLV_TIME":"","SALES_UNIT":"","S_UNIT_ISO":"","TRG_QTY_NO":"0","TRGQTY_DEN":"0","RNDDLV_QTY":"0,000","MAXDEVAMNT":"0,000","MAXDEVPER":"0","MAXDEV_DAY":"0","USAGE_IND":"001","FIXED_QUAN":"","UNLMT_DLV":"","OVERDLVTOL":"0,0","UNDDLV_TOL":"0,0","DIVISION":"","SALQTYNUM":"0","SALQTYDEN":"0","GROSS_WGHT":"0,000","NET_WEIGHT":"0,000","UNTOF_WGHT":"","UNOF_WTISO":"","VOLUME":"0,000","VOLUNIT":"","VOLUNITISO":"","DLV_PRIO":"00","SHIP_POINT":"","ROUTE":"","CREATED_BY":"","TAX_CLASS1":"","TAX_CLASS2":"","TAX_CLASS3":"","TAX_CLASS4":"","TAX_CLASS5":"","TAX_CLASS6":"","TAX_CLASS7":"","TAX_CLASS8":"","TAX_CLASS9":"","MAT_PR_GRP":"","VAL_TYPE":"","FIXDAT_QTY":"","BOMEXPL_NO":"","RESANALKEY":"","REQMTS_TYP":"","NO_GR_POST":"","BUS_TRANST":"","OVERHD_KEY":"","CSTG_SHEET":"","MATFRGTGRP":"","PLDLVSHDIN":"","SEQ_NO":"","BIL_FORM":"","DLI_PROFIL":"","REV_TYPE":"","BEGDEM_PER":"","PR_REF_MAT":"","REFOBJTYPE":"","REFOBJKEY":"","REFLOGSYS":"","ORDER_PROB":"000","MAX_PL_DLV":"0","CFOP_CODE":"","TAXLAWICMS":"","TAXLAWIPI":"","SD_TAXCODE":"","ASSORT_MOD":"","COMP_QUANT":"0,000","TARGET_VAL":"0,000000000","CURRENCY":"","CURR_ISO":"","PROFIT_CTR":"","ORDERID":"","WBS_ELEM":"","DEPREC_PER":"0,00","REF_DOC":"","REF_DOC_IT":"000000","REF_DOC_CA":"","CUST_MAT35":"","EXCH_RATE_FI_V":"0,00000","EXCHG_RATE_V":"0,00000","ITEMGUID_ATP":"","VAL_CONTR":"","VAL_CON_I":"000000","CONFIG_ID":"","INST_ID":"","MAT_EXT":"","MAT_GUID":"","MAT_VERS":"","P_MAT_EXT":"","P_MAT_GUID":"","P_MAT_VERS":"","FUNC_AREA":"","ALTERN_BOM":"","FKK_CONACCT":"","EAN_UPC":"","PRODCAT":"","SHIP_TYPE":"13","S_PROC_IND":"","FUNC_AREA_LONG":"","BILL_REL":"","VW_UEPOS":"","CAMPAIGN":"00000000000000000000000000000000","DLVSCHDUSE":"","CFOP_LONG":"","SELECTION":"","MAT_ENTRD":"","LOG_SYSTEM_OWN":"","ITM_TYPE_USAGE":"","TAXLAWISS":"","MAT_ENTRD_EXTERNAL":"","MAT_ENTRD_GUID":"","MAT_ENTRD_VERSION":"","LOC_TAXCAT":"","LOC_ZEROVAT":"","LOC_ACTCODE":"","LOC_DISTTYPE":"","LOC_TXRELCLAS":"","CALC_MOTIVE":"","COMPREAS":"","FUND":"","FUNDS_CTR":"","CMMT_ITEM":"","GRANT_NBR":"","BUDGET_PERIOD":"","TAXLAWCOFINS":"","TAXLAWPIS":"","TREASURY_ACC_SYMBOL":"","BUSINESS_EVENT_TCODE":"","MODIFICATION_ALLOWED":"","CANCELLATION_ALLOWED":"","PAYMENT_METHODS":"","BUSINESS_PARTNER_NO":"","REPORTING_FREQ":"","SEPA_MANDATE_ID":"","REQ_SEGMENT":"","TP_SUBLEVL":"","TP_AGENCID":"","TP_ALTRAID":"","TP_BEGPER":"0000","TP_ENDPER":"0000","TP_AVTYPE":"","TP_MAIN_ACCT":"","TP_SUB_ACCT":"","TP_BETC":""}]},{"Name":"TG_CONDITIONS","Structures":[]},{"Name":"TG_RETURN","Structures":[{"TYPE":"S","ID":"V4","NUMBER":"233","MESSAGE":"SALES_HEADER_IN processado com êxito","LOG_NO":"","LOG_MSG_NO":"000000","MESSAGE_V1":"VBAKKOM","MESSAGE_V2":"10.10.2019","MESSAGE_V3":"10:11:17","MESSAGE_V4":"","PARAMETER":"SALES_HEADER_IN","ROW":"0","":"","SYSTEM":"QASCLNT400"},{"TYPE":"S","ID":"V4","NUMBER":"233","MESSAGE":"SALES_ITEM_IN processado com êxito","LOG_NO":"","LOG_MSG_NO":"000000","MESSAGE_V1":"VBAPKOM","MESSAGE_V2":"000010","MESSAGE_V3":"","MESSAGE_V4":"","PARAMETER":"SALES_ITEM_IN","ROW":"1","":"","SYSTEM":"QASCLNT400"},{"TYPE":"S","ID":"V4","NUMBER":"233","MESSAGE":"SALES_ITEM_IN processado com êxito","LOG_NO":"","LOG_MSG_NO":"000000","MESSAGE_V1":"VBAPKOM","MESSAGE_V2":"000020","MESSAGE_V3":"","MESSAGE_V4":"","PARAMETER":"SALES_ITEM_IN","ROW":"2","":"","SYSTEM":"QASCLNT400"},{"TYPE":"S","ID":"V4","NUMBER":"233","MESSAGE":"SALES_ITEM_IN processado com êxito","LOG_NO":"","LOG_MSG_NO":"000000","MESSAGE_V1":"VBAPKOM","MESSAGE_V2":"000030","MESSAGE_V3":"","MESSAGE_V4":"","PARAMETER":"SALES_ITEM_IN","ROW":"3","":"","SYSTEM":"QASCLNT400"},{"TYPE":"S","ID":"V4","NUMBER":"233","MESSAGE":"SALES_ITEM_IN processado com êxito","LOG_NO":"","LOG_MSG_NO":"000000","MESSAGE_V1":"VBAPKOM","MESSAGE_V2":"000040","MESSAGE_V3":"","MESSAGE_V4":"","PARAMETER":"SALES_ITEM_IN","ROW":"4","":"","SYSTEM":"QASCLNT400"},{"TYPE":"W","ID":"V1","NUMBER":"555","MESSAGE":"Documento de vendas e distrib.ainda incompleto -> completar","LOG_NO":"","LOG_MSG_NO":"000000","MESSAGE_V1":"VBAPKOM","MESSAGE_V2":"000040","MESSAGE_V3":"","MESSAGE_V4":"","PARAMETER":"VBUVKOM","ROW":"0","":"","SYSTEM":"QASCLNT400"},{"TYPE":"S","ID":"V1","NUMBER":"311","MESSAGE":"Rem Exemplar c/estoq 1039357 foi gravado(a)","LOG_NO":"","LOG_MSG_NO":"000000","MESSAGE_V1":"Rem Exemplar c/estoq","MESSAGE_V2":"1039357","MESSAGE_V3":"","MESSAGE_V4":"","PARAMETER":"SALES_HEADER_IN","ROW":"0","":"","SYSTEM":"QASCLNT400"}]}]}}';
                  
                    system.debug('msg tratada ' + tratarMensagem(retorno));
                    
                } else {
                	
                    //  HTTP Envio para SAP
                	HTTPExterno portal = new HTTPExterno();
          
                    body = 'key=' + Constants.AMOSTRA_ESB_KEY + '&User=' + Constants.AMOSTRA_ESB_USER + '&ConnectionName=' + Constants.AMOSTRA_ESB_CONNECTIONNAME + '&Application=' +  Constants.AMOSTRA_ESB_APPLICATION + '&EndPoint=' + Constants.AMOSTRA_ESB_RFC + '&DataRequest=' + str_datarequest; 
                        
                   	retorno = portal.getContent(Constants.AMOSTRA_ESB_URL,'POST', 'application/x-www-form-urlencoded',body);
                    
                }
                       
                System.Debug('----------------------------------------------------------------------------------------------'); 
                System.debug('RETORNO:' + retorno);
                System.Debug('-----------------------------------------------------------------------------------------------');
                      
                if (retorno == 'Erro de conexão com SAP') {
                	continue;
                } else {
                    
                	// Ajuste do JSON que tem variáveis que são restritos
                    retorno = retorno.replaceAll('"NUMBER"', '"NUMBER1"');
                    retorno = retorno.replaceAll('"SYSTEM"', '"SYSTEM1"');
                    
                    // Faz parse do retorno do SAP
                    JSONParser parser = JSON.createParser(retorno);
                    
                    // Class de retorno do ponto que interessa
                    Amostra_Retorno inv = new Amostra_Retorno();    
                            
                    while (parser.nextToken() != null) {
                    	if (parser.getCurrentToken() == JSONToken.FIELD_NAME) {
                        	parser.nextToken();
                            	if ( parser.getText() == 'TG_CONDITIONS') {
                                	while (parser.nextToken() != null) {
                                    	if (parser.getCurrentToken() == JSONToken.START_OBJECT) {
                                        	inv = (Amostra_Retorno)parser.readValueAs(Amostra_Retorno.class);
                                        }
                                    }
                                }
                        }
                    }
                             
                    if (inv.Structures.size()>0) {                         
                                        
                        Integration_log__c Log = New Integration_log__c();          
                        Log.Account__c = distribuicao.BR_Oportunidade__r.AccountID;
                        Log.Oportunidade__c = distribuicao.BR_Oportunidade__r.Id;
                        Log.DistribuicaoGratuita__c = distribuicao.Id;
                        
                        System.debug('Debug RETORNO: ' + JSON.serialize(inv.Structures));
                        for (Structure f: inv.Structures) {
                            System.debug('Debug RETORNO: ' + JSON.serialize(f));
                            if ((f.TYPE == 'S') && (f.NUMBER1 == '311') ) {
                                    
                                system.debug('------------------------------------------');
                                system.debug('f.TYPE = #' + f.TYPE + '#');
                                system.debug('f.id = ' + f.id);
                                system.debug('f.NUMBER1 = ' + f.NUMBER1);
                                system.debug('f.MESSAGE_V2 = ' + f.MESSAGE_V2);
                                system.debug('------------------------------------------');
                                
                                Log.ERP__c = f.MESSAGE_V2;  // Numero do pedido do SAP
                                Log.Status__c = 'Sucesso';
                                Log.Message_Long__c = f.MESSAGE;  // Mensagem do SAP
                                Log.Message__c = DateTime.now().format('HH:mm:ss'); 
                                distribuicao.BR_IntegradoSucesso__c = true;
                                distribuicao.BR_ErroIntegracao__c = false;
                                distribuicao.BR_NOrdemVenda__c = f.MESSAGE_V2;
                                
                                if (!Test.isRunningTest())
                                	update distribuicao;
                                
                                break; 
                                
                            } else if (f.TYPE == 'E') {
                                
                                // há erro no processameto da requisição de criação da OV
                                // 
                                // DEU RUIM
                                system.debug('JK ERROOOOOOOO!');
                                Log.ERP__c = '';
                                Log.Status__c = 'Error';
                                distribuicao.BR_IntegradoSucesso__c = false;
                                distribuicao.BR_ErroIntegracao__c = true;
                                
                                if (!Test.isRunningTest())
                                	update distribuicao;
                                
                                //atualizo o status da Oportunidade
                                system.debug('JK - atualizando o status da oportunidade para ERRO SAP ' + distribuicao.BR_Oportunidade__r.ID); 
                                Opportunity op = [select StageName from Opportunity where id =: distribuicao.BR_Oportunidade__r.ID limit 1];
                                op.StageName = 'Erro ERP';
                                
                                if (!Test.isRunningTest())
                                	update op;        
                                
                                System.Debug('Mensagem Retorno: ' + f.MESSAGE);
                                
                                Log.Message__c =  tratarMensagem(f.MESSAGE);
                                
                                break;
                            } 
                        }
                   	
                        lstLog.add(Log);
                    }
            	}
    		}
    		
    		insert lstLog;
    	}
    }
    
    public static String NumeroApenas(String Texto) {  
        if(String.IsBlank(Texto)){
            Texto = '';
        } else { 
        Texto = Texto.replaceAll('[|,|.|/|\\,||"||:|~|!|@|#|$|%|^|&|*|_|-|-|+|=|<|>|?|\\(|\\)|\\{|\\}|\\;|\\\'"]', '');
        }
        return Texto;
    }    
        
    public static String CentrodeCusto(String Texto) {  
        String N_CentrodeCusto = '';
        List<String> usr = new List<String>();

        usr.add(Texto);
        
        for(User lstUser : UserDAO.getListUserByIdsUsers(usr)){
            N_CentrodeCusto = lstUser.CentroCusto_SAP__c;
        }
        
        return N_CentrodeCusto;
    } 
    
    public static String TipoFreteSAP(String Texto) {  
        String FreteTexto;
        if (Texto ==  'PAC-Correios' || Texto == 'PAC') {
            FreteTexto = '13'; // PAC
        }    
        if (Texto == 'Sedex') {
            FreteTexto = '10'; // SEDEX
        }    
        if (Texto == '') {
            FreteTexto = '';
        }
        return FreteTexto;
    } 
    
    public static String tratarMensagem(String msg){
    	String retorno = msg;
		if (msg.contains('Indicar nº endereço ou handle de endereço') == true) {
        	retorno = 'SalesForce - Verificar a conta do professor - CPF/Email/Endereço';
        }
                                             
        if (msg.contains('não foi criado para área de vendas') == true) {
        	retorno = 'SAP - Solicitação de Ampliação de Cliente';
        }
                                            
        if (msg.contains('esquema de cálculo') == true) {
        	retorno = 'SAP - Solicitação de Alteração de Cliente - Marcar esquema de cálculo';
        }
                                            
        if (msg.contains('idioma PT não está previsto') == true) {
        	retorno = 'SAP - Produto não cadastrado ou não disponível para amostra';
        }
                                            
        if (msg.contains('tabela T184 ZEXE ZSER') == true) {
        	retorno = 'SAP - É um serviço e não pode ser enviado para amostra';
        }
        
        return retorno;
    }
}