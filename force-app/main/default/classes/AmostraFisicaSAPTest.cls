@IsTest
public with sharing class AmostraFisicaSAPTest {
    
    @IsTest
    static void shouldTestNewClassIntance(){
        AmostraFisicaSAP.TGBAPISDITM TGBAPISDITM = new AmostraFisicaSAP.TGBAPISDITM();
        TGBAPISDITM.MATERIAL = 'test';
        TGBAPISDITM.TARGET_QTY = 'test';
        TGBAPISDITM.PURCH_DATE = 'test';
        TGBAPISDITM.BILL_DATE = 'test';
        TGBAPISDITM.USAGE_IND = 'test';
        TGBAPISDITM.PLANT = 'test';
        TGBAPISDITM.STORE_LOC = 'test';
        TGBAPISDITM.INCOTERMS1 = 'test';
        TGBAPISDITM.INCOTERMS2 = 'test';

        AmostraFisicaSAP.Amostra_SAP amostraSAP = new AmostraFisicaSAP.Amostra_SAP();
        amostraSAP.AUART = 'test';
        amostraSAP.VTWEG = 'test';
        amostraSAP.VKBUR = 'test';
        amostraSAP.BSTDK1 = 'test';
        amostraSAP.PF_EMISSOR = 'test';
        amostraSAP.CNPJ_CPF_EMISSOR = 'test';
        amostraSAP.PF_RECEBEDOR = 'test';
        amostraSAP.CNPJ_CPF_RECEBEDOR = 'test';
        amostraSAP.VDATU = 'test';
        amostraSAP.BSTKD = 'test';
        amostraSAP.OBS = 'test';
        amostraSAP.ENTREGA = 'test';
        amostraSAP.FRETE = 'test';
        amostraSAP.PYMT_METH = 'test';
        amostraSAP.KVGR1 = 'test';
        amostraSAP.DZTERM = 'test';
        amostraSAP.KVGR2 = 'test';
        amostraSAP.COMPLEM = 'test';
        amostraSAP.VKORG = 'test';
        amostraSAP.NFNUM = 'test';
        amostraSAP.SERIES = 'test';
        amostraSAP.INCO1 = 'test';
        amostraSAP.INCO2 = 'test';
        amostraSAP.CIDADE = 'test';
        amostraSAP.ESTADO = 'test';
        amostraSAP.PAIS = 'test';
        amostraSAP.RAZAO_SOCIAL = 'test';
        amostraSAP.NOME_FANTASIA = 'test';
        amostraSAP.BAIRRO = 'test';
        amostraSAP.ENDERECO = 'test';
        amostraSAP.CEP = 'test';
        amostraSAP.DTA_CADASTRO = 'test';
        amostraSAP.RG = 'test';
        amostraSAP.FONE = 'test';
        amostraSAP.COMPLEMENTO = 'test';
        amostraSAP.NUMERO = 'test';
        amostraSAP.EMAIL = 'test';
        amostraSAP.COND_PAGTO = 'test';
        amostraSAP.KOSTL = 'test';

        amostraSAP.TG_BAPISDITM = new List<AmostraFisicaSAP.TGBAPISDITM>();
        amostraSAP.TG_BAPISDITM.add(TGBAPISDITM);

        amostraSAP.TG_CONDITIONS = new List<Object>();
        amostraSAP.TG_CONDITIONS.add('String');
        amostraSAP.TG_CONDITIONS.add(1);

        AmostraFisicaSAP.Structure structure = new AmostraFisicaSAP.Structure();
        structure.TYPE = 'test';
        structure.ID = 'test';
        structure.NUMBER1 = 'test';
        structure.MESSAGE = 'test';
        structure.LOG_NO = 'test';
        structure.LOG_MSG_NO = 'test';
        structure.MESSAGE_V1 = 'test';
        structure.MESSAGE_V2 = 'test';
        structure.MESSAGE_V3 = 'test';
        structure.MESSAGE_V4 = 'test';
        structure.PARAMETER = 'test';
        structure.ROW = 'test';
        structure.SYSTEM1 = 'test';

        AmostraFisicaSAP.Amostra_Retorno amostraRetorno = new AmostraFisicaSAP.Amostra_Retorno();
        amostraRetorno.Name = 'test';
        amostraRetorno.Structures = new List<AmostraFisicaSAP.Structure>();
        amostraRetorno.Structures.add(structure);
    }
}