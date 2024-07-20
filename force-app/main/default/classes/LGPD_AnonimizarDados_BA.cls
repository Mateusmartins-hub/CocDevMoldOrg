global class LGPD_AnonimizarDados_BA implements Database.Batchable<SObject>, Database.Stateful {

    private Set<Id> IdsParaAnonimizacao;
    private DataMask__c customSettings = DataMask__c.getOrgDefaults();
    private Anonimizacao__c customSettingsAnonimizacao = Anonimizacao__c.getOrgDefaults();
    
    global LGPD_AnonimizarDados_BA(Set<Id> Ids) {
        IdsParaAnonimizacao = Ids;
    }

    global List<ObjetoLGPD__mdt> start(Database.BatchableContext BC) {
        return [SELECT Label, (SELECT ApiName__c, Tipo__c, Tamanho__c FROM CamposAnonimizacao__r) FROM ObjetoLGPD__mdt];
    }

    global void execute(Database.BatchableContext BC, List<ObjetoLGPD__mdt> objetosLGPD) {
        Map<String, List<CampoAnonimizacao__mdt>> mapObjetosLGPD = new Map<String, List<CampoAnonimizacao__mdt>>();

        if(!IdsParaAnonimizacao.isEmpty())
        {
            for(ObjetoLGPD__mdt objetoLGPD : objetosLGPD){
                mapObjetosLGPD.put(objetoLGPD.Label, objetoLGPD.CamposAnonimizacao__r);
            }

            List<SObject> registrosParaAnonimizar = new List<SObject>();

            for(Id idRegistro : IdsParaAnonimizacao){
                
                SObject registroAnonimizacao = idRegistro.getSObjectType().newSObject(idRegistro);

                for(CampoAnonimizacao__mdt campoAnonimizacao : mapObjetosLGPD.get((String)idRegistro.getSObjectType().getDescribe().getName())){
                    
                    switch on campoAnonimizacao.Tipo__c {
                        when 'Date','DateTime','Time','Geolocation','Picklist','MultiPicklist','URL','Phone' {
                            registroAnonimizacao.put(campoAnonimizacao.ApiName__c, NULL);
                        }
                        when 'Email' {
                            registroAnonimizacao.put(campoAnonimizacao.ApiName__c, customSettingsAnonimizacao.EmailFieldValue__c);
                        }
                        when 'Text','TextArea','TextAreaLong','TextAreaRich','TextEncrypted' {
                            if(campoAnonimizacao.Tamanho__c >= customSettingsAnonimizacao.TextFieldValue__c.length()) 
                                registroAnonimizacao.put(campoAnonimizacao.ApiName__c, customSettingsAnonimizacao.TextFieldValue__c);
                            else registroAnonimizacao.put(
                                    campoAnonimizacao.ApiName__c, Util.generateRandomStringChar(campoAnonimizacao.Tamanho__c.intValue())
                                );
                        }
                        when 'Number','Percent','Currency' { 
                            registroAnonimizacao.put(campoAnonimizacao.ApiName__c, customSettingsAnonimizacao.NumericFieldValue__c);
                        }
                        when 'Checkbox' {
                            registroAnonimizacao.put(campoAnonimizacao.ApiName__c, customSettingsAnonimizacao.CheckboxFieldValue__c);
                        }
                        when else {
                            System.debug('Nenhum tipo de dado passível de anonimização válido: '+campoAnonimizacao.Tipo__c);
                        }
                    }   
                }

                registrosParaAnonimizar.add(registroAnonimizacao);
            }

            byPassTriggers();

            Database.SaveResult[] srList = Database.update(registrosParaAnonimizar, false);

            for (Database.SaveResult sr : srList) { if (!sr.isSuccess()) { for(Database.Error err : sr.getErrors()) {
                System.debug(err.getStatusCode() + ': ' + err.getMessage());
            }}}
        }
    }
    
    global void finish(Database.BatchableContext BC) {}

    private void byPassTriggers(){
        if(String.isNotBlank(customSettings.TriggersToBypass__c)){
            List<String> triggersToByPass = customSettings.TriggersToBypass__c.split(',');
            for(String triggerName: triggersToBypass){
                TriggerHandler.bypass(triggerName);
            }
        }
    }
}