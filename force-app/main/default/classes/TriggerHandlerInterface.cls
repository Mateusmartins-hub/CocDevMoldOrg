global interface TriggerHandlerInterface {    
    void beforeUpdate();
    
    void beforeInsert();
    
    void beforeDelete();
    
    void afterUpdate();
    
    void afterInsert();
    
    void afterDelete();
}