public without sharing class LGPD_AnonimizacaoController {
    
    // Montar estrutura dos objetos/campos em campos Map<String, List<String>> puxando o custom metadata
    public static Map<String, List<CampoAnonimizacao__mdt>> escopo;
    Public static Map<String, List<String>> emailObjectFields;
    
    @AuraEnabled
    public static List<String> findCPFRecords(String cpf) {
        System.debug('VALOR DO CPF: ' + cpf);
        Set<String> emails = new Set<String>();
        
        if(cpf != null) {
            // SOSL pelo CPF informado no caso BR_CPF__c no escopo de objetos
            retrieveMetadata();
            List<String> objetosParaProcurar = populateQueryObjects();
            
            // Identificar o email pelo campo do mapa
            // Adicionar o email na lista de emails
            for(List<sObject> result : search.query('FIND :cpf IN ALL FIELDS RETURNING ' + String.join(objetosParaProcurar, ','))){
                for(sObject obj : result){
                    if(emailObjectFields.get(obj.getSObjectType().getDescribe().getName()) != null) {
                        for(String emailField : emailObjectFields.get(obj.getSObjectType().getDescribe().getName())) {
                            if(obj.get(emailField) != null) {
                                emails.add(obj.get(emailField).toString());
                            }
                        }
                    }
                }
            }
            System.debug(emails);
        }
        return new List<String>(emails);
    }
    
    @AuraEnabled
    public static List<RecordResult> findCPFEmailRecords(String cpf, List<String> emailSet) {
        List<RecordResult> recordResultList = new List<RecordResult>();
        if(cpf != null) {
            retrieveMetadata();
            String searchTerm = cpf;
            List<String> objetosParaProcurar = new List<String>();
            if(emailSet != null && !emailSet.isEmpty()) {
                searchTerm += ' or ' + String.join(emailSet, ' or ');
            }
            objetosParaProcurar = populateQueryObjects();
            recordResultList.addAll(getResultListFromSearch(search.query('FIND :searchTerm IN ALL FIELDS RETURNING ' + String.join(objetosParaProcurar, ','))));
        }
        return recordResultList;
    }
    
    //Recupera os campos do Metadata Type para usar na busca pelos registros.
    public static void retrieveMetadata() {
        if(escopo == null) {
            escopo = new Map<String, List<CampoAnonimizacao__mdt>>();
            emailObjectFields = new Map<String, List<String>>();
            for(CampoAnonimizacao__mdt mdt : [SELECT ObjetoLGPD__r.Label, ApiName__c, Tipo__c FROM CampoAnonimizacao__mdt WHERE Tipo__c != null]) {
                if('EMAIL'.equals(mdt.Tipo__c.toUpperCase())) {
                    if(emailObjectFields.get(mdt.ObjetoLGPD__r.Label) != null) {
                        emailObjectFields.get(mdt.ObjetoLGPD__r.Label).add(mdt.ApiName__c);
                    } else {
                        emailObjectFields.put(mdt.ObjetoLGPD__r.Label, new List<String>{mdt.ApiName__c});
                    }
                }
                if(escopo.get(mdt.ObjetoLGPD__r.Label) != null) {
                    escopo.get(mdt.ObjetoLGPD__r.Label).add(mdt);
                } else {
                    escopo.put(mdt.ObjetoLGPD__r.Label, new List<CampoAnonimizacao__mdt>{mdt});
                }
            }
        }
    }
    
    public static List<String> populateQueryObjects() {
        List<String> objetos = new List<String>(escopo.keySet());
        List<String> objetosParaProcurar = new List<String>();
        for(String obj : objetos){
            List<CampoAnonimizacao__mdt> campos = escopo.get(obj);
            String qry = '';
            if('CASE'.equals(obj.toUpperCase())) {
                qry = obj + '( caseNumber, createdDate, ';
            } else {
                qry = obj + '( createdDate, ';
            }
            for(CampoAnonimizacao__mdt campo : campos) {
                qry = qry + campo.ApiName__c + ',';
            }
            qry = qry.substring(0, qry.lastIndexOf(',')) + ')';
            objetosParaProcurar.add(qry);
        }
        return objetosParaProcurar;
    }
    
    public static List<RecordResult> getResultListFromSearch(List<List<sObject>> results) {
        List<RecordResult> recordResultList = new List<RecordResult>();
        if(!results.isEmpty()) {
            for(List<sObject> result : results) {
                RecordResult rr = new RecordResult();
                rr.records = new List<objectField>();
                for(sObject obj : result){
                    rr.recordName = obj.getSObjectType().getDescribe().getName();
                    objectField objField = new objectField();
                    if('CASE'.equals(obj.getSObjectType().getDescribe().getName().toUpperCase())) {
                        objField.name = obj.get('caseNumber').toString();
                    } else {
                        try {
                            objField.name = obj.get('Name').toString();
                        } catch(Exception e) {
                            objField.name = obj.get('Id').toString();
                        }
                    }
                    objField.id = obj.get('Id').toString();
                    objField.createdDate = ((Datetime)obj.get('createdDate')).format('dd-MM-yyyy');
                    rr.records.add(objField);
                }
                if(!rr.records.isEmpty()) {
                    recordResultList.add(rr);
                }
            }
        }
        return recordResultList;
    }
    
    @AuraEnabled
    public static Id executeBatchJob(List<String> ids){
        Set<ID> idSet = new Set<ID>();
        for(String strId : ids) {
            idSet.add(ID.valueOf(strId));
        }
        Id batchJobId = Database.executeBatch(new LGPD_AnonimizarDados_BA(idSet));
        return batchJobId;
    }

    @AuraEnabled
    public static AsyncApexJob getBatchJobStatus(Id jobID){
        AsyncApexJob jobInfo = [SELECT Status, NumberOfErrors,JobItemsProcessed,TotalJobItems FROM AsyncApexJob WHERE Id = :jobID];
        System.debug(jobInfo);
        return jobInfo;
    }
    
    public class RecordResult {
        @AuraEnabled public String recordName;
        @AuraEnabled public List<objectField> records;
    }
    
    public class objectField {
        @AuraEnabled public String id;
        @AuraEnabled public String name;
        @AuraEnabled public String createdDate;
    }
}