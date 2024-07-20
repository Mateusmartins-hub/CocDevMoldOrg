public without sharing class LGPD_DataMask {

    private static DataMask__c customSettings = DataMask__c.getOrgDefaults();

    public LGPD_DataMask() {
        run();
    }
    
    private static void run(){

        List<ObjetoLGPD__mdt> objects = [
            SELECT MasterLabel FROM ObjetoLGPD__mdt
        ];

        List<String> objectsToAvoid = new List<String>();
        if(String.isNotBlank(customSettings.ObjectsToAvoid__c)){
            objectsToAvoid.addAll(customSettings.ObjectsToAvoid__c.split(','));
        }

        for(ObjetoLGPD__mdt obj: objects){
            if(objectsToAvoid.contains(obj.MasterLabel)) continue;
           
            Database.executeBatch(new LGPD_DataMask_BA(obj.MasterLabel));
            if(Test.isRunningTest()) break;
        }
    }
}