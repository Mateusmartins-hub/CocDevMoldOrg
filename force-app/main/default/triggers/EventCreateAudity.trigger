/**********************************************************************************
*                         Copyright 2012 - Cloud2b
***********************************************************************************
* WHEN AN EVENT HAS THE BR_Create_Audit__c FIELD MARKED EQUALS TRUE IS CREATED AN 
* Auditoria__c RECORD.
*
* NAME: AccountCopyAccountToContact
* AUTHOR: CARLOS CARVALHO                              DATE: 29/01/2013
***********************************************************************************/
trigger EventCreateAudity on Event (after insert, after update) {
    
    //Invoke Log Limits
    LogLimits.print('TRIGGER: EventCreateAudity - BEGIN CODE', false);
    
    //Variables declaration 
    List< Auditoria__c > listAuditoria = new List< Auditoria__c >();
    Id idRecTypeEvent = RecordTypeMemory.getRecType( 'Auditoria__c', 'Auditoria_Universitario' );
    
    //Select the queue to use on creation of Auditoria__c.
    List< QueueSobject > listFila = [ SELECT id, QueueId FROM QueueSobject 
                                        WHERE Queue.Name = 'Auditoria'
                                        AND SObjectType = 'Auditoria__c' limit 1]; 
    
    //Invoke Log Limits
    LogLimits.print('TRIGGER: EventCreateAudity - AFTER SELECT QueueSobject', false);
    
    //If there isn't Queue stop code.
    if( listFila.size() == 0 ) return;
    
    for( Event e : trigger.new ){
        //Validate if the field BR_Create_Audit__c equals TRUE 
        if( ( Trigger.isInsert && e.BR_Create_Audit__c ) || ( Trigger.isUpdate && 
           e.BR_Create_Audit__c && !Trigger.oldMap.get(e.Id).BR_Create_Audit__c )){
            Auditoria__c aud = new Auditoria__c();
            aud.OwnerId = listFila[0].QueueId;
            aud.BR_subject__c = e.Subject;
            aud.BR_Assigned__c = e.CreatedById;
            aud.Visit_Source__c = e.BR_Source_Visit__c;
            aud.BR_Tipo_de_visita__c = e.BR_Tipo_da_Visita__c;
            aud.BR_Inicio__c = e.StartDateTime;
            aud.BR_Fim__c = e.EndDateTime;
            aud.BR_account__c = e.AccountId;
            aud.BR_Contact__c = e.WhoId;
            listAuditoria.add( aud );
        }
    }
    
    //Invoke Log Limits
    LogLimits.print('TRIGGER: EventCreateAudity - AFTER FOR EVENT', false);
    
    //Insert Auditoria__c records if the list > 0
    if( listAuditoria.size() > 0 ) insert listAuditoria;
    
    //Invoke Log Limits
    LogLimits.print('TRIGGER: EventCreateAudity - AFTER INSERT AUDITORIA', false);
}