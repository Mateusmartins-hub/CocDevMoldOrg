public without sharing class LGPD_DataMask_BA implements Database.Batchable<sObject> {
    
    private DataMask__c customSettings = DataMask__c.getOrgDefaults();
    private String objectName;
    private List<String> fieldsName;
    private Map<String, String> fieldMap = new Map<String, String>();
    private List<CampoAnonimizacao__mdt> fields;
    @TestVisible private Boolean isSandbox = [SELECT isSandbox FROM Organization LIMIT 1].isSandbox;

    public LGPD_DataMask_BA(String objectName) {

        this.objectName = objectName;

        this.fields = [
            SELECT ApiName__c, Tipo__c 
            FROM CampoAnonimizacao__mdt
            WHERE ObjetoLGPD__c IN (SELECT Id FROM ObjetoLGPD__mdt WHERE MasterLabel = :objectName)
        ];

        for(CampoAnonimizacao__mdt field :fields) {
            this.fieldMap.put(field.ApiName__c, field.Tipo__c);
        }

        this.fieldsName = new List<String>(fieldMap.keySet());
    }

    public Database.QueryLocator start(Database.BatchableContext BC){
        try{
            preventToRunInProduction(BC);
        }
        catch(DataMaskException e){
			System.debug(e.getMessage());
        }
            
            String query = 'SELECT ' + String.join(this.fieldsName, ',') + ' FROM ' + this.objectName;
    
            if(String.isNotBlank(customSettings.QueryLimit__c)){
                query += ' LIMIT ' + customSettings.QueryLimit__c;
            }
    
            return Database.getQueryLocator(query);
    }
    
    public void execute(Database.BatchableContext BC, List<sObject> scope) {
        
        for(sObject obj: scope){

            for(String fieldName: this.fieldsName){

                Object field = obj.get(fieldName);

                if(field == null) continue;

                String fieldType = this.fieldMap.get(fieldName);                        
                switch on fieldType {
                    when 'Geolocation','Picklist','MultiPicklist' {
                        obj.put(fieldName, null);
                    }
                    when 'Date'{
                        obj.put(
                            fieldName, Util.generateRandomDate()
                        );
                    }
                    when 'DateTime'{
                        obj.put(
                            fieldName, Util.generateRandomDateTime()
                        );
                    }
                    when 'Time' {
                        obj.put(
                            fieldName, Util.generateRandomTime()
                        );
                    }
                    when 'Text','TextArea','TextAreaLong','TextAreaRich','TextEncrypted', 'Email', 'URL','Phone' { 
                        obj.put(
                            fieldName, Util.generateRandomValueBasedOnString(removeCPF((String)field))
                        );
                    }
                    when 'Number', 'Percent', 'Currency' {
                        obj.put(
                            fieldName, Decimal.valueOf(Util.generateRandomValueBasedOnString(String.valueOf(field)))
                        );
                    }
                    when 'Checkbox' {
                        obj.put(fieldName, false);
                    }
                    when else {
                        System.debug('Nenhum tipo de dado passível de anonimização válido: ' + fieldType);
                    }
                }   
            }
        }
            
        byPassTriggers();

        Database.SaveResult[] srList = Database.update(scope, false);
         
        for (Database.SaveResult sr : srList) { 
            if (!sr.isSuccess()) { 
                for(Database.Error err : sr.getErrors()) {
                    ExceptionLogger.log('LGPD_DataMask_BA', err);
                }
            }
        }

        ExceptionLogger.save();
    }
    
    public void finish(Database.BatchableContext BC){}

    private void byPassTriggers(){
        if(String.isNotBlank(customSettings.TriggersToBypass__c)){
            List<String> triggersToByPass = customSettings.TriggersToBypass__c.split(',');
            for(String triggerName: triggersToBypass){
                TriggerHandler.bypass(triggerName);
            }
        }
    }

    private void preventToRunInProduction(Database.BatchableContext BC){
        if(!this.isSandbox){
            System.abortJob(BC.getJobId());
			throw new DataMaskException('Data mask can\'t run in production environment');
        }
    }

    private String removeCPF(String text){
        return text.replaceAll('\\d{3}\\.\\d{3}\\.\\d{3}\\-\\d{2}$', '');
    }

    private class DataMaskException extends Exception {}
}