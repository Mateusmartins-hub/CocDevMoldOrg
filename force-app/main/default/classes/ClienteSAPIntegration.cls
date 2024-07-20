public class ClienteSAPIntegration {
    
    private static final IntegracaoClienteSAP__c ENDPOINT_INFO = IntegracaoClienteSAP__c.getOrgDefaults();
	
    public static Boolean getClientSAPAndUpdate(Account acc) {
        Boolean temErro = false;
        
        try{
            String cpfCnpj = removeSpecialChars(acc.BR_CNPJ_CPF__c);
            List<String> ovs = getAllOVS();
            
            Map<String, ClienteRetorno> mapOVBodyRetorno = new Map<String, ClienteRetorno>();
            
            for(String ov : ovs) {
                String dataRequest = '{"I_STCD":"' + cpfCnpj + '","I_VKORG":"' + ov + '","I_BUKRS":"PEBR"}';
                
                HTTPExterno request = new HTTPExterno();
                String bodyRetorno = request.getContent(ENDPOINT_INFO.EndpointURL__c , 'POST', 'application/x-www-form-urlencoded', buildParamURL(dataRequest));
                ClienteRetorno retorno = ClienteRetorno.parse(bodyRetorno);
                
                mapOVBodyRetorno.put(ov, retorno);
            }
            
            Integer contasEncontradas = 0;
            
            for(String ov : mapOVBodyRetorno.keySet()) {
                ClienteRetorno c = mapOVBodyRetorno.get(ov);
                
                if(c.Data.Tables[0].Structures.size() > 0) {
                    ClienteRetorno.Structures data = c.Data.Tables[0].Structures[0];
                    
                    acc.Name = data.NAME1;
                    acc.BR_Main_State__c = data.REGIO;
                    acc.BR_FI_Saldo_disponivel__c = Double.valueof(data.SALDO.replace(',', '.'));
                    acc.BR_FI_Dividas_a_receber__c = Double.valueof(data.SKFOR.replace(',', '.'));
                    acc.BR_FI_Limite_de_credito_do_cliente__c = Double.valueof(data.KLIMK.Replace(',', '.'));
                    acc.BR_Account_Id_SAP__c = data.KUNNR;
                    acc.BR_Integrate_to_SAP__c = true;
                    acc.BR_Integration_Status_SAP__c = 'Integrado ERP';
                    
                    update acc;
                    
                    contasEncontradas++;
                }
            }
            
            if(contasEncontradas == 0) 
                insertLog(acc, 'error', 'Cliente não encontrado.');
            else
                insertLog(acc, 'Success', 'Cliente encontrado e atualizado no Salesforce.');    
            
            return temErro;
        }catch(Exception e) {
            temErro = true;
            insertLog(acc, 'error', e.getMessage());    
            return temErro;
        }
    }
    
     private static void insertLog(Account acc, String status, String messageLong) {
        Integration_log__c log = new Integration_log__c();
        
        log.Account__c = acc.Id;
        log.Status__c = status;   
        log.Message_Long__c = messageLong;
        if(status == 'error') {
            log.Message__c = 'Erro ao integrar com o SAP.';
        }else if(status == 'success') {
            log.Message__c = 'Sucesso ao integrar com o SAP.';
        }
        
        insert log;
    }
    
    private static List<Integration_log__c> addLog(List<Integration_log__c> logs, Account acc, String status, String messageLong) {
        Integration_log__c log = new Integration_log__c();
        
        log.Account__c = acc.Id;
        log.Status__c = status;   
        log.Message_Long__c = messageLong;
        if(status == 'error') {
            log.Message__c = 'Erro ao integrar com o SAP.';
        }else if(status == 'success') {
            log.Message__c = 'Sucesso ao integrar com o SAP.';
        }
        
        logs.add(log);
        
        return logs;
    }
    
    private static String isEmpty(String valor) {
        return String.isBlank(valor) ? '' : valor;
    }
    
    private static string removeSpecialChars(String texto) {  
        if(String.IsBlank(texto))
            return texto;
        
        return texto.replaceAll('[|,|.|/|\\,||"||:|~|!|@|#|$|%|^|&|*|_|-|-|+|=|<|>|?|\\(|\\)|\\{|\\}|\\;|\\\'"]', '');
    } 

    private static String buildParamURL(String dataRequest) {
        Map<String, String> mapParams = new Map<String, String>();
        
        mapParams.put('key', ENDPOINT_INFO.EndpointKey__c);
        mapParams.put('User', ENDPOINT_INFO.EndpointUser__c);
        mapParams.put('ConnectionName', ENDPOINT_INFO.ConnectionName__c);
        mapParams.put('Application', ENDPOINT_INFO.EndpointApplication__c);
        mapParams.put('EndPoint', ENDPOINT_INFO.RFC__c);
        mapParams.put('DataRequest', dataRequest);
        
        List<String> listParams = new List<String>();
        for (String mp : mapParams.keySet()) {
            listParams.add(mp + '=' + mapParams.get(mp));
        }
        
        return String.join(listParams, '&');
    }
    
    private static List<String> getAllOVS() {
        List<String> ovs = new List<String>();
        
        ovs.add('OV0');
        ovs.add('OV1');
        ovs.add('OV2');
        ovs.add('OV4');
        ovs.add('OV5');
        ovs.add('OV7');
        
        return ovs;
    }
}