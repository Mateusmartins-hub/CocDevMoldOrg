public class AmostraFisicaSAP {
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
}