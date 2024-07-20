global with sharing class CadastroClienteIntegracaoSAPJob {
    
    public class Exports
    {
        public string E_MESSAGE { get; set; }
        public string E_RETORNO { get; set; }
    }
    
    public class Data
    {
        public Exports Exports { get; set; }
        public List<object> Tables { get; set; }
    }
    
    public class RootObject
    {
        public string Status { get; set; }
        public Data Data { get; set; }
    }
    
    public static CadastroClienteIntegracaoSAPJob getInstance() {
        CadastroClienteIntegracaoSAPJob instance = new CadastroClienteIntegracaoSAPJob();
        
        return instance;
    }
    
    //Inicializando a class
    private void CadastroClienteIntegracaoSAPJob() {
        
    }
    
    private static String retornoSAP {get; set;}
    
    
    public void Integra(){
        List<SolicitacaoCadastroCliente__c> lstCadastroCliente = [SELECT Id,
                                                                  BR_Bairro__c,
                                                                  BR_Conta__c,
                                                                  BR_CNPJ__c,
                                                                  BR_CPF__c,
                                                                  BR_email__c,
                                                                  BR_Main_Address__c,
                                                                  BR_Main_City__c,
                                                                  BR_Main_Complement__c,
                                                                  BR_Main_Nbr__c,
                                                                  BR_Main_State__c,
                                                                  BR_Main_Zip_code__c,
                                                                  BR_Name__c,
                                                                  BR_Nascimento__c,
                                                                  BR_Phone__c,
                                                                  BR_RazaoSocial__c,
                                                                  BR_Status__c,
                                                                  CreatedDate,
                                                                  InscricaoEstadual__c,
                                                                  Name,
                                                                  Pessoa_de_Contato__c,
                                                                  Tipo_de_Pessoa__c,
                                                                  Unidade__c,
                                                                  BR_RegionalVendas__c,
                                                                  BR_GrupoClassificaContrib__c,
                                                                  BR_GrupoClientes__c,
                                                                  BR_ClienteBloqueado__c,
                                                                  BR_CRTN__c,
                                                                  BR_EscritorioVendas__c,
                                                                  BR_EquipeVendas__c, 
                                                                  TipoRegistroConta__c
                                                                  FROM SolicitacaoCadastroCliente__c 
                                                                  WHERE BR_Status__c = 'Enviado para Integração'];
        for(SolicitacaoCadastroCliente__c cadastroCli : lstCadastroCliente){
            sendToSAP(cadastroCli.Id);
        }
    }
    
    /*public void Integra() {
        
        List<Integration_log__c> lstLog = New List<Integration_log__c>();
        
        List<SolicitacaoCadastroCliente__c> lstCadastroCliente = [SELECT Id,
                                                                  BR_Bairro__c,
                                                                  BR_Conta__c,
                                                                  BR_CNPJ__c,
                                                                  BR_CPF__c,
                                                                  BR_email__c,
                                                                  BR_Main_Address__c,
                                                                  BR_Main_City__c,
                                                                  BR_Main_Complement__c,
                                                                  BR_Main_Nbr__c,
                                                                  BR_Main_State__c,
                                                                  BR_Main_Zip_code__c,
                                                                  BR_Name__c,
                                                                  BR_Nascimento__c,
                                                                  BR_Phone__c,
                                                                  BR_RazaoSocial__c,
                                                                  BR_Status__c,
                                                                  CreatedDate,
                                                                  InscricaoEstadual__c,
                                                                  Name,
                                                                  Pessoa_de_Contato__c,
                                                                  Tipo_de_Pessoa__c,
                                                                  Unidade__c,
                                                                  BR_RegionalVendas__c,
                                                                  BR_GrupoClassificaContrib__c,
                                                                  BR_GrupoClientes__c,
                                                                  BR_ClienteBloqueado__c,
                                                                  BR_CRTN__c,
                                                                  BR_EscritorioVendas__c,
                                                                  BR_EquipeVendas__c, 
                                                                  TipoRegistroConta__c
                                                                  FROM SolicitacaoCadastroCliente__c 
                                                                  WHERE BR_Status__c = 'Enviado para Integração'];
        
        System.debug('Quantidade de registros a processar ' + lstCadastroCliente.size());
        if(lstCadastroCliente.size() > 0){
            for(SolicitacaoCadastroCliente__c cadastroCli : lstCadastroCliente){
                sendToSAP(str_datarequest, cadastroCli.Id);
                
                // Tenho que usar o JsonGenerator porque essa RFC espera os parametros numa certa ordem.
                JSONGenerator jsGen = JSON.createGenerator(true);
                jsGen.writeStartObject();
                jsGen.writeFieldName('I_DATA');
                jsGen.writeStartArray();
                jsGen.writeStartObject();
                
                jsGen.writeStringField('MANDT','400');
                jsGen.writeStringField('BUKRS','PEBR');
                
                switch on cadastroCli.Unidade__c {
                    when 'Wizard'{
                        jsGen.writeStringField('VKORG','OVE0');
                        jsGen.writeStringField('VTWEG','99');
                        jsGen.writeStringField('SPART','WZ');
                    }
                    when 'Skill'{
                        jsGen.writeStringField('VKORG','OVE0');
                        jsGen.writeStringField('VTWEG','99');
                        jsGen.writeStringField('SPART','SK');
                    }
                    when 'Yazigi'{
                        jsGen.writeStringField('VKORG','OVE0');
                        jsGen.writeStringField('VTWEG','99');
                        jsGen.writeStringField('SPART','YZ');
                    }
                    when 'COC'{
                        jsGen.writeStringField('VKORG','OVE2');
                        jsGen.writeStringField('VTWEG','99');
                        jsGen.writeStringField('SPART','99');
                    }
                    when 'NAME'{
                        jsGen.writeStringField('VKORG','OVE1');
                        jsGen.writeStringField('VTWEG','99');
                        jsGen.writeStringField('SPART','99');
                    }
                    when 'Dom Bosco'{
                        jsGen.writeStringField('VKORG','OVE5');
                        jsGen.writeStringField('VTWEG','99');
                        jsGen.writeStringField('SPART','99');
                    }
                    when 'HED'{
                        jsGen.writeStringField('VKORG','OVE7');
                        jsGen.writeStringField('VTWEG','99');
                        jsGen.writeStringField('SPART','99');
                    }
                    when 'Atitude'{
                        jsGen.writeStringField('VKORG','OVE8');
                        jsGen.writeStringField('VTWEG','99');
                        jsGen.writeStringField('SPART','99');
                    }
                    when 'Corporate'{
                        jsGen.writeStringField('VKORG','OV10');
                        jsGen.writeStringField('VTWEG','99');
                        jsGen.writeStringField('SPART','CP');
                    }
                    when 'Coleção Mentes'{
                        jsGen.writeStringField('VKORG','OVE9');
                        jsGen.writeStringField('VTWEG','99');
                        jsGen.writeStringField('SPART','CM');
                    }
                    when 'Leitura e Companhia'{
                        jsGen.writeStringField('VKORG','OVE9');
                        jsGen.writeStringField('VTWEG','99');
                        jsGen.writeStringField('SPART','LC');
                    }
                }
                
                // como essa desgraça tem que ir numa ordem específica para o SAP, tive que repetir parte do código.
                // facilitar pra que ?.
                if (cadastroCli.Tipo_de_Pessoa__c == 'Pessoa Física'){
                    jsGen.writeStringField('KTOKD','Z005');
                    
                    // temos que dividir o sap.NAME1 caso possua mais de 35 caracteres para não estourar o limite do SAP
                    // no campo sap.NAME2 ficarão mais 35 caracteres e o resto será truncado.
                    if (cadastroCli.BR_Name__c.length() > 40){
                        
                        Integer sobra = cadastroCli.BR_Name__c.length() - 40;
                        
                        jsGen.writeStringField('NAME1', cadastroCli.BR_Name__c.substring(0,40));
                        jsGen.writeStringField('NAME2', cadastroCli.BR_Name__c.substring(40, sobra + 40));
                        
                        
                    } else {
                        jsGen.writeStringField('NAME1', cadastroCli.BR_Name__c);
                        jsGen.writeStringField('NAME2', '');
                    }
                }
                else{
                    
                    //  em caso de PJ e Franquias, usar o grupo de contas Y004
                    switch on cadastroCli.Unidade__c {
                        when 'Wizard','Skill','Yazigi'{
                            jsGen.writeStringField('KTOKD','Y004');
                        }
                        when else {
                            jsGen.writeStringField('KTOKD','Z011');        
                        }
                    }
                    
                    if (cadastroCli.BR_RazaoSocial__c != NULL){
                        
                        system.debug('razao social ' + cadastroCli.BR_RazaoSocial__c);
                        
                        if (cadastroCli.BR_RazaoSocial__c.length() > 40){
                            
                            system.debug('entrou no if ' + cadastroCli.BR_RazaoSocial__c.length());
                            
                            Integer sobra = cadastroCli.BR_RazaoSocial__c.length() - 40;
                            
                            system.debug('sobra ' + sobra);
                            
                            jsGen.writeStringField('NAME1', cadastroCli.BR_RazaoSocial__c.substring(0,40));
                            system.debug('JK1 ' + cadastroCli.BR_RazaoSocial__c.substring(0,40));
                            
                            jsGen.writeStringField('NAME2', cadastroCli.BR_RazaoSocial__c.substring(40,(sobra + 40)));
                            system.debug('JK1 ' + cadastroCli.BR_RazaoSocial__c.substring(40,(sobra + 40)));
                            
                        } else {
                            jsGen.writeStringField('NAME1',cadastroCli.BR_RazaoSocial__c);
                            jsGen.writeStringField('NAME2','');
                        }
                    }
                }
                
                jsGen.writeStringField('LAND1','BR');
                jsGen.writeStringField('STREET',cadastroCli.BR_Main_Address__c);
                jsGen.writeStringField('HOUSE_NUM1',cadastroCli.BR_Main_Nbr__c);
                
                if (cadastroCli.BR_Bairro__c.length() > 40)
                    jsGen.writeStringField('CITY2',cadastroCli.BR_Bairro__c.substring(0,39));
                else
                    jsGen.writeStringField('CITY2',cadastroCli.BR_Bairro__c);
                
                if (cadastroCli.BR_Main_City__c.length() > 40)
                    jsGen.writeStringField('CITY1',cadastroCli.BR_Main_City__c.substring(0,39));
                else
                    jsGen.writeStringField('CITY1',cadastroCli.BR_Main_City__c);
                
                jsGen.writeStringField('REGION',cadastroCli.BR_Main_State__c);
                System.debug('CEP ' + cadastroCli.BR_Main_Zip_code__c);
                jsGen.writeStringField('POST_CODE1',cadastroCli.BR_Main_Zip_code__c);
                jsGen.writeStringField('TELF1',NumeroApenas(cadastroCli.BR_Phone__c));
                jsGen.writeStringField('TELF2','');
                
                if (cadastroCli.Tipo_de_Pessoa__c == 'Pessoa Física'){
                    jsGen.writeStringField('STCD1','');
                    jsGen.writeStringField('STCD2',NumeroApenas(cadastroCli.BR_CPF__c));
                    jsGen.writeStringField('STCD3','ISENTO');
                    
                } else {
                    
                    jsGen.writeStringField('STCD1',NumeroApenas(cadastroCli.BR_CNPJ__c));
                    jsGen.writeStringField('STCD2','');
                    
                    if (cadastroCli.InscricaoEstadual__c == 'ISENTO' 
                        || String.isBlank(cadastroCli.InscricaoEstadual__c) )
                        jsGen.writeStringField('STCD3','ISENTO');
                    else
                        jsGen.writeStringField('STCD3',cadastroCli.InscricaoEstadual__c);
                    
                }
                
                switch on cadastroCli.BR_CRTN__c {
                    when 'Simples Nacional'{
                        jsGen.writeStringField('CRTN','1');
                    }
                    
                    when 'Demais Empresas'{
                        jsGen.writeStringField('CRTN','3');
                    }
                    when 'Pessoa Física'{
                        jsGen.writeStringField('CRTN','8');
                    }
                }
                
                switch on cadastroCli.BR_RegionalVendas__c {
                    when 'Acre'{
                        jsGen.writeStringField('BZIRK','AC0001');
                    }
                    when 'Alagoas'{
                        jsGen.writeStringField('BZIRK','AL0001');
                    }
                    when 'Amazonas'{
                        jsGen.writeStringField('BZIRK','AM0001');
                    }
                    when 'Amapá'{
                        jsGen.writeStringField('BZIRK','AP0001');
                    }
                    when 'Bahia'{
                        jsGen.writeStringField('BZIRK','BA0001');
                    }
                    when 'Ceará'{
                        jsGen.writeStringField('BZIRK','CE0001');
                    }
                    when 'Distrito Federal'{
                        jsGen.writeStringField('BZIRK','DF0001');
                    }
                    when 'Espirito Santo'{
                        jsGen.writeStringField('BZIRK','ES0001');
                    }
                    when 'Estrangeiro'{
                        jsGen.writeStringField('BZIRK','EST001');
                    }
                    when 'Exportação'{
                        jsGen.writeStringField('BZIRK','EX0001');
                    }
                    when 'Goias'{
                        jsGen.writeStringField('BZIRK','GO0001');
                    }
                    when 'Maranhão'{
                        jsGen.writeStringField('BZIRK','MA0001');
                    }
                    when 'Minas Gerais'{
                        jsGen.writeStringField('BZIRK','MG0001');
                    }
                    when 'Mato Grosso do Sul'{
                        jsGen.writeStringField('BZIRK','MS0001');
                    }
                    when 'Mato Grosso'{
                        jsGen.writeStringField('BZIRK','MT0001');
                    }
                    when 'NORDESTE'{
                        jsGen.writeStringField('BZIRK','NORDES');
                    }
                    when 'NORTE'{
                        jsGen.writeStringField('BZIRK','NORTE');
                    }
                    when 'CENTRO-OESTE'{
                        jsGen.writeStringField('BZIRK','OESTE');
                    }
                    when 'Pará'{
                        jsGen.writeStringField('BZIRK','PA0001');
                    }
                    when 'Paraíba'{
                        jsGen.writeStringField('BZIRK','PB0001');
                    }
                    when 'Pernambuco'{
                        jsGen.writeStringField('BZIRK','PE0001');
                    }
                    when 'Piauí'{
                        jsGen.writeStringField('BZIRK','PI0001');
                    }
                    when 'São Paulo'{
                        jsGen.writeStringField('BZIRK','SP0001');
                    }
                    when else {
                        jsGen.writeStringField('BZIRK','SP0001');
                    }
                }
                
                jsGen.writeStringField('VKBUR',cadastroCli.BR_EscritorioVendas__c);
                jsGen.writeStringField('VKGRP',cadastroCli.BR_EquipeVendas__c);
                jsGen.writeStringField('KALKS','1');
                
                switch on cadastroCli.Unidade__c {
                    when 'Wizard','Skill','Yazigi'{
                        jsGen.writeStringField('VERSG','1');
                    }
                    when 'COC'{
                        jsGen.writeStringField('VERSG','3');
                    }
                    when 'NAME'{
                        jsGen.writeStringField('VERSG','4');
                    }
                    when 'Dom Bosco'{
                        jsGen.writeStringField('VERSG','6');
                    }
                    when 'HED'{
                        jsGen.writeStringField('VERSG','7');
                    }
                    when 'Atitude'{
                        jsGen.writeStringField('VERSG','9');
                    }
                    when 'Coleção Mentes', 'Leitura e Companhia'{
                        jsGen.writeStringField('VERSG','A');
                    }
                    when 'Corporate'{
                        jsGen.writeStringField('VERSG','B');
                    }
                }
                
                switch on cadastroCli.BR_GrupoClassificaContrib__c{
                    when 'Parceiros - MI'{
                        jsGen.writeStringField('KTGRD','Z1');
                    }
                    when 'Prefeitura'{
                        jsGen.writeStringField('KTGRD','Z2');
                    }
                    when 'Empresas do Grupo'{
                        jsGen.writeStringField('KTGRD','Z3');
                    }
                    when 'Terceiro - MI'{
                        jsGen.writeStringField('KTGRD','Z4');
                    }                    
                }
                
                //FOI SOLICITADO PARA REMOVER O CAMPO DO CADASTRO, O SAP IRÁ PREENCHER AUTOMATICO
                //switch on cadastroCli.BR_GrupoAdminTesouro__c{
//when 'Parceiros'{
//jsGen.writeStringField('FDGRV','C002');
//}
//when 'Prefeituras'{
//jsGen.writeStringField('FDGRV','C003');
//}
//when 'Cliente Direto'{
//jsGen.writeStringField('FDGRV','C005');
//}
//when 'Prospecção'{
//jsGen.writeStringField('FDGRV','C006');
//}
//when 'Professor'{
//jsGen.writeStringField('FDGRV','C010');
//}
//when 'Cliente E-commerce'{
//jsGen.writeStringField('FDGRV','C012');
//}
//}
                
                switch on cadastroCli.BR_GrupoClientes__c{
                    when 'Cliente Distratado'{
                        jsGen.writeStringField('KDGRP','01');
                    }
                    when 'Cliente E-commerce'{
                        jsGen.writeStringField('KDGRP','02');
                    }
                    when 'Unidade Própria'{
                        jsGen.writeStringField('KDGRP','03');
                    }
                    when 'Professor'{
                        jsGen.writeStringField('KDGRP','04');
                    }
                    when 'Prefeitura'{
                        jsGen.writeStringField('KDGRP','05');
                    }
                    when 'Cliente Direto'{
                        jsGen.writeStringField('KDGRP','07');
                    }
                    when 'Prospecção'{
                        jsGen.writeStringField('KDGRP','08');
                    }
                    when 'Parceiro colaborador'{
                        jsGen.writeStringField('KDGRP','09');
                    }
                    when 'Interveniente'{
                        jsGen.writeStringField('KDGRP','10');
                    }
                }
                
                
                jsGen.writeStringField('E_MAIL',cadastroCli.BR_email__c);
                
                if(cadastroCli.BR_ClienteBloqueado__c)
                    jsGen.writeStringField('BLOQ','X');
                else
                    jsGen.writeStringField('BLOQ','');
                
                if (String.isNotEmpty(cadastroCli.BR_Main_Complement__c))
                    jsGen.writeStringField('STR_SUPPL3',cadastroCli.BR_Main_Complement__c);
                else {
                    jsGen.writeStringField('STR_SUPPL3','');
                }
                
                //  HTTP Envio para SAP
                jsGen.writeEndObject();
                jsGen.writeEndArray();
                jsGen.writeEndObject();
                jsGen.close();
                
                // Tudo isso porque o SAP não consegue processar uma mensagem JSON pretty e a porcaria do getAsString()
                // só gera assim.
                String str_datarequest = jsGen.getAsString().replaceAll('&','e');
                str_datarequest = str_datarequest.replaceAll('\\n\\r', ''); // remove CRLF
                str_datarequest = str_datarequest.replaceAll('\\n', '');    // remove LF
                str_datarequest = str_datarequest.replaceAll('\\r', '');    //remove CR
                str_datarequest = str_datarequest.replaceAll('  ', '');	 // remove espaços duplos entre os parametros
                str_datarequest = str_datarequest.replaceAll(' : ', ':');   // remove espaços entre chave e o valor
                
                
                if (Test.isRunningTest()){
                    System.debug('Considerou teste');
                    retornoSAP = '{"Status":"OK","Data":{"Exports":{"E_MESSAGE":"Cliente 138791 modificado com sucesso!"},"Tables":[]}}';
                    System.debug('retorno SAP ' + retornoSAP);
                } 
                else {   
                    System.debug('Chamando o SAP');
                    // chama a integração com o SAP
                    sendToSAP(str_datarequest, cadastroCli.Id);
                    System.debug('chamada do SAP retornou');
                }
                
                
            }
        }
    }*/ 
    
    /**
* Envia os dados para o SAP
*/
    /*@future (callout=true)
public static void sendToSAP(String str_datarequest, String cadCliId ){

String body;
String retorno;

//  HTTP Envio para SAP
HTTPExterno portal = new HTTPExterno();

system.debug('request ' + str_datarequest);

body = 'key=' + Constants.CADCLI_ESB_KEY + '&User=' + Constants.CADCLI_ESB_USER + '&ConnectionName=' + Constants.CADCLI_ESB_CONNECTIONNAME + '&Application=' +  Constants.CADCLI_ESB_APPLICATION + '&EndPoint=' + Constants.CADCLI_ESB_RFC + '&DataRequest=' + str_datarequest; 

if (Test.isRunningTest()){
retorno = '{"Status":"OK","Data":{"Exports":{"E_MESSAGE":"Cliente 139312 modificado com sucesso!", "E_RETORNO":"Sucesso"},"Tables":[]}}';
} else {
retorno = portal.getContent(Constants.CADCLI_ESB_URL,'POST', 'application/x-www-form-urlencoded',body);
}

System.Debug('----------------------------------------------------------------------------------------------'); 
System.Debug('RETORNO:' + retorno);
System.Debug('----------------------------------------------------------------------------------------------');

SolicitacaoCadastroCliente__c cadastroCli = [SELECT Id,
BR_Bairro__c,
BR_Conta__c,
BR_CNPJ__c,
BR_CPF__c,
BR_email__c,
BR_Main_Address__c,
BR_Main_City__c,
BR_Main_Complement__c,
BR_Main_Nbr__c,
BR_Main_State__c,
BR_Main_Zip_code__c,
BR_Name__c,
BR_Nascimento__c,
BR_Phone__c,
BR_RazaoSocial__c,
BR_Status__c,
CreatedDate,
InscricaoEstadual__c,
Name,
Pessoa_de_Contato__c,
Tipo_de_Pessoa__c,
Unidade__c,
BR_RegionalVendas__c,
BR_GrupoClassificaContrib__c,
BR_GrupoClientes__c,
BR_ClienteBloqueado__c,
BR_CRTN__c,
BR_EscritorioVendas__c,
BR_EquipeVendas__c,
TipoRegistroConta__c,
BR_MensagemErro__c
FROM SolicitacaoCadastroCliente__c 
where id =: cadCliId];

// pega a mensagem de retorno do SAP
RootObject root = (RootObject) Json.deserialize(retorno, RootObject.class);

if (retorno == 'Erro de conexão com SAP'){ 

cadastroCli.BR_Status__c = 'Erro de Integração';
update cadastroCli;
return;
}

System.debug('AQUI -> ' + root.Data.Exports.E_RETORNO);

if (root.Data.Exports.E_RETORNO.contains('Sucesso')) {

String codSAp = root.Data.Exports.E_MESSAGE.split(' ')[1];

System.debug('código SAP -> ' + codSAp);

// cria o registro no Account
Account acc;
Boolean isUpdate = false;

if (root.Data.Exports.E_MESSAGE.contains('modificado com sucesso!')){

List<Account> accExistente;

if (cadastroCli.Tipo_de_Pessoa__c == 'Pessoa Jurídica'){
String cnpj = cadastroCli.BR_CNPJ__c;
accExistente = [select id, 
Name, 
RecordTypeId,
BR_cnpj__c,
BR_Company_Name__c,
BR_tax_registration_number__c,
BR_CPF__c,
BR_Approval_status__c,
BR_Main_Address__c,
BR_Main_Nbr__c,
BR_Bairro__c,
BR_Main_District__c,
BR_Main_City__c,
BR_Main_Zip_code__c,
BR_Main_State__c,
BR_Account_Id_SAP__c,
BR_Account_email__c,
BR_Area_code__c,
Phone,
Marca__c,
BR_Main_Complement__c
from Account where BR_cnpj__c =: cnpj limit 1];
} else {
String cpf = cadastroCli.BR_CPF__c;
accExistente = [select id, 
Name, 
RecordTypeId,
BR_cnpj__c,
BR_Company_Name__c,
BR_tax_registration_number__c,
BR_CPF__c,
BR_Approval_status__c,
BR_Main_Address__c,
BR_Main_Nbr__c,
BR_Bairro__c,
BR_Main_District__c,
BR_Main_City__c,
BR_Main_Zip_code__c,
BR_Main_State__c,
BR_Account_Id_SAP__c,
BR_Account_email__c,
BR_Area_code__c,
Phone,
Marca__c
from Account where BR_CPF__c =: cpf limit 1];
}

if (accExistente.size() > 0) {
acc = accExistente[0];
isUpdate = true;
} else {
// as vezes o cliente existe na base do SAP mas não no SF
acc = new Account();
}

} else {
System.debug('novo account');
acc = new Account();
}

// se CNPJ ou CPF
if (cadastroCli.Tipo_de_Pessoa__c == 'Pessoa Jurídica'){
acc.Name = cadastroCli.BR_RazaoSocial__c;
acc.BR_Company_Name__c = cadastroCli.BR_RazaoSocial__c;
acc.RecordTypeId =  cadastroCli.TipoRegistroConta__c;  //'0120V0000026BAeQAM';
acc.BR_cnpj__c = cadastroCli.BR_CNPJ__c;
acc.BR_tax_registration_number__c = cadastroCli.InscricaoEstadual__c;
} else {

acc.Name = cadastroCli.BR_Name__c;
acc.RecordTypeId = cadastroCli.TipoRegistroConta__c; //'012d0000000hJ0CAAU'; 
acc.BR_CPF__c = cadastroCli.BR_CPF__c;
acc.BR_tax_registration_number__c = 'ISENTO';
}

acc.BR_Approval_status__c = 'Aprovado';                 
acc.BR_Main_Address__c = cadastroCli.BR_Main_Address__c;
acc.BR_Main_Nbr__c = cadastroCli.BR_Main_Nbr__c;
acc.BR_Bairro__c = cadastroCli.BR_Bairro__c;
acc.BR_Main_District__c = cadastroCli.BR_Bairro__c;
acc.BR_Main_City__c = cadastroCli.BR_Main_City__c;
acc.BR_Main_State__c = cadastroCli.BR_Main_State__c;
acc.BR_Main_Zip_code__c = cadastroCli.BR_Main_Zip_code__c;               
acc.BR_Account_email__c = cadastroCli.BR_email__c;
acc.BR_Main_Complement__c = cadastroCli.BR_Main_Complement__c;

try{
acc.Phone = cadastroCli.BR_Phone__c;
acc.BR_Area_code__c = decimal.valueOf(cadastroCli.BR_Phone__c.substring(1,3));
} catch (Exception e) {
System.debug('Verificar máscara do telefone: ' + e.getMessage());
}

acc.BR_Account_Id_SAP__c = codSap;
acc.BR_Approval_status__c = 'Aprovado';
acc.Marca__c = cadastroCli.Unidade__c;

try{
if (isUpdate)
update acc;
else
insert acc;
} catch (Exception e) {
System.debug('houve erro na inserção no SF ->' + e.getMessage());
}

try {
// muda o status da solicitação 'Cliente Integrado'.
cadastroCli.BR_Status__c = 'Cliente Integrado';
cadastroCli.BR_Conta__c = acc.Id;
cadastroCli.BR_MensagemErro__c = '';                
//RecordType tipoConta = [SELECT Id,Name FROM RecordType WHERE Id =: cadastroCli.TipoRegistroConta__c limit 1];
//cadastroCli.TipoRegistroConta__c = tipoConta.Name;                

update cadastroCli; 

} catch (Exception e) {
System.debug('houve erro na atualização da solcitação do cadastro. ->' + e.getMessage());
}

System.debug('Chegou nos finalmentes');
}
else {

// qualquer outro erro
cadastroCli.BR_Status__c = 'Erro de Integração'; 
cadastroCli.BR_MensagemErro__c = root.Data.Exports.E_MESSAGE;
update cadastroCli; 
}
}*/
    
    @future (callout=true)
    public static void sendToSAP(String cadCliId ){
        SolicitacaoCadastroCliente__c cadastroCli = [SELECT Id,
                                                     BR_Bairro__c,
                                                     BR_Conta__c,
                                                     BR_CNPJ__c,
                                                     BR_CPF__c,
                                                     BR_email__c,
                                                     BR_Main_Address__c,
                                                     BR_Main_City__c,
                                                     BR_Main_Complement__c,
                                                     BR_Main_Nbr__c,
                                                     BR_Main_State__c,
                                                     BR_Main_Zip_code__c,
                                                     BR_Name__c,
                                                     BR_Nascimento__c,
                                                     BR_Phone__c,
                                                     BR_RazaoSocial__c,
                                                     BR_Status__c,
                                                     CreatedDate,
                                                     InscricaoEstadual__c,
                                                     Name,
                                                     Pessoa_de_Contato__c,
                                                     Tipo_de_Pessoa__c,
                                                     Unidade__c,
                                                     BR_RegionalVendas__c,
                                                     BR_GrupoClassificaContrib__c,
                                                     BR_GrupoClientes__c,
                                                     BR_ClienteBloqueado__c,
                                                     BR_CRTN__c,
                                                     BR_EscritorioVendas__c,
                                                     BR_EquipeVendas__c,
                                                     TipoRegistroConta__c,
                                                     BR_MensagemErro__c
                                                     FROM SolicitacaoCadastroCliente__c 
                                                     where id =: cadCliId];
        
        Account acc;
        Boolean isUpdate = false;
        
        List<Account> accExistente;
        
        if (cadastroCli.Tipo_de_Pessoa__c == 'Pessoa Jurídica'){
            String cnpj = cadastroCli.BR_CNPJ__c;
            accExistente = [select id, 
                            Name, 
                            RecordTypeId,
                            BR_cnpj__c,
                            BR_Company_Name__c,
                            BR_tax_registration_number__c,
                            BR_CPF__c,
                            BR_Approval_status__c,
                            BR_Main_Address__c,
                            BR_Main_Nbr__c,
                            BR_Bairro__c,
                            BR_Main_District__c,
                            BR_Main_City__c,
                            BR_Main_Zip_code__c,
                            BR_Main_State__c,
                            BR_Account_Id_SAP__c,
                            BR_Account_email__c,
                            BR_Area_code__c,
                            Phone,
                            Marca__c,
                            BR_Main_Complement__c
                            from Account where BR_cnpj__c =: cnpj limit 1];
        } else {
            String cpf = cadastroCli.BR_CPF__c;
            accExistente = [select id, 
                            Name, 
                            RecordTypeId,
                            BR_cnpj__c,
                            BR_Company_Name__c,
                            BR_tax_registration_number__c,
                            BR_CPF__c,
                            BR_Approval_status__c,
                            BR_Main_Address__c,
                            BR_Main_Nbr__c,
                            BR_Bairro__c,
                            BR_Main_District__c,
                            BR_Main_City__c,
                            BR_Main_Zip_code__c,
                            BR_Main_State__c,
                            BR_Account_Id_SAP__c,
                            BR_Account_email__c,
                            BR_Area_code__c,
                            Phone,
                            Marca__c
                            from Account where BR_CPF__c =: cpf limit 1];
        }
        
        if (accExistente.size() > 0) {
            acc = accExistente[0];
            isUpdate = true;
        } else {
            // as vezes o cliente existe na base do SAP mas não no SF
            acc = new Account();
        }
        
        // se CNPJ ou CPF
        if (cadastroCli.Tipo_de_Pessoa__c == 'Pessoa Jurídica'){
            acc.Name = cadastroCli.BR_RazaoSocial__c;
            acc.BR_Company_Name__c = cadastroCli.BR_RazaoSocial__c;
            acc.RecordTypeId =  cadastroCli.TipoRegistroConta__c;  //'0120V0000026BAeQAM';
            acc.BR_cnpj__c = cadastroCli.BR_CNPJ__c;
            acc.BR_tax_registration_number__c = cadastroCli.InscricaoEstadual__c;
        } else {
            
            acc.Name = cadastroCli.BR_Name__c;
            acc.RecordTypeId = cadastroCli.TipoRegistroConta__c; //'012d0000000hJ0CAAU'; 
            acc.BR_CPF__c = cadastroCli.BR_CPF__c;
            acc.BR_tax_registration_number__c = 'ISENTO';
        }
        
        acc.BR_Approval_status__c = 'Aprovado';                 
        acc.BR_Main_Address__c = cadastroCli.BR_Main_Address__c;
        acc.BR_Main_Nbr__c = cadastroCli.BR_Main_Nbr__c;
        acc.BR_Bairro__c = cadastroCli.BR_Bairro__c;
        acc.BR_Main_District__c = cadastroCli.BR_Bairro__c;
        acc.BR_Main_City__c = cadastroCli.BR_Main_City__c;
        acc.BR_Main_State__c = cadastroCli.BR_Main_State__c;
        acc.BR_Main_Zip_code__c = cadastroCli.BR_Main_Zip_code__c;               
        acc.BR_Account_email__c = cadastroCli.BR_email__c;
        acc.BR_Main_Complement__c = cadastroCli.BR_Main_Complement__c;
        
        try{
            acc.Phone = cadastroCli.BR_Phone__c;
            acc.BR_Area_code__c = decimal.valueOf(cadastroCli.BR_Phone__c.substring(1,3));
        } catch (Exception e) {
            System.debug('Verificar máscara do telefone: ' + e.getMessage());
        }
        
        acc.BR_Approval_status__c = 'Aprovado';
        acc.Marca__c = cadastroCli.Unidade__c;
        
        try{
            if (isUpdate)
                update acc;
            else
                insert acc;
        } catch (Exception e) {
            System.debug('houve erro na inserção no SF ->' + e.getMessage());
        }
        
        try {
            // muda o status da solicitação 'Cliente Integrado'.
            cadastroCli.BR_Status__c = 'Cliente Integrado';
            cadastroCli.BR_Conta__c = acc.Id;
            cadastroCli.BR_MensagemErro__c = '';                
            //RecordType tipoConta = [SELECT Id,Name FROM RecordType WHERE Id =: cadastroCli.TipoRegistroConta__c limit 1];
            //cadastroCli.TipoRegistroConta__c = tipoConta.Name;                
            
            update cadastroCli; 
            
        } catch (Exception e) {
            System.debug('houve erro na atualização da solcitação do cadastro. ->' + e.getMessage());
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
    
}